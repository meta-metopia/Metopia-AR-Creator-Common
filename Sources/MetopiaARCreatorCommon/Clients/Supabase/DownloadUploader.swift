//
//  File.swift
//  
//
//  Created by Qiwei Li on 11/17/22.
//

import Foundation
import Alamofire

public class SupabaseDownloadUploader {
    let endpoint: URL
    
    public init(endpoint: URL) {
        self.endpoint = endpoint
    }
    
    public func download(file: DownloadableProtocol) async throws -> Data? {
        guard let downloadSource = file.downloadSource(baseURL: endpoint) else {
            return nil
        }
        
        guard let downloadDestination = file.downloadDestination else {
            return nil
        }
        
        let downloadFolder = downloadDestination.deletingLastPathComponent()
        
        if !FileManager.default.fileExists(atPath: downloadFolder.path) {
            try! FileManager.default.createDirectory(atPath: downloadFolder.path, withIntermediateDirectories: true)
        }
        
        if !FileManager.default.fileExists(atPath: downloadDestination.path) {
            // download from cloud
            let destination: DownloadRequest.Destination = { _, _ in
                return (downloadDestination, [.removePreviousFile])
            }
        
            let task = AF.download(downloadSource, method: .get, to: destination).serializingDownloadedFileURL()
            let _ = try await task.value
        }
        return try Data(contentsOf: downloadDestination)
    }
}
