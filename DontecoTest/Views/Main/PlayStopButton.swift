//
//  PlayStopButton.swift
//  DontecoTest
//
//  Created by Артем Ластович on 05.06.2022.
//

import SwiftUI

struct PlayStopButton: View {
    @EnvironmentObject var audioService: AudioService
    
    var body: some View {
        Button {
            withAnimation(.spring()) {
                audioService.togglePlayStop()
            }
        } label: {
            Image(systemName: audioService.isPlaying ? "stop.circle.fill" : "play.circle.fill")
                .foregroundColor(audioService.filesChoosed ? .primary : .secondary.opacity(0.2))
                .font(.system(size: 60))
        }
        .buttonStyle(ScaledButton())
        .disabled(!audioService.filesChoosed)
    }
}

struct PlayStopButton_Previews: PreviewProvider {
    static var previews: some View {
        PlayStopButton()
            .environmentObject(AudioService())
    }
}
