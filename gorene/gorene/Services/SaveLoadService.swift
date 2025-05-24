//
//  SaveLoadService.swift
//  gorene
//
//  Created by Illya Blinov on 9.05.25.
//

import Foundation
import OSLog
protocol SaveLoadServiceProtocol {
    func loadAutoSave(questService: QuestServiceProtocol, player: PlayerModelProtocol)
    func deleteAutoSave()
    func autoSave(questService: QuestServiceProtocol, player: PlayerModelProtocol)
    func mainLoad(questService: QuestServiceProtocol, player: PlayerModelProtocol, saveSlot: SaveSlotModel?)
}

final class SaveLoadService: SaveLoadServiceProtocol {

    func loadAutoSave(questService: QuestServiceProtocol, player: PlayerModelProtocol){
        mainLoad(questService: questService, player: player, saveSlot: SaveSlotService.shared.load(slotId: "autosave"))
    }

    func autoSave(questService: QuestServiceProtocol, player: PlayerModelProtocol){
        guard let currentQuest:QuestModel = questService.currentQuest else { 
            Logger.saveLoadService.warning("Save error:  Current Quest is nil ")
            return }
        let playerSave = PlayerSaveModel(name: player.name, variables: player.variables, stringVariables: player.stringVariables)
        let questProgress = QuestProgress(questName: currentQuest.questName, stateId: questService.currentQuestState, lastBackground: questService.lastBackground)
        let saveSlotModel = SaveSlotModel(slotId: "autosave", player: playerSave, quest: questProgress)
        SaveSlotService.shared.save(slot: saveSlotModel)
    }

    func deleteAutoSave(){
        SaveSlotService.shared.delete(slotId: "autosave")
    }


    func mainLoad(questService: QuestServiceProtocol, player: PlayerModelProtocol, saveSlot: SaveSlotModel?) {
        guard let saveSlot else {
            Logger.saveLoadService.warning("SaveLoadService: No save slot found. Restart game.")
            player.reStart()
            questService.changeQuest(newQuest: "ruPrologue", newState: 0)
            return }
        player.loadPlayer(loadName: saveSlot.player.name, loadVariables: saveSlot.player.variables, loadStringVariables: [:])
        questService.lastBackground = saveSlot.quest.lastBackground
        questService.changeQuest(newQuest: saveSlot.quest.questName, newState: saveSlot.quest.stateId)
    }
}
