//
//  DesiralizationService.swift
//  gorene
//
//  Created by Illya Blinov on 20.05.24.
//

import Foundation
import OSLog
struct DesiralizationService{
    static var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    static var encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        return encoder
    }()


    static func questStateDecode(data: Data) -> QuestStateCollection? {
        let questStateCollection =  (try? self.decoder.decode(QuestStateCollection.self, from: data))
        questStateCollection == nil ? Logger.questService.critical("Decode is impossible") : ()
        return questStateCollection
    }

    static func questStateEncode(questStates: QuestStateCollection) -> Data? {
        let data =  try? self.encoder.encode(questStates.self)
        data == nil ? Logger.questService.critical("Encoding is impossible") : ()
        return data
    }


}
