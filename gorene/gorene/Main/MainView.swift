//
//  MainView.swift
//  gorene
//
//  Created by Illya Blinov on 30.01.24.
//
import UIKit

protocol MainViewProtocol: AnyObject {
    func getColorTheme()
    //MARK: func for MainPresenter
    func pushBackgroundImage(_ image: String)
    func pushStatusLabel(text: String)
    func pushMainText(text: String)
    func pushPlayButton(actionButtonTitle: [String], detailsButtonText: [String?], actionIsOn: [Bool])
    
}

final class MainView: UIViewController, MainViewProtocol {

    var mainPresenter: MainPresenterProtocol

    let mainFontParagraphStyle: NSMutableParagraphStyle = {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        paragraphStyle.paragraphSpacing = 8
        return paragraphStyle
    }()

    private let labelFont = UIFont.italicSystemFont(ofSize: 18)
    private let mainFont = UIFont.italicSystemFont(ofSize: 18)
    private let titleFont = UIFont.italicSystemFont(ofSize: 20)
    var themeColor : [UIColor] { SettingsModel.share.colorTheme.getColor()}
    var actionButtons : [String] = []
    var actionIsPossible : [Bool] = []
    var detailsButtons : [String?] = []

    lazy var touchDetailsViewClose = UITapGestureRecognizer(target: self, action: #selector(detailsViewClose))

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
        label.font = mainFont
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
        button.setBackgroundImage(UIImage(systemName: "person.circle"), for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 25
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemFill.cgColor
        return button
    }()

    lazy var settingsButton: UIButton = {
        let button: UIButton = CustomButton(title: "", action: { [weak self] in
            if SettingsModel.share.colorTheme != .mainWhite {
                SettingsModel.share.chooseColorTheme(colorTheme: .mainWhite)} else {
                    SettingsModel.share.chooseColorTheme(colorTheme: .mainDarck)
                }
            self?.getColorTheme() })
        button.setBackgroundImage(UIImage(systemName: "gearshape"), for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 25
        return button
    }()

    lazy var saveButton: UIButton = {
        let button: UIButton = CustomButton(title: "", action: { [weak self] in
            self?.dismiss(animated: true)
        })
        let saveImage = UIImage(systemName: "folder.circle")
        button.setBackgroundImage(saveImage, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 25
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemFill.cgColor
        return button
    }()

    lazy var loadButton: UIButton = {
        let button: UIButton = CustomButton(title: "", action: { [weak self] in
            self?.dismiss(animated: true)
        })
        button.setBackgroundImage(UIImage(systemName: "doc.circle"), for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 25
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemFill.cgColor
        return button
    }()

    lazy var clearView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    lazy var playButtonTable: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = .clear
        table.separatorColor = .clear
        TableButtonViewCell.appearance().selectedBackgroundView = clearView
        table.register(TableButtonViewCell.self, forCellReuseIdentifier: TableButtonViewCell.identifier)
        table.rowHeight = 56
        table.showsVerticalScrollIndicator = false
        table.layer.cornerRadius = 12
        return table
    }()

    lazy var detailsView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.systemFill.cgColor
        view.isHidden = true
        view.alpha = 1
        return view
    }()

    lazy var detailsTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = titleFont
        label.isHidden = true
        return label
    }()
    lazy var detailsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = mainFont
        label.isHidden = true
        return label
    }()

    init(mainPresenter: MainPresenterProtocol) {
        self.mainPresenter = mainPresenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


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
        mainPresenter.start()
        view.backgroundColor = .black
        appleColorTheme(colors: themeColor)

        setupSubView()
        view.addSubViews([mainTextView, informationView, playButtonTable, playerButton, saveButton, loadButton])
        setupConstraints()
    }

    private func setupSubView(){
        mainTextView.addSubViews([mainTextLabel])
        informationView.addSubViews([locationLabel, statusLabel, settingsButton])
    }

    internal func getColorTheme(){
        appleColorTheme(colors: themeColor)
    }

    internal func pushImageView(image: String, duration: Int?, description: String?){

    }

    internal func pushBackgroundImage(_ image: String){
        let backgraungImage = UIImage(named: image)
        guard let backgraungImage else { return }
        view.layer.contents = backgraungImage.cgImage
    }

