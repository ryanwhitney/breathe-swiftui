//
//  Persistence.swift
//  Shared
//

import CoreData


struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        let newRoutine = Routine(context: viewContext)
        
        for i in 0..<3 {
            switch i {
                case 0:
                    newRoutine.name = "Calm Breathing"
                    newRoutine.instruction = "i:4,p:2,e:4,p:4,r:30"
                    newRoutine.dateCreated = Date()
                    newRoutine.desc = "a sixty second breath routine to start your day"
                case 1:
                    let newRoutine = Routine(context: viewContext)
                    newRoutine.name = "5-5-5"
                    newRoutine.instruction = "i:5,p:5,e:5,p:5,r:30"
                    newRoutine.dateCreated = Date()
                    newRoutine.desc = "a box breathing routine for relaxation"
                case 2:
                    let newRoutine = Routine(context: viewContext)
                    newRoutine.name = "Relaxing Breath"
                    newRoutine.instruction = "i:4,p:7,e:8,p:7,r20"
                    newRoutine.dateCreated = Date()
                    newRoutine.desc = "a 4-7-8 breathing technique for relaxation"
                default:
                    break
            }
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

    let container: NSPersistentCloudKitContainer
    
    func save() {
        let context = container.viewContext

        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("err-or")
            }
        }
    }
    
    
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "breathe_swiftui")
        
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
