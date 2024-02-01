//
//  AlertActionProtocol.swift
//  Notes
//
//  Created by Eugene Maksimow on 28.01.2024.
//

import UIKit

protocol AlertActionProtocol {
    func cancelAction(_ handler: @escaping ((UIAlertAction) -> Void)) -> UIAlertAction
    func okAction(_ handler: @escaping ((UIAlertAction) -> Void)) -> UIAlertAction
    func tryAgainAction(_ handler: @escaping ((UIAlertAction) -> Void)) -> UIAlertAction
    
    func takePhotoAction(_ handler: @escaping ((UIAlertAction) -> Void)) -> UIAlertAction
    func choosePhotoFromLibraryAction(_ handler: @escaping ((UIAlertAction) -> Void)) -> UIAlertAction
    func removePhotoAction(_ handler: @escaping ((UIAlertAction) -> Void)) -> UIAlertAction
    
    func createNoteAction(_ handler: @escaping ((UIAlertAction) -> Void)) -> UIAlertAction
}
