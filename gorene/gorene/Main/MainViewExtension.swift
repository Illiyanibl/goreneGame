//
//  MainViewExtension.swift
//  gorene
//
//  Created by Illya Blinov on 4.02.24.
//

import UIKit
extension MainView {
    func setupConstraints(){
        let safeArea = view.safeAreaLayoutGuide
        let buttonIndent: CGFloat = 12
        let topLineHeight: CGFloat = 60
        let bottomLineHeight: CGFloat = 180
        NSLayoutConstraint.activate([

            playerButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -buttonIndent),
            playerButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: buttonIndent),
            playerButton.heightAnchor.constraint(equalToConstant: topLineHeight),
            playerButton.widthAnchor.constraint(equalTo: playerButton.heightAnchor),

            informationView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: buttonIndent),
            informationView.trailingAnchor.constraint(equalTo: playerButton.leadingAnchor, constant: -buttonIndent),
            informationView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: buttonIndent),
            informationView.heightAnchor.constraint(equalToConstant: topLineHeight),

            locationLabel.leadingAnchor.constraint(equalTo: informationView.leadingAnchor, constant: buttonIndent),
            locationLabel.topAnchor.constraint(equalTo: informationView.topAnchor, constant: buttonIndent / 2),
            statusLabel.leadingAnchor.constraint(equalTo: informationView.leadingAnchor, constant: buttonIndent),
            statusLabel.bottomAnchor.constraint(equalTo: informationView.bottomAnchor, constant: -buttonIndent / 2),


            mainTextView.topAnchor.constraint(equalTo: informationView.bottomAnchor, constant: buttonIndent),
            mainTextView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: buttonIndent),
            mainTextView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -buttonIndent),
            mainTextView.bottomAnchor.constraint(equalTo: playButtonTable.topAnchor, constant: -buttonIndent),

            mainTextLabel.topAnchor.constraint(equalTo: mainTextView.topAnchor, constant: buttonIndent / 2),
            mainTextLabel.bottomAnchor.constraint(equalTo: mainTextView.bottomAnchor, constant: -buttonIndent / 2),
            mainTextLabel.leadingAnchor.constraint(equalTo: mainTextView.leadingAnchor, constant: buttonIndent / 2),
            mainTextLabel.trailingAnchor.constraint(equalTo: mainTextView.trailingAnchor, constant: -buttonIndent / 2),


            playButtonTable.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: buttonIndent),
            playButtonTable.trailingAnchor.constraint(equalTo: settingsButton.leadingAnchor, constant: -buttonIndent),
            playButtonTable.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -buttonIndent),
            playButtonTable.heightAnchor.constraint(equalToConstant: bottomLineHeight),

            settingsButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -buttonIndent),
            settingsButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -buttonIndent),
            settingsButton.widthAnchor.constraint(equalToConstant: 60),
            settingsButton.heightAnchor.constraint(equalTo: settingsButton.widthAnchor),
        ])
    }

}
