//
//  TableButtonViewCell.swift
//  gorene
//
//  Created by Illya Blinov on 4.02.24.
//
import UIKit
//
final class TableButtonViewCell: UITableViewCell {
    typealias Action = (()-> Void)
    var actionButtonAction: Action?
    var detailsButtonAction: Action?
    private var themeColor : [UIColor] { SettingsModel.share.colorTheme.getColor()}
    let buttonFont = UIFont.italicSystemFont(ofSize: 16)
    let actionButtonAttributes: [NSAttributedString.Key : Any] = [
        NSAttributedString.Key.underlineStyle: 0]

    lazy var actionButton: UIButton = {
        let button: UIButton = UIButton()
        button.titleLabel?.font = buttonFont
        button.titleLabel?.numberOfLines = 2
        button.alpha = 1
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemFill.cgColor
        button.setBackgroundImage(UIImage(systemName: "line.diagonal"), for: .disabled)
        button.addTarget(self, action: #selector(actionButtonClick), for: .touchUpInside)
        return button
    }()

    @objc private func actionButtonClick(){
        actionButtonAction?()
    }

    lazy var detailsButton: UIButton = {
        let button: UIButton = UIButton()
        button.alpha = 1
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 25
        button.setBackgroundImage(UIImage(systemName: "questionmark.circle"), for: .normal)
        button.addTarget(self, action: #selector(detailButtonClick), for: .touchUpInside)
        return button
    }()

    @objc private func detailButtonClick(){
        DispatchQueue.global(qos: .utility).async {
            sleep(1)
            DispatchQueue.main.async { [weak self] in
                self?.detailsButton.alpha = 1
            }
        }
        detailsButton.alpha = 0.5
        detailsButtonAction?()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupView(){
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        self.backgroundColor = .clear
        appleColorTheme(colors: themeColor)
        setupSubView()
        setupConstraints()
    }
    
    private func setupSubView(){
        contentView.addSubViews([detailsButton, actionButton])
    }

    func setupCell(actionButtonTitle: String, isEnable: Bool, detailsIsOff: Bool = false){

        let actionTitle = NSMutableAttributedString(string: actionButtonTitle, attributes: actionButtonAttributes)
        actionButton.setAttributedTitle(NSAttributedString(attributedString: actionTitle), for: .normal)
        actionButton.isEnabled = isEnable
        detailsButton.isHidden = detailsIsOff
        !isEnable ? actionButton.alpha = 0.2 : ()
    }
    
    func appleColorTheme(colors: [UIColor]){
        guard colors.count == 4 else { return }
        contentView.backgroundColor = colors[1]
        actionButton.tintColor = colors[2]
        actionButton.backgroundColor = colors[1]
        actionButton.setTitleColor(colors[2].withAlphaComponent(1), for: .normal)
        detailsButton.tintColor = colors[2]
        detailsButton.backgroundColor = colors[1]
        detailsButton.setTitleColor(colors[2].withAlphaComponent(1), for: .normal)
    }

    private func setupConstraints(){
        let nearIndent: CGFloat = 3
        NSLayoutConstraint.activate([
            detailsButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: nearIndent),
            detailsButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: nearIndent),
            detailsButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -nearIndent),
            detailsButton.widthAnchor.constraint(equalTo: detailsButton.heightAnchor),

            actionButton.topAnchor.constraint(equalTo: detailsButton.topAnchor),
            actionButton.bottomAnchor.constraint(equalTo: detailsButton.bottomAnchor),
            actionButton.leadingAnchor.constraint(equalTo: detailsButton.trailingAnchor, constant: 12),
            actionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -nearIndent),

            ])
    }
}

