import Foundation

enum AppConfig {
    static let appName = "Tiktok Farlands"

    // Loaded from build settings / Info.plist keys.
    static let tikTokClientKey = requiredValue("TIKTOK_CLIENT_KEY")
    static let tikTokClientSecret = requiredValue("TIKTOK_CLIENT_SECRET")

    // Must match your TikTok app registration callback.
    static let redirectURI = requiredValue("TIKTOK_REDIRECT_URI")
    static let redirectScheme = URL(string: redirectURI)?.scheme ?? "tiktokfarlands"

    // In production, this should be your own backend that calls approved TikTok APIs.
    static let recommendationsEndpoint = URL(
        string: optionalValue("TIKTOK_RECOMMENDATIONS_ENDPOINT")
            ?? "https://example.com/api/tiktok/recommendations"
    )!
    static let tokenExchangeEndpoint = optionalValue("TIKTOK_TOKEN_EXCHANGE_ENDPOINT")
        .flatMap(URL.init(string:))

    static let allowedTags: Set<String> = [
        "#tiktokfarlands",
        "#farlands",
        "#ishoweyes"
    ]

    private static func requiredValue(_ key: String) -> String {
        if let value = optionalValue(key), value.isEmpty == false {
            return value
        }
        return "MISSING_\(key)"
    }

    private static func optionalValue(_ key: String) -> String? {
        let envValue = ProcessInfo.processInfo.environment[key]
        if let envValue, envValue.isEmpty == false {
            return envValue
        }

        let plistValue = Bundle.main.object(forInfoDictionaryKey: key) as? String
        if let plistValue, plistValue.isEmpty == false {
            return plistValue
        }

        return nil
    }
}
