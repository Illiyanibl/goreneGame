//
//  ModalGameView.swift
//  gorene
//
//  Created by Illya Blinov on 24.11.24.
//

import UIKit
protocol GameMemoriesViewProtocol : AnyObject, ShowModalViewProtocol {
    func pushInstructionText(text: String)
}
final class GameMemoriesModalView: UIView, GameMemoriesViewProtocol {
    var themeColor : [UIColor] { SettingsModel.share.colorTheme.getColor()}
    var gameMemoriesPresenter: GameMemoriesPresenterProtocol?

    let mainFontParagraphStyle: NSMutableParagraphStyle = {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        paragraphStyle.paragraphSpacing = 8
        return paragraphStyle
    }()

    lazy var gameView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.mainFont
        label.numberOfLines = 1
        return label
    }()
    lazy var instructionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.mainFont
        label.numberOfLines = 4
        return label
    }()

    lazy var playZoneView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        return view
    }()

    lazy var  gameCollectionView: UICollectionView = {
        let loyut = UICollectionViewFlowLayout()
        loyut.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: loyut)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.dataSource = self
        view.delegate = self
        view.register(GameMemoriesCellView.self, forCellWithReuseIdentifier: GameMemoriesCellView.identifier)
        return view
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)
        gameMemoriesPresenter = GameMemoriesPresenter(gameMemoriesModalView: self)
        setupUI()
        setupGesture()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupUI(){
        appleColorTheme(colors: themeColor)
        titleLabel.text = "Memories"
        self.addSubViews([gameView])
        setupSubView()
        gameMemoriesPresenter?.startGame()
    }
    private func setupSubView (){
        playZoneView.addSubViews([gameCollectionView])
        gameView.addSubViews([titleLabel, instructionLabel, playZoneView])
    }

    internal func pushInstructionText(text: String) {
        let attrText = NSMutableAttributedString(string: text)
        attrText.addAttribute(.paragraphStyle, value:mainFontParagraphStyle, range:NSMakeRange(0, attrText.length))
        instructionLabel.attributedText = attrText
    }
    func setupGesture(){}



    private func appleColorTheme(colors: [UIColor]){
        guard colors.count == 4 else { return }
        self.backgroundColor = colors[0]
        titleLabel.textColor = colors[2].withAlphaComponent(1)
        gameView.backgroundColor = colors[0]
        playZoneView.backgroundColor = colors[0]
       // modalDescriptionLabel.textColor = colors[3].withAlphaComponent(1)
      //  modalLabelview.backgroundColor = colors[0].withAlphaComponent(0.8)
    }
    func setupConstraints(){
        let safeArea = self.safeAreaLayoutGuide
        let defaultIndent: CGFloat = 12
        let nearIndent: CGFloat = 3
        let topLineHeight: CGFloat = 56
        let bottomLineHeight: CGFloat = 226
        let buttonHeight: CGFloat = 50
        NSLayoutConstraint.activate([
            gameView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: defaultIndent),
            gameView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: defaultIndent),
            gameView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -defaultIndent),
            gameView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -defaultIndent),

            titleLabel.topAnchor.constraint(equalTo: gameView.topAnchor, constant: defaultIndent),
            titleLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),

            instructionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: defaultIndent),
            instructionLabel.leadingAnchor.constraint(equalTo:  gameView.leadingAnchor, constant: defaultIndent),
            instructionLabel.trailingAnchor.constraint(equalTo:  gameView.trailingAnchor, constant: -defaultIndent),
            instructionLabel.heightAnchor.constraint(equalToConstant: 60),

            playZoneView.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: defaultIndent),
            playZoneView.leadingAnchor.constraint(equalTo: gameView.leadingAnchor, constant: defaultIndent),
            playZoneView.trailingAnchor.constraint(equalTo: gameView.trailingAnchor, constant: -defaultIndent),
            playZoneView.bottomAnchor.constraint(equalTo: gameView.bottomAnchor, constant: -defaultIndent),

            gameCollectionView.topAnchor.constraint(equalTo: playZoneView.topAnchor, constant: nearIndent),
            gameCollectionView.bottomAnchor.constraint(equalTo: playZoneView.bottomAnchor, constant: -nearIndent),
            gameCollectionView.leadingAnchor.constraint(equalTo: playZoneView.leadingAnchor, constant: nearIndent),
            gameCollectionView.trailingAnchor.constraint(equalTo: playZoneView.trailingAnchor, constant: -nearIndent)
        ])

    }
    

}
extension GameMemoriesModalView: UICollectionViewDelegateFlowLayout{
    private var inset: CGFloat  { return 8}



    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - inset * 6) / 4
        return CGSize(width: width, height: width)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return inset
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return inset
    }
}

extension GameMemoriesModalView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        16
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //GameMemoriesCellView
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GameMemoriesCellView.identifier, for: indexPath) as! GameMemoriesCellView
        return cell
    }
}
