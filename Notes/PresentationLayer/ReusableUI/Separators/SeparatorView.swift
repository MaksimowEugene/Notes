//
//  SeparatorView.swift
//  Notes
//
//  Created by Eugene Maksimow on 28.01.2024.
//

import UIKit

private struct Constants {
    static let color = UIColor.separator
}

final class SeparatorView: UIImageView {
    
    let thickness: CGFloat
    
    init(thickness: CGFloat) {
        self.thickness = thickness
        
        super.init(frame: .null)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundColor = Constants.color
        heightAnchor.constraint(equalToConstant: thickness).isActive = true
    }
}
