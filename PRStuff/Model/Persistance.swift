//
//  Persistance.swift
//  PRStuff
//
//  Created by Hans Capapey sierra on 1/6/22.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<2 {
            let newItem = Registro(context: viewContext)
            newItem.food = "Platano"
            newItem.time = Date()
            newItem.quantity = 25
            newItem.type = "Proteïnes"
        }
        for _ in 0..<1 {
            let newItem = Usuario(context: viewContext)
            newItem.name = "Michelle"
            newItem.height = 32
            newItem.weight = 25
            newItem.genderName = "Dona"
            newItem.gender = 0
            newItem.age = 32
            newItem.sportName = "Moderat"
            newItem.sport = 1
            
        }
        for _ in 0..<2 {
            let newItem2 = Registro(context: viewContext)
            newItem2.food = "cum"
            newItem2.time = Date()
            newItem2.quantity = 25
            newItem2.type = "Proteïnes"
        }
        for _ in 0..<1 {
            let newItem = FavoriteType(context: viewContext)
            newItem.nameOfType = "Proteïnes"
        }
        for _ in 0..<4 {
            let newItem = Registro(context: viewContext)
            newItem.food = "Platano"
            newItem.time = Calendar.current.date(byAdding: .day, value: -2, to: Date())
            newItem.quantity = 25
            newItem.type = "Proteïnes"
        }
        for _ in 0..<3 {
            let newItem = Registro(context: viewContext)
            newItem.food = "Sandía"
            newItem.time = Date()
            newItem.quantity = 25
            newItem.type = "Fibra"
        }
        for _ in 0..<20 {
            let newItem = Registro(context: viewContext)
            newItem.food = "Sandía"
            newItem.time = Calendar.current.date(byAdding: .day, value: -1, to: Date())
            newItem.quantity = 25
            newItem.type = "Fibra"
        }
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
    
    

    let container: NSPersistentContainer

    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Model")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
