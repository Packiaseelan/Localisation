//
//  DataManager.swift
//  
//
//  Created by Packiaseelan S on 16/06/22.
//

import CoreData

typealias Completion = (Error?) -> ()

class DataManager {
    ///
    /// ```
    /// Local database name.
    /// ```
    /// Its ``private`` because it is not required out of this `class`.
    ///
    private let containerName = "Localisation"
    ///
    /// ```
    /// Container holds the database.
    /// ```
    /// Its ``private`` due to security.
    ///
    private let container: NSPersistentContainer
    ///
    /// ```
    /// Singleton instance for [DataManager] class
    /// ```
    ///
    static let shared = DataManager()
    ///
    /// ```
    /// ViewContext of the openned coredata.
    /// ```
    ///
    var viewContext: NSManagedObjectContext  {
        container.viewContext
    }
    ///
    /// ```
    /// Initialise DataManager.
    /// ```
    /// The ``init`` marked as `private` to avoide multiple instance.
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
    ///
    /// ```
    /// Completion handler to handle error while opening database.
    /// ```
    ///
    private func completionHandler(description: NSPersistentStoreDescription, error: Error?) {
        if let error = error {
            fatalError("Error initializing CoreData: \(error)")
        }
    }
    ///
    /// ```
    /// Saves the current database contexts
    /// ```
    /// if ``viewContext`` has any changes.
    ///
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
    ///
    /// ```
    /// Deletes the object from the database.
    /// ```
    /// the object should be any ``Entity`` in the openned coredata..
    ///
    func delete(_ object: NSManagedObject, completion: @escaping Completion) {
        container.viewContext.delete(object)
        save(completion: completion)
    }
    ///
    /// ```
    /// Gets the supported languages.
    /// ```
    /// Fetch the supported languages from coredata and returned in ``[SupportedLanguagesEntity]`` type.
    /// If there is no languages available in coredata it returns ``Empty Array``
    ///
    func getSupportedLanguages() -> [SupportedLanguagesEntity] {
        let supLangFtchReq = NSFetchRequest<SupportedLanguagesEntity>(entityName: "SupportedLanguagesEntity")
        
        do {
            return try container.viewContext.fetch(supLangFtchReq)
        } catch let error {
            print("Error fetching supported languages from local database, \(error)")
        }
        return []
    }
    ///
    /// ```
    /// Gets the language.
    /// ```
    /// It rerurn ``nil`` if `languageId` not available in coredata.
    /// else it will returns the appropriate language in ``SupportedLanguagesEntity`` type.
    ///
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
    ///
    /// ```
    /// Gets the language contents.
    /// ```
    /// It rerurn ``Empty Array`` if `languageId` not available in coredata.
    /// else it will return all the contents for the provided `languageId` in ``[LanguageContentEntity]`` type.
    ///
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
