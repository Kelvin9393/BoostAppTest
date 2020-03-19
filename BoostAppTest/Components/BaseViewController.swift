//
//  BaseViewController.swift
//  Fluence
//
//  Created by 2.9mac256 on 10/02/2020.
//  Copyright © 2020 FTEG Technology. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    var viewWidth: CGFloat!
    var viewHeight: CGFloat!
    
    override func loadView() {
        super.loadView()
        setupLayout()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupLayout() {
        viewWidth = view.frame.width
        viewHeight = view.frame.height
    }
    
    func setupUI() {
        hideKeyboardWhenTappedAround()
    }

}
