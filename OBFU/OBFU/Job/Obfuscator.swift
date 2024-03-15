//
//  Obfuscator.swift
//  OBFU
//
//  Created by aaron on 2024/1/22.
//
import Foundation

final class Obfuscator: NSObject {
    
    var fileHelper: FileHelper
    var suffixMark: String
    
    var fileModels: [FileModel] = []

    init(basePath: String, suffixMark: String) {
        self.fileHelper = FileHelper(basePath: basePath)
        self.suffixMark = suffixMark
        
        super.init()
        self.test()
    }
    func test() {
        testFindFiles()
    }
}

// MARK: - files
extension Obfuscator {
    func testFindFiles() {
        let files = getSourceFiles()
        print(files)
        
        fileModels = []
//        files.forEach { file in
//            let model = FileModel.createModel(f: file)
//            fileModels.append(model)
//        }
        
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
