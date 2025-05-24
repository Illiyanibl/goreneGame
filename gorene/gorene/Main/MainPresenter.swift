//
//  MainPresenter.swift
//  gorene
//
//  Created by Illya Blinov on 4.02.24.
//

import Foundation
import OSLog
protocol MainPresenterProtocol: AnyObject {
    //for main View
    func mainViewDidLoad()
    func actionPressed(action: Int)
    //for QuestService
    func newState()
    //for Settings
    func reStart()
    //for game's presenters
    func gameResult(_ result: GameResult)
    //Player
    var player: PlayerModelProtocol {get set}
    func getVariables(_ key: String) -> (Int?, String?)
    func reLoadColorTheme()


}

enum GameResult {
case win
case lose
case noPlay
}

final class MainPresenter: MainPresenterProtocol {
    weak var mainView : MainViewProtocol?
    var modalMainView : MainModalViewProtocol?
    var modalGameView : GameMemoriesViewProtocol?
    let questService: QuestServiceProtocol
    //
    var saveLoadService: SaveLoadServiceProtocol
    //
    var player: PlayerModelProtocol
    private var gamesWinParameters: [String : Int] = [:]
    private var gamesLoseParameters: [String : Int] = [:]

    init(mainView: MainViewProtocol? = nil) {
        self.mainView = mainView
        self.saveLoadService = SaveLoadService()
        self.questService = QuestService()
        self.player = PlayerModel(name: "Player")
        questService.player = player
        questService.mainPresenter = self
        start()
    }

//MARK: private function

    private func start(){
        saveLoadService.loadAutoSave(questService: questService, player: player)
    }


    private func pushMainText(){
        let mainText: String = questService.findMainText(intVariables: player.variables, stringVariables: player.stringVariables)
        mainView?.pushMainText(text: mainText)
    }

   private func pushActions(){
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
        player.changeVariables(parameters)
    }
    private func setStringParameters(_ parameters: [String : String]?){
        guard let parameters else { return }
        player.setStringVariables(parameters)
    }


    private func checkTypeOfGame(action: ActionStruct?) {
        let typeOfGame = questService.checkTypeOfGame(action: action)
        let gamesParameters = questService.checkGamesParameters(action: action, win: ["coins" : 2, "gameLavel": 1], lose: ["coins" : -1, "gameLavel": -2])
        gamesWinParameters = gamesParameters.0 //win
        gamesLoseParameters = gamesParameters.1 //lose
        switch typeOfGame {
        case .nogame:
            break
        case .memories:
            createMemoriesGame()
        }
    }
    
    private func createMemoriesGame(){
        let memoriesGamePresenter: GameMemoriesPresenterProtocol = GameMemoriesPresenter(mainPresenter: self)
        showModalGameView(view: GameMemoriesModalView(gameMemoriesPresenter: memoriesGamePresenter))
    }


    private func showModalGameView(view: GameMemoriesViewProtocol) {
        self.modalGameView = view
        mainView?.showModalView(view: modalGameView)
    }

    //MARK: MainPresenterProtocol function
    func reStart(){
        saveLoadService.deleteAutoSave()
        start()
    }

    func mainViewDidLoad(){
        newState()
    }

    func getVariables(_ key: String) -> (Int?, String?) {
        player.getVariables(key)
    }

    func gameResult(_ result: GameResult) {
        switch result {
        case .lose:
            changeParameters(gamesLoseParameters)
            gamesLoseParameters = [:]
            gamesWinParameters = [:]
            return
        case .win:
            changeParameters(gamesWinParameters)
            gamesLoseParameters = [:]
            gamesWinParameters = [:]
            return
        case .noPlay:
            gamesLoseParameters = [:]
            gamesWinParameters = [:]
        }
    }

    func actionPressed(action: Int){ // обработка нажатия вариантов
        let actionPressed = questService.currentQuest?.questStates[questService.currentQuestState].actions[action]
        let newState = actionPressed?.actionNextState
        let newCurrentQuestName = actionPressed?.actionNextQuest
        changeParameters(actionPressed?.changingParameters)
        setStringParameters(actionPressed?.setStringParameters)
        if newCurrentQuestName == nil {
            guard let newState else { return }
            questService.changeState(newState: newState)
        } else {
            guard let newCurrentQuestName else { return }
            questService.changeQuest(newQuest: newCurrentQuestName, newState: newState ?? 0)
        }
        checkTypeOfGame(action: actionPressed)
    }

    func newState(){ // обработка нового состояния
        let state = questService.currentQuestState
        let stateModal: QuestStateModal? = questService.currentQuest?.questStates[state].questStateModal
        stateModal != nil ? showQuestStateModal(stateModal: stateModal) : ()

        questService.lastBackground != nil ? mainView?.pushBackgroundImage(questService.lastBackground ?? "nil") : ()

        let statusText: String? = questService.currentQuest?.questStates[state].status
        statusText != nil ? mainView?.pushStatusLabel(text: statusText ?? "Error") : ()
        pushMainText()
        pushActions()
        //
        saveLoadService.autoSave(questService: questService, player: player)
    }

    func reLoadColorTheme(){
        mainView?.getColorTheme()
    }



}
