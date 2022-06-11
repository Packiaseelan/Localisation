//
//  MockData.swift
//  
//
//  Created by Packiaseelan S on 11/06/22.
//

import Foundation

class MockData {
    
    static let shared = MockData()
    
    var supportedLanguages: [SupportedLang] = []
    
    private init() {
        if let supportLangData = readLocalFile(forName: "supported_languages") {
            
            supportedLanguages = parseSupportedLanguage(jsonData: supportLangData)
        }
    }
    
    private func readLocalFile(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.module.path(forResource: name, ofType: "json"),
                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }
        
        return nil
    }
    
    private func parseSupportedLanguage(jsonData: Data) -> [SupportedLang] {
        do {
            let decodedData = try JSONDecoder().decode(SupportedLanguageResponse.self, from: jsonData)
            return decodedData.supportedLanguage
        } catch {
            print("decode error")
            return []
        }
    }
}
