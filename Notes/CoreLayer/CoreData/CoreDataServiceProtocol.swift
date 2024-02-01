//
//  CoreDataServiceProtocol.swift
//  Notes
//
//  Created by Eugene Maksimow on 26.01.2024.
//

import CoreData
import Combine

protocol CoreDataServiceProtocol: AnyObject {
    var dataChangePublisher: PassthroughSubject<Void, Never> { get }

    func save(block: @escaping (NSManagedObjectContext) throws -> Void)
    func fetchObject<Object: NSManagedObject>(with id: UUID, of type: Object.Type) throws -> Object?
    func fetchNotes() throws -> [DBNote]
    func deleteNote(with id: UUID)
}
