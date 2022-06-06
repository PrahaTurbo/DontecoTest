//
//  DontecoTestApp.swift
//  DontecoTest
//
//  Created by Артем Ластович on 03.06.2022.
//

import SwiftUI

@main
struct DontecoTestApp: App {
    @StateObject private var audioService: AudioService
    
    var body: some Scene {
        WindowGroup {
            Main()
                .preferredColorScheme(.light)
                .environmentObject(audioService)
        }
    }
    
    init() {
        _audioService = StateObject(wrappedValue: .init())
    }
}
