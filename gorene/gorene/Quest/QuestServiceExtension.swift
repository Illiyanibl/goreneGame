//
//  QuestServiceExtension.swift
//  gorene
//
//  Created by Illya Blinov on 12.05.24.
//

import Foundation

extension QuestService {

    func getDataForJSON(jsonName: String) -> Data {
        let url = Bundle.main.url(forResource: jsonName, withExtension: "json")
        guard let url else { return Data() }
        guard let data = try? Data(contentsOf: url) else { return Data() }
        return data
    }

    func addQuestFromData(data: Data) {
        let questCollection = DesiralizationService.questStateDecode(data: data)
        if let questCollection {
            let quest = QuestModel(questName: questCollection.questName, questStates: questCollection.questStates)
            addQuest(quest: quest)
        }
    }

    func servicesQuestInitial(){ //Добавляем служебные, пустые квесты. Позволяет выполнить некоторый код в нужный момент времени. Например переключить ветку изходя из ранее сделанного выбора

        addQuestFromData(data: getDataForJSON(jsonName: "ruPrologue"))
        changeQuest(newQuest: "ruPrologue")

        addQuest(quest: QuestModel(questName: "QuestBranching01",
                                   questStart: { player, service in
        }))
        addQuest(quest: QuestModel(questName: "QuestBranching02",
                                   questStart: { player, service in
        }))

    }

    func findQuest(questName: String) -> Int?{
        quests.firstIndex(where: {$0.questName == questName})
    }

}
