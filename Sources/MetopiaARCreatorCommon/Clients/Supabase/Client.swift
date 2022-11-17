import Foundation

public class SupabaseClient: ClientProtocol {
    public var url: URL

    public var authenticationClient: NetworkRequestAuthProtocol

    public required init(url: URL, key: String, authenticationClient: NetworkRequestAuthProtocol? = nil) {
        self.url = url

        // use default authentication client if not provided
        if let authenticationClient = authenticationClient {
            self.authenticationClient = authenticationClient
        } else {
            self.authenticationClient = SupabaseAuthenticationClient(url: url, key: key)
        }
    }
}
