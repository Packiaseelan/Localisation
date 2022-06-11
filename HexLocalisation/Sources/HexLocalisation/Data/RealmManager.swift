//
//  RealmManager.swift
//  
//
//  Created by Packiaseelan S on 10/06/22.
//

import Foundation
import RealmSwift

class RealmManager {
    
    private var localRealm: Realm?
    
    static let shared = RealmManager()
    let suppotredLang = SupportedLanguageManager.shared
    let langContent = LanguageContentManager.shared
    
    private init() { }
    
    /// openRealm
    /// ```
    /// Open the realm container if exists else create.
    /// ```
    ///
    func openRealm(containerName: String) {
        guard
            let name = UserDefaults.standard.string(forKey: "selectedLanguage"),
            let url = getFileUrl(for: name) else { return }
//         guard let url = getFileUrl(for: containerName) else { return }
        
        let config = Realm.Configuration(fileURL: url, schemaVersion: 1)
        Realm.Configuration.defaultConfiguration = config
        do {
            localRealm = try Realm()
        } catch let error {
            print("Error openning database. \(error)")
        }
    }
    
    /// isContainerExists
    /// ```
    /// Check whether the container available for [selectedlanguage].
    /// ```
    func isContainerExists(for containerName: String) -> Bool {
        return isFileExists(name: containerName)
    }
   
}
