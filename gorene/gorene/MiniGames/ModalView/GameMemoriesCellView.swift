//
//  GameMemoriesCellView.swift
//  gorene
//
//  Created by Illya Blinov on 19.01.25.
//

import UIKit
final class GameMemoriesCellView: UICollectionViewCell{
    let cellColor: UIColor = .gray
    let cellView: UIView = {
        let cellView = UIView()
        cellView.translatesAutoresizingMaskIntoConstraints = false
        cellView.contentMode = .scaleAspectFill
        cellView.layer.masksToBounds = true
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
        cellView.backgroundColor = cellColor
        contentView.addSubViews([cellView])
        setupConstraints()
    }

    func cellPush(_ color: UIColor){
        pushAnimation(color)
    }

    func pushAnimation(_ color: UIColor){
        let animator = UIViewPropertyAnimator(duration: 0.25, curve: .linear) {
            self.cellView.backgroundColor = color}
        let comeBackAnomator = UIViewPropertyAnimator(duration: 0.25, curve: .linear){
            self.cellView.backgroundColor = self.cellColor
        }
        animator.addCompletion {_ in
            comeBackAnomator.startAnimation(afterDelay: 1.5)
        }
        animator.startAnimation(afterDelay: 0.0)
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
