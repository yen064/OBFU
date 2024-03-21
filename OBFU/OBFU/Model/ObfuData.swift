//
//  ObfuModel.swift
//  OBFU
//
//  Created by Aaron Yen on 2024/3/18.
//

import Foundation

class ObfuData {
    var obfuFileModels: [ObfuFileModel] = []
    var obfuKeyValues: [String: String] = [:]
}
extension ObfuData: ReportMakerDelegate {
    func toReportParagraphModel() -> ReportParagraphModel {
        let model = ReportParagraphModel()
        return model
    }
}
