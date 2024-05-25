//
//  DesiralizationService.swift
//  gorene
//
//  Created by Illya Blinov on 20.05.24.
//

import Foundation
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
        return questStateCollection
    }

    static func questStateEncode(questStates: QuestStateCollection) -> Data? {
        let data =  try? self.encoder.encode(questStates.self)
        return data
    }


}
