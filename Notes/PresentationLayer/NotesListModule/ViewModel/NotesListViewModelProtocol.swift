//
//  NotesListViewModelProtocol.swift
//  Notes
//
//  Created by Eugene Maksimow on 26.01.2024.
//

import Foundation
import Combine

protocol NotesListViewModelProtocol: AnyObject {
    var notes: PassthroughSubject<[NoteModel], Never> { get }
    
    var createNoteTitle: CurrentValueSubject<String?, Never> { get }
    
    var isLoading: CurrentValueSubject<Bool, Never> { get }
    
    init(router: RouterProtocol,
         coreDataService: CoreDataServiceProtocol)
    
    func loadNotes()
    func createNote()
    func deleteNote(by id: UUID)
    func sortNotes(_ notes: [NoteModel]) -> [NoteModel]
    func showNoteView(note: NoteModel)
}
