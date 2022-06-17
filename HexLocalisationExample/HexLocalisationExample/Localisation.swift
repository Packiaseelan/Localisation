//
//  Localisation.swift
//  HexLocalisationExample
//
//  Created by Packiaseelan S on 11/06/22.
//

import Foundation
import HexLocalisation

class Localisation: ObservableObject {
    static let shared = Localisation()
    
    private let localisation: HexLocalisation
    
    private init() {
        let bundleId = Bundle.main.bundleIdentifier ?? ""
        var apiKey: String = ""
        
        do {
            apiKey = try Configuration.value(for: "Hex_Localisation_API_Key")
        } catch {
            print("Hex_Localisation_API_Key not available in property list.")
        }
        
        localisation = HexLocalisation(
            appId: bundleId,
            apiKey: apiKey
        )
    }
    
    func getSupportedlanguages() -> [SupportedLanguage] {
        return localisation.getSupportedLanguages()
    }
    
    func selectLanguage(languageId: String) {
        localisation.selectLanguage(languageId: languageId)
    }
    
    func getString(for key: String, defaultValue: String? = nil) -> String {
        return localisation.getString(for: key, defaultValue: defaultValue)
    }
}
