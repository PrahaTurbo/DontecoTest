//
//  CrossfadeSlider.swift
//  DontecoTest
//
//  Created by Артем Ластович on 05.06.2022.
//

import SwiftUI

struct CrossfadeSlider: View {
    @EnvironmentObject var audioService: AudioService
    
    var body: some View {
        VStack {
            HStack {
                Text("Crossfade")
                
                Spacer()
                
                Text(String(format: "%.0f", audioService.crossFadeDuration.rounded()) + " sec")
            }
            .font(.headline)
            
            Slider(value: $audioService.crossFadeDuration, in: 2...10, step: 1)
        }
        .padding(.vertical)
        .padding(.horizontal, 5)
        .accentColor(audioService.isPlaying ? .secondary.opacity(0.5) : .yellow)
        .disabled(audioService.isPlaying)
        .foregroundColor(audioService.isPlaying ? .secondary.opacity(0.5) : .black)
        .scaleEffect(audioService.isPlaying ? 0.95 : 1)
    }
}

struct CrossfadeSlider_Previews: PreviewProvider {
    static var previews: some View {
        CrossfadeSlider()
            .environmentObject(AudioService())
    }
}
