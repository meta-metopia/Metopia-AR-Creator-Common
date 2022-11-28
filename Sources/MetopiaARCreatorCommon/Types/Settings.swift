//
//  Settings 2.swift
//  
//
//  Created by Qiwei Li on 11/28/22.
//

import Foundation

/**
 List of ar settings
 */
public enum ARSettings: String, CaseIterable {
  case personSegmentation = "Person segmentation"
  case objectOcclusion = "Object occlusion"
  case ultraHD = "4k Resolution"
  case debug = "Debug Mode"
  
  /**
   Icon for settings
   */
  public var icon: String {
    switch self {
      case .personSegmentation:
        return "person.crop.rectangle.fill"
      case .objectOcclusion:
        return "square.3.stack.3d.middle.filled"
      case .ultraHD:
        return "4k.tv.fill"
      case .debug:
        return "eyeglasses"
    }
  }
}
