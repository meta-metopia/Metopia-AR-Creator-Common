import Foundation

public struct Session: Codable, Equatable {
    public var providerToken: String?
    public var providerRefreshToken: String?
    public var accessToken: String
    public var tokenType: String
    /// The number of seconds until the token expires (since it was issued).
    public var expiresIn: Double
    public var refreshToken: String
    public var user: User

    public init(providerToken: String? = nil, providerRefreshToken: String? = nil, accessToken: String, tokenType: String, expiresIn: Double, refreshToken: String, user: User) {
        self.providerToken = providerToken
        self.providerRefreshToken = providerRefreshToken
        self.accessToken = accessToken
        self.tokenType = tokenType
        self.expiresIn = expiresIn
        self.refreshToken = refreshToken
        self.user = user
    }
}

public struct User: Codable, Equatable {
    public var id: UUID
}
