//
//  GameMemoriesPresenter.swift
//  gorene
//
//  Created by Illya Blinov on 11.02.25.
//

import Foundation
protocol GameMemoriesPresenterProtocol {
    func startGame()
    func play(newElement: Int)
    var gameMemoriesModalView : GameMemoriesViewProtocol? {get set}
}
final class GameMemoriesPresenter: GameMemoriesPresenterProtocol {
    weak var gameMemoriesModalView : GameMemoriesViewProtocol?
    weak var mainPresenter: MainPresenterProtocol?


    private var randomSequence : [Int] = []
    private var playerSequencce : [Int] = []
    private var isGameOver : Bool =  true

    init(gameMemoriesModalView: GameMemoriesViewProtocol? = nil, mainPresenter: MainPresenterProtocol? = nil) {
        self.gameMemoriesModalView = gameMemoriesModalView
        self.mainPresenter = mainPresenter

    }
    func startGame() {
        let gameLavel: Int = mainPresenter?.getVariables("gameLavel").0 ?? 0 //0 елемент тьюпла
        let lavel = (gameLavel / 4) + 5
        
        isGameOver = false
        randomSequence = randomSequenceGenerating(lengthSequence: lavel)
        playerSequencce.removeAll()
        gameMemoriesModalView?.pushInstructionText(text: "Повторите комбинацию используя кнопки.")
        gameMemoriesModalView?.playSequence(sequence: randomSequence)
    }

    func play(newElement: Int) {
        debugPrint("new element \(newElement)")
        guard randomSequence.count > playerSequencce.count else {
            gameOver()
            return }
        playerSequencce.append(newElement)
        if playerSequencce.count == randomSequence.count { gameOver() }
    }

    private func gameOver(){
        guard isGameOver == false else { return }
        isGameOver = true
        gameMemoriesModalView?.setCellsInteraction(state: .block)
        //view gameover
        if playerSequencce == randomSequence { win()}
        else { lose()}
    }

    private func win() {
        gameMemoriesModalView?.pushInstructionText(text: "Конец игры. Вы выйграли")
        mainPresenter?.gameResult(.win)
        debugPrint(mainPresenter?.getVariables("coins").0 ?? "Переменная coins не найдена")
    }

    private func lose(){
        gameMemoriesModalView?.pushInstructionText(text: "Конец игры. Вы проиграли")
        mainPresenter?.gameResult(.lose)
        debugPrint(mainPresenter?.getVariables("coins").0 ?? "Переменная coins не найдена")
    }

    func randomSequenceGenerating (lengthSequence: Int = 5, maxValue: Int = 10) -> [Int] {
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
