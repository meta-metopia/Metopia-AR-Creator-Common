//
//  File.swift
//
//
//  Created by Qiwei Li on 11/17/22.
//

import Foundation

public protocol DownloadUploaderProtocol {
  func download(file: DownloadableProtocol, type: DownloadTypeProtocol) async throws -> Data?

  func upload(file: UploadableProtocol, type: UploadTypeProtocol, data: Data, isUpdate: Bool)
    async throws -> URL
}
