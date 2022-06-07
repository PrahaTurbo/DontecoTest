//
//  AudioItem.swift
//  DontecoTest
//
//  Created by Артем Ластович on 04.06.2022.
//

import SwiftUI

struct AudioItem: View {
    @EnvironmentObject var audioService: AudioService
    
    let fileName: String?
    let itemPlace: Place
    let showImporter: (Place) -> Void
    
    var body: some View {
        ZStack {
            Color.yellow.opacity(0.3)
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            
            HStack {
                Image(systemName: "music.note")
                    .font(.title3)
                    .padding(.horizontal, 10)
                
                Divider()
                    .frame(height: 40)
                
                Text(fileName ?? "Add an audio file")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(1)
                    .padding(.leading, 10)
                
                Button {
                    showImporter(itemPlace)
                } label: {
                    Image(systemName: fileName == nil ? "plus" : "arrow.triangle.2.circlepath")
                        .frame(width: 20, height: 20)
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.black)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .shadow(color: .black.opacity(0.1), radius: 20)
                        .aspectRatio(1, contentMode: .fit)
                }
                .buttonStyle(ScaledButton())
                .opacity(audioService.isPlaying ? 0 : 1)
                
            }
            .padding(.horizontal)
        }
    }
}

struct AudioItem_Previews: PreviewProvider {
    static var previews: some View {
        AudioItem(fileName: "Filename", itemPlace: .first) { _ in  }
            .padding(16.0)
            .previewLayout(.sizeThatFits)
            .environmentObject(AudioService())
        
        AudioItem(fileName: "Filename", itemPlace: .first) { _ in  }
            .padding(16.0)
            .previewLayout(.sizeThatFits)
            .environmentObject(AudioService())
        
    }
}
