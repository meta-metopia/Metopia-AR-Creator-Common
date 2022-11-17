import Foundation
import Supabase

public class SupabaseAuthenticationClient: NetworkRequestAuthProtocol {
    public var url: URL

    public var user: User?

    public var client: Supabase.SupabaseClient

    public required init(url: URL, key: String) {
        self.url = url
        client = Supabase.SupabaseClient(supabaseURL: url, supabaseKey: key)
    }

    public func signIn(email: String, password: String) async throws -> Session {
        let session = try await client.auth.signIn(email: email, password: password)
        return Session(accessToken: session.accessToken, tokenType: session.tokenType, expiresIn: session.expiresIn, refreshToken: session.refreshToken, user: User(id: session.user.id))
    }

    public func signOut() async throws {
        try await client.auth.signOut()
    }

    public func signUp(email: String, password: String) async throws {
        let _ = try await client.auth.signUp(email: email, password: password)
    }

    public func refresh() async throws {}
}
