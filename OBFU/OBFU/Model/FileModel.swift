//
//  FileModel.swift
//  OBFU
//
//  Created by Aaron Yen on 2024/3/18.
//

import Foundation


struct FileModel {
    
    static func createModel(f: File) -> FileModel {
        let content = f.read()
        let model = FileModel(file: f, originContent: content)
        return model
    }
    
    var file: File
    var originContent: String
    var newContent: String?
    
    mutating func obfuscating(tag: String, obfuData: ObfuData) {
        let (isNeedToReplace, newContentStr) = getNewContentWhenObfuscating(tag: tag, obfuData: obfuData)
        if isNeedToReplace {
            newContent = newContentStr
            obfuData.obfuFileModels.append(self)
        }
    }
    private typealias IsNeedToReplaceNewContent = Bool
    private typealias NewContentString = String?
    private func getNewContentWhenObfuscating(tag: String, obfuData: ObfuData) -> (IsNeedToReplaceNewContent, NewContentString) {
        var isNeedToReplace: IsNeedToReplaceNewContent = false
        var newContentString: NewContentString = nil
        
        var offset = 0
        var content = self.originContent

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
            
            isNeedToReplace = true
            newContentString = content
        }
        return (isNeedToReplace, newContentString)
    }
}
