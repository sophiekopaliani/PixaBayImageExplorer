//
//  Footer.swift
//  PixaBayImageExplorer
//
//  Created by Sophio Kopaliani on 26/12/2023.
//

import UIKit

class FooterView: UICollectionReusableView {
    static let identifier = String(describing: FooterView.self)
    
    private let activityIndicator:  UIActivityIndicatorView = {
        var ai = UIActivityIndicatorView()
        ai.translatesAutoresizingMaskIntoConstraints = false
        ai.hidesWhenStopped = true
        return ai
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubview(activityIndicator)
        
        activityIndicator.centerVertically(to: self)
        activityIndicator.centerHorizontally(to: self)
    }
    
    
    func toggleLoading(isEnabled: Bool) {
        if isEnabled {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
}
