//
//  LanguageContent.swift
//  
//
//  Created by Packiaseelan S on 10/06/22.
//

import Foundation
import RealmSwift

class LanguageContent: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var languageId = ""
    @Persisted var key = ""
    @Persisted var content = ""
    
    /// ```
    /// Convert to data model
    /// ```
    func toModel() -> LangContent {
        return LangContent(
            id: self.id.stringValue,
            languageId: self.languageId,
            key: self.key,
            content: self.content
        )
    }
}

public struct LangContent: Identifiable, Codable {
    public let id: String
    let languageId: String
    let key: String
    let content: String
    
    /// ```
    /// Convert model to database object
    /// ```
    func toObject() -> LanguageContent {
        return LanguageContent(
            value: [
                "languageId": self.languageId,
                "key": self.key,
                "content": self.content
            ]
        )
    }
}
