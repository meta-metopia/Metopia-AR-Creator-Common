//
//  File.swift
//  
//
//  Created by Qiwei Li on 11/17/22.
//

import Foundation

public protocol DownloadableProtocol {
    /**
     Download path for the object
     */
    var downloadPath: URL { get }
}
