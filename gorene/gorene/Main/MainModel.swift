//
//  PlayerModel.swift
//  gorene
//
//  Created by Illya Blinov on 30.01.24.
//

import Foundation
protocol PlayerModelProtocol: AnyObject {
    var stats: [String : Int] { get }
    func shangeStats(_ stats: [String : Int])
}
final class PlayerModel: PlayerModelProtocol {
    weak var mainView: MainViewProtocol?
    var name: String = ""
    private (set) var stats: [String : Int] = [:]
//    var currentMainQuest: QuestModel? { questService.currentQuest }
  //  var currentQuest: [QuestModel] = []

    init(questService: QuestServiceProtocol, name: String) {
        self.name = name
        self.stats = statsInit()
    }

    private func statsInit() -> [String : Int]  {
        var stats : [String : Int] = [:]
        stats.updateValue(1, forKey: "strong")
        stats.updateValue(1, forKey: "intelect")
        stats.updateValue(1, forKey: "authority")
        stats.updateValue(8, forKey: "discipline")
        stats.updateValue(10, forKey: "energy")
        stats.updateValue(1, forKey: "oratory")
        stats.updateValue(1, forKey: "flexibility")
        return stats
    }

    func shangeStats(_ stats: [String : Int]){

    }



}
