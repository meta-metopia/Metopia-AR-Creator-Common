//
//  File.swift
//  
//
//  Created by Qiwei Li on 11/17/22.
//

import Foundation

public protocol DownloadUploader {
    func download(file: DownloadableProtocol) async throws -> Data
    
    func upload(file: UploadableProtocol) async throws
}
