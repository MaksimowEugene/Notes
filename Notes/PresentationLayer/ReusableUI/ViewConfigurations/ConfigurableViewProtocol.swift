//
//  ConfigurationViewProtocol.swift
//  Notes
//
//  Created by Eugene Maksimow on 28.01.2024.
//

import Foundation

protocol ConfigurableViewProtocol: AnyObject {
    associatedtype ConfigurationModel
    func configure(with model: ConfigurationModel)
}
