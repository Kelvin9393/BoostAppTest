//
//  AvatarView.swift
//  BoostAppTest
//
//  Created by 2.9mac256 on 19/03/2020.
//

import UIKit

class AvatarView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }
    
    private func setupViews() {
        backgroundColor = Colors.primaryColor
    }
    
}
