//
//  RouterProtocol.swift
//  Notes
//
//  Created by Eugene Maksimow on 26.01.2024.
//

import Foundation

protocol RouterProtocol: AnyObject {
    func instantiateNotesListView()
    func instantiateNoteView(noteModel: NoteModel)
    func instantiateSettingsView()
    func popToRoot()
}
