//
//  QuestService.swift
//  gorene
//
//  Created by Illya Blinov on 30.01.24.
//

import Foundation
import OSLog
protocol QuestServiceProtocol: AnyObject{
    var currentQuestState: Int { get }
    var currentQuest: QuestModel? { get }
    var mainPresenter: MainPresenterProtocol? { get set }
    var player: PlayerModelProtocol? { get set }
    func checkTypeOfGame(action: ActionStruct?) -> TypeOfGame
    func checkGamesParameters(action: ActionStruct?, win defaultWinParameters: [String : Int], lose defaultLoseParameters: [String : Int]) -> ([String : Int], [String : Int])
    func elementIsPossible(element: AlternativeElementProtocol) -> Bool
    func findMainText(intVariables: [String: Int], stringVariables: [String: String]) -> String
    func changeState(newState: Int)
    func changeQuest(newQuest: String, newState: Int)
}
protocol QuestServiceEdditProtocol: AnyObject {
    func addQuest(quest: QuestModel)
}

enum TypeOfGame {
    case memories
    case nogame
}

final class QuestService : QuestServiceProtocol {
    var quests: [QuestModel] = []
    var currentQuestState: Int
    var currentQuest: QuestModel?
    weak var mainPresenter: MainPresenterProtocol?
    weak var player: PlayerModelProtocol?

    init(currentQuest: QuestModel? = nil, currentQuestState: Int = 0) {
        self.currentQuestState = currentQuestState
        servicesQuestInitial()
    }

    func playState() {
    }

    func addQuest(quest: QuestModel) {
        let foundQuest: QuestModel? = quests.first(where: {$0.questName == quest.questName})
        guard foundQuest == nil else {
            Logger.questService.error("JSON error: A quest with the same name already exists.")
            return }
        quests.append(quest)
    }

    func checkTypeOfGame(action: ActionStruct?) -> TypeOfGame {
        guard let typeOfGame = action?.typeOfGame else { return .nogame}
        switch typeOfGame {
        case "memories":
            return .memories
        default:
            return .nogame
        }
    }

    func checkGamesParameters(action: ActionStruct?, win defaultWinParameters: [String : Int], lose defaultLoseParameters: [String : Int]) -> ([String : Int], [String : Int]){
        guard let gamesWinParameters = action?.gamesWinParameters else { return (defaultWinParameters, defaultLoseParameters)}
        let gamesLoseParameters = action?.gamesLoseParameters ?? gamesWinParameters.mapValues { -$0 }
        return (gamesWinParameters, gamesLoseParameters)
    }

    func elementIsPossible(element: AlternativeElementProtocol) -> Bool{
        guard let player else { return false}
        var isPossible = true
        //     var altIsPossible = true
        var sumPlayerStats = 0
        var sumNeed = 0
        let requiredParameters = element.requiredParameters ?? [:]
        let exactParameters = element.exactParameters ?? [:]
        let sumOfParameters = element.sumOfParameters ?? [:]

        requiredParameters.forEach() { parameter in
            let playerValue = player.variables[parameter.key]
            playerValue == nil ? Logger.questService.error("JSON error: \(parameter.key) not exists") : ()
            parameter.key.contains("Base") ? Logger.questService.error("JSON error: \(parameter.key) is Base parameter. It be able using only for changingParameters()") : ()
            parameter.value > (playerValue  ?? 0) ? isPossible = false : ()
        }

        exactParameters.forEach() { parameter in
            let playerValue = player.variables[parameter.key]
            playerValue == nil ? Logger.questService.error("JSON error: \(parameter.key) not exists") : ()
            parameter.key.contains("Base") ? Logger.questService.error("JSON error: \(parameter.key) is Base parameter. It be able using only for changingParameters()") : ()
            parameter.value != (playerValue ?? 0) ?  isPossible = false : ()
        }

        sumOfParameters.forEach(){ parameter in
            sumNeed += parameter.value
            player.variables[parameter.key] == nil ? Logger.questService.error("JSON error: \(parameter.key) not exists") : ()
            sumPlayerStats +=  player.variables[parameter.key] ?? 0
        }
        sumNeed > sumPlayerStats ? isPossible = false : ()
        return isPossible
    }

    func findMainText(intVariables: [String: Int], stringVariables: [String: String]) -> String {
        var mainText: String?
        let alternativesMainText = currentQuest?.questStates[currentQuestState].alternativeMainText
        guard let alternativesMainText else {
            mainText = currentQuest?.questStates[currentQuestState].mainText
            return mainText ?? "Main text Error"
        }
        alternativesMainText.forEach(){ alternativeMainText in
            let isAcceptable = elementIsPossible(element: alternativeMainText)
            isAcceptable ? mainText = alternativeMainText.mainText : ()
        }
        mainText == nil ? mainText = currentQuest?.questStates[currentQuestState].mainText : ()

        return  replaceTextWithVariables(in: mainText ?? "Main text Error", intVariables: intVariables, stringVariables: stringVariables)
    }

    private func replaceTextWithVariables(in text: String, intVariables: [String: Int], stringVariables: [String: String]
    ) -> String {
        var result = ""
        var currentIndex = text.startIndex

        while let ampersandIndex = text[currentIndex...].firstIndex(of: "&") {
            result += text[currentIndex..<ampersandIndex]
            let nextIndex = text.index(after: ampersandIndex)

            // Проверка на возможный * сразу после &
            let isStar = nextIndex < text.endIndex && text[nextIndex] == "*"
            let variableStartIndex = isStar ? text.index(after: nextIndex) : nextIndex

            // Поиск конца имени переменной
            let variableEndIndex = text[variableStartIndex...].firstIndex(where: {
                $0.isWhitespace || $0.isPunctuation || $0.isSymbol
            }) ?? text.endIndex

            let rawVariableName = String(text[variableStartIndex..<variableEndIndex])
            let fullVariableName = isStar ? "*" + rawVariableName : rawVariableName

            if let stringValue = stringVariables[fullVariableName] {
                result += stringValue
            } else if let intValue = intVariables[fullVariableName] {
                result += String(intValue)
            } else {
                result += fullVariableName
            }

            currentIndex = variableEndIndex
        }

        result += text[currentIndex...]
        return result
    }

    func changeState(newState: Int){
        guard (currentQuest?.questStates.enumerated().first(where: { $0.offset == newState }) != nil) else { return }
        currentQuestState = newState
        mainPresenter?.newState()
    }

    func changeQuest(newQuest: String, newState: Int = 0){
        let foundQuest: QuestModel? = quests.first(where: {$0.questName == newQuest})
        guard let foundQuest else {
            let currentQuestName: String = currentQuest?.questName ?? "Not found current quest"
            let currentQuestSatateName: String = "\(currentQuestState)"
            Logger.questService.critical("It is impossible to find the quest \(newQuest) for quest \(currentQuestName) and quest state \(currentQuestSatateName)")
            return }
        currentQuest = foundQuest
        if player != nil { foundQuest.start(player: &player!, questService: self)}
        changeState(newState: newState)
    }
}
