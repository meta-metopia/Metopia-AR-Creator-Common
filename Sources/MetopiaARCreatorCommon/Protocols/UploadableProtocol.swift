//
//  File.swift
//  
//
//  Created by Qiwei Li on 11/17/22.
//

import Foundation

public protocol UploadTypeProtocol {
    var value: String { get }
}

public protocol UploadableProtocol {
    func uploadDestination(type: UploadTypeProtocol) -> URL?
    
    func uploadFile(type: UploadTypeProtocol, data: Data) -> File?
}
