//
//  QuestServiceExtension.swift
//  gorene
//
//  Created by Illya Blinov on 12.05.24.
//

import Foundation
import OSLog
extension QuestService {

    func getDataFromJSON(jsonName: String) -> Data {
        let url = Bundle.main.url(forResource: jsonName, withExtension: "json")
        guard let url else {
            Logger.questService.critical("Couldn't find the file \(jsonName).json")
            return Data() }
        guard let data = try? Data(contentsOf: url) else { return Data() }
        return data
    }

    func addQuestFromData(data: Data) {
        let questCollection = DesiralizationService.questStateDecode(data: data)
        guard let questCollection else {
            Logger.questService.critical("Data cannot be retrieved")
            return }
        let quest = QuestModel(questName: questCollection.questName, questStates: questCollection.questStates)
            addQuest(quest: quest)
    }

    func servicesQuestInitial(){
        addQuestFromData(data: getDataFromJSON(jsonName: "ruPrologue"))
       // addQuestFromData(data: getDataFromJSON(jsonName: "cirticalErrorTest"))
        addQuestFromData(data: getDataFromJSON(jsonName: "ruFreeBrothersSCamp1"))
        addQuestFromData(data: getDataFromJSON(jsonName: "ruFreeBrothersSCamp2"))
        addQuestFromData(data: getDataFromJSON(jsonName: "ruMinesA"))
        addQuestFromData(data: getDataFromJSON(jsonName: "ruMinesS"))
        addQuestFromData(data: getDataFromJSON(jsonName: "ruMinesSA"))

       // addQuest(quest: QuestModel(questName: "QuestBranching01",
       //                            questStart: { player, service in
       // }))

    }

    func findQuest(questName: String) -> Int?{
        quests.firstIndex(where: {$0.questName == questName})
    }

}
