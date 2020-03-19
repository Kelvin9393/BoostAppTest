//
//  CustomInputFieldCell.swift
//  BoostAppTest
//
//  Created by 2.9mac256 on 19/03/2020.
//

import UIKit

class CustomInputFieldCell: UITableViewCell {

    override func layoutSubviews() {
        super.layoutSubviews()
        let width = subviews[0].frame.width

        for view in subviews where view != contentView {
            if view.frame.width == width {
                view.removeFromSuperview()
            }
        }
    }

}
