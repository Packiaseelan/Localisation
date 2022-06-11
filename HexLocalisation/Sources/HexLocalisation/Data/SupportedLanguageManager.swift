//
//  File.swift
//  
//
//  Created by Packiaseelan S on 10/06/22.
//

import Foundation
import RealmSwift

class SupportedLanguageManager {
    
    static let shared = SupportedLanguageManager()
    
    private var localRealm: Realm?
    
    private init() {
        openRealm()
    }
    
    private func openRealm() {
        guard let url = getFileUrl(for: "supportedLanguage") else { return }
        
        let config = Realm.Configuration(fileURL: url, schemaVersion: 1)
        Realm.Configuration.defaultConfiguration = config
        do {
            localRealm = try Realm()
        } catch let error {
            print("Error openning database. \(error)")
        }
    }
    
    func getLanguageContent() -> [SupportedLanguage] {
        
        if let realm = localRealm {
            let all = realm.objects(SupportedLanguage.self)
            var cont: [SupportedLanguage] = []
            all.forEach { content in
                cont.append(content)
            }
            return cont
        }
        
        return []
    }
    
    func getLanguage(languageId: String) -> SupportedLanguage? {
        if let realm = localRealm {
            let items = realm.objects(SupportedLanguage.self).filter(NSPredicate(format: "languageId == %@", languageId))
            return items.first
        }
        return nil
    }
    
    func insertAll(contents: [SupportedLanguage]) {
        do {
            try localRealm?.write({
                contents.forEach { content in
                    localRealm?.add(content)
                }
            })
            print("Supported languages inserted successfully.")
        } catch let error {
            print("Error inserting supported languages. \(error)")
        }
    }
}
