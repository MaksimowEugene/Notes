//
//  ActivityIndicatorView.swift
//  Notes
//
//  Created by Eugene Maksimow on 28.01.2024.
//

import UIKit

private struct Constants {
    static let size: CGFloat = 50
    static let cornerRadius: CGFloat = 8
    static let clipsToBounds = true
    static let hidesWhenStopped = true
    
    static let blurViewOpacity: Float = 0.3
    static let blurViewColor = UIColor.secondarySystemBackground
}

class ActivityIndicatorView: UIView {
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.clipsToBounds = Constants.clipsToBounds
        view.layer.cornerRadius = Constants.cornerRadius
        view.hidesWhenStopped = Constants.hidesWhenStopped
        view.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(blurView, at: 0)
        
        return view
    }()
    
    lazy var blurView: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        view.contentView.layer.opacity = Constants.blurViewOpacity
        view.contentView.backgroundColor = Constants.blurViewColor
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    init() {
        super.init(frame: .null)
        
        setupActivityIndicator()
        setupBlurView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupActivityIndicator() {
        addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            activityIndicator.widthAnchor.constraint(equalToConstant: Constants.size),
            activityIndicator.heightAnchor.constraint(equalToConstant: Constants.size)
        ])
    }
    
    private func setupBlurView() {
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: activityIndicator.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: activityIndicator.bottomAnchor),
            blurView.leadingAnchor.constraint(equalTo: activityIndicator.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: activityIndicator.trailingAnchor)
        ])
    }
}
