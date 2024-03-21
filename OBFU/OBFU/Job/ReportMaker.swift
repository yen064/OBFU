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
        // OBFU Conversion Mapping Report File
        //
        //  (Generated on: \(Date().fullDateTime))
        //
        
        """ + modelsToText()
//        + obfuscationData.obfuscationDict.reduce("") {
//            $0 + "\n\($1.key) ===> \($1.value)"
//        }
    }
    private var models: [ReportParagraphModel] = []
    private var basePath: String = "./"
    private(set) var fileName: String = defaultFileName()
    var filePath: String {
        basePath + (basePath.last == "/" ? "" : "/") + fileName
    }
    
    init(models: [ReportParagraphModel], basePath: String, fileName: String? = nil) {
        self.models = models
        self.basePath = basePath
        if let fileName_ = fileName {
            self.fileName = fileName_
        }
    }
    func run() {
        let text = description
        write(text)
    }
    fileprivate func write(_ text: String) {
        do {
            try text.write(toFile: filePath, atomically: false, encoding: .utf8)
        } catch let err {
            log.writeError(err)
            exit(error: err)
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
        let format = "yyyy MM dd"
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let dateStr = dateFormatter.string(from: Date())
        return "OBFUReport \(dateStr).txt"
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
