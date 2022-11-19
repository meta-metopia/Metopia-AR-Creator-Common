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
    let key: String
    
    public init(endpoint: URL, key: String) {
        self.endpoint = endpoint
        self.key = key
    }
    
    public func download(file: DownloadableProtocol, type: DownloadTypeProtocol) async throws -> Data? {
        guard let downloadSource = file.downloadSource(type: type) else {
            return nil
        }

        guard let downloadDestination = file.downloadDestination(type: type) else {
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
    
    public func upload(file: UploadableProtocol, type: UploadTypeProtocol, data: Data, upsert: Bool = false) async throws -> URL {
        let storageClient = SupabaseStorageClient(url: endpoint, key: key)
     
        try await storageClient.upsertObject(at: file.uploadDestination(type: type)!.absoluteString, file: file.uploadFile(type: type, data: data)!, isUpdate: upsert)
        
        return file.uploadDestination(type: type)!
    }
}
