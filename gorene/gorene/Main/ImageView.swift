//
//  ImageView.swift
//  gorene
//
//  Created by Illya Blinov on 26.05.24.
//

import UIKit

final class ImageView: UIView {
var image: String = "default"
var duration: Int?
var imageDescription: String?
lazy var imageText: UILabel = {
    let label = UILabel()
    label.numberOfLines = 60
    return label
    }()

    func setupImage(image: String, duration: Int?, imageDescription: String?){

    }
}
