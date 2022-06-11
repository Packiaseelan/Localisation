//
//  SupportedLanguages.swift
//  
//
//  Created by Packiaseelan S on 10/06/22.
//

import Foundation
import RealmSwift

class SupportedLanguage: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var languageId = ""
    @Persisted var language = ""
    @Persisted var displayContent = ""
    @Persisted var iconPath = ""
    
    /// ```
    /// Convert to data model
    /// ```
    func toModel() -> SupportedLang {
        return SupportedLang(
            languageId: self.languageId,
            language: self.language,
            displayContent: self.displayContent,
            iconPath: self.iconPath
        )
    }
}

struct SupportedLanguageResponse: Codable {
    let statusCode: Int
    let message: String?
    let supportedLanguage: [SupportedLang]

    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case message
        case SupportedLang = "supported_language"
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.statusCode = try container.decode(Int.self, forKey: .statusCode)
        self.message = try container.decode(String.self, forKey: .message)
        self.supportedLanguage = try container.decode([SupportedLang].self, forKey: .SupportedLang)
    }
}

public struct SupportedLang: Identifiable, Codable {
    public let languageId: String
    public let language: String
    public let displayContent: String
    public var iconPath: String? = ""
    
    public var id: String {
        return self.languageId
    }
    
    public init(languageId: String, language: String, displayContent: String, iconPath: String = "") {
        self.languageId = languageId
        self.language = language
        self.displayContent = displayContent
        self.iconPath = iconPath
    }
    
    /// ```
    /// Convert model to database object
    /// ```
    func toObject() -> SupportedLanguage {
        return SupportedLanguage(
            value: [
                "languageId": self.languageId,
                "language": self.language,
                "displayContent": self.displayContent,
                "iconPath": self.iconPath
            ]
        )
    }
}

