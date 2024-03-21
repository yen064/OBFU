//
//  ReportMaker.swift
//  OBFU
//
//  Created by Aaron Yen on 2024/3/19.
//

import Foundation

class ReportMaker: CustomStringConvertible {
    var description: String {
        
        return """
        //
        // OBFU Conversion KayValues Mapping Report
        //
        //  (\(Date().fullDate)
        //
        
        """ + modelsToText()
//        + obfuscationData.obfuscationDict.reduce("") {
//            $0 + "\n\($1.key) ===> \($1.value)"
//        }
    }
    private var models: [ReportParagraphModel] = []
    private var basePath: String = "./"
    private var fileName: String = defaultFileName()
    
    init(models: [ReportParagraphModel], basePath: String, fileName: String? = nil) {
        self.models = models
        self.basePath = basePath
        if let fileName_ = fileName {
            self.fileName = fileName_
        }
    }
    func run() {
        let text = description
        let filePath = basePath + (basePath.last == "/" ? "" : "/") + fileName
        write(text, filePath: filePath)
    }
    fileprivate func write(_ text: String, filePath: String) {
        do {
            try text.write(toFile: filePath, atomically: false, encoding: .utf8)
        } catch {
//            Logger.log(.fatal(error: error.localizedDescription))
//            exit(error: true)
            exit()
        }
    }
    
    fileprivate func modelsToText() -> String {
        var txtArray: [String] = []
        models.forEach { model in
            txtArray.append(model.description)
        }
        let text = txtArray.joined(separator: "\n")
        return text
    }
    fileprivate static func defaultFileName() -> String {
        return "OBFUReport\(Date().shortDate).txt"
    }
}
// MARK: - ReportMakerDelegate / ReportParagraphModel
protocol ReportMakerDelegate {
    func toReportParagraphModel() -> ReportParagraphModel
}

struct ReportParagraphModel: CustomStringConvertible {
    private var paragraphTitle: String = ""
    private var strArray: [String] = []
    var description: String {
        return paragraphTitle + "\n" + strArray.joined(separator: "\n ")
    }
}
