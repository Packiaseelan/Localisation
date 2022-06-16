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
    
    let localisation: HexLocalisation
    
    private init() {
        let bundleId = Bundle.main.bundleIdentifier ?? ""
        
        localisation = HexLocalisation(
            appId: bundleId,
            apiKey: "QWERTY1231"
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
