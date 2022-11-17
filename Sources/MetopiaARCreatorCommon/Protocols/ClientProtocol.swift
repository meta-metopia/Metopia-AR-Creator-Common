import Foundation

public protocol ClientProtocol {
    var url: URL { get }

    init(url: URL, key: String, authenticationClient: (any NetworkRequestAuthProtocol)?, storageClient: (any NetworkRequestStorageProtocol)?, serviceClient: (any NetworkRequestServiceProtocol)?)

    /**
     Authentication client
     */
    var authenticationClient: NetworkRequestAuthProtocol { get }
    
    var storageClient: NetworkRequestStorageProtocol { get }
    
    var serviceClient: NetworkRequestServiceProtocol { get }
}
