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
        localisation = HexLocalisation(
            appId: "com.hexcreators.HexLocalisationExample",
            apiKey: "QWERTY1231"
        )
    }
    
    func getSupportedlanguages() -> [SupportedLang] {
        return localisation.getSupportedLanguages()
    }
    
    func selectLanguage(languageId: String) {
        localisation.selectLanguage(languageId: languageId)
    }
    
    func getString(for key: String) -> String {
        return localisation.getString(for: key)
    }
}
