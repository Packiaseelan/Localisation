import SwiftUI

public struct HexLocalisation {
   
    @AppStorage("selectedLanguageId") var selectedLanguageId: String?
    @AppStorage("selectedLanguage") var selectedLanguage: String?
    
    private let appId: String
    private let apiKey: String
    private var contentCache : NSCache<NSString, NSString>
    private let manager = RealmManager.shared
    
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
    public func getSupportedLanguages() -> [SupportedLang] {
        // get supported languages for appId
        let supported = manager.suppotredLang.getLanguageContent()
        if supported.isEmpty {
            print("supported language from temp")
            // TODO: make API call to get the supported language and store in local
            // mock data
            let supportedLanguages = MockData.shared.supportedLanguages
            // store in local
            saveSupportedLanguages(languages: supportedLanguages)
            
            return supportedLanguages
        }
        
        var list: [SupportedLang] = []
        supported.forEach { supLang in
            list.append(supLang.toModel())
        }
        
        print("supported language from local database")
        return list
    }
    
    /// ```
    /// Update the selected language in the AppStorage and
    /// loads the language content in the cache.
    /// ```
    public func selectLanguage(languageId: String) {
        // update selected language in AppStorage
        if let lang = manager.suppotredLang.getLanguage(languageId: languageId) {
            selectedLanguage = lang.language
            selectedLanguageId = lang.languageId
            getLanguageContents(languagaeId: languageId)
        }
    }
    
    /// ```
    /// Gets the String value for the key provided.
    /// ```
    public func getString(for key: String) -> String {
        let content = contentCache.object(forKey: key as NSString)
        let contentString = content as? String
        return contentString ?? key
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
            
            // from temp
            saveLanguageContents(contents: english)
            cacheLanguageContents(contents: english)
        }
    }
    
    /// ```
    /// Save the language contents into the local database.
    /// ```
    private func saveLanguageContents(contents: [LangContent]) {
        // save or update languade contents to the local database
        var cont: [LanguageContent] = []
        contents.forEach { eng in
            cont.append( eng.toObject())
        }
        manager.langContent.insertAll(contents: cont)
    }
    
    private func saveSupportedLanguages(languages: [SupportedLang]) {
        var supported: [SupportedLanguage] = []
        
        languages.forEach { supLng in
            supported.append(supLng.toObject())
        }
        
        manager.suppotredLang.insertAll(contents: supported)
    }
    
    /// ```
    /// Get the language content form local database
    /// ```
    private func loadCache() {
        // fetch from local database
        let con = manager.langContent.getLanguageContent()
        var co: [LangContent] = []
        // conver to model
        con.forEach { c in
            co.append(c.toModel())
        }
        cacheLanguageContents(contents: co)
    }
    
    /// ```
    /// Update cache with language content.
    /// ```
    private func cacheLanguageContents(contents: [LangContent]) {
        contents.forEach { content in
            contentCache.setObject(content.content as NSString, forKey: content.key as NSString)
        }
        print("language content loaded into cache.")
    }
    
    /// checkLocalStorage
    /// ```
    /// Check [selectedLanguage] content available in local
    /// ```
    private func checkLocalStorage() -> Bool {
        if let lang = selectedLanguage {
            return manager.isContainerExists(for: lang)
        }
        return false
    }
}

// temp
//let supportedLanguages: [SupportedLang] = [
//    SupportedLang(languageId: "1", language: "English", displayContent: "Welcome"),
//    SupportedLang(languageId: "2", language: "Tamil", displayContent: "வரவேற்பு"),
//    SupportedLang(languageId: "3", language: "Malayalam", displayContent: "സ്വാഗതം"),
//    SupportedLang(languageId: "4", language: "Telugu", displayContent: "స్వాగతం"),
//    SupportedLang(languageId: "5", language: "Hindi", displayContent: "स्वागत हे"),
//]

let english: [LangContent] = [
    LangContent(id: "1", languageId: "1", key: "app_name", content: "My App"),
    LangContent(id: "2", languageId: "1", key: "app_description", content: "This is the example app for hex localisaction"),
]
