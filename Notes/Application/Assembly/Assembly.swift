//
//  Assembly.swift
//  Notes
//
//  Created by Eugene Maksimow on 26.01.2024.
//

import UIKit

final class Assembly {
    
    
    // MARK: - Store
    
    private lazy var coreDataService: CoreDataServiceProtocol = {
        let service = CoreDataService()
        
        return service
    }()
    
    // MARK: - UI
    
    private lazy var navigationBarBuilder: NavigationBarBuilderProtocol = {
        let service = NavigationBarBuilder()
        
        return service
    }()
    
    private lazy var alertBuilder: AlertProtocol & AlertActionProtocol = {
        let service = AlertBuilder()
        
        return service
    }()
}

extension Assembly: AssemblyProtocol {
    
    func createNotesListModule(router: RouterProtocol) -> UIViewController {
        let notesListViewModel = NotesListViewModel(router: router, coreDataService: coreDataService)
        let view = NotesListViewController(viewModel: notesListViewModel,
                                           navigationBarBuilder: navigationBarBuilder, 
                                           alertBuilder: alertBuilder)
        return view
    }
    
    func createNoteModule(router: RouterProtocol, noteModel: NoteModel) -> UIViewController {
        let noteViewModel = NoteViewModel(router: router, coreDataService: coreDataService, noteModel: noteModel)
        let view = NoteViewController(viewModel: noteViewModel,
                                           navigationBarBuilder: navigationBarBuilder,
                                           alertBuilder: alertBuilder)
        return view
    }

    func createSettingsModule(router: RouterProtocol) -> UIViewController {

        return UIViewController()
    }
    
}
