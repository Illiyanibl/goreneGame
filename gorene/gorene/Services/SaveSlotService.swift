//
//  SaveSlotService.swift
//  gorene
//
//  Created by Illya Blinov on 3.05.25.
//

import Foundation
import KeychainAccess

protocol SaveSlotServiceProtocol {
    func save(slot: SaveSlotModel)
    func load(slotId: String) -> SaveSlotModel?
    func delete(slotId: String)
    func allSlotIds() -> [String]
}

final class SaveSlotService: SaveSlotServiceProtocol  {
    static let shared: SaveSlotServiceProtocol = SaveSlotService()
    private let keychain = Keychain(service: "ecorp.red.quest.saves")
    private init() {}

    func save(slot: SaveSlotModel) {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(slot) {
            keychain[data: slot.slotId] = data
        }
    }
    func load(slotId: String) -> SaveSlotModel? {
        guard let data = keychain[data: slotId],
              let slot = try? JSONDecoder().decode(SaveSlotModel.self, from: data) else {
            return nil
        }
        return slot
    }
    func delete(slotId: String) {
        try? keychain.remove(slotId)
    }

    func allSlotIds() -> [String] {
        return keychain.allKeys()
    }
}


