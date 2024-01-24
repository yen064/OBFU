//
//  OBFUManager.swift
//  OBFU
//
//  Created by aaron on 2024/1/24.
//

import Foundation

final class OBFUManager {
    public static var shared: OBFUManager = OBFUManager()
    func run() {
        obfuscator = Obfuscator()
        obfuscator?.run()
    }
    
    // MARK: - private
    public private(set) var obfuscator: Obfuscator?
    private init() { }
}
