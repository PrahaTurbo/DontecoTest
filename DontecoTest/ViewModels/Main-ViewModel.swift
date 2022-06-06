//
//  Main-ViewModel.swift
//  DontecoTest
//
//  Created by Артем Ластович on 04.06.2022.
//

import Foundation

enum Place {
    case first, second
}

extension Main {
    @MainActor class ViewModel: ObservableObject {
        @Published var showingFileImporter = false
        @Published var itemPicked: Place = .first
        
        func showImporter(item: Place) {
            itemPicked = item
            
            if showingFileImporter {
                showingFileImporter = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.showingFileImporter = true
                }
            } else {
                showingFileImporter = true
            }
        }
    }
}
