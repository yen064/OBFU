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
        let title: String = "Obfuscated Key/Value mapping table (Key/Value count: \(obfuKeyValues.keys.count))"
        var contentArray: [String] = []
        obfuKeyValues.keys.forEach { key in
            contentArray.append(" \(key) => \(obfuKeyValues[key] ?? "無資料")")
        }
        let model = ReportParagraphModel(title: title, contentArray: contentArray)
        return model
    }
}
