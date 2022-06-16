//
//  DataManager.swift
//  
//
//  Created by Packiaseelan S on 16/06/22.
//

import CoreData
import SwiftUI

typealias Completion = (Error?) -> ()

class DataManager {
    
    static let shared = DataManager()
    private let containerName = "Localisation"
    
    private let container: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext  {
        container.viewContext
    }
    
    private init() {
        guard
            let modelURL = Bundle.module.url(forResource: containerName, withExtension: "momd"),
            let model = NSManagedObjectModel(contentsOf: modelURL) else {
                container = NSPersistentContainer(name: containerName)
                container.loadPersistentStores(completionHandler: completionHandler)
                return
        }
        
        container = NSPersistentContainer(name: containerName, managedObjectModel:model)
        container.loadPersistentStores(completionHandler: completionHandler)
    }
    
    private func completionHandler(description: NSPersistentStoreDescription, error: Error?) {
        if let error = error {
            fatalError("Error initializing CoreData: \(error)")
        }
    }
    
    func save(completion: @escaping Completion) {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
                completion(nil)
            } catch let error {
                completion(error)
            }
        }
    }
    
    func delete(_ object: NSManagedObject, completion: @escaping Completion) {
        container.viewContext.delete(object)
        save(completion: completion)
    }
    
    func getSupportedLanguages() -> [SupportedLanguagesEntity] {
        let supLangFtchReq = NSFetchRequest<SupportedLanguagesEntity>(entityName: "SupportedLanguagesEntity")
        
        do {
            return try container.viewContext.fetch(supLangFtchReq)
        } catch let error {
            print("Error fetching supported languages from local database, \(error)")
        }
        return []
    }
    
    func getLanguage(for languageId: String) -> SupportedLanguagesEntity? {
        let supLangFtchReq = NSFetchRequest<SupportedLanguagesEntity>(entityName: "SupportedLanguagesEntity")
        supLangFtchReq.predicate = NSPredicate(format: "languageId == %@", languageId)
        do {
            return try container.viewContext.fetch(supLangFtchReq).first
        } catch let error {
            print("Error fetching supported languages from local database, \(error)")
        }
        return nil
    }

    func getLanguageContent(for languageId: String) -> [LanguageContentEntity] {
        let langCntFtchReq = NSFetchRequest<LanguageContentEntity>(entityName: "LanguageContentEntity")
        langCntFtchReq.predicate = NSPredicate(format: "languageId == %@", languageId)
        do {
            return try container.viewContext.fetch(langCntFtchReq)
        } catch let error {
            print("Error fetching language contents from local database, \(error)")
        }
        return []
    }
    
}
