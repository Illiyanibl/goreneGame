//
//  QuestState.swift
//  gorene
//
//  Created by Illya Blinov on 26.04.24.
//
struct QuestStateCollection: Decodable, Encodable {
    let questName: String
    let questStates: [QuestState]
}
struct QuestState: Decodable, Encodable {
    let stateId: Int //id состояния совпадает с индексом в массиве состояний для визуальной навигации и контроля целостности файла
    var showImage: QuestStateShowImage? // при смене состояния, например выбрали действие показываем картинку анимировано. Если не надо показывать - nil
    var background: String?
    var mainText: String // текст на основном экране // основное поле повествования
    var status: String? // основная информация
    var actions: [ActionStruct]
}

struct ActionStruct: Decodable, Encodable {
    var actionText: String // текст для каждой кнопки
    var actionDesctiption: String? // описание действия для каждой кнопки// какие статы потребуюся для данной развилки
    var requiredParameters : [String : Int]? // обязательные параметры успешно если этот же параметр у игрока равен или больше (логическое И)
    var sumOfParameters  : [String : Int]? // сумма выбранных параметров, успешно если сумма этих же параметров у игрока равна либо больше
    var changingParameters: [String : Int]? // изменение параметра игрока по ключу
    var isGame: Bool?
    var actionNextState: Int // пока Int, новое состояние при нажатие кнопки // следующий экран
    var actionNextQuest: String?
}

struct QuestStateShowImage: Decodable, Encodable {
    var image: String
    var duration: Int?
    var description: String?
    var changingParameters: [String : Int]?
}
