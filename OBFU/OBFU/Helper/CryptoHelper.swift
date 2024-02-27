//
//  CryptoHelper.swift
//  OBFU
//
//  Created by Aaron Yen on 2024/2/26.
//
import CryptoSwift

class CryptoHelper {
    static
    func test() -> Void {
        _ = KeyGenerator(seed: "2.36.1")
    }
//    static fileprivate func AESKeyGenerator() -> String {
//
//    }
}

fileprivate struct KeyGenerator {
    let prefix: String = "obfuscator"
    let suffix: String = "obfuscator"
    init(seed: String) {
        let str96 = String(format: "%@%@%@", prefix.md5(), seed.md5(), suffix.md5())
        print(str96)
        print(seed)
    }
}
