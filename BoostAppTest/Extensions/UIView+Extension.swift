//
//  UIView+Extension.swift
//  a761
//
//  Created by 2.9mac256 on 04/03/2020.
//  Copyright © 2020 AWESOMEEE. All rights reserved.
//

import UIKit

extension UIView {
    func fillSuperView() {
        anchor(top: superview?.topAnchor, leading: superview?.leadingAnchor, bottom: superview?.bottomAnchor, trailing: superview?.trailingAnchor)
    }
    
    func anchorSize(to view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
    func anchorCenterX(to anchorX: NSLayoutXAxisAnchor, constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: anchorX, constant: constant).isActive = true
    }
    
    func anchorCenterY(to anchorY: NSLayoutYAxisAnchor, constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: anchorY, constant: constant).isActive = true
    }
    
    func anchor(top: NSLayoutYAxisAnchor? = nil, leading: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, trailing: NSLayoutXAxisAnchor? = nil, padding: UIEdgeInsets = .zero, size: CGSize = .zero, widthAnchor: NSLayoutDimension? = nil, widthMultiplier: CGFloat = 1, heightAnchor: NSLayoutDimension? = nil, heightMultiplier: CGFloat = 1, centerX: NSLayoutXAxisAnchor? = nil, centerY: NSLayoutYAxisAnchor? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }
        
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }
        
        if size.width != 0 {
            self.widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0 {
            self.heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
        
        if let widthAnchor = widthAnchor {
            self.widthAnchor.constraint(equalTo: widthAnchor, multiplier: widthMultiplier).isActive = true
        }
        
        if let heightAnchor = heightAnchor {
            self.heightAnchor.constraint(equalTo: heightAnchor, multiplier: heightMultiplier).isActive = true
        }
        
        if let centerX = centerX {
            centerXAnchor.constraint(equalTo: centerX).isActive = true
        }
        
        if let centerY = centerY {
            centerYAnchor.constraint(equalTo: centerY).isActive = true
        }
    }
    
//    func setShadowView() {
//        self.layer.shadowColor = Colors.shadowColor.cgColor
//        self.layer.shadowOffset = CGSize(width: 0, height: 0)
//        self.layer.shadowOpacity = 1
//        self.layer.shadowRadius = 3
//    }
//    
//    func setBottomShadowView() {
//        self.layer.shadowColor = Colors.shadowColor.cgColor
//        self.layer.shadowOffset = CGSize(width: 0, height: 2)
//        self.layer.shadowOpacity = 1
//        self.layer.shadowRadius = 2
//    }
}
