import Foundation

protocol TokenExchanging {
    func exchange(authCode: String, redirectURI: String) async throws -> AppSession
}

private struct TokenResponseDTO: Decodable {
    let accessToken: String
    let userID: String?
    let expiresIn: Int?
}

final class TikTokTokenExchangeService: TokenExchanging {
    private let urlSession: URLSession

    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

    func exchange(authCode: String, redirectURI: String) async throws -> AppSession {
        guard let endpoint = AppConfig.tokenExchangeEndpoint else {
            // Fallback for local testing while backend is not ready.
            return AppSession(
                accessToken: authCode,
                userID: nil,
                expiresAt: Calendar.current.date(byAdding: .hour, value: 1, to: Date())
            )
        }

        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(
            withJSONObject: [
                "code": authCode,
                "client_key": AppConfig.tikTokClientKey,
                "client_secret": AppConfig.tikTokClientSecret,
                "redirect_uri": redirectURI
            ]
        )

        let (data, response) = try await urlSession.data(for: request)
        guard let status = (response as? HTTPURLResponse)?.statusCode, (200 ... 299).contains(status) else {
            throw FeedError.badServerResponse
        }

        let decoded = try JSONDecoder().decode(TokenResponseDTO.self, from: data)
        let expiresAt: Date?
        if let expiresIn = decoded.expiresIn {
            expiresAt = Calendar.current.date(byAdding: .second, value: expiresIn, to: Date())
        } else {
            expiresAt = nil
        }

        return AppSession(
            accessToken: decoded.accessToken,
            userID: decoded.userID,
            expiresAt: expiresAt
        )
    }
}
