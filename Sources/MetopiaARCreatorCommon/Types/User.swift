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
}

public struct User: Codable, Equatable {
    public var id: UUID
}
