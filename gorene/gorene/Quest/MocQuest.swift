//
//  MocQuest.swift
//  gorene
//
//  Created by Illya Blinov on 29.04.24.
//

import Foundation
extension QuestModel {
    func getQuest() -> QuestModel {
        var quest = QuestModel(questName: "ruTest01")
        let questStates = [
            QuestState(
                stateId: 0,
                background: "backgraund1",
                mainText: "Начало квеста!\nКвест с двумя путями\nКакой путь я выберу...",
                status: "Какой то статус" ,
                actions: [
                    ActionStruct(
                        actionText: "Основной путь",
                        requiredParameters: ["Дисциплина" : 1, "Красноречие" : 2],
                        actionNextState: 1),
                    ActionStruct(
                        actionText: "Альтернативный путь",
                        actionNextState: 2),
                    ActionStruct(
                        actionText: "Просто завершить",
                        actionDesctiption: "Это самый короткий путь тестового квеста. Это тестовый квест!",
                        actionNextState: 3)

                ]),
            QuestState(
                stateId: 1,
                background: "backgraundState1",
                mainText: "Основной путь " ,
                actions: [
                    ActionStruct(
                        actionText: "Завершить квест!",
                        actionDesctiption: "Квест просто завершится. Это тестовый квест!",
                        actionNextState: 3)
                ]),
            QuestState(
                stateId: 2,
                mainText: "Альтернативный путь",
                actions: [
                    ActionStruct(
                        actionText: "Завершить альтренативно! Слишком много букв",
                        actionDesctiption: "Квест завершится альтернативно. Не удачный пример кнопки с слишком длинным текстом. Это тестовый квест!",
                        actionNextState: 3)
                ]),
            QuestState(
                stateId: 3,
                mainText: "Конец квеста",
                status: "Квест успешно выполнен!",
                actions: [
                    ActionStruct(
                        actionText: "Начать сначала",
                        actionDesctiption: "Это бесконечный квест. Это тестовый и бесконечный квест!",
                        actionNextState: 0)
                ])
        ]
        quest.questStates = questStates
        return quest
    }

}
