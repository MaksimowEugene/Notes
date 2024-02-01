//
//  CoreDataService.swift
//  Notes
//
//  Created by Eugene Maksimow on 26.01.2024.
//

import CoreData
import Combine

private struct Constants {
    static let containerName = "Note"
}

final class CoreDataService {
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Constants.containerName)
        container.loadPersistentStores { _, error in
            guard let error else { return }
        }
        
        return container
    }()
    
    private lazy var viewContext: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
    var dataChangePublisher = PassthroughSubject<Void, Never>()
}

extension CoreDataService: CoreDataServiceProtocol {
    
    // MARK: - General
    
    func save(block: @escaping (NSManagedObjectContext) throws -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        backgroundContext.perform {
            do {
                try block(backgroundContext)
                if backgroundContext.hasChanges {
                    try backgroundContext.save()
                    self.dataChangePublisher.send()
                }
            } catch {
                let errorMessage = "Failed to save data: \(error.localizedDescription)."
                print(errorMessage)
            }
        }
    }
    
    func fetchObject<Object: NSManagedObject>(with id: UUID, of type: Object.Type) throws -> Object? {
        let fetchRequest = Object.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        let dbObject = try viewContext.fetch(fetchRequest).first as? Object
        guard let dbObject else {
            let errorMessage = "\(Object.entity().name ?? "Object") wasn't fetched (id: \(id))."
            print(errorMessage)
            return nil
        }
        
        let successMessage = "\(Object.entity().name ?? "Object") has been fetched (id: \(id))."
        print(successMessage)        
        return dbObject
    }
    
    // MARK: - Notes
    
    func deleteNote(with id: UUID) {
        guard let noteID = try? fetchObject(with: id, of: DBNote.self)?.objectID else { return }
        
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            do {
                guard let noteOnBackgroundContext = try backgroundContext.existingObject(with: noteID)
                        as? DBNote
                else { return }
                backgroundContext.delete(noteOnBackgroundContext)
                try backgroundContext.save()
                self.dataChangePublisher.send()
            } catch {
                let errorMessage = "Failed to delete note (id: \(id)): \(error.localizedDescription)."
                print(errorMessage)
            }
        }    }
    
    func fetchNotes() throws -> [DBNote] {
        let fetchRequest = DBNote.fetchRequest()
        let dbNotes = try viewContext.fetch(fetchRequest)
        
        guard !dbNotes.isEmpty else {
            return []
        }

        return dbNotes
    }
}

extension CoreDataService: NSCopying {
    
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
