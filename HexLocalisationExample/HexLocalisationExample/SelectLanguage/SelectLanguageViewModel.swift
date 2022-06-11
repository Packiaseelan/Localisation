//
//  SelectLanguageViewModel.swift
//  HexLocalisationExample
//
//  Created by Packiaseelan S on 12/06/22.
//

import Foundation
import HexLocalisation

class SelectLanguageViewModel: ObservableObject {
    
    let localisation = Localisation.shared
    
    @Published var supportedLanguages: [SupportedLang] = []
    
    init() {
        supportedLanguages = localisation.getSupportedlanguages()
    }
    
    func selectLang(languageId: String) {
        localisation.selectLanguage(languageId: languageId)
    }
}
