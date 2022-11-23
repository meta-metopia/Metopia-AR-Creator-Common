//
//  File.swift
//
//
//  Created by Qiwei Li on 11/17/22.
//

import Foundation

public protocol DownloadTypeProtocol {
  var value: String { get }
}

public protocol DownloadableProtocol {
  /**
     Download path for the object
     */
  func downloadDestination(type: DownloadTypeProtocol) -> URL?

  /**
     Remote file path
     */
  func downloadSource(type: DownloadTypeProtocol) -> URL?
}
