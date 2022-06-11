//
//  Utility.swift
//  
//
//  Created by Packiaseelan S on 10/06/22.
//

import Foundation

/// getFileUrl
/// ```
/// get database file url from caches directory.
/// ```
func getFileUrl(for fileName: String) -> URL? {
    return FileManager
        .default
        .urls(for: .cachesDirectory, in: .userDomainMask)
        .first?
        .appendingPathComponent("\(fileName).realm");
}

/// isFileExists
/// ```
/// Check whether the file exists or not.
/// ```
func isFileExists(name: String) -> Bool {
    guard let url = getFileUrl(for: name) else {
        return false
    }
    
    return FileManager.default.fileExists(atPath: url.path)
}
