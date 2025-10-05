//
//  SettingsView.swift
//  gorene
//
//  Created by Illya Blinov on 20.04.25.
//

import UIKit
final class SettingsView: UIView,  ShowModalViewProtocol {
    var delegateClose: ShowModalViewDelegate?
    lazy var settingsView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var colorThemeButton: UIButton = {
        let button = CustomButton(title: String(localized: "accept"), action: {[weak self] in self?.changeColorTheme()})
        return button
    }()
    lazy var reStartButton: UIButton = {
        let button = CustomButton(title: String(localized: "reStart"), action: {[weak self] in self?.reStartGame()})
        return button
    }()

    var themeColor : [UIColor] { SettingsModel.share.colorTheme.getColor()}
    weak var mainPresenter: MainPresenterProtocol?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        appleColorTheme(colors: themeColor)
        settingsView.addSubViews([colorThemeButton, reStartButton])
        self.addSubViews([settingsView])
        setupConstraints()

    }

    private func changeColorTheme(){
        if SettingsModel.share.colorTheme != .mainWhite {
            SettingsModel.share.chooseColorTheme(colorTheme: .theEndOfSummer)} else {
                SettingsModel.share.chooseColorTheme(colorTheme: .mainDarck)
            }
        appleColorTheme(colors: themeColor)
        mainPresenter?.reLoadColorTheme()
    }

    private func reStartGame(){
        mainPresenter?.reStart()
    }

    private func appleColorTheme(colors: [UIColor]){
        guard colors.count == 4 else { return }
        self.backgroundColor = colors[0]
        settingsView.backgroundColor = colors[0]
        colorThemeButton.backgroundColor = colors[1]
        reStartButton.backgroundColor = colors[1]

    }

    func setupConstraints(){
        let safeArea = self.safeAreaLayoutGuide
        let defaultIndent: CGFloat = 12
      //  let nearIndent: CGFloat = 3
        NSLayoutConstraint.activate([
            settingsView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            settingsView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            settingsView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            settingsView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),

            colorThemeButton.topAnchor.constraint(equalTo: settingsView.topAnchor, constant: defaultIndent),
            colorThemeButton.leadingAnchor.constraint(equalTo: settingsView.leadingAnchor, constant: defaultIndent),
            colorThemeButton.widthAnchor.constraint(equalToConstant: 180),
            colorThemeButton.heightAnchor.constraint(equalToConstant: 30),

            reStartButton.topAnchor.constraint(equalTo: colorThemeButton.bottomAnchor, constant: defaultIndent),
            reStartButton.leadingAnchor.constraint(equalTo: settingsView.leadingAnchor, constant: defaultIndent),
            reStartButton.widthAnchor.constraint(equalToConstant: 180),
            reStartButton.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
}
