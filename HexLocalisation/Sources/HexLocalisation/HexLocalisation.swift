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
            
            var langContent:  [LanguageContent] = []
            
            switch languagaeId {
            case "1":
                langContent = english
                break
            case "2":
                langContent = tamil
                break
            case "3":
                langContent = malayalam
                break
            case "4":
                langContent = telugu
                break
            case "5":
                langContent = hindi
                break
            default:
                langContent = english
                break
                
            }
            
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

// temp
let supportedLanguages: [SupportedLanguage] = [
    SupportedLanguage(languageId: "1", language: "English", displayContent: "Welcome"),
    SupportedLanguage(languageId: "2", language: "Tamil", displayContent: "வரவேற்பு"),
    SupportedLanguage(languageId: "3", language: "Malayalam", displayContent: "സ്വാഗതം"),
    SupportedLanguage(languageId: "4", language: "Telugu", displayContent: "స్వాగతం"),
    SupportedLanguage(languageId: "5", language: "Hindi", displayContent: "स्वागत हे"),
]

let english: [LanguageContent] = [
    LanguageContent(id: "1", languageId: "1", key: "app_name", content: "My App"),
    LanguageContent(id: "2", languageId: "1", key: "app_description", content: "This is the example app for hex localisaction"),
    LanguageContent(id: "3", languageId: "1", key: "question", content: "What is localisation in computer?"),
    LanguageContent(id: "4", languageId: "1", key: "answer", content: "Localization is the process of adapting internationalized software for a specific region or language by translating text and adding locale-specific components."),
]

let tamil: [LanguageContent] = [
    LanguageContent(id: "1", languageId: "2", key: "app_name", content: "எனது பயன்பாடு"),
    LanguageContent(id: "2", languageId: "2", key: "app_description", content: "இது ஹெக்ஸ் உள்ளூர்மயமாக்கலுக்கான எடுத்துக்காட்டு பயன்பாடாகும்"),
    LanguageContent(id: "3", languageId: "2", key: "question", content: "கணினியில் உள்ளூர்மயமாக்கல் என்றால் என்ன?"),
    LanguageContent(id: "4", languageId: "2", key: "answer", content: "உள்ளூர்மயமாக்கல் என்பது ஒரு குறிப்பிட்ட பிராந்தியம் அல்லது மொழிக்கான சர்வதேசமயமாக்கப்பட்ட மென்பொருளைத் தழுவி, உரையை மொழிபெயர்ப்பதன் மூலமும், உள்ளூர்-குறிப்பிட்ட கூறுகளைச் சேர்ப்பதன் மூலமும் ஆகும்."),
]

let malayalam: [LanguageContent] = [
    LanguageContent(id: "1", languageId: "3", key: "app_name", content: "എന്റെ ആപ്പ്"),
    LanguageContent(id: "2", languageId: "3", key: "app_description", content: "ഹെക്‌സ് ലോക്കലൈസേഷനുള്ള ഉദാഹരണ ആപ്പാണിത്"),
    LanguageContent(id: "3", languageId: "3", key: "question", content: "കമ്പ്യൂട്ടറിലെ പ്രാദേശികവൽക്കരണം എന്താണ്?"),
    LanguageContent(id: "4", languageId: "3", key: "answer", content: "ടെക്‌സ്‌റ്റ് വിവർത്തനം ചെയ്‌ത് പ്രാദേശിക-നിർദ്ദിഷ്‌ട ഘടകങ്ങൾ ചേർത്ത് ഒരു പ്രത്യേക പ്രദേശത്തിനോ ഭാഷയ്‌ക്കോ വേണ്ടി അന്താരാഷ്ട്രവൽക്കരിച്ച സോഫ്റ്റ്‌വെയർ പൊരുത്തപ്പെടുത്തുന്ന പ്രക്രിയയാണ് പ്രാദേശികവൽക്കരണം.")
]

let telugu: [LanguageContent] = [
    LanguageContent(id: "1", languageId: "4", key: "app_name", content: "నా యాప్"),
    LanguageContent(id: "2", languageId: "4", key: "app_description", content: "హెక్స్ స్థానికీకరణకు ఇది ఉదాహరణ యాప్"),
    LanguageContent(id: "3", languageId: "4", key: "question", content: "కంప్యూటర్‌లో స్థానికీకరణ అంటే ఏమిటి?"),
    LanguageContent(id: "4", languageId: "4", key: "answer", content: "స్థానికీకరణ అనేది టెక్స్ట్‌ను అనువదించడం మరియు లొకేల్-నిర్దిష్ట భాగాలను జోడించడం ద్వారా నిర్దిష్ట ప్రాంతం లేదా భాష కోసం అంతర్జాతీయ సాఫ్ట్‌వేర్‌ను స్వీకరించే ప్రక్రియ.")
]

let hindi: [LanguageContent] = [
    LanguageContent(id: "1", languageId: "5", key: "app_name", content: "मेरा ऐप"),
    LanguageContent(id: "2", languageId: "5", key: "app_description", content: "यह हेक्स स्थानीयकरण के लिए उदाहरण ऐप है"),
    LanguageContent(id: "3", languageId: "5", key: "question", content: "कंप्यूटर में स्थानीयकरण क्या है?"),
    LanguageContent(id: "4", languageId: "5", key: "answer", content: "स्थानीयकरण एक विशिष्ट क्षेत्र या भाषा के लिए पाठ का अनुवाद करके और स्थानीय-विशिष्ट घटकों को जोड़कर अंतर्राष्ट्रीयकृत सॉफ़्टवेयर को अनुकूलित करने की प्रक्रिया है।")
]
