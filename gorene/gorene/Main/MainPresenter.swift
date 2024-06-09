//
//  MainPresenter.swift
//  gorene
//
//  Created by Illya Blinov on 4.02.24.
//

import Foundation
protocol MainPresenterProtocol: AnyObject {
    func newState()
    func start()
    func actionPressed(action: Int)
}

final class MainPresenter: MainPresenterProtocol {
    weak var mainView : MainViewProtocol?
    let questService: QuestServiceProtocol
    var player: PlayerModelProtocol
    init(mainView: MainViewProtocol? = nil) {
        self.mainView = mainView
        self.questService = QuestService()
        self.player = PlayerModel(questService: questService, name: "Name")
        questService.player = player
        questService.mainPresenter = self
    }

    func start(){
        newState()
    }

    func newState(){
        let background: String? = questService.currentQuest?.questStates[questService.currentQuestState].background
        background != nil ? mainView?.pushBackgroundImage(background ?? "Nil") : ()

        let statusText: String? = questService.currentQuest?.questStates[questService.currentQuestState].status
        statusText != nil ? mainView?.pushStatusLabel(text: statusText ?? "Nil") : ()

        let mainText: String = questService.currentQuest?.questStates[questService.currentQuestState].mainText ?? "Error"
        mainView?.pushMainText(text: mainText)

        //
        let actions = questService.currentQuest?.questStates[questService.currentQuestState].actions
        var actionTitle: [String] = []
        var actionDesctiption : [String?] = []
        var actionIsOn : [Bool] = []

        //Массив действий(кнопок)
        actions?.forEach(){

            let isPossible =  actionIsPossible(
                requiredParameters: $0.requiredParameters ?? [:],
                sumOfParameters: $0.sumOfParameters ?? [:],
                player: player
            )
            actionTitle.append($0.actionText)
            actionDesctiption.append($0.actionDesctiption)
            actionIsOn.append(isPossible)
        }

        mainView?.pushPlayButton(actionButtonTitle: actionTitle, detailsButtonText: actionDesctiption, actionIsOn: actionIsOn)
    }

    func actionIsPossible(requiredParameters : [String : Int], sumOfParameters  : [String : Int], player: PlayerModelProtocol) -> Bool{
        var possible = true
        var sumPlayerStats = 0
        var sumNeed = 0

        requiredParameters.forEach() { parameter in
            let playerValue = player.stats[parameter.key] ?? 100
            parameter.value > playerValue ? possible = false : ()
        }

        sumOfParameters.forEach(){ parameter in
            sumNeed += parameter.value
            sumPlayerStats +=  player.stats[parameter.key] ?? 100
        }
        sumNeed > sumPlayerStats ? possible = false : ()
        return possible
    }

    func actionPressed(action: Int){ // обработка нажатия вариантов
        let actionPressed = questService.currentQuest?.questStates[questService.currentQuestState].actions[action]
        let newState = actionPressed?.actionNextState
        let newCurrentQuestName = actionPressed?.actionNextQuest

        if newCurrentQuestName == nil {
            guard let newState else { return }
            questService.changeState(newState: newState)
        } else {
            guard let newCurrentQuestName else { return }
            questService.changeQuest(newQuest: newCurrentQuestName, newState: newState ?? 0)
        }
    }
}
