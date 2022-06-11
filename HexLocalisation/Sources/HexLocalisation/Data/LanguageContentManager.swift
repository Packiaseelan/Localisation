//
//  File.swift
//  
//
//  Created by Packiaseelan S on 10/06/22.
//

import Foundation
import RealmSwift

class LanguageContentManager {
    
    static let shared = LanguageContentManager()
    
    private var localRealm: Realm?
    
    private init() { }
    
    func closeContainer() {
        localRealm = nil
    }
    
    /// openContainer
    /// ```
    /// open container for selected language.
    /// ```
    private func openContainer() {
        localRealm = nil
        guard
            let name = UserDefaults.standard.string(forKey: "selectedLanguage"),
            let url = getFileUrl(for: name) else { return }
        
        let config = Realm.Configuration(fileURL: url, schemaVersion: 1)
        Realm.Configuration.defaultConfiguration = config
        do {
            localRealm = try Realm()
        } catch let error {
            print("Error openning database. \(error)")
        }
    }
    
    /// getLanguageContent
    /// ```
    /// gets the content for selected language.
    /// ```
    func getLanguageContent() -> [LanguageContent] {
        
        openContainer()
        
        if let realm = localRealm {
            let all = realm.objects(LanguageContent.self)
            var cont: [LanguageContent] = []
            all.forEach { content in
                cont.append(content)
            }
            return cont
        }
        
        return []
    }
    
    func insertAll(contents: [LanguageContent]) {
        
        openContainer()
        
        do {
            try localRealm?.write({
                contents.forEach { content in
                    localRealm?.add(content)
                }
            })
        } catch let error {
            print("Error inserting language content. \(error)")
        }
    }
}
