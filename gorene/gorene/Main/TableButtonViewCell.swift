//
//  TableButtonViewCell.swift
//  gorene
//
//  Created by Illya Blinov on 4.02.24.
//

import UIKit
final class TableButtonViewCell: UITableViewCell {
    typealias callBackAction =  (() -> Void)
    var action: callBackAction?

    let buttonFont = UIFont.italicSystemFont(ofSize: 16)
    lazy var actionButton: UIButton = {
        let button: UIButton = CustomButton(title: "",
                                            titleColor: .systemBackground,
                                            backgroundColor: .darkGray,
                                            action: { [weak self] in self?.action?() })
        button.titleLabel?.font = buttonFont
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.layer.borderWidth = 2
        button.alpha = 0.6
        let borderColor = UIColor.systemFill
        borderColor.withAlphaComponent(0.2)
        button.layer.borderColor = borderColor.cgColor
        return button
    }()

}
