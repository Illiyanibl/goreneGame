//
//  GameMemoriesPresenter.swift
//  gorene
//
//  Created by Illya Blinov on 11.02.25.
//

import Foundation
protocol GameMemoriesPresenterProtocol {
    func startGame()
}
final class GameMemoriesPresenter: GameMemoriesPresenterProtocol {
    weak var gameMemoriesModalView : GameMemoriesViewProtocol?
    init(gameMemoriesModalView: GameMemoriesViewProtocol? = nil) {
        self.gameMemoriesModalView = gameMemoriesModalView
    }
    func startGame() {
        let randomSequence = randomSequenceGenerating()
        gameMemoriesModalView?.pushInstructionText(text: "Повторите комбинацию используя кнопки <Тест комбинация> = \(randomSequence)")
    }

    func randomSequenceGenerating (lengthSequence: Int = 8, maxValue: Int = 16) -> [Int] {
        var randomSequences = [[Int](),[Int]()]
        var randomSequence: [Int] = [Int]()
        (1...lengthSequence).forEach(){ f in
            let randomValues = [Int.random(in: (1...maxValue)), Int.random(in: (1...maxValue)), Int.random(in: (1...maxValue)), Int.random(in: (1...maxValue))]
            let randomIndexFirst = Int.random(in: (0...1))
            let randomIndexSecond = Int.random(in: (2...3))
            randomSequences[0].append(randomValues[randomIndexFirst])
            randomSequences[1].append(randomValues[randomIndexSecond])
        }
        randomSequence = Set(randomSequences[0]).count > Set(randomSequences[1]).count ? randomSequences[0] : randomSequences[1]
        return randomSequence
    }
}
