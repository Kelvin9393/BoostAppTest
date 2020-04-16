//
//  CustomTextField.swift
//  BoostAppTest
//
//  Created by 2.9mac256 on 19/03/2020.
//

import UIKit

class CustomTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        font = UIFont.systemFont(ofSize: 16)
        layer.borderWidth = 1
        layer.borderColor = UIColor.groupTableViewBackground.cgColor
        layer.cornerRadius = 6
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        leftView = paddingView
        leftViewMode = .always
    }

}
