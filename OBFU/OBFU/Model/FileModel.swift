//
//  FileModel.swift
//  OBFU
//
//  Created by Aaron Yen on 2024/3/18.
//

import Foundation


struct FileModel {
    
    var file: File?
    var content: String?
    
    static func createModel(f: File) -> FileModel {
        
        var model = FileModel()
        model.file = f
        model.content = f.read()
        
        return model
    }
}
