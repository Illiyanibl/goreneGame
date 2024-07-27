//
//  MainPresenter.swift
//  gorene
//
//  Created by Illya Blinov on 4.02.24.
//

import Foundation
protocol MainPresenterProtocol: AnyObject {
    func newState()
    func mainViewDidLoad()
    func actionPressed(action: Int)
}

final class MainPresenter: MainPresenterProtocol {
    weak var mainView : MainViewProtocol?
    var modalMainView : ModalMainViewProtocol?
    let questService: QuestServiceProtocol
    var player: PlayerModelProtocol
    init(mainView: MainViewProtocol? = nil) {
        self.mainView = mainView
        self.questService = QuestService()
        self.player = PlayerModel(name: "Name")
        questService.player = player
        questService.mainPresenter = self
        start()
    }

    func start(){
        questService.changeQuest(newQuest: "ruFreeBrothersSCamp1", newState: 0)
    }

    func mainViewDidLoad(){
        newState()
    }

    func newState(){
        let state = questService.currentQuestState
        let stateModal: QuestStateModal? = questService.currentQuest?.questStates[state].questStateModal
        stateModal != nil ? showQuestStateModal(stateModal: stateModal) : ()
        let background: String? = questService.currentQuest?.questStates[state].background
        background != nil ? mainView?.pushBackgroundImage(background ?? "nil") : ()
        let statusText: String? = questService.currentQuest?.questStates[state].status
        statusText != nil ? mainView?.pushStatusLabel(text: statusText ?? "Error") : ()
        pushMainText()
        pushActions()
    }

    func pushMainText(){
        var mainText: String
        let state = questService.currentQuestState
        let alternativeMainText = questService.currentQuest?.questStates[state].alternativeMainText
        guard let alternativeMainText else {
            mainText = questService.currentQuest?.questStates[state].mainText ?? "Error"
            mainView?.pushMainText(text: mainText)
            return
        }

    }

    func pushActions(){
        let state = questService.currentQuestState
        let actions = questService.currentQuest?.questStates[state].actions
        var actionTitle: [String] = []
        var actionDescription : [String?] = []
        var actionIsOn : [Bool] = []
        actions?.forEach(){
            var isPossible =  elementIsPossible(
                requiredParameters: $0.requiredParameters ?? [:],
                sumOfParameters: $0.sumOfParameters ?? [:],
                player: player)
            if let inverseRelation = $0.inverseRelation {
                if inverseRelation < actionIsOn.count {
                    actionIsOn[inverseRelation] ? isPossible = false : ()
                }
            }
            actionTitle.append($0.actionText)
            actionDescription.append($0.actionDescription)
            actionIsOn.append(isPossible)
        }
        mainView?.pushActions(actionTitle: actionTitle, actionDetailsText: actionDescription, actionIsOn: actionIsOn)
    }

    private func showQuestStateModal(stateModal: QuestStateModal?) {
        guard let stateModal else { return }
        modalMainView?.setupView(modalImage: stateModal.image, showingDuration: stateModal.duration, modalDescription: stateModal.description)
        mainView?.showQuestStateModalView(view: modalMainView)
    }

    private func elementIsPossible(requiredParameters : [String : Int], sumOfParameters  : [String : Int] = [:], player: PlayerModelProtocol) -> Bool{
        var isPossible = true
        var sumPlayerStats = 0
        var sumNeed = 0

        requiredParameters.forEach() { parameter in
            let playerValue = player.parameters[parameter.key]
            playerValue == nil ? debugPrint("JSON error: \(parameter.key) not exists") : ()
            parameter.key.contains("Base") ? debugPrint("JSON error: \(parameter.key) is Base parameter. It be able using only for changingParameters()") : ()
            parameter.value > (playerValue  ?? 0) ? isPossible = false : ()
        }
        sumOfParameters.forEach(){ parameter in
            sumNeed += parameter.value
            player.parameters[parameter.key] == nil ? debugPrint("JSON error: \(parameter.key) not exists") : ()
            sumPlayerStats +=  player.parameters[parameter.key] ?? 0
        }
        sumNeed > sumPlayerStats ? isPossible = false : ()
        return isPossible
    }

    private func changeParameters(_ parameters: [String : Int]?){
        guard let parameters else { return }
        player.changeParameters(parameters)
    }

    func actionPressed(action: Int){ // обработка нажатия вариантов
        let actionPressed = questService.currentQuest?.questStates[questService.currentQuestState].actions[action]
        let newState = actionPressed?.actionNextState
        let newCurrentQuestName = actionPressed?.actionNextQuest
        changeParameters(actionPressed?.changingParameters)

        if newCurrentQuestName == nil {
            guard let newState else { return }
            questService.changeState(newState: newState)
        } else {
            guard let newCurrentQuestName else { return }
            questService.changeQuest(newQuest: newCurrentQuestName, newState: newState ?? 0)
        }
    }
}
