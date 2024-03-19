//
//  ObfuFileModel.swift
//  OBFU
//
//  Created by Aaron Yen on 2024/3/19.
//

import Foundation

class ObfuFileModel: FileModel {
    var name: String {
        return self.file?.name ?? "N/A"
    }
    var obfuKeyValues: [String: String] = [:]
    init(sourceModel: FileModel) {
        super.init()
        self.file = sourceModel.file
        self.originContent = sourceModel.originContent ?? ""
        self.newContent = sourceModel.newContent
    }
}
