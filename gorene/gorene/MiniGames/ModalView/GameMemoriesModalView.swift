//
//  ModalGameView.swift
//  gorene
//
//  Created by Illya Blinov on 24.11.24.
//
import UIKit
protocol GameMemoriesViewProtocol : AnyObject, ShowModalViewProtocol {
    func pushInstructionText(text: String)
    func playSequence(sequence : [Int])
    func playSequence(sequence : [Int], delay: Double)
    func setCellsInteraction(state: TapState)

}
enum TapState {
    case block
    case unblock
}

final class GameMemoriesModalView: UIView, GameMemoriesViewProtocol {
    var themeColor : [UIColor] { SettingsModel.share.colorTheme.getColor()}
    var gameMemoriesPresenter: GameMemoriesPresenterProtocol

    let cellCounter = 0

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

    lazy var startButton: UIButton = {
        let button: UIButton = CustomButton(title: "Start Game", action: { [weak self] in
            self?.startGame()})
        button.layer.cornerRadius = 25
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemFill.cgColor
        return button
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


    init(gameMemoriesPresenter: GameMemoriesPresenterProtocol) {
        self.gameMemoriesPresenter = gameMemoriesPresenter
        super.init(frame: .zero)
        self.gameMemoriesPresenter.gameMemoriesModalView = self
        setupUI()
        setupGesture()
        setupConstraints()
        }

    override init(frame: CGRect) {
            fatalError("init(frame:) has not been implemented")
        }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        }

    func setupUI(){
        setCellsInteraction(state: .block)
        appleColorTheme(colors: themeColor)
        titleLabel.text = "Memories"
        self.addSubViews([gameView])
        setupSubView()
    }

    private func setupSubView (){
        playZoneView.addSubViews([gameCollectionView])
        gameView.addSubViews([titleLabel, instructionLabel, startButton,  playZoneView])
    }

    internal func pushInstructionText(text: String) {
        let attrText = NSMutableAttributedString(string: text)
        attrText.addAttribute(.paragraphStyle, value:mainFontParagraphStyle, range:NSMakeRange(0, attrText.length))
        instructionLabel.attributedText = attrText
    }
    func setupGesture(){
    }

    private func appleColorTheme(colors: [UIColor]){
        guard colors.count == 4 else { return }
        self.backgroundColor = colors[0]
        titleLabel.textColor = colors[2].withAlphaComponent(1)
        startButton.backgroundColor = colors[1]
        startButton.tintColor = colors[2].withAlphaComponent(1)
        gameView.backgroundColor = colors[0]
        playZoneView.backgroundColor = colors[0]
       // modalDescriptionLabel.textColor = colors[3].withAlphaComponent(1)
      //  modalLabelview.backgroundColor = colors[0].withAlphaComponent(0.8)
    }

    func startGame(){
        setCellsInteraction(state: .block)
        gameMemoriesPresenter.startGame()
    }

    func playSequence(sequence : [Int]){
        playSequence(sequence: sequence, delay: 2.0)
    }

    func playSequence(sequence: [Int], delay: Double) {
        for (index, element) in sequence.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + (delay * Double(index))) {
                let sequenceCell = self.gameCollectionView.cellForItem(at: IndexPath(row: element - 1, section: 0)) as? GameMemoriesCellView
                sequenceCell?.cellPush(.red)
            }
        }
        let totalDelay = delay * Double(sequence.count)
            DispatchQueue.main.asyncAfter(deadline: .now() + totalDelay) {
                self.setCellsInteraction(state: .unblock)
            }
    }

    func setCellsInteraction(state: TapState) {
        switch state {
        case .block:
            gameCollectionView.isUserInteractionEnabled = false
        case .unblock:
            gameCollectionView.isUserInteractionEnabled = true
        }
    }

    private func getUpdateForCollection(){
        gameCollectionView.reloadData()
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




            startButton.centerXAnchor.constraint(equalTo: playZoneView.centerXAnchor),
            startButton.bottomAnchor.constraint(equalTo: playZoneView.topAnchor, constant: -defaultIndent),
            startButton.widthAnchor.constraint(equalToConstant: 100),
            startButton.heightAnchor.constraint(equalToConstant: 60),

           // playZoneView.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: defaultIndent),
            playZoneView.heightAnchor.constraint(equalTo: gameView.widthAnchor, constant: -defaultIndent * 2),
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GameMemoriesCellView.identifier, for: indexPath) as! GameMemoriesCellView
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! GameMemoriesCellView
        cell.cellPush(.green)
        gameMemoriesPresenter.play(newElement: indexPath.item + 1)
    }
}
