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
    
    mutating func scanTag(_ tag: String) {
        let (isNeedToReplace, newContentStr) = getNewContentWithScanTag(tag)
        if isNeedToReplace {
            newContent = newContentStr
        }
    }
    private typealias IsNeedToReplaceNewContent = Bool
    private typealias NewContentString = String?
    private func getNewContentWithScanTag(_ tag: String) -> (IsNeedToReplaceNewContent, NewContentString) {
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
            
            
//            //find ignore
//            let findIgnore = self.classesOrMethodsToIgnore.first { (s) -> Bool in
//                return originalName.matchToBoolean(s)
//                //return s == name
//            }
//            if let ignore = findIgnore {
//                //is ignore
//            } else {
//                //not ignore
//                let obfuscatedName: String = {
//                    guard let protected = obfsData.obfuscationDict[originalName] else {
//                        let protected = String.random(length: protectedClassNameSize,
//                                                      excluding: obfsData.allObfuscatedNames)
//                        obfsData.obfuscationDict[originalName] = protected
//                        return protected
//                    }
//                    return protected
//                }()
//                Logger.log(.protectedReference(originalName: originalName,
//                                               protectedName: obfuscatedName))
//                offset += obfuscatedName.count - originalName.count
//                content.replaceSubrange(startIndex..<endIndex, with: obfuscatedName)
//            }
//            //end of ... if let ignore = findIgnore {
        }
        
        return (false, nil)
        
    }
}
