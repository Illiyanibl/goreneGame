//
//  TableButtonViewCell.swift
//  gorene
//
//  Created by Illya Blinov on 4.02.24.
//
import UIKit
//
protocol TableButtonViewCellDelegate{
}
final class TableButtonViewCell: UITableViewCell {

    typealias callBackAction =  (() -> Void)
    var action: callBackAction?
    let buttonFont = UIFont.italicSystemFont(ofSize: 16)

    lazy var actionButton: UIButton = {
        let button: UIButton = CustomButton(title: "",
                                            titleColor: .systemBackground,
                                            backgroundColor: .white.withAlphaComponent(0.5),
                                            action: { [weak self] in self?.action?() })
        button.titleLabel?.font = buttonFont
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 12
        return button
    }()

    lazy var detailedButton: UIButton = {
        let button: UIButton = CustomButton(title: "",
                                            action: {})
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 12
        button.setBackgroundImage(UIImage(named: "details"), for: .normal)
        return button
    }()

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
        contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        setupSubView()
        setupConstraints()
    }
    
    private func setupSubView(){
        contentView.addSubViews([detailedButton, actionButton])
    }

    func setupCell(gotAction: callBackAction?){
    //проверить утечку памяти, по идее тут уже weak self потому что actionButton ссылается на var action слабо
        self.action = gotAction
    }

    private func setupConstraints(){
        let heightContentView: CGFloat = 50
        let nearIndent: CGFloat = 3
        NSLayoutConstraint.activate([
            detailedButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: nearIndent),
            detailedButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -nearIndent),
            detailedButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: nearIndent),
            detailedButton.heightAnchor.constraint(equalToConstant: heightContentView),
            detailedButton.widthAnchor.constraint(equalToConstant: heightContentView),

            actionButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: nearIndent),
            actionButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -nearIndent),
            actionButton.leadingAnchor.constraint(equalTo: detailedButton.trailingAnchor, constant: 12),
            actionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -nearIndent),
        ])
    }
}

