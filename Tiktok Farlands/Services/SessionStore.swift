import Foundation
import Security

protocol SessionStoring {
    func load() -> AppSession?
    func save(_ session: AppSession)
    func clear()
}

final class SessionStore: SessionStoring {
    private let tokenKey = "tiktok_farlands_access_token_keychain"
    private let userIDKey = "tiktok_farlands_user_id"
    private let expiresAtKey = "tiktok_farlands_expires_at"
    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func load() -> AppSession? {
        guard let accessToken = readKeychainValue(for: tokenKey) else {
            return nil
        }

        let userID = defaults.string(forKey: userIDKey)
        let expiresAt = defaults.object(forKey: expiresAtKey) as? Date
        let session = AppSession(accessToken: accessToken, userID: userID, expiresAt: expiresAt)
        return session.isExpired ? nil : session
    }

    func save(_ session: AppSession) {
        saveKeychainValue(session.accessToken, for: tokenKey)
        defaults.set(session.userID, forKey: userIDKey)
        defaults.set(session.expiresAt, forKey: expiresAtKey)
    }

    func clear() {
        deleteKeychainValue(for: tokenKey)
        defaults.removeObject(forKey: userIDKey)
        defaults.removeObject(forKey: expiresAtKey)
    }

    private func saveKeychainValue(_ value: String, for key: String) {
        guard let data = value.data(using: .utf8) else { return }
        deleteKeychainValue(for: key)

        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: data
        ]
        SecItemAdd(query as CFDictionary, nil)
    }

    private func readKeychainValue(for key: String) -> String? {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ]

        var result: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        guard status == errSecSuccess, let data = result as? Data else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }

    private func deleteKeychainValue(for key: String) {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ]
        SecItemDelete(query as CFDictionary)
    }
}
