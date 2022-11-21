import Foundation

public class SupabaseClient: ClientProtocol {
    public var url: URL

    public var authenticationClient: NetworkRequestAuthProtocol

    public var storageClient: NetworkRequestStorageProtocol

    public var serviceClient: NetworkRequestServiceProtocol
    
    public var downloaderClient: DownloadUploaderProtocol

    public required init(url: URL, key: String, authenticationClient: NetworkRequestAuthProtocol? = nil, storageClient: NetworkRequestStorageProtocol? = nil, serviceClient: NetworkRequestServiceProtocol? = nil) {
        self.url = url

        // use default authentication client if not provided
        if let authenticationClient = authenticationClient {
            self.authenticationClient = authenticationClient
        } else {
            self.authenticationClient = SupabaseAuthenticationClient(url: url, key: key)
        }

        // use default storage client if not provided
        if let storageClient = storageClient {
            self.storageClient = storageClient
        } else {
            self.storageClient = SupabaseStorageClient(url: url, key: key)
        }

        // use default service client if not provided
        if let serviceClient = serviceClient {
            self.serviceClient = serviceClient
        } else {
            self.serviceClient = SupabaseServiceClient(url: url, key: key)
        }
        
        self.downloaderClient = SupabaseDownloadUploader(endpoint: url, key: key)
    }
}
