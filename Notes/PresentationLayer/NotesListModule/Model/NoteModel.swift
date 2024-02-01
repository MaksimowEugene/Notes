//
//  NoteModel.swift
//  Notes
//
//  Created by Eugene Maksimow on 26.01.2024.
//

import Foundation

struct NoteModel: Hashable {
    let id: UUID
    var title: String
    var text: NSMutableAttributedString
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(title)
        hasher.combine(text)
    }
    
    static func == (lhs: NoteModel, rhs: NoteModel) -> Bool {
        return lhs.id == rhs.id
            && lhs.title == rhs.title
            && lhs.text == rhs.text
    }
}
