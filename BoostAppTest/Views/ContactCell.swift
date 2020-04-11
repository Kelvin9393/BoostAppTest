//
//  ContactCell.swift
//  BoostAppTest
//
//  Created by 2.9mac256 on 19/03/2020.
//

import UIKit

class ContactCell: UITableViewCell {
    
    var contactCellViewModel: ContactCellViewModel! {
        didSet {
            fullNameLabel.text = contactCellViewModel.fullName
        }
    }
    
    private let avatarView: AvatarView = {
        let view = AvatarView(frame: .zero)
        return view
    }()
    
    private let fullNameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        let stackView = UIStackView(arrangedSubviews: [avatarView, fullNameLabel])
        stackView.axis = .horizontal
        stackView.spacing = frame.width * 0.05
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        
        addSubview(stackView)
        
        let avatarViewDimension = frame.width * 0.14
        avatarView.anchor(size: .init(width: avatarViewDimension, height: avatarViewDimension))
        let horizontalPadding: CGFloat = 20
        let verticalPadding = frame.width * 0.021
        stackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding))
        
    }
    
}
