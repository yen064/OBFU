//
//  Obfuscator.swift
//  OBFU
//
//  Created by aaron on 2024/1/22.
//
import Foundation

final class Obfuscator: NSObject {
    
    var fileHelper: FileHelper
    var tag: String
    var fileModels: [FileModel] = []
    var obfuData: ObfuData = ObfuData()

    init(basePath: String, tag: String) {
        self.fileHelper = FileHelper(basePath: basePath)
        self.tag = tag
        
        super.init()
    }
    func test() {
        
        self.testFindFiles()
    }
}

// MARK: - files
extension Obfuscator {
    func testFindFiles() {
        
        var files: [File] = []
//        files = getSourceFiles() + getSwiftFiles() + getStoryboardsAndXibs()
        files = getSourceFiles()
        
        files.forEach { file in
            var model = FileModel.createModel(f: file)
            fileModels.append(model)
            
            model.obfuscating(tag: OBFUManager.shared.tag,
                              obfuData: obfuData)
        }
        
    }
    
    func getStoryboardsAndXibs() -> [File] {
        return fileHelper.getFiles(suffix: ".storyboard") + fileHelper.getFiles(suffix: ".xib")
    }

    func getSourceFiles() -> [File] {
        return getSwiftFiles() + fileHelper.getFiles(suffix: ".h") + fileHelper.getFiles(suffix: ".m")
    }

    func getSwiftFiles() -> [File] {
        return fileHelper.getFiles(suffix: ".swift")
    }
}
