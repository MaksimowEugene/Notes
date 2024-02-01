//
//  NotesListViewModel.swift
//  Notes
//
//  Created by Eugene Maksimow on 26.01.2024.
//

import Foundation
import Combine

final class NotesListViewModel {
    var notes = PassthroughSubject<[NoteModel], Never>()
    
    var createNoteTitle = CurrentValueSubject<String?, Never>(nil)
    
    var isLoading = CurrentValueSubject<Bool, Never>(false)
    
    private let router: RouterProtocol
    private let coreDataService: CoreDataServiceProtocol
    private var cancellables: Set<AnyCancellable> = []
    
    required init(router: RouterProtocol, coreDataService: CoreDataServiceProtocol) {
        self.router = router
        self.coreDataService = coreDataService
        
        coreDataService.dataChangePublisher
            .sink { [weak self] _ in
                self?.loadNotes()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Core Data
    
    private func loadNotesFromCoreData() -> [NoteModel]? {
        isLoading.send(true)
        
        guard var dbNotes = try? coreDataService.fetchNotes()
        else {
            isLoading.send(false)
            return nil
        }
        
        if dbNotes.isEmpty {
            createExampleNote()
            
            guard let notes = try? coreDataService.fetchNotes() else { return nil }
            dbNotes = notes
        }
        
        let notes: [NoteModel] = dbNotes.compactMap { dbNote in
            let id = dbNote.id ?? UUID()
            let title = dbNote.title ?? ""
            let text = dbNote.text ?? NSMutableAttributedString("")
            
            return NoteModel(id: id,
                             title: title,
                             text: NSMutableAttributedString(attributedString: text))
        }
        
        isLoading.send(false)
        
        return notes
    }
    
    private func createExampleNote() {
        coreDataService.save { context in
            let exampleNote = DBNote(context: context)
            exampleNote.id = UUID()
            exampleNote.title = "Example Note"
            exampleNote.text = NSMutableAttributedString(string: "This is an example note. Feel free to edit or delete it.")
        }
    }
}

extension NotesListViewModel: NotesListViewModelProtocol {
    
    func loadNotes() {
        DispatchQueue.main.async { [weak self] in
            guard let self,
                  let dbNotes = self.loadNotesFromCoreData()
            else { return }
            self.notes.send(dbNotes)
        }
    }
    
    internal func createNote() {
        coreDataService.save { context in
            let newNote = DBNote(context: context)
            newNote.id = UUID()
            newNote.title = self.createNoteTitle.value
            newNote.text = NSMutableAttributedString(string: "")
        }
    }
    
    func deleteNote(by id: UUID) {
        coreDataService.deleteNote(with: id)
    }
    
    func showNoteView(note: NoteModel) {
        router.instantiateNoteView(noteModel: note)
    }
    
    // future possible sort available
    func sortNotes(_ notes: [NoteModel]) -> [NoteModel] {
        return notes
    }
}
