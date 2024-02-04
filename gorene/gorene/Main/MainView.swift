//
//  MainView.swift
//  gorene
//
//  Created by Illya Blinov on 30.01.24.
//

import UIKit

protocol MainViewProtocol: AnyObject {
    func setBackgroundImage(_ image: String)
}

final class MainView: UIViewController, MainViewProtocol {

    let labelFont = UIFont.italicSystemFont(ofSize: 18)
    let viewColor = UIColor.darkGray

    lazy var mainTextView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = viewColor
        view.alpha = 0.8
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
        label.textColor = .white
        return label
    }()

    lazy var informationView: UIView = {
        let view = UIView()
        view.backgroundColor = viewColor
        view.alpha = 0.8
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.systemFill.cgColor
        return view
    }()

    lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = labelFont
        label.textColor = .white
        return label
    }()

    lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = labelFont
        label.textColor = .black
        return label
    }()

    lazy var itemsButton: UIButton = {
        let button: UIButton = CustomButton(title: "", backgroundColor: .white)
        button.alpha = 0.8
        button.setBackgroundImage(UIImage(named: "inventory"), for: .normal)
        button.backgroundColor = viewColor
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemFill.cgColor
        return button
    }()

    lazy var playerButton: UIButton = {
        let button: UIButton = CustomButton(title: "", backgroundColor: .white)
        button.alpha = 0.8
        button.setBackgroundImage(UIImage(named: "player"), for: .normal)
        button.backgroundColor = viewColor
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemFill.cgColor
        return button
    }()

    lazy var playButtonTable: UITableView = {
        let table = UITableView()
        table.alpha = 0.8
        table.backgroundColor = viewColor
        table.layer.cornerRadius = 12
        table.layer.borderWidth = 2
        table.layer.borderColor = UIColor.systemFill.cgColor
        return table
    }()

    lazy var settingsButton: UIButton = {
        let button: UIButton = CustomButton(title: "", backgroundColor: .white)
        button.alpha = 0.8
        button.setBackgroundImage(UIImage(named: "settings"), for: .normal)
        button.backgroundColor = viewColor
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
        self.navigationController?.navigationBar.isHidden = true
    }

    private func setupView(){
        view.backgroundColor = .black
        setBackgroundImage("backgraund1")
        setupSubView()
        view.addSubViews([mainTextView, playerButton, informationView, playButtonTable, settingsButton])
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
        informationView.addSubViews([locationLabel, statusLabel])
    }


    func setBackgroundImage(_ image: String){
        let backgraungImage = UIImage(named: image)
        guard let backgraungImage else { return }
        view.layer.contents = backgraungImage.cgImage
    }
}
