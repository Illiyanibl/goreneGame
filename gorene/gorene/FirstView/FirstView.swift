//
//  FirstView.swift
//  gorene
//
//  Created by Illya Blinov on 28.01.24.
//

import UIKit
final class FirstView: UIViewController {
    let buttonFont = UIFont.italicSystemFont(ofSize: 30)
    lazy var startButton: UIButton = {
        let button: UIButton = CustomButton(title: "Start",
                                            titleColor: .systemBackground,
                                            backgroundColor: .darkGray,
                                            action: { [weak self] in self?.startGame() })
        button.titleLabel?.font = buttonFont
        button.layer.cornerRadius = 50
        button.layer.masksToBounds = true
        button.layer.borderWidth = 8
        button.alpha = 0.6
        let borderColor = UIColor.systemFill
        borderColor.withAlphaComponent(0.2)
        button.layer.borderColor = borderColor.cgColor
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView(){
        view.backgroundColor = .black
        setBackgroundImage("backgraund0")
        setupSubView()
        setupConstraints()
    }
    private func setupSubView(){
        view.addSubview(startButton)

    }
    private func startGame(){
        let mainPresenter  = MainPresenter()
        let mainView = MainView(mainPresenter: mainPresenter)
        mainPresenter.mainView = mainView
        self.navigationController?.pushViewController(mainView, animated: true)

    }

    private func setBackgroundImage(_ image: String){
        let backgraungImage = UIImage(named: image)
        guard let backgraungImage else { return }
        view.layer.contents = backgraungImage.cgImage
    }

    private func setupConstraints(){
        NSLayoutConstraint.activate([
            startButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 80),
            startButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: 160),
            startButton.heightAnchor.constraint(equalToConstant: startButton.layer.cornerRadius * 2),
            startButton.widthAnchor.constraint(equalToConstant: startButton.layer.cornerRadius * 4),
        ])
    }

}
