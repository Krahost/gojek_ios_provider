//
//  DatabaseManager.swift
//  GoJekProvider
//
//  Created by CSS on 25/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import CoreData


final class DataBaseManager {
    
    private init() {}
    
    static let shared = DataBaseManager()

    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "GoJekProvider")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
            
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var context = persistentContainer.viewContext
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetch<T: NSManagedObject>(_ objectType: T.Type) -> [T] {
        let entityName = String(describing: objectType)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        do {
            let fetchObjects = try context.fetch(fetchRequest) as? [T]
            return fetchObjects ?? [T]()
        }catch{
            print(error)
            return [T]()
        }
        
    }

    func delete(entityName: String) {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        }catch{
            print(error)
        }
        
    }
}


