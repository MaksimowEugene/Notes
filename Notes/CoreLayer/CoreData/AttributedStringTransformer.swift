//
//  AttributedStringTransformer.swift
//  Notes
//
//  Created by Eugene Maksimow on 30.01.2024.
//

import UIKit

@objc(AttributedStringTransformer)
class AttributedStringTransformer: NSSecureUnarchiveFromDataTransformer {
    override class var allowedTopLevelClasses: [AnyClass] {
        return super.allowedTopLevelClasses + [NSMutableAttributedString.self]
    }
    
    static func register() {
        let transformer = AttributedStringTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: NSValueTransformerName(rawValue: "AttributedStringTransformer"))
    }
}
