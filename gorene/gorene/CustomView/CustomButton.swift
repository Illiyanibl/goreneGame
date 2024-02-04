//
//  CustomButton.swift
//  gorene
//
//  Created by Illya Blinov on 28.01.24.
//

import UIKit
class CustomButton: UIButton {

    typealias Action = () -> Void
    var action: Action?

    init(title: String, titleColor: UIColor = .white, backgroundColor: UIColor = .black, translatesAutoresizingMask: Bool = false, action: Action? = nil) {
        super.init(frame: .null)
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.action = action
        self.backgroundColor = backgroundColor
        self.translatesAutoresizingMaskIntoConstraints = translatesAutoresizingMask
        self.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    @objc private func buttonTapped(){
        action?()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
