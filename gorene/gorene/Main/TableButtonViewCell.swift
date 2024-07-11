//
//  TableButtonViewCell.swift
//  gorene
//
//  Created by Illya Blinov on 4.02.24.
//
import UIKit
enum TableButtonActions {
    case primaryAction
    case detailsAction
}
protocol TableButtonCellDelegate {
    func cellActions(_ cellId: Int, action: TableButtonActions)
}
final class TableButtonViewCell: UITableViewCell {
    var cellConstraints: [NSLayoutConstraint]?
    var cellId: Int?
    var delegate: TableButtonCellDelegate?

    private var themeColor : [UIColor] { SettingsModel.share.colorTheme.getColor()}
    let buttonFont = UIFont.italicSystemFont(ofSize: 16)

    lazy var actionButtonAttributes: [NSAttributedString.Key : Any] = [
        NSAttributedString.Key.underlineStyle: 0, NSAttributedString.Key.font:  buttonFont]
    lazy var disabledActionButtonAttributes: [NSAttributedString.Key : Any] = [
        NSAttributedString.Key.underlineStyle: 0, NSAttributedString.Key.strikethroughStyle: 1,  NSAttributedString.Key.font:  buttonFont, NSAttributedString.Key.strokeColor: UIColor.red]

    var buttonConfig: UIButton.Configuration = {
        var config = UIButton.Configuration.filled()
        return config
    }()

    lazy var buttonPrimaryAction = UIAction() { [weak self] action in
        guard let self else { return }
        guard let cellId else { return }
        self.delegate?.cellActions(cellId, action: .primaryAction)}

    lazy var actionButton: UIButton = {
        let button = UIButton(configuration: buttonConfig, primaryAction: nil)
        button.titleLabel?.numberOfLines = 2
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemFill.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button

    }()

    lazy var detailsButton: UIButton = {
        let button: UIButton = UIButton()
        button.alpha = 1
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 25
        button.setBackgroundImage(UIImage(systemName: "questionmark.circle"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(detailButtonClick), for: .touchUpInside)
        return button
    }()

    lazy var clearView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    @objc private func detailButtonClick(){
        DispatchQueue.global(qos: .utility).async {
            sleep(1)
            DispatchQueue.main.async { [weak self] in
                self?.detailsButton.alpha = 1
                self?.detailsButton.isEnabled = true
            }
        }
        detailsButton.alpha = 0.5
        detailsButton.isEnabled = false
        guard let cellId else { return }
        delegate?.cellActions(cellId, action: .detailsAction)
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

    override func prepareForReuse() {
        super.prepareForReuse()
       // activateConstraints(activate: false)
        actionButton.removeAction(buttonPrimaryAction, for: .touchUpInside)
        cellId = nil
    }

    func setupCell(actionButtonTitle: String, isActive: Bool, detailsIsOff: Bool = false, row: Int){
        cellId = row
        if isActive {
            let actionTitle = NSMutableAttributedString(string: actionButtonTitle, attributes: actionButtonAttributes)
            actionButton.addAction(buttonPrimaryAction, for: .touchUpInside)
            actionButton.setAttributedTitle(NSAttributedString(attributedString: actionTitle), for: .normal)
            actionButton.alpha = 1
        } else {
            let actionTitle = NSMutableAttributedString(string: actionButtonTitle, attributes: disabledActionButtonAttributes)
            actionButton.setAttributedTitle(NSAttributedString(attributedString: actionTitle), for: .normal)
            actionButton.alpha = 0.7
        }
        detailsButton.isHidden = detailsIsOff
    }
    
    func appleColorTheme(colors: [UIColor]){
        guard colors.count == 4 else { return }
     //   guard let cellIsActive else { return }
     //   guard cellIsActive else { return }
        buttonConfig.baseBackgroundColor = colors[1]
        buttonConfig.baseForegroundColor = colors[2]
        detailsButton.tintColor = colors[2]
        detailsButton.backgroundColor = colors[1]
        detailsButton.setTitleColor(colors[2].withAlphaComponent(1), for: .normal)
        updateButtonColors()
    }

    func updateButtonColors(){
        actionButton.configuration = buttonConfig
    }

    private func setupConstraints(){
        let nearIndent: CGFloat = 3
        cellConstraints = ([
            detailsButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: nearIndent),
            detailsButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            detailsButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            detailsButton.widthAnchor.constraint(equalTo: detailsButton.heightAnchor),
            actionButton.topAnchor.constraint(equalTo: detailsButton.topAnchor),
            actionButton.bottomAnchor.constraint(equalTo: detailsButton.bottomAnchor),
            actionButton.leadingAnchor.constraint(equalTo: detailsButton.trailingAnchor, constant: 12),
            actionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            ])
        activateConstraints(activate: true)
    }

    private func activateConstraints(activate: Bool){
        activate ? NSLayoutConstraint.activate(cellConstraints ?? []) : NSLayoutConstraint.deactivate(cellConstraints ?? [])
    }
}

