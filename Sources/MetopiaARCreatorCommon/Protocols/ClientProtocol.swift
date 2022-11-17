import Foundation

public protocol ClientProtocol {
    var url: URL { get }

    init(url: URL, key: String, authenticationClient: NetworkRequestAuthProtocol?)

    /**
     Authentication client
     */
    var authenticationClient: NetworkRequestAuthProtocol { get }
}
