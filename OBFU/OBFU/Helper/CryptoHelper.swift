//
//  CryptoHelper.swift
//  OBFU
//
//  Created by Aaron Yen on 2024/2/26.
//
import CryptoSwift

class CryptoHelper {
    static func test() -> Void {
        let kg = KeyGenerator(seed: "2.36.1")
        print("aesKey => \(kg.aesKeyStr)")
        print("aesIv => \(kg.aesIvStr)")
        
        let a: String? = CryptoHelper(kg).encrypt("loginInfoModel")
        if let aStr = a {
            print(aStr)
        }
        
    }
    fileprivate static var defaultSeed: String {
        return "1.0.0"
    }
    fileprivate var keyGenerator: KeyGenerator = KeyGenerator(seed: CryptoHelper.defaultSeed)
    init(_ keyGenerator: KeyGenerator? = nil) {
        if let kg = keyGenerator {
            self.keyGenerator = kg
        }
    }
    func encrypt(_ source: String) -> String? {
        if let encryptStr = try? encrypt(source: source) {
            return encryptStr
        }
        return nil
    }
    fileprivate func encrypt(source: String) throws -> String {
        do {
            if let aesKeyBytes = keyGenerator.aesKeyStr.data(using: .utf8) {
                print("aesKeyBytes.count = \(aesKeyBytes.count)")
                
            }
            if let aesIvBytes = keyGenerator.aesIvStr.data(using: .utf8) {
                print("aesIvBytes.count = \(aesIvBytes.count)")
                
            }
            let aes = try AES(key: keyGenerator.aesKeyStr, iv: keyGenerator.aesIvStr)
            let encryptBytes = try aes.encrypt(Array(source.utf8))
            let encryptStr = encryptBytes.toBase64()
            return encryptStr
        } catch let error {
            throw error
        }
    }
//    static fileprivate func AESKeyGenerator() -> String {
//
//    }
}

struct KeyGenerator {
    private var sourceSeed: String = "N/A"
    var aesKeyStr: String {
        let charArr: [String] = self.sourceSeed.md5().map { String($0) }
        var newCharArr: [String] = []
        for (index, elem) in charArr.enumerated() {
            if (index % 2 == 0) {
                newCharArr.append(elem)
            }
        }
        let keyStr = newCharArr.joined()
        return keyStr
    }
    var aesIvStr: String {
        let charArr: [String] = self.sourceSeed.md5().map { String($0) }
        var newCharArr: [String] = []
        for (index, elem) in charArr.enumerated() {
            if (index % 2 != 0) {
                newCharArr.append(elem)
            }
        }
        let ivStr = newCharArr.joined()
        return ivStr
    }
    init(seed: String) {
        self.sourceSeed = seed
    }
}
