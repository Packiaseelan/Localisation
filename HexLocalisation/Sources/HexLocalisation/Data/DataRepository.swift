//
//  DataRepository.swift
//  
//
//  Created by Packiaseelan S on 17/06/22.
//

class DataRepository {
    ///
    /// ```
    /// Shared instance for DataRepository
    /// ```
    /// to maintain `singleton`.
    ///
    static let shared = DataRepository()
    ///
    /// ```
    /// Instance of DataManager.
    /// ```
    ///
    let data = DataManager.shared
    ///
    /// ```
    /// Empty Initialise marked as private
    /// ```
    /// to avoide multiple `instance`, only can intialise in this class.
    /// to maintain ``singleton``
    ///
    private init() {}
    ///
    /// ```
    /// ```
    ///
    func getSupportedLanguages() -> [SupportedLanguage] {
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
    ///
    /// ```
    /// Get language
    /// ```
    /// - Parameters:
    ///   - languageId: language id to gets the selected language.
    ///   
    /// return ``nil`` if `languageId` not in coredata.
    ///
    func getLanguage(for languageId: String) -> SupportedLanguage? {
        if let lang = data.getLanguage(for: languageId) {
            return SupportedLanguage(languageId: lang.languageId!,
                          language: lang.language!,
                          displayContent: lang.displayContent!,
                          iconPath: lang.iconPath ?? "")
        }
        return nil
    }
    ///
    /// ```
    /// Saves supported languages.
    /// ```
    /// - Parameters:
    ///   - languages: array of supported languages in ``[SupportedLanguage]`` type.
    /// Converts the languages from ``SupportedLanguage`` to ``Entity``
    /// and saved into coredata.
    func saveSupportedLanguages(languages: [SupportedLanguage]) {
        for lang in languages {
            // create new instance for SupportedLanguagesEntity with ViewContext.
            let langEntity = SupportedLanguagesEntity(context: data.viewContext)
            // update the SupportedLanguagesEntity instance with supported language data.
            langEntity.languageId = lang.languageId
            langEntity.language = lang.language
            langEntity.displayContent = lang.displayContent
            langEntity.iconPath = lang.iconPath
        }
        // save changes in the ViewContext
        data.save { error in
            if let error = error {
                print("Error adding supported languages into coredata. \(error)")
            }
        }
    }
    ///
    /// ```
    /// Gets the contents.
    /// ```
    /// - Parameters:
    ///   - languageId: language id to gets the contents for selected language.
    ///
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
    ///
    /// ```
    /// Saves the language content.
    /// ```
    /// - Parameters:
    ///   - contents: array of language contents in ``[LanguageContent]`` type.
    ///
    func saveLanguageContents(_ contents: [LanguageContent]) {
        for content in contents {
            // create new instance for LanguageContentEntity with ViewContext.
            let entity = LanguageContentEntity(context: data.viewContext)
            // update the LanguageContentEntity instance with language content data.
            entity.serverId = content.id
            entity.languageId = content.languageId
            entity.key = content.key
            entity.content = content.content
        }
        // save changes in the ViewContext
        data.save { error in
            if let error = error {
                print("Error adding language contents into coredata. \(error)")
            }
        }
    }
    ///
    /// ```
    /// Check whether contents available for selected language.
    /// ```
    /// - Parameters:
    ///   - languageId: language id to check the contents available in coredata.
    ///
    /// returns ``true`` if any contens matched for provided `languageId`
    /// else return ``false``
    ///
    func isContentAvailable(for languageId: String) -> Bool {
        let lang = data.getLanguageContent(for: languageId)
        return !lang.isEmpty
    }
    
}
