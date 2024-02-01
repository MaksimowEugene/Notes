//
//  NavigationBarBuilderProtocol.swift
//  Notes
//
//  Created by Eugene Maksimow on 28.01.2024.
//

import UIKit

protocol NavigationBarBuilderProtocol {
    var target: UIViewController? { get set }
    
    func cancelButton(_ action: Selector?) -> UIBarButtonItem
    func saveButton(_ action: Selector?) -> UIBarButtonItem
    func createNoteButton(_ action: Selector?) -> UIBarButtonItem
    
    func activityIndicatorButton() -> UIBarButtonItem
}
