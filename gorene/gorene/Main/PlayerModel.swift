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
    //    var currentMainQuest: QuestModel? { questService.currentQuest }
    //  var currentQuest: [QuestModel] = []
    private var parametersMax:[String : Int] = [:]

    var faith: Int { (parameters["faithBase"] ?? 0) + (parameters["contemplation"] ?? 0) / 4 +  (parameters["discipline"] ?? 0) / 2}
    var oratory: Int {(parameters["oratoryBase"] ?? 0) + (parameters["strength"] ?? 0) / 4 +  (parameters["flexibility"] ?? 0) / 2}
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
    }
    private func setParametersLimit(){
        parametersMax.updateValue(20, forKey: "energy")
    }

    private func parametersInit() -> [String : Int]  {
        var parameters : [String : Int] = [:]
        parameters.updateValue(4, forKey: "strength")
        parameters.updateValue(8, forKey: "flexibility")
        parameters.updateValue(8, forKey: "discipline")
        parameters.updateValue(8, forKey: "contemplation")
        parameters.updateValue(20, forKey: "energy")
        parameters.updateValue(5, forKey: "coins")
        parameters.updateValue(5, forKey: "technologyBase")
        parameters.updateValue(6, forKey: "oratoryBase")
        parameters.updateValue(2, forKey: "faithBase")
        parameters.updateValue(1, forKey: "authorityBase")
        parameters.updateValue(3, forKey: "relFather")
        parameters.updateValue(0, forKey: "relMother")
        return parameters
    }

    func changeParameters(_ changingParameters: [String : Int]){
        changingParameters.forEach(){ changingParameter in
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
