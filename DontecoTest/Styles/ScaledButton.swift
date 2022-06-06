//
//  ScaledButton.swift
//  DontecoTest
//
//  Created by Артем Ластович on 05.06.2022.
//

import Foundation
import SwiftUI

struct ScaledButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeInOut, value: configuration.isPressed)
    }
}
