//
//  MainPresenter.swift
//  gorene
//
//  Created by Illya Blinov on 4.02.24.
//

import Foundation
import OSLog
protocol MainPresenterProtocol: AnyObject {
    func newState()
    func mainViewDidLoad()
    func actionPressed(action: Int)
}

final class MainPresenter: MainPresenterProtocol {
    weak var mainView : MainViewProtocol?
    var modalMainView : MainModalViewProtocol?
    var modalGameView : GameMemoriesViewProtocol?
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
        questService.changeQuest(newQuest: "ruPrologue", newState: 0)
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
      //  var mainText: String
      //  let state = questService.currentQuestState
      //  let alternativeMainText = questService.currentQuest?.questStates[state].alternativeMainText
       // print("alternativeMainText test \(questService.findMainText())")
      //  guard let alternativeMainText else {
      //      mainText = questService.currentQuest?.questStates[state].mainText ?? "Error"
       //     mainView?.pushMainText(text: mainText)
        //    return
      //  }
        let mainText: String = questService.findMainText()
        mainView?.pushMainText(text: mainText)


    }

    func pushActions(){
        let state = questService.currentQuestState
        let actions = questService.currentQuest?.questStates[state].actions
        var actionTitle: [String] = []
        var actionDescription : [String?] = []
        var actionIsOn : [Bool] = []
        actions?.forEach(){
            var isPossible = questService.elementIsPossible(element: $0)
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
        mainView?.showModalView(view: modalMainView)
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
        checkTypeOfGame(action: actionPressed)
    }

    func checkTypeOfGame(action: ActionStruct?) {
        let typeOfGame = questService.checkTypeOfGame(action: action)
        switch typeOfGame {
        case .nogame:
            break
        case .memories:
            showModalGameView(view: GameMemoriesModalView())
        }

    }

    private func showModalGameView(view: GameMemoriesViewProtocol) {
        self.modalGameView = view
        mainView?.showModalView(view: modalGameView)
    }


}
