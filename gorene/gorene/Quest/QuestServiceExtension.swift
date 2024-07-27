//
//  QuestServiceExtension.swift
//  gorene
//
//  Created by Illya Blinov on 12.05.24.
//

import Foundation

extension QuestService {

    func getDataFromJSON(jsonName: String) -> Data {
        let url = Bundle.main.url(forResource: jsonName, withExtension: "json")
        guard let url else { return Data() }
        guard let data = try? Data(contentsOf: url) else { return Data() }
        return data
    }

    func addQuestFromData(data: Data) {
        let questCollection = DesiralizationService.questStateDecode(data: data)
        guard let questCollection else { return }
        let quest = QuestModel(questName: questCollection.questName, questStates: questCollection.questStates)
            addQuest(quest: quest)
    }

    func servicesQuestInitial(){
        addQuestFromData(data: getDataFromJSON(jsonName: "ruPrologue"))
        addQuestFromData(data: getDataFromJSON(jsonName: "ruFreeBrothersSCamp1"))
        addQuestFromData(data: getDataFromJSON(jsonName: "ruFreeBrothersSCamp2"))
       // addQuest(quest: QuestModel(questName: "QuestBranching01",
       //                            questStart: { player, service in
       // }))

    }

    func findQuest(questName: String) -> Int?{
        quests.firstIndex(where: {$0.questName == questName})
    }

}
