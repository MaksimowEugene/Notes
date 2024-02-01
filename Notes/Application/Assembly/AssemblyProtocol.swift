//
//  AssemblyProtocol.swift
//  Notes
//
//  Created by Eugene Maksimow on 26.01.2024.
//

import UIKit

protocol AssemblyProtocol: AnyObject {
    func createNotesListModule(router: RouterProtocol) -> UIViewController
    func createNoteModule(router: RouterProtocol, noteModel: NoteModel) -> UIViewController
    func createSettingsModule(router: RouterProtocol) -> UIViewController
}
