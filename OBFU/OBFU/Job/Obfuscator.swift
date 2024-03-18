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
    var scanFileModels: [FileModel] = []
    var obfuData: ObfuData = ObfuData()

    init(basePath: String, tag: String) {
        self.fileHelper = FileHelper(basePath: basePath)
        self.tag = tag
        
        super.init()
    }
    func run() {
        self.scanFiles()
    }
}

// MARK: - 混淆
extension Obfuscator {
    func obfuscating(fileModel: FileModel) {
        
        var isNeedToReplaceNewContent: Bool = false
        
        // 搬原作者的 code, 這段程式已 work, 無需驗證
        var offset = 0
        var content = fileModel.originContent ?? ""
        
        //let regexString = "[a-zA-Z0-9_$]*\(tag)"
        //let regexString = "(?!_)(?:[a-zA-Z0-9_$]*\(tag))(?!(?:\\S)*(?:\\\"){1})"
        let regexString = "(?!_)(?:[a-zA-Z0-9_$]*\(tag))(?!(?:\\S)*(?:\\.h|\\.swift)(?:\\\"){1})"
        for match in content.match(regex: regexString) {
            let range = match.adjustingRanges(offset: offset).range
            let startIndex = content.index(content.startIndex, offsetBy: range.location)
            let endIndex = content.index(startIndex, offsetBy: range.length)
            let originalName = String(content[startIndex..<endIndex])

            let obfuscatedName: String = {
                guard let protected = obfuData.obfuKeyValues[originalName] else {
                    let h = CryptoHelper(key: CryptoKeyGenerator(seed: OBFUManager.shared.encryptKey), type: .hex)
                    let protected = h.encrypt(originalName)?.md5() ?? (originalName + OBFUManager.shared.encryptKey).md5()
                    obfuData.obfuKeyValues[originalName] = protected
                    return protected
                }
                return protected
            }()
            offset += obfuscatedName.count - originalName.count
            content.replaceSubrange(startIndex..<endIndex, with: obfuscatedName)
            
            isNeedToReplaceNewContent = true
        } // end of ... for match in content.match(regex: regexString) {
        
        if isNeedToReplaceNewContent {
            fileModel.newContent = content
            obfuData.obfuFileModels.append(fileModel)
        }

    }
}

// MARK: - 檔案處理
extension Obfuscator {
    fileprivate func scanFiles() {
        
        var files: [File] = []
        files = getSourceFiles() + getSwiftFiles() + getStoryboardsAndXibs()
//        files = getSourceFiles()
        
        files.forEach { file in
            let model = FileModel.createModel(f: file)
            self.obfuscating(fileModel: model)
            scanFileModels.append(model)
        }
        
    }
    
    fileprivate func getStoryboardsAndXibs() -> [File] {
        return fileHelper.getFiles(suffix: ".storyboard") + fileHelper.getFiles(suffix: ".xib")
    }

    fileprivate func getSourceFiles() -> [File] {
        return getSwiftFiles() + fileHelper.getFiles(suffix: ".h") + fileHelper.getFiles(suffix: ".m")
    }

    fileprivate func getSwiftFiles() -> [File] {
        return fileHelper.getFiles(suffix: ".swift")
    }
}
