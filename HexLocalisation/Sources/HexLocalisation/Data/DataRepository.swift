//
//  DataRepository.swift
//  
//
//  Created by Packiaseelan S on 17/06/22.
//

import Foundation

class DataRepository {
    
    static let shared = DataRepository()
    
    let data = DataManager.shared
    
    private init() {}
    
    func getSUpportedLanguages() -> [SupportedLanguage] {
        let supLangs = data.getSupportedLanguages()
        var langs: [SupportedLanguage] = []
        for supLang in supLangs {
            let lng = SupportedLanguage(languageId: supLang.languageId!,
                                    language: supLang.language!,
                                    displayContent: supLang.displayContent!,
                                    iconPath: supLang.iconPath ?? "")
            langs.append(lng)
        }
        return langs
    }
    
    func getLanguage(for languageId: String) -> SupportedLanguage? {
        if let lang = data.getLanguage(for: languageId) {
            return SupportedLanguage(languageId: lang.languageId!,
                          language: lang.language!,
                          displayContent: lang.displayContent!,
                          iconPath: lang.iconPath ?? "")
        }
        return nil
    }
    
    func saveSupportedLanguages(languages: [SupportedLanguage]) {
        for lang in languages {
            let langEntity = SupportedLanguagesEntity(context: data.viewContext)
            langEntity.languageId = lang.languageId
            langEntity.language = lang.language
            langEntity.displayContent = lang.displayContent
            langEntity.iconPath = lang.iconPath
        }
        data.save { error in
            if let error = error {
                print("Error adding supported languages to the local database. \(error)")
            }
        }
    }
    
    func getContents(for languageId: String) -> [LanguageContent] {
        let localContents = data.getLanguageContent(for: languageId)
        var contents: [LanguageContent] = []
        for content in localContents {
            contents.append(
                LanguageContent(
                    id: "\(content.id)",
                    languageId: content.languageId!,
                    key: content.key!,
                    content: content.content!
                )
            )
        }
        return contents
    }
    
    func saveLanguageContents(_ contents: [LanguageContent]) {
        for content in contents {
            let entity = LanguageContentEntity(context: data.viewContext)
            entity.serverId = content.id
            entity.languageId = content.languageId
            entity.key = content.key
            entity.content = content.content
        }
        data.save { error in
            if let error = error {
                print("Error adding language contents to the local database. \(error)")
            }
        }
    }
    
    func isContentAvailable(for languageId: String) -> Bool {
        let lang = data.getLanguageContent(for: languageId)
        return !lang.isEmpty
    }
    
}
