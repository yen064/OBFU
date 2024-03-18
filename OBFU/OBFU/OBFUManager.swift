//
//  OBFUManager.swift
//  OBFU
//
//  Created by aaron on 2024/1/24.
//

import Foundation


final class OBFUManager: NSObject {
    static var shared: OBFUManager = OBFUManager()
    
    // MARK: -
    public private(set) var workPath: String = Cmd.workPath.VALUE ?? defaultWorkPath()
    public private(set) var encryptKey: String = Cmd.encryptKey.VALUE ?? defaultEncryptKey()
    public private(set) var suffixMark: String = Cmd.suffixMark.VALUE ?? defaultSuffixMark()
    public private(set) var timer: WaitingTimer = WaitingTimer()
    public private(set) var obfuscator: Obfuscator?
    
    // MARK: - override
    override var description: String {
        var strArray: [String] = [super.description]
        strArray.append(String(format: "> workPath: %@", workPath))
        strArray.append(String(format: "> encryptKey: %@", encryptKey))
        strArray.append(String(format: "> suffixMark: %@", suffixMark))
        strArray.append(String(format: "> printSelf: %@", Cmd.printSelf.USE ? "YES" : "NO"))
        strArray.append("")
        return strArray.joined(separator: "\n")
    }
    override init() {
        super.init()
        printDocumentationAutomatically()
        printSelf()
    }
    
    func run() {
        obfuscator = Obfuscator(basePath: self.workPath, suffixMark: self.suffixMark)
        timer.run()
        backgroundThreadExecution {
            
            CryptoHelper.test()
            self.obfuscator?.test()
            self.timer.stop()
            
            let fileCount = self.obfuscator?.fileModels.count ?? 0
            print("scan file: \(fileCount) files.")
        }
        CFRunLoopRun()
    }
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
    
    deinit {
        
    }
    
    // MARK: - private
    private func printDocumentationAutomatically() {
        if Cmd.isAnyCommandLineArg && !Cmd.help.USE {
            return
        }
        // TODO:
        //  印些什麼
        Documentation.dump()
    }
    private func printSelf() {
        if !Cmd.printSelf.USE {
            return
        }
        log.write(self)
    }
    
    // MARK: - default (static)
    static func defaultEncryptKey() -> String {
        return "1.0.0"
    }
    static func defaultWorkPath() -> String {
        return FileManager.default.currentDirectoryPath
    }
    static func defaultSuffixMark() -> String {
        return "__obfu"
    }
//    static func defaultMode() -> ObfuscateMode {
////        return .reflect
//        return .file
//    }
//    static func getObfuscateMode() -> ObfuscateMode {
//        guard
//            let VALUE = Cmd.mode.VALUE,
//            let MODE = ObfuscateMode(rawValue: VALUE)
//        else {
//            return defaultMode()
//        }
//        return MODE
//    }
    
}


//enum ObfuscateMode: String {
//    case reflect = "reflect"
//    case file = "file"
//    static var defaultRawValue: String {
//        return ObfuscateMode.reflect.rawValue
//    }
//}
