import Foundation

// Code taken from
// https://medium.com/swift2go/increase-the-security-of-your-ios-app-by-obfuscating-sensitive-strings-swift-c915896711e6

final class Obfuscator {

    private var salt: String = ""

    init(withSalt salt: [AnyObject]) {
        self.salt = salt.description
    }

    func bytesByObfuscatingString(string: String) -> [UInt8] {
        let text = [UInt8](string.utf8)
        let cipher = [UInt8](self.salt.utf8)
        let length = cipher.count
        var encrypted = [UInt8]()
        for txt in text.enumerated() {
            encrypted.append(txt.element ^ cipher[txt.offset % length])
        }
        return encrypted
    }

    func reveal(key: [UInt8]) -> String? {
        let cipher = [UInt8](self.salt.utf8)
        let length = cipher.count
        var decrypted = [UInt8]()
        for key in key.enumerated() {
            decrypted.append(key.element ^ cipher[key.offset % length])
        }
        return String(bytes: decrypted, encoding: .utf8)
    }
}
