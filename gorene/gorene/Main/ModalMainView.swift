//
//  ImageView.swift
//  gorene
//
//  Created by Illya Blinov on 26.05.24.
//

import UIKit

protocol ModalMainViewProtocol: AnyObject {
   func setupView(modalImage: String?, showingDuration: Int?, modalDescription: String?)
}
protocol ModalMainViewDelegateProtocol {
    func closeModalView(view: UIView)
}

final class ModalMainView: UIView, ModalMainViewProtocol {
    var modalImage: String?
    var showingDuration: Int?
    var modalDescription: String?
    var themeColor : [UIColor] { SettingsModel.share.colorTheme.getColor()}
    var delegate: ModalMainViewDelegateProtocol?
    lazy var modalDescriptionLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 30
        label.font = UIFont.mainFont
        return label
    }()

    lazy var modalLabelview: UIScrollView = {
        let view = UIScrollView()
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 2
        view.layer.masksToBounds = true
        view.layer.borderColor = UIColor.systemFill.cgColor
        return view
    }()

    lazy var closeButton: UIView = {
        let view = UIView()
        view.layer.contents = UIImage(systemName: "arrow.down.circle")?.cgImage
        view.layer.cornerRadius = 25
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupGesture()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI(){
        self.contentMode = .scaleAspectFill
        modalLabelview.addSubViews([modalDescriptionLabel])
        self.addSubViews([modalLabelview])

    }

    func setupView(modalImage: String?, showingDuration: Int?, modalDescription: String?){
        appleColorTheme(colors: themeColor)
        if modalDescription != nil {
            modalDescriptionLabel.isHidden = false
            modalLabelview.isHidden = false
            modalDescriptionLabel.attributedText = UIFont.getAttributedString(text: modalDescription ?? "", paragraphStyle: UIFont.mainFontParagraphStyle)
        } else {
            modalDescriptionLabel.isHidden = true
            modalLabelview.isHidden = true}
        if modalImage != nil {
            guard let modalImage else { return }
            let setupImage = UIImage(named: modalImage)
            self.layer.contents = setupImage?.cgImage
        } else {
            self.layer.contents = .none
        }
    }

    private func setupGesture(){
        let tapCloseButton = UITapGestureRecognizer(target: self, action: #selector(closeModalMainView))
        closeButton.addGestureRecognizer(tapCloseButton)
    }

    @objc private func closeModalMainView(){
        delegate?.closeModalView(view: self)
        debugPrint("Push close button")
    }

    private func appleColorTheme(colors: [UIColor]){
        guard colors.count == 4 else { return }
        self.backgroundColor = colors[0]
        modalDescriptionLabel.textColor = colors[3].withAlphaComponent(1)
        modalLabelview.backgroundColor = colors[0].withAlphaComponent(0.8)
    }

    func setupConstraints(){
        let ident: CGFloat = 16
        NSLayoutConstraint.activate([
            modalLabelview.topAnchor.constraint(equalTo: self.topAnchor, constant: ident / 2),
            modalLabelview.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -ident),
            modalLabelview.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: ident / 2),
            modalLabelview.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -ident / 2),

            modalDescriptionLabel.topAnchor.constraint(equalTo: modalLabelview.topAnchor, constant: ident),
            modalDescriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: ident),
            modalDescriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -ident),
            modalDescriptionLabel.bottomAnchor.constraint(equalTo: modalLabelview.bottomAnchor, constant: -ident),
            //modalDescriptionLabel.bottomAnchor.constraint(equalTo: closeButton.topAnchor, constant: -ident),
        ])
    }
}
