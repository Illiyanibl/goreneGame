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
        guard let questCollection else { Logger.questService.critical("Data cannot be retrieved")
            return }
        let quest = QuestModel(questName: questCollection.questName, questStates: questCollection.questStates)
            addQuest(quest: quest)

    }

    func servicesQuestInitial(){
        QuestConfiguration.shared.getQuestNameList().forEach(){ questName in addQuestFromData(data: getDataFromJSON(jsonName: questName))}
    }

    func findQuest(questName: String) -> Int?{
        quests.firstIndex(where: {$0.questName == questName})
    }

}
