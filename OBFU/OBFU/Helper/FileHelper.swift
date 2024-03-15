//
//  FileHelper.swift
//  OBFU
//
//  Created by Aaron Yen on 2024/3/15.
//

import Foundation

class FileHelper {
    var basePath: String
    init(basePath: String) {
        self.basePath = basePath
    }

    func getFiles(suffix: String) -> [File] {
        let filePaths = findFiles(rootPath: basePath, suffix: suffix) ?? []
        return filePaths.compactMap{ File(filePath: $0) }
    }

    func findFiles(rootPath: String, suffix: String, ignoreDirs: Bool = true) -> [String]? {
        var result = Array<String>()
        let fileManager = FileManager.default
        if let paths = fileManager.subpaths(atPath: rootPath) {
            let swiftPaths = paths.filter({ return $0.hasSuffix(suffix)})
            for path in swiftPaths {
                var isDir : ObjCBool = false
                let fullPath = (rootPath as NSString).appendingPathComponent(path)
                if fileManager.fileExists(atPath: fullPath, isDirectory: &isDir) {
                    if ignoreDirs == false || (ignoreDirs && isDir.boolValue == false) {
                        result.append(fullPath)
                    }
                }
            }
        }
        return result.count > 0 ? result : nil
    }
}

// MARK: -
class File {
    
    let path: String
    init(filePath: String) {
        self.path = filePath
    }
    var name: String {
        return (path as NSString).lastPathComponent
    }
    
    func read() -> String {
        do {
            return try String(contentsOfFile: path, encoding: .utf8)
        } catch {
//            Logger.log(.fatal(error: error.localizedDescription))
//            exit(error: true)
            exit()
        }
    }

    func write(_ text: String) {
        do {
            try text.write(toFile: path, atomically: false, encoding: .utf8)
        } catch {
//            Logger.log(.fatal(error: error.localizedDescription))
//            exit(error: true)
            exit()
        }
    }
}
extension File: CustomStringConvertible {
    var description: String {
        let p1 = "<\(type(of: self)): \(Unmanaged.passUnretained(self).toOpaque())>"
        let p2 = "name=\(self.name)"
        let p3 = "path=\(self.path)"
        let desc = "\(p1) \(p2) \(p3) "
        return desc
    }
}
extension File: Hashable {
    var hashValue: Int {
        return path.hashValue
    }
    static func ==(lhs: File, rhs: File) -> Bool {
        return lhs.path == rhs.path
    }
}
