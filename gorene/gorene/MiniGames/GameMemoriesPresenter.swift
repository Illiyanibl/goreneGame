//
//  GameMemoriesPresenter.swift
//  gorene
//
//  Created by Illya Blinov on 11.02.25.
//

import Foundation
protocol GameMemoriesPresenterProtocol {
    func modalViewDidLoad()
    func startGame()
    func play(newElement: Int)
    func viewClosed()
    var gameMemoriesModalView : GameMemoriesViewProtocol? {get set}
}
final class GameMemoriesPresenter: GameMemoriesPresenterProtocol {
    weak var gameMemoriesModalView : GameMemoriesViewProtocol?
    weak var mainPresenter: MainPresenterProtocol?

    private var playState: MiniGameState
    private var randomSequence : [Int] = []
    private var playerSequencce : [Int] = []
    private var isGameOver : Bool =  true

    init(gameMemoriesModalView: GameMemoriesViewProtocol? = nil, mainPresenter: MainPresenterProtocol? = nil) {
        self.gameMemoriesModalView = gameMemoriesModalView
        self.mainPresenter = mainPresenter
        self.playState = .shownView

    }
    //MARK: func GameMemoriesPresenterProtocol
    internal func modalViewDidLoad(){
        gameMemoriesModalView?.pushInstructionText(text: String(localized: "startGameInfoMemories"))
    }

    internal func startGame() {
        playState = .gameStarted
        let gameLavel: Int = mainPresenter?.getVariables("gameLavel").0 ?? 0 //Int елемент тьюпла
        let lavel = (gameLavel / 4) + 5
        isGameOver = false
        randomSequence = randomSequenceGenerating(lengthSequence: lavel)
        playerSequencce.removeAll()
        gameMemoriesModalView?.playSequence(sequence: randomSequence)
    }

    internal func play(newElement: Int) {
        debugPrint("new element \(newElement)")
        guard randomSequence.count > playerSequencce.count else {
            gameOver()
            return }
        playerSequencce.append(newElement)
        if playerSequencce.count == randomSequence.count { gameOver() }
    }

    internal func viewClosed() {
        switch playState {
        case .gameOver:
            debugPrint("Window closed, game over ")
            return
        case .shownView:
            debugPrint("Window closed, no game ")
            mainPresenter?.gameResult(.noPlay)
            return
        case .gameStarted:
            debugPrint("Window closed, the game was not finished")
            mainPresenter?.gameResult(.lose)
        }

    }

    //MARK: END func GameMemoriesPresenterProtocol
    private func gameOver(){
        guard playState == .gameStarted else { return }
        playState = .gameOver
        gameMemoriesModalView?.setCellsInteraction(state: .block)
        if playerSequencce == randomSequence { win()}
        else { lose()}
    }

    private func win() {
        gameMemoriesModalView?.pushInstructionText(text: String(localized: "gameOverWin"))
        mainPresenter?.gameResult(.win)
        debugPrint(mainPresenter?.getVariables("coins").0 ?? "Переменная coins не найдена")
    }

    private func lose(){
        gameMemoriesModalView?.pushInstructionText(text: String(localized: "gameOverLose"))
        mainPresenter?.gameResult(.lose)
        debugPrint(mainPresenter?.getVariables("coins").0 ?? "Переменная coins не найдена")
    }
}

extension GameMemoriesPresenter {
    func randomSequenceGenerating(lengthSequence: Int = 5, maxValue: Int = 10) -> [Int] {
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
