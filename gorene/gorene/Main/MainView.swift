//
//  MainView.swift
//  gorene
//
//  Created by Illya Blinov on 30.01.24.
//

import UIKit

protocol MainViewProtocol: AnyObject {
    func setBackgroundImage(_ image: String)
    func getColorTheme()
}

final class MainView: UIViewController, MainViewProtocol {

    private let labelFont = UIFont.italicSystemFont(ofSize: 18)
    private var themeColor : [UIColor] { SettingsModel.share.colorTheme.getColor()}

    lazy var mainTextView: UIScrollView = {
        let view = UIScrollView()
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.systemFill.cgColor
        return view
    }()

    lazy var mainTextLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        return label
    }()

    lazy var informationView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.systemFill.cgColor
        return view
    }()
    lazy var buttonCountView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 2
        view.backgroundColor = .systemGreen
        view.layer.borderColor = UIColor.systemFill.cgColor
        return view
    }()

    lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = labelFont
        return label
    }()

    lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = labelFont
        return label
    }()

    lazy var itemsButton: UIButton = {
        let button: UIButton = CustomButton(title: "")
        button.setBackgroundImage(UIImage(named: "inventory"), for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemFill.cgColor
        return button
    }()

    lazy var playerButton: UIButton = {
        let button: UIButton = CustomButton(title: "")
        button.setBackgroundImage(UIImage(named: "player"), for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemFill.cgColor
        return button
    }()

    lazy var playButtonTable: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = .clear
        table.register(TableButtonViewCell.self, forCellReuseIdentifier: TableButtonViewCell.identifier)
        table.showsVerticalScrollIndicator = false
        table.layer.cornerRadius = 12
        return table
    }()

    lazy var settingsButton: UIButton = {
        let button: UIButton = CustomButton(title: "", action: { [weak self] in
            if SettingsModel.share.colorTheme != .mainWhite {
                SettingsModel.share.chooseColorTheme(colorTheme: .mainWhite)} else {
                    SettingsModel.share.chooseColorTheme(colorTheme: .mainDarck)
                }
            self?.getColorTheme() })
        button.setBackgroundImage(UIImage(named: "settings"), for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 12
        return button
    }()

    lazy var saveButton: UIButton = {
        let button: UIButton = CustomButton(title: "", action: { [weak self] in
            self?.dismiss(animated: true)

        })
        button.setBackgroundImage(UIImage(named: "save"), for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemFill.cgColor
        return button
    }()
    lazy var loadButton: UIButton = {
        let button: UIButton = CustomButton(title: "L", action: { [weak self] in
            self?.dismiss(animated: true)

        })
   //     button.setBackgroundImage(UIImage(named: "save"), for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemFill.cgColor
        return button
    }()




    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.contents = UIImage(named: "backgraund0")
        setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    private func setupView(){
        view.backgroundColor = .black
        appleColorTheme(colors: themeColor)
        setBackgroundImage("backgraund1")
        setupSubView()
        view.addSubViews([mainTextView, informationView, playButtonTable, playerButton, saveButton, loadButton, buttonCountView])
        setupConstraints()
    }

    private func setupSubView(){
        mainTextView.addSubViews([mainTextLabel])
        DispatchQueue.global(qos: .utility).async {
            var mainText = " Такой длинный текст написанный Андреем \n"
            (1...7).forEach(){ _ in mainText += mainText}
            DispatchQueue.main.async { [weak self] in
                self?.mainTextLabel.text = mainText
            }
        }
        locationLabel.text = { return "Окрестности условных Афин"}()
        let name = "Андрей"
        let status = "Рыцарь изада"
        statusLabel.text = { return "\(name) .... \(status)"}()
        informationView.addSubViews([locationLabel, statusLabel, settingsButton])
    }

    internal func getColorTheme(){
        appleColorTheme(colors: themeColor)
    }

    internal func setBackgroundImage(_ image: String){
        let backgraungImage = UIImage(named: image)
        guard let backgraungImage else { return }
        view.layer.contents = backgraungImage.cgImage
    }

    private func appleColorTheme(colors: [UIColor]){
        guard colors.count == 4 else { return }
        mainTextView.backgroundColor = colors[0]
        informationView.backgroundColor = colors[1]
        locationLabel.textColor = colors[2]
        statusLabel.textColor = colors[2]
        mainTextLabel.textColor = colors[3]
        settingsButton.backgroundColor = colors[2]
        settingsButton.tintColor = colors[0]
        playerButton.backgroundColor = colors[1]
        playerButton.tintColor = colors[2]
        saveButton.backgroundColor = colors[1]
        saveButton.tintColor = colors[2]
        loadButton.backgroundColor = colors[1]
        loadButton.tintColor = colors[2]
    }
}
