//
//  GameMemoriesCellView.swift
//  gorene
//
//  Created by Illya Blinov on 19.01.25.
//

import UIKit
final class GameMemoriesCellView: UICollectionViewCell{
    let cellView: UIView = {
        let cellView = UIView()
        cellView.translatesAutoresizingMaskIntoConstraints = false
        cellView.contentMode = .scaleAspectFill
        cellView.layer.masksToBounds = true
        cellView.backgroundColor = .yellow
        return cellView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        contentView.addSubViews([cellView])
        setupConstraints()
    }

    private func setupConstraints(){
        NSLayoutConstraint.activate([
            cellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
}
