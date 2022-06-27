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
    
    @Published var supportedLanguages: [SupportedLanguage] = []
    
    init() {
        Task(priority: .medium) {
            let lan = await localisation.getSupportedlanguages()
            DispatchQueue.main.async {
                self.supportedLanguages = lan
            }
        }
    }
    
    func selectLang(languageId: String) {
        localisation.selectLanguage(languageId: languageId)
    }
}
