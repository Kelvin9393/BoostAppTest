//
//  ContactDetailSectionHeader.swift
//  BoostAppTest
//
//  Created by 2.9mac256 on 19/03/2020.
//

import UIKit

class ContactDetailSectionHeader: UITableViewHeaderFooterView {
    
    static let cellID = "ContactDetailSectionHeader"
    var title: String! {
        didSet {
            titleLabel.text = title
        }
    }

    private let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setupLayout()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(titleLabel)
        titleLabel.anchor(leading: leadingAnchor, padding: .init(top: 0, left: 15, bottom: 0, right: 0), centerY: centerYAnchor)
    }
    
    private func setupUI() {
        layer.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)
    }

}
