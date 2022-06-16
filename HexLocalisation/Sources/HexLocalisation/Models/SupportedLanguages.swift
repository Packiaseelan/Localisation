//
//  SupportedLanguages.swift
//  
//
//  Created by Packiaseelan S on 10/06/22.
//

import Foundation

public struct SupportedLanguage: Identifiable, Codable {
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
    
}
