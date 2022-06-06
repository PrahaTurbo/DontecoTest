//
//  AudioPlayer.swift
//  DontecoTest
//
//  Created by Артем Ластович on 03.06.2022.
//

import Foundation
import AVFoundation

@MainActor final class AudioService: ObservableObject {
    @Published var isPlaying = false
    @Published var showingImportError = false

    @Published var firstAudioUrl: URL?
    @Published var secondAudioUrl: URL?
    @Published var crossFadeDuration: Double = 10.0
    
    var filesChoosed: Bool {
        if firstAudioUrl == nil || secondAudioUrl == nil {
            return false
        } else {
            return true
        }
    }
    
    private let playerQueue = [AVPlayer(), AVPlayer()]
    private var timeObserverToken: Any?
    private var playingCopy = false
    private var currentPlayer: AVPlayer {
        return playingCopy ? playerQueue.last! : playerQueue.first!
    }
    
    func setUrl(result: Result<URL, Error>, itemPicked: Place) {
        switch result {
        case .success(let url):
            guard url.startAccessingSecurityScopedResource() else { return }
            
            if itemPicked == .first {
                firstAudioUrl = url
            } else {
                secondAudioUrl = url
            }
            
            url.stopAccessingSecurityScopedResource()
        case .failure(let error):
            showingImportError = true
            print("Error with file import: \(error.localizedDescription)")
        }
    }
    
    private func setupFade() {
        guard let firstAudioUrl = firstAudioUrl, let secondAudioUrl = secondAudioUrl else {
            return
        }
        
        let firstAsset = AVAsset(url: firstAudioUrl)
        let secondAsset = AVAsset(url: secondAudioUrl)
        
        let firstItem = AVPlayerItem(asset: firstAsset, automaticallyLoadedAssetKeys: ["playable"])
        let secondItem = AVPlayerItem(asset: secondAsset, automaticallyLoadedAssetKeys: ["playable"])
        
        currentPlayer.replaceCurrentItem(with: firstItem)
        playerQueue.last?.replaceCurrentItem(with: secondItem)
                
        addVolumeRamps(with: crossFadeDuration)
        addPeriodicTimeObserver(for: currentPlayer)
    }
    
    func togglePlayStop() {
        if isPlaying {
            stop()
        } else {
            setupFade()
            play()
        }
    }
    
    private func play() {
        isPlaying = true
        currentPlayer.play()
    }
    
    private func stop() {
        isPlaying = false
        currentPlayer.pause()
        currentPlayer.seek(to: .zero)
    }
    
    private func addVolumeRamps(with duration: Double) {
        for player in playerQueue {
            let assetDuration = CMTimeGetSeconds(player.currentItem?.asset.duration ?? CMTime())
            
            let introRange = CMTimeRangeMake(start: CMTimeMakeWithSeconds(0, preferredTimescale: 1), duration: CMTimeMakeWithSeconds(duration, preferredTimescale: 1))
            let endingSecond = CMTimeRangeMake(start: CMTimeMakeWithSeconds(assetDuration - duration, preferredTimescale: 1000), duration: CMTimeMakeWithSeconds(duration, preferredTimescale: 1))
            
            let inputParams = AVMutableAudioMixInputParameters(track: player.currentItem?.asset.tracks.first)
            inputParams.setVolumeRamp(fromStartVolume: 0, toEndVolume: 1, timeRange: introRange)
            inputParams.setVolumeRamp(fromStartVolume: 1, toEndVolume: 0, timeRange: endingSecond)
            
            let audioMix = AVMutableAudioMix()
            audioMix.inputParameters = [inputParams]
            player.currentItem?.audioMix = audioMix
        }
    }
    
    private func addPeriodicTimeObserver(for player: AVPlayer) {
        timeObserverToken = currentPlayer.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: CMTimeScale(NSEC_PER_SEC)), queue: .main) { [weak self] currentTime in
            if let currentItem = self?.currentPlayer.currentItem,
               currentItem.status == .readyToPlay,
               let crossFadeDuration = self?.crossFadeDuration {
                let totalDuration = currentItem.asset.duration
                
                if (CMTimeCompare(currentTime, totalDuration - CMTimeMakeWithSeconds(crossFadeDuration, preferredTimescale: CMTimeScale(NSEC_PER_SEC))) > 0) {
                    self?.handleCrossFade()
                }
            }
        }
    }
    
    private func removePeriodicTimeObserver(for player: AVPlayer) {
        if let timeObserverToken = timeObserverToken {
            player.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
    }
    
    private func handleCrossFade() {
        removePeriodicTimeObserver(for: currentPlayer)
        playingCopy = !playingCopy
        addPeriodicTimeObserver(for: currentPlayer)
        
        currentPlayer.seek(to: .zero)
        currentPlayer.play()
    }
}


