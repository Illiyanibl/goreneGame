//
//  QuestConfiguration.swift
//  gorene
//
//  Created by Illya Blinov on 1.06.25.
//

import Foundation
import OSLog
protocol QuestConfigurationProtocol {
    func getQuestNameList() -> [String]

}
enum BuildVersion {
    case main
    case test
}

final class QuestConfiguration: QuestConfigurationProtocol {
    static let shared: QuestConfigurationProtocol = QuestConfiguration()
    private let builldVersion: BuildVersion = .main

    private init() {}

    func getQuestNameList() -> [String] {
        var nameList: [String] = []
        switch builldVersion {
        case .main:
            nameList = findJsonFiles()
        case .test:
            break
        }
        return nameList
    }

    func getStartQuestName() -> String {
        var questName: String = ""
        switch builldVersion {
        case .main:
            questName = "ruPrologue"
        case .test:
            break
        }
        return questName
    }

    func findJsonFiles() -> [String] {
        if let resourcePath = Bundle.main.resourcePath {
            let fileManager = FileManager.default
            let desiredPrefixes = ["ru", "en", "fr", "jp", "bg"]
            do {
                let allFiles = try fileManager.subpathsOfDirectory(atPath: resourcePath)
                let jsonFiles = allFiles.compactMap { file -> String? in
                    guard file.hasSuffix(".json") else { return nil }
                    let filename = (file as NSString).lastPathComponent
                    let nameWithoutExtension = (filename as NSString).deletingPathExtension
                    for prefix in desiredPrefixes {
                        if nameWithoutExtension.hasPrefix(prefix) {
                            return nameWithoutExtension
                        }
                    }
                    return nil
                }
                Logger.questService.info("\(jsonFiles.count) JSON files were found")
                return jsonFiles
            } catch {
                Logger.questService.info("Not possible to read the Bundle: \(error)")
            }
        }
        return []
    }


}
