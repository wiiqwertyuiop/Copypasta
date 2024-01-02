import Foundation
import CoreData

class PastaDatabase
{
    static let shared = PastaDatabase()
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Copypasta")
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
        return container
    }()
    
    func getStoredDataFromCoreData() -> [Pasta] {
        // Get copypasta data, by date
        let context = persistentContainer.viewContext
        let sort = NSSortDescriptor(keyPath: \Pasta.lastUsed, ascending: false)
        let fetchRequest = NSFetchRequest<Pasta>(entityName: "Pasta")
        fetchRequest.sortDescriptors = [sort]
        do {
            return try context.fetch(fetchRequest)
        } catch let error as NSError {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func deleteFromContext(pasta: Pasta) {
        let context = persistentContainer.viewContext
        context.delete(pasta)
        updateContext(context: context)
    }
    
    func createNewContext(text: String) -> Pasta {
        let context = persistentContainer.viewContext
        let newItem = Pasta(context: context)
        newItem.text = text
        newItem.lastUsed = Date()
        updateContext(context: context)
        return newItem
    }
    
    func updateContext(context: NSManagedObjectContext? = nil) {
        let context = context ?? persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
