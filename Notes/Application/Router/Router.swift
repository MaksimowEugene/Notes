//
//  Router.swift
//  Notes
//
//  Created by Eugene Maksimow on 26.01.2024.
//

import UIKit

final class Router {
    
    private let assembly: AssemblyProtocol
    private let navigationController: UINavigationController
    
    init(assembly: AssemblyProtocol, navigationController: UINavigationController) {
        self.assembly = assembly
        self.navigationController = navigationController
    }
}


extension Router: RouterProtocol {
    
    func instantiateNotesListView() {
        let mainViewController = assembly.createNotesListModule(router: self)
        navigationController.viewControllers = [mainViewController]
    }
    
    func instantiateNoteView(noteModel: NoteModel) {
        let noteViewController = assembly.createNoteModule(router: self, noteModel: noteModel)
        navigationController.pushViewController(noteViewController, animated: true)
    }
    
    func instantiateSettingsView() {
        let mainViewController = assembly.createSettingsModule(router: self)
        navigationController.viewControllers = [mainViewController]
    }

    func popToRoot() {
        navigationController.popToRootViewController(animated: true)
    }
}
