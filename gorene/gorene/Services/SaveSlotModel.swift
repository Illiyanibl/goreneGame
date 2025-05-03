//
//  SaveSlotModel.swift
//  gorene
//
//  Created by Illya Blinov & chatgpt 4o on 3.05.25.
//

import Foundation
struct PlayerSaveModel: Codable {
    let name: String
    let variables: [String: Int]
    let stringVariables: [String: String]
}

struct QuestProgress: Codable {
    let questName: String
    let stateId: Int
}

struct SaveSlotModel: Codable {
    let slotId: String
    let player: PlayerSaveModel
    let quest: QuestProgress
}
