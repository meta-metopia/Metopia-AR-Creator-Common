//
//  File.swift
//  
//
//  Created by Qiwei Li on 11/17/22.
//

import Foundation

public struct File: Hashable, Equatable {
  public var name: String
  public var data: Data
  public var fileName: String?
  public var contentType: String?

  public init(name: String, data: Data, fileName: String?, contentType: String?) {
    self.name = name
    self.data = data
    self.fileName = fileName
    self.contentType = contentType
  }
}
