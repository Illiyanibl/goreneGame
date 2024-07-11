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
    let stateId: Int //id состояния для навигации
    var questStateModal: QuestStateModal? // при смене состояния, например выбрали действие показываем картинку анимировано. Если не надо показывать то не указываем
    var background: String? //имя картинки на фон, фон висит пока не будет передано имя другой картинки
    var mainText: String // основное поле повествования// показывается или когда нет ни одного alternativeMainText либо ни один alternativeMainText не прошел условия
    var alternativeMainText: [AlternativeMainText]? //альтернативный текст в основном поле повествования // выдает первый попавшийся который пройдет по условию
    var status: String? // основная информация
    var actions: [ActionStruct]
}

struct ActionStruct: Decodable, Encodable {
    var actionText: String // текст для каждой кнопки
    var actionDescription: String? // описание действия для каждой кнопки// какие статы потребуюся для данной развилки
    var requiredParameters : [String : Int]? // обязательные параметры успешно если этот же параметр у игрока равен или больше (логическое И)
    var sumOfParameters  : [String : Int]? // сумма выбранных параметров, успешно если сумма этих же параметров у игрока равна либо больше
    var changingParameters: [String : Int]? // изменение параметра игрока по ключу
    var typeOfGame: String? // тип игры, имя игры в наборе игр
    var inverseRelation: Int? // эксперементальная фича!! обратная зависимость кнопки, идея показывать кнопку только если кнопка на которую ссылаемся недоступна
    var actionNextState: Int //новое состояние при нажатие кнопки // следующий экран
    var actionNextQuest: String?
}

struct AlternativeMainText: Decodable, Encodable { //
    var mainText: String // альтернативный основной текст
    var requiredParameters : [String : Int] // обязательные параметры/условия // обязательный парметр
    var priority: Int? // преоритет при прохождение нескольких условий// вероятно НЕ реализованно!
}


struct QuestStateModal: Decodable, Encodable {
    var image: String?
    var duration: Int?
    var description: String?
    var changingParameters: [String : Int]?
}
