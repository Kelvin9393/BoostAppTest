//
//  UIViewController+Extension.swift
//  a761
//
//  Created by 2.9mac256 on 04/03/2020.
//  Copyright © 2020 AWESOMEEE. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func switchChildController(from oldVC: UIViewController, to newVC: UIViewController, duration: TimeInterval = 0.3, options: UIView.AnimationOptions = .transitionCrossDissolve, animations: (() -> Void)? = nil, completion: (() -> Void)? = nil) {
        
        oldVC.willMove(toParent: nil)
        addChild(newVC)
        
        transition(from: oldVC, to: newVC, duration: duration, options: options, animations: animations) {
            [weak self] (finished) in
            oldVC.removeFromParent()
            newVC.didMove(toParent: self)
            completion?()
        }
    }
    
}
