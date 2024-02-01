//
//  AlertProtocol.swift
//  Notes
//
//  Created by Eugene Maksimow on 28.01.2024.
//

import UIKit

protocol AlertProtocol {
    func successSaveAlert(_ action: UIAlertAction) -> UIAlertController
    func failureSaveAlert(_ firstAction: UIAlertAction,
                          _ secondAction: UIAlertAction) -> UIAlertController
    func newNoteAlert(_ firstAction: UIAlertAction,
                      _ secondAction: UIAlertAction) -> UIAlertController
}
