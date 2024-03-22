//
//  OBFUManager.swift
//  OBFU
//
//  Created by aaron on 2024/1/24.
//

import Foundation

final class OBFUManager: CustomStringConvertible {
    static var shared: OBFUManager = OBFUManager()
    
    // MARK: -
    public private(set) var workPath: String = Cmd.workPath.VALUE ?? defaultWorkPath()
    public private(set) var reportPath: String = Cmd.reportPath.VALUE ?? defaultReportPath()
    public private(set) var encryptKey: String = Cmd.encryptKey.VALUE ?? defaultEncryptKey()
    public private(set) var tag: String = Cmd.tag.VALUE ?? defaultTag()
    public private(set) var timer: WaitingTimer = WaitingTimer()
    public private(set) var obfuscator: Obfuscator?
    
    var description: String {
        return "OBFU run!"
    }
    
    func run() {
        // MARK: command line print
        printDocumentationAutomatically()
        if !isOkToRun() {
            return
        }
        printSelf()
        
        // MARK: 混淆開始
        obfuscator = Obfuscator(basePath: workPath, tag: tag)
        timer.run()
        backgroundThreadExecution {
            self.obfuscator?.run()
            self.timer.stop()
            self.printAfterObfuscated()
        }
        CFRunLoopRun()
    }
    
    
    deinit {
        
    }
    // MARK: - public
    func isDocumentationPrintOnly() -> Bool {
        if Cmd.isAnyCommandLineArg && !Cmd.help.USE {
            return false // 如果沒有任何參數, 也沒使用 h 參數 就不印出 documentation
        }
        return true
    }
    
    // MARK: - private
    private func backgroundThreadExecution(action: (() -> Void)?) {
        let queue = DispatchQueue.global(qos: .userInitiated)
        queue.async {
            if let runAction = action {
                runAction()
            }
            DispatchQueue.main.async {
                CFRunLoopStop(CFRunLoopGetCurrent())
            }
        }
    }
    private func printAfterObfuscated() {
        if let reportModel = self.obfuscator?.toReportParagraphModel() {
            let reportStr = reportModel.paragraphContentArray.joined(separator: "\n")
            log.write(reportStr)
        }
        log.write(" " + OBFUManager.shared.timer.durationDescription)
    }
    private func printDocumentationAutomatically() {
        if !isDocumentationPrintOnly() {
            return
        }
        Documentation.dump()
    }
    private func printSelf() {
        log.write(self)
    }
    private func isOkToRun() -> Bool {
        if isDocumentationPrintOnly() {
            return false
        }
        return true
    }
    
    // MARK: - default (static)
    static func defaultEncryptKey() -> String {
        return "1.0.0"
    }
    static func defaultWorkPath() -> String {
        return FileManager.default.currentDirectoryPath
    }
    static func defaultReportPath() -> String {
        return FileManager.default.currentDirectoryPath
    }
    static func defaultTag() -> String {
        return "__obfu"
    }
}
