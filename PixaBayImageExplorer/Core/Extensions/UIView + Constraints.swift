//
//  UIView + Constraints.swift
//  PixaBayImageExplorer
//
//  Created by Sophio Kopaliani on 26/12/2023.
//

import UIKit

public extension UIView {
    func height(equalTo constant: CGFloat) {
        self.heightAnchor.constraint(equalToConstant: constant).isActive = true
    }
    
    func width(equalTo constant: CGFloat) {
        self.widthAnchor.constraint(equalToConstant: constant).isActive = true
    }
    
    @discardableResult
    func left(toView view: UIView,
              constant value: CGFloat = 0) -> NSLayoutConstraint {
        let result = leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: value)
        result.isActive = true
        return result
    }
    
    func leftNotSafe(toView view: UIView, constant value: CGFloat = 0) {
        self.leftAnchor.constraint(equalTo: view.leftAnchor, constant: value).isActive = true
    }

    @discardableResult
    func right(toView view: UIView,
               constant value: CGFloat = 0) -> NSLayoutConstraint {
        let result = self.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -value)
        result.isActive = true
        return result
    }
    
    func rightNotSafe(toView view: UIView, constant value: CGFloat = 0) {
        self.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -value).isActive = true
    }

    @discardableResult
    func top(toView view: UIView,
             constant value: CGFloat = 0) -> NSLayoutConstraint {
        let result = topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: value)
        result.isActive = true
        return result
    }
    
    func relativeTop(toView view: UIView,
                     constant value: CGFloat = 0) {
        self.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: value).isActive = true
    }
    
    @discardableResult
    func bottom(toView view: UIView,
                constant value: CGFloat = 0) -> NSLayoutConstraint {
        let result = self.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -value)
        result.isActive = true
        return result
    }
    
    func centerVertically(to view: UIView) {
        self.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func centerHorizontally(to view: UIView) {
        self.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}
