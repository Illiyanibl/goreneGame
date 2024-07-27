//
//  PlayerModel.swift
//  gorene
//
//  Created by Illya Blinov on 30.01.24.
//

import Foundation
protocol PlayerModelProtocol: AnyObject {
    var parameters: [String : Int] { get }
    func changeParameters(_ parameters: [String : Int])
}
final class PlayerModel: PlayerModelProtocol {
    var name: String = ""
    private (set) var parameters: [String : Int] = [:]
    //var currentMainQuest: QuestModel? { questService.currentQuest }
    //vat currentQuestState: Int {}
    //var currentQuest: [QuestModel] = []
    private var parametersMax:[String : Int] = [:]

    var faith: Int { 10 }
    var oratory: Int { 10 }
    var contemplation: Int { 10 }
    var discipline: Int { 10 }
    var creative: Int { 10 }
    var technology: Int { 10 }
    //
    init(name: String) {
        self.name = name
        self.parameters = parametersInit()
        setParametersLimit()
        updateСalculatedParameters()
    }

    private func updateСalculatedParameters(){
        parameters.updateValue(faith, forKey: "faith")
        parameters.updateValue(oratory, forKey: "oratory")
        parameters.updateValue(contemplation, forKey: "contemplation")
        parameters.updateValue(discipline, forKey: "discipline")
        parameters.updateValue(creative, forKey: "creative")
        parameters.updateValue(technology, forKey: "technology")
    }
    private func setParametersLimit(){
        parametersMax.updateValue(20, forKey: "energy")
    }

    private func lazyParametersInitial(key: String) {
        debugPrint("Lazy init for \(key)")
        switch key {
        case  "faithBase":
            let valueFaithBase = (parameters["contemplation"] ?? 0) / 4 +  (parameters["discipline"] ?? 0) / 2
            parameters.updateValue(valueFaithBase, forKey: "faithBase") // init faithBase
        case "oratoryBase":
            let valueOratoryBase = (parameters["strength"] ?? 0) / 4 +  (parameters["flexibility"] ?? 0) / 2
            parameters.updateValue(valueOratoryBase, forKey: "oratoryBase")  // init oratoryBase
        case "technologyBase":
            parameters.updateValue(10, forKey: "technologyBase")
        case "creativeBase":
            parameters.updateValue(10, forKey: "creativeBase")
        default: break
        }
    }

    private func parametersInit() -> [String : Int]  {
        var parameters : [String : Int] = [:]
        parameters.updateValue(4, forKey: "strength")
        parameters.updateValue(8, forKey: "flexibility")
        parameters.updateValue(8, forKey: "disciplineBase")
        parameters.updateValue(10, forKey: "contemplationBase")
        parameters.updateValue(20, forKey: "energy")
        parameters.updateValue(5, forKey: "coins")
        parameters.updateValue(4, forKey: "relFather")
        parameters.updateValue(4, forKey: "relMother")
        parameters.updateValue(4, forKey: "relSheima")
        parameters.updateValue(4, forKey: "relVecente")
        parameters.updateValue(4, forKey: "relTelec")
        parameters.updateValue(4, forKey: "relAgiat")
        return parameters
    }

    func changeParameters(_ changingParameters: [String : Int]){
        changingParameters.forEach(){ changingParameter in
            // Если передаем 0 происходит инициализация параметра // для всех ленивых параметров необходимо передавать 0 в "changingParameters" перед их использованием
            changingParameter.value == 0 ? lazyParametersInitial(key: changingParameter.key) : ()
            //parameters[changingParameter.key] == nil ? lazyParametersInitial(key: changingParameter.key) : () // страхуем если забыли
            //
            let parameterValue = parameters[changingParameter.key]
            let maxValue: Int = parametersMax[changingParameter.key] ?? 10
            if parameterValue != nil {
                var newValue: Int = (parameterValue ?? 0) + changingParameter.value
                newValue = newValue > maxValue ? maxValue : newValue
                newValue = newValue < -3 ? -3 : newValue
                parameters.updateValue(newValue, forKey: changingParameter.key)
            } else {
                if changingParameter.key.first == "*" {
                    parameters.updateValue(changingParameter.value, forKey: changingParameter.key)
                    debugPrint("Attention: Added  *parametr \(changingParameter.key)")
                } else {
                    debugPrint("JSON error: \(changingParameter.key) is not possible to change a non-existent parameter if it is not $parameters ")
                }
            }
        }
        updateСalculatedParameters()
        debugPrint(parameters)
    }



}
