//
//  CryptoHelper.swift
//  OBFU
//
//  Created by Aaron Yen on 2024/2/26.
//
import CryptoSwift

class CryptoHelper {
    
    fileprivate static var defaultSeed: String {
        return "1.0.0"
    }
    public private(set) var keyGenerator: CryptoKeyGenerator = CryptoKeyGenerator(seed: CryptoHelper.defaultSeed)
    public private(set) var encryptStringType: CryptoEncryptStringDisplayType = .base64
    
    init(key: CryptoKeyGenerator? = nil, type: CryptoEncryptStringDisplayType = CryptoEncryptStringDisplayType.base64) {
        if let keyGen = key {
            self.keyGenerator = keyGen
        }
        self.encryptStringType = type
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
            
            var encryptStr = ""
            switch encryptStringType {
            case .base64:
                encryptStr = encryptBytes.toBase64()
            case .hex:
                encryptStr = encryptBytes.toHexString()
            }
            
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
            
            var decryptStr = ""
            switch encryptStringType {
            case .base64:
                decryptStr = try source.decryptBase64ToString(cipher: aes)
            case .hex:
                let decryptBytes = try Array(hex: source).decrypt(cipher: aes)
                decryptStr = String(data: Data(decryptBytes), encoding: .utf8) ?? ""
            }
            
            return decryptStr
        } catch let error {
            throw error
        }
    }
}
// MARK: -
extension CryptoHelper {
    enum CryptoEncryptStringDisplayType {
        case base64
        case hex
    }

}
// MARK: -
extension CryptoHelper {

    static func test() -> Void {
        cryptoTest()
        cryptoTest(seed: "2.36.1")
        cryptoTest(seed: "2.37.0")
    }
    
    fileprivate static func cryptoTest(seed: String? = nil) -> Void {
        
        let encryptStrType: CryptoEncryptStringDisplayType = .hex
        var helper: CryptoHelper = CryptoHelper(type: encryptStrType)
        
        if let seedStr = seed {
            let keyGen = CryptoKeyGenerator(seed: seedStr)
            helper = CryptoHelper(key: keyGen, type: encryptStrType)
        }
        
        let rawStr = "loginInfoModel"
        let encryptedStr: String? = helper.encrypt(rawStr)
        var decryptedStr: String?
        
        if let encryptedString = encryptedStr {
            decryptedStr = helper.decrypt(encryptedString)
        }
        
        print("")
        print("加密測試:")
        print("aesKey => \(helper.keyGenerator.aesKeyStr)")
        print("aesIv => \(helper.keyGenerator.aesIvStr)")
        
        print("rawStr = \(rawStr)")
        print("encryptedStr = \(encryptedStr ?? "")")
        print("decryptedStr = \(decryptedStr ?? "")")
        print("")
    }
}

// MARK: -
struct CryptoKeyGenerator {
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
    init(seed: String) {
        self.sourceSeed = seed
    }
}
