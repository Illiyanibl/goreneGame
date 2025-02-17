//
//  PlayerModel.swift
//  gorene
//
//  Created by Illya Blinov on 30.01.24.
//

import Foundation
import OSLog
protocol PlayerModelProtocol: AnyObject {
    var parameters: [String : Int] { get }
    func changeParameters(_ parameters: [String : Int])
}
final class PlayerModel: PlayerModelProtocol {
    var name: String = ""
    private (set) var parameters: [String : Int] = [:]
    private (set) var jsonVariables: [String : Any] = [:]
    //var currentMainQuest: QuestModel? { questService.currentQuest }
    //vat currentQuestState: Int {}
    //var currentQuest: [QuestModel] = []
    private var parametersMax:[String : Int] = [:]
    //все вычесляемые параметры
    var discipline: Int { (parameters["disciplineBase"] ?? 0) + 2 }
    var contemplation: Int { (parameters["contemplationBase"] ?? 0) + 2 }
    var faith: Int { (parameters["faithBase"] ?? 0) + 2 }
    var oratory:  Int { (parameters["oratoryBase"] ?? 0) * 2 }
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
        //обноаление вычесляемых параметров в словаре parameters
        parameters.updateValue(contemplation, forKey: "contemplation")
        parameters.updateValue(discipline, forKey: "discipline")
        parameters.updateValue(oratory, forKey: "oratory")
        parameters.updateValue(faith, forKey: "faith")
        parameters.updateValue(creative, forKey: "creative")
        parameters.updateValue(technology, forKey: "tyranny")
        parameters.updateValue(technology, forKey: "intrigues")
    }
    private func setParametersLimit(){
        parametersMax.updateValue(20, forKey: "energy")
    }

    private func lazyParametersInitial(key: String) {
        Logger.playerService.info("Lazy init for \(key)")
        switch key {
        case "disciplineBase":
            parameters.updateValue(5, forKey: "disciplineBase")
        case "contemplationBase":
            parameters.updateValue(5, forKey: "contemplationBase")
        case "oratoryBase":
            let valueOratoryBase: Int = ((parameters["strength"] ?? 0)  +  (parameters["flexibility"] ?? 0)) * 15 / 10
            parameters.updateValue(valueOratoryBase, forKey: "oratoryBase")  // init oratoryBase
        case  "faithBase":
            let valueFaithBase = (parameters["flexibility"] ?? 0 + (parameters["strength"] ?? 0) / 2 )
            parameters.updateValue(valueFaithBase, forKey: "faithBase") // init faithBase
        case "technologyBase":
            parameters.updateValue(5, forKey: "technologyBase")
        case "creativeBase":
            parameters.updateValue(5, forKey: "creativeBase")
        case "tyrannyBase":
            parameters.updateValue(5, forKey: "tyrannyBase")
        case "intriguesBase":
            parameters.updateValue(5, forKey: "intriguesBase")

        default: break
        }
    }

    private func parametersInit() -> [String : Int]  {
        var parameters : [String : Int] = [:]
        //не вычесляемые
        parameters.updateValue(20, forKey: "energy")
        parameters.updateValue(5, forKey: "coins")
        parameters.updateValue(5, forKey: "strength")
        parameters.updateValue(5, forKey: "flexibility")
        // базовые компоненты вычесляемых переменных инициализируются лениво
        /*
        parameters.updateValue(5, forKey: "disciplineBase")
        parameters.updateValue(5, forKey: "contemplationBase")
        parameters.updateValue(5, forKey: "oratoryBase")
        parameters.updateValue(5, forKey: "faithBase")
        parameters.updateValue(5, forKey: "creativeBase")
        parameters.updateValue(5, forKey: "technologyBase")
        parameters.updateValue(5, forKey: "tyrannyBase")
        parameters.updateValue(5, forKey: "intriguesBase")
         */
        // отношения
        parameters.updateValue(4, forKey: "relFather")
        parameters.updateValue(4, forKey: "relMother")
        parameters.updateValue(4, forKey: "relSheima")
        parameters.updateValue(4, forKey: "relVecente")
        parameters.updateValue(4, forKey: "relTelec")
        parameters.updateValue(4, forKey: "relAgiat")
        parameters.updateValue(4, forKey: "relFinito")
        parameters.updateValue(4, forKey: "relDion")
        parameters.updateValue(4, forKey: "relGeom")
        parameters.updateValue(4, forKey: "relTelec")
        parameters.updateValue(4, forKey: "relNemira")
        parameters.updateValue(4, forKey: "relNabis")
        parameters.updateValue(4, forKey: "relPriam")
        parameters.updateValue(4, forKey: "relDilof")
        parameters.updateValue(4, forKey: "relNeidg")
        return parameters
    }

    func changeParameters(_ changingParameters: [String : Int]){
        changingParameters.forEach(){ changingParameter in
            parameters[changingParameter.key] == nil ? lazyParametersInitial(key: changingParameter.key) : ()
            // ленивая инициализация
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
                    Logger.playerService.info("Attention: Added  *parametr \(changingParameter.key)")
                } else {
                    Logger.playerService.error("JSON error: \(changingParameter.key) is not possible to change a non-existent parameter if it is not *parameters ")
                }
            }
        }
        updateСalculatedParameters()
        debugPrint(parameters)
    }



}
