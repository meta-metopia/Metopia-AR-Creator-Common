//
//  File.swift
//  
//
//  Created by Qiwei Li on 11/17/22.
//

import Foundation

public protocol UploadableProtocol {
    func uploadDestination(baseURL: URL) -> URL
}
