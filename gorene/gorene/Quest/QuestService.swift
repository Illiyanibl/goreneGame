//
//  QuestService.swift
//  gorene
//
//  Created by Illya Blinov on 30.01.24.
//

import Foundation
protocol QuestServiceProtocol: AnyObject{
    var currentQuestState: Int { get }
    var currentQuest: QuestModel? { get }
    var mainPresenter: MainPresenterProtocol? { get set }

    func changeState(newState: Int)
    func changeQuest(newQuest: String, newState: Int)
}
protocol QuestServiceEdditProtocol: AnyObject {
    func addQuest(quest: QuestModel)
}

final class QuestService : QuestServiceProtocol {
    var quests: [QuestModel] = []
    var currentQuestState: Int
    var currentQuest: QuestModel?
    weak var mainPresenter: MainPresenterProtocol?
    weak var player: PlayerModelProtocol? // !!!Если в MainPresenter нет сильной ссылки и он не будет то удерживать сделать сильной!

    init(currentQuest: QuestModel? = nil, currentQuestState: Int = 0) {
        self.currentQuestState = currentQuestState
        if currentQuest != nil { changeQuest(newQuest: currentQuest?.questName ?? quests[0].questName, newState: currentQuestState)}
        servicesQuestInitial()
    }

    func playState() {
    }

    func addQuest(quest: QuestModel) {
        let foundQuest: QuestModel? = quests.first(where: {$0.questName == quest.questName})
        guard foundQuest == nil else {
            print("A quest with the same name already exists.")
            return }
        quests.append(quest)
        // return quests.lastIndex(where: { _ in return true})
    }

    func changeState(newState: Int){
        guard (currentQuest?.questStates.enumerated().first(where: { $0.offset == newState }) != nil) else { return }
        currentQuestState = newState
        mainPresenter?.newState()
    }
    
    func changeQuest(newQuest: String, newState: Int = 0){
        let foundQuest: QuestModel? = quests.first(where: {$0.questName == newQuest})
        guard let foundQuest else { return }
        currentQuest = foundQuest
        currentQuestState = newState
        if player != nil { foundQuest.start(player: &player!, questService: self)}
    }
}
