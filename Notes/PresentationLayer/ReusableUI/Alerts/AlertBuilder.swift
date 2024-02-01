//
//  AlertBuilder.swift
//  Notes
//
//  Created by Eugene Maksimow on 28.01.2024.
//

import UIKit

private struct Constants {
    static let okAlertTitle = "OK"
    static let tryAgainAlertTitle = NSLocalizedString("Try Again", comment: "")
    static let cancelAlertTitle = NSLocalizedString("Cancel", comment: "")
    static let createAlertTitle = NSLocalizedString("Create", comment: "")

    static let takePhotoAlertTitle = NSLocalizedString("Take photo", comment: "")
    static let choosePhotoFromLibraryAlertTitle = NSLocalizedString("Choose photo from Library", comment: "")
    static let removePhotoAlertTitle = NSLocalizedString("Remove photo", comment: "")

    static let successSaveAlertTitle = NSLocalizedString("Success", comment: "")
    static let successSaveAlertMessage = NSLocalizedString("You're breathtaking.", comment: "")
    
    static let failureSaveAlertTitle = NSLocalizedString("Failure", comment: "")
    static let failureSaveAlertMessage = NSLocalizedString("Couldn't sav.", comment: "")
    
    static let newNoteAlertTitle = NSLocalizedString("New Note", comment: "")
    static let titleTextFieldPlaceholder = NSLocalizedString("Title", comment: "")
    
    static let alertStyle = UIAlertController.Style.alert
    static let sheetStyle = UIAlertController.Style.actionSheet
    
    static let defaultActionStyle = UIAlertAction.Style.default
    static let cancelActionStyle = UIAlertAction.Style.cancel
    static let destructiveActionStyle = UIAlertAction.Style.destructive
    
    static let titleCapitalization = UITextAutocapitalizationType.sentences
}

struct AlertBuilder {}

extension AlertBuilder: AlertProtocol {
    
    func successSaveAlert(_ action: UIAlertAction) -> UIAlertController {
        let alert = UIAlertController(title: Constants.successSaveAlertTitle,
                                      message: Constants.successSaveAlertMessage,
                                      preferredStyle: Constants.alertStyle)
        alert.addAction(action)
        
        return alert
    }
    
    func failureSaveAlert(_ firstAction: UIAlertAction,
                          _ secondAction: UIAlertAction) -> UIAlertController {
        let alert = UIAlertController(title: Constants.failureSaveAlertTitle,
                                      message: Constants.failureSaveAlertMessage,
                                      preferredStyle: Constants.alertStyle)
        alert.addAction(firstAction)
        alert.addAction(secondAction)
        
        return alert
    }
    
    func changePhotoAlert(_ firstAction: UIAlertAction,
                          _ secondAction: UIAlertAction,
                          _ thirdAction: UIAlertAction,
                          _ fourthAction: UIAlertAction,
                          _ fifthAction: UIAlertAction?) -> UIAlertController {
        let alert = UIAlertController()
        alert.addAction(firstAction)
        alert.addAction(secondAction)
        alert.addAction(thirdAction)
        alert.addAction(fourthAction)
        if let fifthAction {
            alert.addAction(fifthAction)
        }
        
        return alert
    }
    
    func newNoteAlert(_ firstAction: UIAlertAction,
                         _ secondAction: UIAlertAction) -> UIAlertController {
        let alert = UIAlertController(title: Constants.newNoteAlertTitle,
                                      message: nil,
                                      preferredStyle: Constants.alertStyle)
        
        alert.addTextField { (textField) in
            textField.placeholder = Constants.titleTextFieldPlaceholder
            textField.autocapitalizationType = Constants.titleCapitalization
        }
        
        alert.addAction(firstAction)
        alert.addAction(secondAction)
        secondAction.isEnabled = false
        
        return alert
    }
}

extension AlertBuilder: AlertActionProtocol {
    
    func cancelAction(_ handler: @escaping ((UIAlertAction) -> Void)) -> UIAlertAction {
        return UIAlertAction(title: Constants.cancelAlertTitle,
                             style: Constants.cancelActionStyle,
                             handler: handler)
    }
    
    func okAction(_ handler: @escaping ((UIAlertAction) -> Void)) -> UIAlertAction {
        return UIAlertAction(title: Constants.okAlertTitle,
                             style: Constants.defaultActionStyle,
                             handler: handler)
    }
    
    func tryAgainAction(_ handler: @escaping ((UIAlertAction) -> Void)) -> UIAlertAction {
        return UIAlertAction(title: Constants.tryAgainAlertTitle,
                             style: Constants.cancelActionStyle,
                             handler: handler)
    }
    
    func takePhotoAction(_ handler: @escaping ((UIAlertAction) -> Void)) -> UIAlertAction {
        return UIAlertAction(title: Constants.takePhotoAlertTitle,
                             style: Constants.defaultActionStyle,
                             handler: handler)
    }
    
    func choosePhotoFromLibraryAction(_ handler: @escaping ((UIAlertAction) -> Void)) -> UIAlertAction {
        return UIAlertAction(title: Constants.choosePhotoFromLibraryAlertTitle,
                             style: Constants.defaultActionStyle,
                             handler: handler)
    }
    
    func removePhotoAction(_ handler: @escaping ((UIAlertAction) -> Void)) -> UIAlertAction {
        return UIAlertAction(title: Constants.removePhotoAlertTitle,
                             style: Constants.destructiveActionStyle,
                             handler: handler)
    }
    
    func createNoteAction(_ handler: @escaping ((UIAlertAction) -> Void)) -> UIAlertAction {
        return UIAlertAction(title: Constants.createAlertTitle,
                             style: Constants.defaultActionStyle,
                             handler: handler)
    }
}
