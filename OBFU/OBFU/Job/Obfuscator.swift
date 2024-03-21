//
//  Obfuscator.swift
//  OBFU
//
//  Created by aaron on 2024/1/22.
//
import Foundation
import CryptoSwift

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
        self.scanFile()
        self.writeFile()
    }
}

// MARK: - 混淆
extension String {
    fileprivate func obfu() -> String {
        let h = CryptoHelper(key: CryptoKeyGenerator(seed: OBFUManager.shared.encryptKey), type: .hex)
        let obfuStr = h.encrypt(self)?.md5() ?? (self + OBFUManager.shared.encryptKey).md5()
        return "obfu\(obfuStr)"
    }
}
extension Obfuscator {
    func writeFile() {
        // MARK: replace obfu
        obfuData.obfuFileModels.forEach { fileModel in
            if let f = fileModel.file,
               let text = fileModel.newContent {
                f.write(text)
            }
        }
        
        // MARK: Report maker
        var reportModels: [ReportParagraphModel] = []
        reportModels.append(self.toReportParagraphModel())
        reportModels.append(obfuData.toReportParagraphModel())
        obfuData.obfuFileModels.forEach { obfuFileModel in
            reportModels.append(obfuFileModel.toReportParagraphModel())
        }
        let maker = ReportMaker(models: reportModels, basePath: fileHelper.basePath)
        maker.run() // 寫出 report
    }
    func obfuscating(fileModel: FileModel) {
        
        var isNeedToReplaceNewContent: Bool = false
        var keyValues: [String: String] = [:]
        
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
                    let protected = originalName.obfu()
                    obfuData.obfuKeyValues[originalName] = protected // 全部的 key values 儲存
                    keyValues[originalName] = protected // 獨立的 key values 儲存
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
            
            let obfuFileModel = ObfuFileModel(sourceModel: fileModel)
            obfuFileModel.obfuKeyValues = keyValues // 獨立的 key values 儲存
            obfuData.obfuFileModels.append(obfuFileModel)
        }
    }
}
extension Obfuscator: ReportMakerDelegate {
    func toReportParagraphModel() -> ReportParagraphModel {
        let model = ReportParagraphModel()
        return model
    }
}

// MARK: - 檔案處理
extension Obfuscator {
    fileprivate func scanFile() {
        
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
