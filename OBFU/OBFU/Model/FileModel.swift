//
//  FileModel.swift
//  OBFU
//
//  Created by Aaron Yen on 2024/3/18.
//

import Foundation

class FileModel {
    
    static func createModel(f: File) -> FileModel {
        let content = f.read()
        let model = FileModel()
        model.file = f
        model.originContent = content
        return model
    }
    
    var file: File?
    var originContent: String?
    var newContent: String?
}
