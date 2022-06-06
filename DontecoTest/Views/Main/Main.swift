//
//  Main.swift
//  DontecoTest
//
//  Created by Артем Ластович on 03.06.2022.
//

import SwiftUI

struct Main: View {
    @EnvironmentObject var audioService: AudioService
    @StateObject private var viewModel: ViewModel
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                
                VStack {
                    AudioItem(fileName: audioService.firstAudioUrl?.lastPathComponent,
                              itemPlace: .first) { itemPicked in
                        viewModel.showImporter(item: itemPicked)
                    }
                    
                    if !audioService.isPlaying {
                        Image(systemName: "chevron.compact.down")
                            .padding()
                    }
                    
                    AudioItem(fileName: audioService.secondAudioUrl?.lastPathComponent,
                              itemPlace: .second) { itemPicked in
                        viewModel.showImporter(item: itemPicked)
                    }
                }
                
                Spacer()
                
                CrossfadeSlider()

                PlayStopButton()
                
            }
            .padding()
            .fileImporter(isPresented: $viewModel.showingFileImporter, allowedContentTypes: [.audio]) { result in
                audioService.setUrl(result: result,
                                    itemPicked: viewModel.itemPicked)
            }
            .alert(isPresented: $audioService.showingImportError) {
                Alert(title: Text("Import error"),
                      message: Text("Couldn't import your file. Please try to pick another one."),
                      dismissButton: .default(Text("OK")))
            }
        }
    }
    
    init() {
        _viewModel = StateObject(wrappedValue: .init())
    }
}

struct Main_Previews: PreviewProvider {
    static var previews: some View {
        Main()
            .environmentObject(AudioService())
    }
}
