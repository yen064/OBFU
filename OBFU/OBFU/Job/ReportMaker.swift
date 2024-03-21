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
        //  (Generated on: \(Date().localizedDescription(date: .short, time: .medium )) )
        //
        """ + "\n" + modelsToText()
    }
    private var models: [ReportParagraphModel] = []
    private var basePath: String = "./"
    fileprivate var _filePath: String? = nil
    var filePath: String {
        if let filePathStr = _filePath {
            return filePathStr
        }
        var folderPath: String {
            let reportFolderName = "OBFUReport"
            let pathStr = basePath + (basePath.last == "/" ? "" : "/") + reportFolderName
            try? FileManager.default.createDirectory(atPath: pathStr, withIntermediateDirectories: true, attributes: nil)
            return pathStr
        }
        _filePath = folderPath + "/" + fileName
        return _filePath!
    }
    private(set) var fileName: String = defaultFileName()
    
    // MARK: -
    init(models: [ReportParagraphModel], basePath: String, fileName: String? = nil) {
        self.models = models
        self.basePath = basePath
        if let fileNameStr = fileName {
            self.fileName = fileNameStr
        }
    }
    func run() {
        let text = description
        write(text)
    }
    
    // MARK: -
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
    public private(set) var paragraphTitle: String = "尚未設定段落 title"
    public private(set) var paragraphContentArray: [String] = []
    var description: String {
        let invisibleStr = "."
        let linebreakStr = "\n"
        var descArray: [String] = []
        descArray.append(invisibleStr)
        descArray.append(invisibleStr)
        descArray.append(paragraphTitle)
        descArray.append(invisibleStr)
        descArray.append(contentsOf: paragraphContentArray)
        return descArray.joined(separator: linebreakStr)
    }
    init() {
        
    }
    init(title: String, contentArray: [String]) {
        self.paragraphTitle = title
        self.paragraphContentArray = contentArray
    }
}
