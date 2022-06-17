import SwiftUI

public struct HexLocalisation {
   
    @AppStorage("selectedLanguageId") var selectedLanguageId: String?
    @AppStorage("selectedLanguage") var selectedLanguage: String?
    
    private let appId: String
    private let apiKey: String
    private var contentCache : NSCache<NSString, NSString>
    private let repo = DataRepository.shared
    ///
    /// ```
    /// Initialize the HexLocalisation
    /// ```
    /// - Parameters:
    ///   - appId: Unique id for the app ``BundleId``.
    ///   - apiKey: API key to validate server.
    ///
    public init(appId: String, apiKey: String) {
        self.appId = appId
        self.apiKey = apiKey
        self.contentCache = NSCache<NSString, NSString>()
        // if selected language is not nil the loads the cache.
        if selectedLanguage != nil {
            loadCache()
        }
    }
    ///
    /// ```
    /// Get supported language.
    /// ```
    /// Gets the supported language from coredata.
    /// if its `Empty` them make API call to download.
    ///
    public func getSupportedLanguages() -> [SupportedLanguage] {
        // get supported languages for appId
        let supported  = repo.getSupportedLanguages()
        if supported.isEmpty {
            // TODO: make API call to get the supported language and store in local
            
            // store in local
            let supportedLanguages = PreviewData.shared.supportedLanguages
            
            saveSupportedLanguages(languages: supportedLanguages)
            
            return supportedLanguages
        }
        
        return supported
    }
    ///
    /// ```
    /// Select language
    /// ```
    /// - Parameters:
    ///   - languageId: language id to update selected language.
    ///
    /// Update the selected language in the `AppStorage` and loads the language content in the ``cache``.
    ///
    public func selectLanguage(languageId: String) {
        // clear cache before switch language
        clearCache()
        // update selected language in AppStorage
        if let lang = repo.getLanguage(for: languageId) {
            selectedLanguage = lang.language
            selectedLanguageId = lang.languageId
            getLanguageContents(languagaeId: languageId)
        }
    }
    ///
    /// ```
    /// Get String.
    /// ```
    /// - Parameters:
    ///   - key: language content key.
    ///   - defaultValue: default value if there is no content available for the ``key``.
    ///
    public func getString(for key: String, defaultValue: String? = nil) -> String {
        let content = contentCache.object(forKey: key as NSString)
        let contentString = content as? String
        return contentString ?? defaultValue ?? key
    }
    ///
    /// ```
    /// Get language content.
    /// ```
    /// - Parameters:
    ///   - languagaeId: language id to loads language content.
    ///
    /// Check whether the language content for seleced language is available in coredata.
    /// if availabe loads from coredata else make API calls to download.
    ///
    private func getLanguageContents(languagaeId: String) {
        // get contents for the selected language.
        if checkLocalStorage() {
            // TODO: check for updates
            // if updates available need to update local database.
            // fetch from local database
            loadCache()
        } else {
            // TODO: fetch from server and save in local database
            
            let langContent = PreviewData.shared.getContent(for: languagaeId)
            
            // from temp
            saveLanguageContents(contents: langContent)
            cacheLanguageContents(contents: langContent)
        }
    }
    ///
    /// ```
    /// Save language contents.
    /// ```
    /// - Parameters:
    ///   - contents: array of language contents in ``[LanguageContent]`` type.
    ///
    /// save it into coredata.
    ///
    private func saveLanguageContents(contents: [LanguageContent]) {
        // save or update languade contents to the local database
        repo.saveLanguageContents(contents)
    }
    ///
    /// ```
    /// Save supported languages.
    /// ```
    /// - Parameters:
    ///   - contents: array of supported languages in ``[SupportedLanguage]`` type.
    ///
    /// save it into coredata.
    ///
    private func saveSupportedLanguages(languages: [SupportedLanguage]) {
        repo.saveSupportedLanguages(languages: languages)
    }
    ///
    /// ```
    /// Load cache
    /// ```
    /// Get the language content for selected language form coredata.
    ///
    private func loadCache() {
        if let langId = selectedLanguageId {
            let contents = repo.getContents(for: langId)
            cacheLanguageContents(contents: contents)
        }
    }
    ///
    /// ```
    /// Cache language contents.
    /// ```
    /// Update `selected language` contents in `cache` memory
    ///
    private func cacheLanguageContents(contents: [LanguageContent]) {
        contents.forEach { content in
            contentCache.setObject(content.content as NSString, forKey: content.key as NSString)
        }
    }
    ///
    /// ```
    /// Clear Cache
    /// ```
    /// Removes all object from ``cache``.
    ///
    private func clearCache() {
        contentCache.removeAllObjects()
    }
    ///
    /// ```
    /// Check local storage.
    /// ```
    /// Check whether the ``contents`` for `selected language` available in coredata.
    ///
    private func checkLocalStorage() -> Bool {
        if let langId = selectedLanguageId {
            return repo.isContentAvailable(for: langId)
        }
        return false
    }
    
}
