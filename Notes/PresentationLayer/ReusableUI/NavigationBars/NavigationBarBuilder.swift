//
//  NavigationBarBuilder.swift
//  Notes
//
//  Created by Eugene Maksimow on 28.01.2024.
//

import UIKit

private struct Constants {
    static let cancelButtonTitle = NSLocalizedString("Cancel", comment: "") // update
    static let saveButtonTitle = NSLocalizedString("Save", comment: "") // update
    
    static let createNoteButtonTitle = NSLocalizedString("Create", comment: "") // update
    
    static let style = UIBarButtonItem.Style.plain
}

struct NavigationBarBuilder {
    
    weak var target: UIViewController?
}

extension NavigationBarBuilder: NavigationBarBuilderProtocol {
    
    func cancelButton(_ action: Selector?) -> UIBarButtonItem {
        return UIBarButtonItem(title: Constants.cancelButtonTitle,
                               style: Constants.style,
                               target: target,
                               action: action)
    }
    
    func saveButton(_ action: Selector?) -> UIBarButtonItem {
        return UIBarButtonItem(title: Constants.saveButtonTitle,
                               style: Constants.style,
                               target: target,
                               action: action)
    }
    
    func createNoteButton(_ action: Selector?) -> UIBarButtonItem {
        return UIBarButtonItem(title: Constants.createNoteButtonTitle,
                               style: Constants.style,
                               target: target,
                               action: action)
    }
    
    func activityIndicatorButton() -> UIBarButtonItem {
        let indicator = UIActivityIndicatorView()
        indicator.startAnimating()
        return UIBarButtonItem(customView: indicator)
    }
}
