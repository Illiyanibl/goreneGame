//
//  QuestModel.swift
//  gorene
//
//  Created by Illya Blinov on 30.01.24.
//

import Foundation
struct QuestModel {
    typealias questCallBack = ((_ player: inout PlayerModelProtocol, _ questService: QuestServiceProtocol)-> Void)
    var questName: String
    var questStates = [QuestState]()
    var questStart: questCallBack?
    mutating func stateAdd(state: QuestState) {
        questStates.append(state)
    }

    func start(player: inout PlayerModelProtocol, questService: QuestServiceProtocol){
        guard let questStart else { return}
        questStart(&player, questService)
    }
}
