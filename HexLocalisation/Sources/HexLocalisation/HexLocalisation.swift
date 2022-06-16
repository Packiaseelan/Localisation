import SwiftUI

public struct HexLocalisation {
   
    @AppStorage("selectedLanguageId") var selectedLanguageId: String?
    @AppStorage("selectedLanguage") var selectedLanguage: String?
    
    private let appId: String
    private let apiKey: String
    private var contentCache : NSCache<NSString, NSString>
    private let repo = DataRepository.shared
    
    /// ```
    /// Initialize the HexLocalisation with your app_id and api_key
    /// ```
    public init(appId: String, apiKey: String) {
        self.appId = appId
        self.apiKey = apiKey
        self.contentCache = NSCache<NSString, NSString>()
        
        if selectedLanguage != nil {
            loadCache()
        }
    }
    
    /// ```
    /// gets the supported language for the app_id and api_key provided.
    /// ```
    public func getSupportedLanguages() -> [SupportedLanguage] {
        // get supported languages for appId
        let supported  = repo.getSUpportedLanguages()
        if supported.isEmpty {
            // TODO: make API call to get the supported language and store in local
            
            // store in local
            let supportedLanguages = PreviewData.shared.supportedLanguages
            
            saveSupportedLanguages(languages: supportedLanguages)
            
            return supportedLanguages
        }
        
        return supported
    }
    
    /// ```
    /// Update the selected language in the AppStorage and
    /// loads the language content in the cache.
    /// ```
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
    
    /// ```
    /// Gets the String value for the key provided.
    /// ```
    public func getString(for key: String, defaultValue: String? = nil) -> String {
        let content = contentCache.object(forKey: key as NSString)
        let contentString = content as? String
        return contentString ?? defaultValue ?? key
    }
    
    /// ```
    /// Check whether the language content for seleced language
    /// is available in local database.
    /// if availabe loads from local else make API calls to download.
    /// ```
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
    
    /// ```
    /// Save the language contents into the local database.
    /// ```
    private func saveLanguageContents(contents: [LanguageContent]) {
        // save or update languade contents to the local database
        repo.saveLanguageContents(contents)
    }
    
    private func saveSupportedLanguages(languages: [SupportedLanguage]) {
        repo.saveSupportedLanguages(languages: languages)
    }
    
    /// ```
    /// Get the language content form local database
    /// ```
    private func loadCache() {
        if let langId = selectedLanguageId {
            let contents = repo.getContents(for: langId)
            cacheLanguageContents(contents: contents)
        }
    }
    
    /// ```
    /// Update cache with language content.
    /// ```
    private func cacheLanguageContents(contents: [LanguageContent]) {
        contents.forEach { content in
            contentCache.setObject(content.content as NSString, forKey: content.key as NSString)
        }
    }
    
    private func clearCache() {
        contentCache.removeAllObjects()
    }
    
    /// checkLocalStorage
    /// ```
    /// Check [selectedLanguage] content available in local
    /// ```
    private func checkLocalStorage() -> Bool {
        if let langId = selectedLanguageId {
            return repo.isContentAvailable(for: langId)
        }
        return false
    }
}
