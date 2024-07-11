//
//  Fonts.swift
//  gorene
//
//  Created by Illya Blinov on 10.06.24.
//

import UIKit
protocol FontsProtocol {}

extension UIFont{
   static var mainFontParagraphStyle: NSMutableParagraphStyle = {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        paragraphStyle.paragraphSpacing = 8
       paragraphStyle.alignment = .justified
        return paragraphStyle
    }()
    static var labelFont = UIFont.italicSystemFont(ofSize: 18)
    static var mainFont = UIFont.italicSystemFont(ofSize: 18)
    static var titleFont = UIFont.italicSystemFont(ofSize: 20)

    static func getAttributedString(text: String, paragraphStyle: NSMutableParagraphStyle) ->  NSMutableAttributedString {
        let attributedText = NSMutableAttributedString(string: text)
        attributedText.addAttribute(.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedText.length))
        return attributedText
    }
}
