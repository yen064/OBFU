//
//  CryptoHelper.swift
//  OBFU
//
//  Created by Aaron Yen on 2024/2/26.
//
import CryptoSwift

class CryptoHelper {
    static func test() -> Void {
        cryptoTest(keyGen: KeyGenerator())
        cryptoTest(keyGen: KeyGenerator(seed: "2.36.1"))
    }
    
    fileprivate static func cryptoTest(keyGen: KeyGenerator) -> Void {
        let rawStr = "loginInfoModel"
        let encryptedStr: String? = CryptoHelper(keyGen).encrypt(rawStr)
        var decryptedStr: String?
        
        if let encryptedString = encryptedStr {
            decryptedStr = CryptoHelper(keyGen).decrypt(encryptedString)
        }
        
        print("")
        print("加密測試:")
        print("aesKey => \(keyGen.aesKeyStr)")
        print("aesIv => \(keyGen.aesIvStr)")
        
        print("rawStr = \(rawStr)")
        print("encryptedStr = \(encryptedStr ?? "")")
        print("decryptedStr = \(decryptedStr ?? "")")
        print("")
    }
    
    fileprivate static var defaultSeed: String {
        return "1.0.0"
    }
    fileprivate var keyGenerator: KeyGenerator = KeyGenerator(seed: CryptoHelper.defaultSeed)
    
    init(_ keyGenerator: KeyGenerator? = nil) {
        if let keyGen = keyGenerator {
            self.keyGenerator = keyGen
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
            let aes = try AES(key: keyGenerator.aesKeyStr, iv: keyGenerator.aesIvStr)
            let encryptBytes = try aes.encrypt(Array(source.utf8))
            let encryptStr = encryptBytes.toBase64()
            return encryptStr
        } catch let error {
            throw error
        }
    }
    
    func decrypt(_ source: String) -> String? {
        if let decryptStr = try? decrypt(source: source) {
            return decryptStr
        }
        return nil
    }
    fileprivate func decrypt(source: String) throws -> String {
        do {
            let aes = try AES(key: keyGenerator.aesKeyStr, iv: keyGenerator.aesIvStr)
            let decryptedStr = try source.decryptBase64ToString(cipher: aes)
            return decryptedStr
        } catch let error {
            throw error
        }
    }
}
// MARK: -
struct KeyGenerator {
    private var sourceSeed: String = CryptoHelper.defaultSeed
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
    init(seed: String? = nil) {
        if let seedStr = seed {
            self.sourceSeed = seedStr
        }
    }
}
