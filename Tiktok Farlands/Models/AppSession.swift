import Foundation

struct AppSession: Equatable {
    let accessToken: String
    let userID: String?
    let expiresAt: Date?

    var isExpired: Bool {
        guard let expiresAt else { return false }
        return Date() >= expiresAt
    }
}
