//
//  LanguageContent.swift
//  
//
//  Created by Packiaseelan S on 10/06/22.
//

import Foundation

public struct LanguageContent: Identifiable, Codable {
    public let id: String
    let languageId: String
    let key: String
    let content: String
}
