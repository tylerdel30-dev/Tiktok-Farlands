import Foundation

enum AuthError: Error, LocalizedError {
    case missingClientKey
    case missingRedirectURI
    case invalidCallback
    case invalidState
    case noAuthorizationCode

    var errorDescription: String? {
        switch self {
        case .missingClientKey:
            return "Missing TikTok client key. Set it in AppConfig."
        case .missingRedirectURI:
            return "Missing TikTok redirect URI. Set it in AppConfig."
        case .invalidCallback:
            return "Invalid login callback URL."
        case .invalidState:
            return "TikTok login state verification failed."
        case .noAuthorizationCode:
            return "TikTok login did not return an authorization code."
        }
    }
}

protocol TikTokAuthenticating {
    func makeAuthorizationURL(state: String) throws -> URL
    func handleCallbackURL(_ url: URL, expectedState: String) async throws -> AppSession
}

final class TikTokAuthService: TikTokAuthenticating {
    private let tokenExchangeService: TokenExchanging

    init(tokenExchangeService: TokenExchanging = TikTokTokenExchangeService()) {
        self.tokenExchangeService = tokenExchangeService
    }

    func makeAuthorizationURL(state: String) throws -> URL {
        let clientKey = AppConfig.tikTokClientKey
        guard clientKey.hasPrefix("MISSING_") == false, clientKey.isEmpty == false else {
            throw AuthError.missingClientKey
        }
        let redirectURI = AppConfig.redirectURI
        guard redirectURI.hasPrefix("MISSING_") == false, redirectURI.isEmpty == false else {
            throw AuthError.missingRedirectURI
        }

        var components = URLComponents(string: "https://www.tiktok.com/v2/auth/authorize/")!
        components.queryItems = [
            URLQueryItem(name: "client_key", value: clientKey),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: "user.info.basic,video.list"),
            URLQueryItem(name: "redirect_uri", value: redirectURI),
            URLQueryItem(name: "state", value: state)
        ]

        return components.url!
    }

    func handleCallbackURL(_ url: URL, expectedState: String) async throws -> AppSession {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw AuthError.invalidCallback
        }

        let state = components.queryItems?.first(where: { $0.name == "state" })?.value
        guard state == expectedState else {
            throw AuthError.invalidState
        }

        let code = components.queryItems?.first(where: { $0.name == "code" })?.value
        guard let code, code.isEmpty == false else {
            throw AuthError.noAuthorizationCode
        }

        return try await tokenExchangeService.exchange(authCode: code, redirectURI: AppConfig.redirectURI)
    }
}
