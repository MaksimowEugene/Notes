//
//  NoteViewModelProtocol.swift
//  Notes
//
//  Created by Eugene Maksimow on 29.01.2024.
//

import Combine
import Foundation

protocol NoteViewModelProtocol: AnyObject {
    var noteModel: NoteModel { get }
    var noteText: CurrentValueSubject<NSMutableAttributedString, Never> { get }
    
    var isLoading: CurrentValueSubject<Bool, Never> { get }
    
    init(router: RouterProtocol,
         coreDataService: CoreDataServiceProtocol,
         noteModel: NoteModel)
    
    func saveNoteToCoreData()
    func traitSelected(trait: Traits, range: NSRange)
    func sizeSelected(size: CGFloat, range: NSRange)
}