    internal func pushMainText(text: String){
        let attrText = NSMutableAttributedString(string: text)
        attrText.addAttribute(.paragraphStyle, value:mainFontParagraphStyle, range:NSMakeRange(0, attrText.length))
        mainTextLabel.attributedText = attrText
    }

    internal func pushPlayButton(actionButtonTitle: [String], detailsButtonText: [String?], actionIsOn: [Bool]){
        actionButtons = actionButtonTitle
        print(actionButtonTitle)
        detailsButtons = detailsButtonText
        actionIsPossible = actionIsOn
        playButtonTable.reloadData()

    }

    internal func pushStatusLabel(text: String){
        statusLabel.text = text
    }

    internal func pushStats(stats: [String : Int]){
    }

    internal func showDetails(details: String?, action: String){
        detailsTitleLabel.text = action
        detailsLabel.text = details ?? ""
        detailsView.addSubViews([detailsTitleLabel, detailsLabel])
        view.addSubview(detailsView)
        detailsView.isHidden = false
        detailsView.frame = CGRect(x: 0, y:0 , width: 10, height: 10)
        detailsView.center = CGPoint(x: self.mainTextView.center.x, y : self.playButtonTable.center.y)
        animateShowDetails()
        view.needsUpdateConstraints()
        view.layoutIfNeeded()
    }
    @objc func detailsViewClose(){
                hideDetails()
    }

    private func hideDetails(){
        detailsTitleLabel.removeFromSuperview()
        detailsLabel.removeFromSuperview()
        detailsConstraints(0)
        animateHideDetails()
        view.needsUpdateConstraints()
        view.layoutIfNeeded()
    }

    private func animateShowDetails(){
        let animator = UIViewPropertyAnimator(duration: 0.3, curve: .linear){ [weak self] in
            guard let self else { return }
            self.detailsView.frame = CGRect(x: 0, y: 0, width: self.mainTextView.frame.width, height: self.playButtonTable.frame.height)
            self.detailsView.center = CGPoint(x: self.mainTextView.center.x, y : self.playButtonTable.center.y)
        }
        let finichAnimator = UIViewPropertyAnimator(duration: 0.0, curve: .linear){ [weak self] in
            guard let self else { return }
            self.detailsConstraints()
            self.detailsTitleLabel.isHidden = false
            self.detailsLabel.isHidden = false
            self.detailsView.addGestureRecognizer(touchDetailsViewClose)
        }
        animator.addCompletion {_ in
            finichAnimator.startAnimation(afterDelay: 0.1)
        }
        animator.startAnimation(afterDelay: 0.0)
    }

    private func animateHideDetails(){
        let animator = UIViewPropertyAnimator(duration: 0.3, curve: .linear){ [weak self] in
            guard let self else { return }
            self.detailsTitleLabel.isHidden = true
            self.detailsLabel.isHidden = true
            self.detailsView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
            self.detailsView.center = CGPoint(x: self.mainTextView.center.x, y : self.playButtonTable.center.y)
        }
        animator.addCompletion {[weak self] _ in
            guard let self else { return }
            self.detailsView.removeGestureRecognizer(touchDetailsViewClose)
            self.detailsView.removeFromSuperview()
        }
        animator.startAnimation(afterDelay: 0.0)
    }


    private func appleColorTheme(colors: [UIColor]){
        guard colors.count == 4 else { return }
        mainTextView.backgroundColor = colors[0]
        informationView.backgroundColor = colors[1]
        locationLabel.textColor = colors[2].withAlphaComponent(1)
        statusLabel.textColor = colors[2]
        mainTextLabel.textColor = colors[3].withAlphaComponent(1)
        settingsButton.backgroundColor = .clear
        //colors[0]
        settingsButton.tintColor = colors[2].withAlphaComponent(1)
        playerButton.backgroundColor = colors[1]
        playerButton.tintColor = colors[2].withAlphaComponent(1)
        saveButton.backgroundColor = colors[1]
        saveButton.tintColor = colors[2].withAlphaComponent(1)
        loadButton.backgroundColor = colors[1]
        loadButton.tintColor = colors[2].withAlphaComponent(1)
        detailsView.backgroundColor = colors[0]
        detailsTitleLabel.textColor = colors[2].withAlphaComponent(1)
        detailsLabel.textColor = colors[3].withAlphaComponent(1)
        playButtonTable.reloadData()
    }
}
