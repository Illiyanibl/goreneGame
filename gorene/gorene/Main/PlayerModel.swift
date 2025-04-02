//
//  PlayerModel.swift
//  gorene
//
//  Created by Illya Blinov on 30.01.24.
//

import Foundation
import OSLog
protocol PlayerModelProtocol: AnyObject {
    var variables: [String : Int] { get }
    var jsonVariables: [String : String] { get }
    func changeVariables(_ parameters: [String : Int])
    func getVariables(_ key: String) -> (Int?, String?)
}
final class PlayerModel: PlayerModelProtocol {
    var name: String = ""
    private (set) var variables: [String : Int] = [:]
    private (set) var jsonVariables: [String : String] = [:]

    //var currentMainQuest: QuestModel? { questService.currentQuest }
    //vat currentQuestState: Int {}
    //var currentQuest: [QuestModel] = []
    private var parametersMax:[String : Int] = [:]
    //все вычесляемые параметры
    var discipline: Int { (variables["disciplineBase"] ?? 0) + 2 }
    var contemplation: Int { (variables["contemplationBase"] ?? 0) + 2 }
    var faith: Int { (variables["faithBase"] ?? 0) + 2 }
    var oratory:  Int { (variables["oratoryBase"] ?? 0) * 2 }
    var creative: Int { 10 }
    var technology: Int { 10 }

    //
    init(name: String) {
        self.name = name
        self.variables = parametersInit()
        setParametersLimit()
        updateСalculatedParameters()
    }

    private func updateСalculatedParameters(){
        //обноаление вычесляемых параметров в словаре parameters
        variables.updateValue(contemplation, forKey: "contemplation")
        variables.updateValue(discipline, forKey: "discipline")
        variables.updateValue(oratory, forKey: "oratory")
        variables.updateValue(faith, forKey: "faith")
        variables.updateValue(creative, forKey: "creative")
        variables.updateValue(technology, forKey: "tyranny")
        variables.updateValue(technology, forKey: "intrigues")
    }
    private func setParametersLimit(){
        parametersMax.updateValue(20, forKey: "energy")
        parametersMax.updateValue(12, forKey: "gameLavel")
        parametersMax.updateValue(99, forKey: "coins")

    }

    private func lazyParametersInitial(key: String) {
        Logger.playerService.info("Lazy init for \(key)")
        switch key {
        case "disciplineBase":
            variables.updateValue(5, forKey: "disciplineBase")
        case "contemplationBase":
            variables.updateValue(5, forKey: "contemplationBase")
        case "oratoryBase":
            let valueOratoryBase: Int = ((variables["strength"] ?? 0)  +  (variables["flexibility"] ?? 0)) * 15 / 10
            variables.updateValue(valueOratoryBase, forKey: "oratoryBase")  // init oratoryBase
        case  "faithBase":
            let valueFaithBase = (variables["flexibility"] ?? 0 + (variables["strength"] ?? 0) / 2 )
            variables.updateValue(valueFaithBase, forKey: "faithBase") // init faithBase
        case "technologyBase":
            variables.updateValue(5, forKey: "technologyBase")
        case "creativeBase":
            variables.updateValue(5, forKey: "creativeBase")
        case "tyrannyBase":
            variables.updateValue(5, forKey: "tyrannyBase")
        case "intriguesBase":
            variables.updateValue(5, forKey: "intriguesBase")

        default: break
        }
    }

    private func parametersInit() -> [String : Int]  {
        var parameters : [String : Int] = [:]
        //не вычесляемые
        parameters.updateValue(4, forKey: "gameLavel")
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

    func changeVariables(_ changingParameters: [String : Int]){
        changingParameters.forEach(){ changingParameter in
            variables[changingParameter.key] == nil ? lazyParametersInitial(key: changingParameter.key) : ()
            // ленивая инициализация
            let parameterValue = variables[changingParameter.key]
            let maxValue: Int = parametersMax[changingParameter.key] ?? 10
            if parameterValue != nil {
                var newValue: Int = (parameterValue ?? 0) + changingParameter.value
                newValue = newValue > maxValue ? maxValue : newValue
                newValue = newValue < -3 ? -3 : newValue
                variables.updateValue(newValue, forKey: changingParameter.key)
            } else {
                if changingParameter.key.first == "*" {
                    variables.updateValue(changingParameter.value, forKey: changingParameter.key)
                    Logger.playerService.info("Attention: Added  *parametr \(changingParameter.key)")
                } else {
                    Logger.playerService.error("JSON error: \(changingParameter.key) is not possible to change a non-existent parameter if it is not *parameters ")
                }
            }
        }
        updateСalculatedParameters()
        debugPrint(variables)
    }

    func getVariables(_ key: String) -> (Int?, String?) {
        let foundParametersInt: Int? = variables[key]
        let foundParametersString: String? = jsonVariables[key]
        return (foundParametersInt, foundParametersString)
    }

}
