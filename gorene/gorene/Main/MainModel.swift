//
//  PlayerModel.swift
//  gorene
//
//  Created by Illya Blinov on 30.01.24.
//

import Foundation
protocol PlayerModelProtocol: AnyObject {

}
final class PlayerModel: PlayerModelProtocol {

    weak var mainView: MainViewProtocol?
    let questService: QuestServiceProtocol
    var name: String = ""
    var stats: [String : Int] = [:]
    var currentMainQuest: QuestModel? { questService.currentQuest }
    var currentQuest: [QuestModel] = []

    init(questService: QuestServiceProtocol, name: String) {
        self.questService = questService
        self.name = name
        self.stats = statsInit()
    }

    private func statsInit() -> [String : Int]  {
        var stats : [String : Int] = [:]
        stats.updateValue(1, forKey: "Strong")
        stats.updateValue(1, forKey: "Intelect")
        stats.updateValue(1, forKey: "Authority")
        return stats
    }



}
