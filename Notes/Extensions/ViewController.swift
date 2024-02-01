//
//  ViewController.swift
//  Notes
//
//  Created by Eugene Maksimow on 30.01.2024.
//

import UIKit

extension UIViewController {
    
    func dismissKeyboardOnTap() {
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboardOnTap(in tableView: UITableView) {
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        tableView.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
