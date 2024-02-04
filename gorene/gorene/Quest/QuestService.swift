//
//  QuestService.swift
//  gorene
//
//  Created by Illya Blinov on 30.01.24.
//

import Foundation
protocol QuestServiceProtocol: AnyObject{
    var CurrentMainQuest: QuestModel? { get }

}
final class QuestService{
   private var CurrentMainQuest: QuestModel?
    init(CurrentMainQuest: QuestModel? = nil) {
        self.CurrentMainQuest = CurrentMainQuest
    }
}
