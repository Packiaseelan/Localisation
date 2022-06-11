//
//  HexLocalisationExampleApp.swift
//  HexLocalisationExample
//
//  Created by Packiaseelan S on 11/06/22.
//

import SwiftUI

@main
struct HexLocalisationExampleApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
            .environmentObject(Localisation.shared)
        }
    }
}
