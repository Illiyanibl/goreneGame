//
//  SettingsModel.swift
//  gorene
//
//  Created by Illya Blinov on 5.02.24.
//

import UIKit
enum ColorTheme {
    case mainDarck
    case whiteText
    case mainWhite
    case theEndOfSummer

    func getColor() -> [UIColor] {
        var colors: [UIColor] = []
        switch self {
        case .mainDarck:
            colors.append(UIColor(hex: "222222")?.withAlphaComponent(0.9) ?? UIColor.black)
            colors.append(UIColor(hex: "111111")?.withAlphaComponent(0.9) ?? UIColor.systemGray)
            colors.append(UIColor(hex: "ffbe8f")?.withAlphaComponent(0.9) ?? UIColor.systemYellow)
            colors.append(UIColor(hex: "FFFAF0")?.withAlphaComponent(0.9) ?? UIColor.white)
        case .whiteText:
            colors.append(UIColor(hex: "222222")?.withAlphaComponent(0.9) ?? UIColor.black)
            colors.append(UIColor(hex: "111111")?.withAlphaComponent(0.9) ?? UIColor.systemGray)
            colors.append(.systemGray6)
            colors.append(.white)
        case .mainWhite:
            colors.append(UIColor(hex: "BBBBBB")?.withAlphaComponent(0.9) ?? UIColor.white)
            colors.append(UIColor(hex: "DDDDDD")?.withAlphaComponent(0.9) ?? UIColor.systemGray6)
            colors.append(UIColor(hex: "222222") ?? UIColor.darkGray)
            colors.append(UIColor(hex: "111111") ?? UIColor.black)
        case .theEndOfSummer:
            // светлый песочный фон для текста
            colors.append(UIColor(hex: "#F8E7C9")?.withAlphaComponent(0.92) ?? UIColor.white)
            // кнопки — нежный пастельно-коралловый рассвет
            colors.append(UIColor(hex: "#F58A74")?.withAlphaComponent(0.95) ?? UIColor.systemGray6)
            // текст на кнопках — белый, как морская пена
            colors.append(UIColor(hex: "#FFFFFF") ?? UIColor.darkGray)
            // глубокая морская бирюза для акцентов
            colors.append(UIColor(hex: "#2C9E92") ?? UIColor.black)

        }

        if colors.count < 4 { colors = [UIColor.black, UIColor.systemGray, UIColor.white, UIColor.lightGray]}
        return colors
    }
}
protocol SettingsModelProtocol: Any{
mutating func chooseColorTheme(colorTheme: ColorTheme)
}
struct SettingsModel:SettingsModelProtocol {
    static var share: SettingsModel = SettingsModel(colorTheme: .mainDarck)
    var colorTheme: ColorTheme
    private init(colorTheme: ColorTheme) {
        self.colorTheme = colorTheme
    }
    mutating func chooseColorTheme(colorTheme: ColorTheme){
        self.colorTheme = colorTheme
    }
}
