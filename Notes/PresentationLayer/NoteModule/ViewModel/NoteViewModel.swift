//
//  NoteViewModel.swift
//  Notes
//
//  Created by Eugene Maksimow on 29.01.2024.
//

import Combine
import UIKit

final class NoteViewModel {
    
    var noteModel: NoteModel
    
    lazy var noteText = CurrentValueSubject<NSMutableAttributedString, Never>(noteModel.text)
    
    var isLoading = CurrentValueSubject<Bool, Never>(false)
    
    private let router: RouterProtocol
    private let coreDataService: CoreDataServiceProtocol
    
    private var cancellables: Set<AnyCancellable> = []
    
    required init(router: RouterProtocol, coreDataService: CoreDataServiceProtocol, noteModel: NoteModel) {
        self.router = router
        self.coreDataService = coreDataService    
        self.noteModel = noteModel
        
        noteText.sink { [weak self] noteText in
            self?.noteModel.text = noteText
        }.store(in: &cancellables)
    }
}

extension NoteViewModel: NoteViewModelProtocol {
    
    // MARK: Core Data
    
    internal func saveNoteToCoreData() {
        guard (try? coreDataService.fetchObject(with: noteModel.id, of: DBNote.self)) != nil else { return }
        let dbNoteID = try? coreDataService.fetchObject(with: noteModel.id, of: DBNote.self)?.objectID
        
        coreDataService.save { context in
            guard let dbNoteID,
                  let dbNoteOnCurrentContext = try context.existingObject(with: dbNoteID) as? DBNote
            else { return }
            dbNoteOnCurrentContext.title = self.noteModel.title
            dbNoteOnCurrentContext.text = self.noteModel.text
        }
    }
    
    // MARK: Font Interactions
    
    internal func traitSelected(trait: Traits, range: NSRange) {
        if range.length == 0 {
            return
        }
        
        let text = noteText.value
        let attributedText = NSAttributedString(attributedString: text).attributedSubstring(from: range)
        let textFont: UIFont = attributedText.attributes(at: 0, effectiveRange: nil)[.font] as? UIFont
        ?? UIFont.systemFont(ofSize: UIFont.systemFontSize)
        var textTraits = textFont.fontDescriptor.symbolicTraits
        
        var symbolicTraits = UIFontDescriptor.SymbolicTraits(rawValue: 0)
        switch trait {
        case .bold:
            symbolicTraits.insert(.traitBold)
        case .italic:
            symbolicTraits.insert(.traitItalic)
        case .clear:
            textTraits.remove(.traitBold)
            textTraits.remove(.traitItalic)
        }
        
        if !textTraits.isDisjoint(with: symbolicTraits) {
            textTraits.remove(symbolicTraits)
        } else {
            textTraits.insert(symbolicTraits)
        }
        
        let descriptor = textFont.fontDescriptor.withSymbolicTraits(textTraits) ?? UIFontDescriptor()
        let font = UIFont(descriptor: descriptor, size: textFont.fontDescriptor.pointSize)
        text.addAttribute(.font, value: font, range: range)
        
        noteText.send(text)
    }
    
    internal func sizeSelected(size: CGFloat, range: NSRange) {
        if range.length == 0 {
            return
        }

        let text = noteText.value
        var updatedText = NSMutableAttributedString(attributedString: text)

        let attributedSubstring = text.attributedSubstring(from: range)
        let textFont = attributedSubstring.attribute(.font, at: 0,
                                                     effectiveRange: nil) as? UIFont
                                                                    ?? UIFont.systemFont(ofSize: UIFont.systemFontSize)

        let newFont = textFont.withSize(size)
        updatedText.addAttribute(.font, value: newFont, range: range)

        noteText.send(updatedText)
    }
}
