//
//  File.swift
//
//
//  Created by Qiwei Li on 11/17/22.
//

import ARKit
import Foundation
import RealityKit

public typealias FindModelByName = (Int) async -> Model?

public enum WorldMapUploadType: UploadTypeProtocol {
  case worldmap
  
  public var value: String {
    switch self {
      case .worldmap:
        return "worldmap"
    }
  }
}

public enum WorldMapDownloadType: DownloadTypeProtocol {
  case worldmap
  
  public var value: String {
    switch self {
      case .worldmap:
        return "worldmap"
    }
  }
}

public enum PositioningEngineType: String, Codable {
  /**
   System default position engine. Different on android and ios
   */
  case defaultEngine = "default"
  /**
   Use Google Cloud Anchor for positioning
   */
  case cloudAnchor = "cloud-anchor"
  /**
   Use Azure spaicial anchor for positioning
   */
  case spacialAnchor = "spacial-anchor"
  /**
   Use Google Cloud Geospatial Anchor for positioning
   */
  case geospatialAnchor = "geospatial-anchor"
}

public protocol WorldMapProtocol: VersionProtocol, Equatable {
  var uid: UUID { get set }
  var name: String { get set }
  var file: String? { get set }
  var latitude: Double? { get set }
  var longitude: Double? { get set }
  var cloudAnchors: [CloudARAnchor]? { get set }
  var usedModels: [Int]? { get set }
  var positioningEngine: PositioningEngineType { get set }
}

public struct WorldMapCreateDto: Codable, WorldMapProtocol {
  public var uid: UUID
  
  public var name: String
  
  public var file: String?
  
  public var latitude: Double?
  
  public var longitude: Double?
  
  public var cloudAnchors: [CloudARAnchor]?
  
  public var usedModels: [Int]?
  
  public var preferCloudAnchor: Bool
  
  public var version: Int
  
  public var positioningEngine: PositioningEngineType
  
  
}

public struct WorldMap: Codable, Identifiable, WorldMapProtocol, DownloadableProtocol,
                        UploadableProtocol
{
  public func downloadSource(type: DownloadTypeProtocol) -> URL? {
    guard let filename = file else {
      return nil
    }
    return URL(string: filename)
  }
  
  
  
  /**
   Map directory
   */
  private var mapDirectory: URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    var dir = paths[0]
    dir.appendPathComponent("maps")
    return dir
  }
  
  public static func == (lhs: WorldMap, rhs: WorldMap) -> Bool {
    lhs.id == rhs.id
  }
  
  public var id: Int
  public var uid: UUID
  public var name: String
  public var file: String?
  public var latitude: Double?
  public var longitude: Double?
  public var version: Int
  public var cloudAnchors: [CloudARAnchor]?
  /**
   List of models' id used in the worldMap
   */
  public var usedModels: [Int]?
  public var positioningEngine: PositioningEngineType
  
  public init(
    id: Int, uid: UUID, name: String, file: String? = nil, latitude: Double? = nil,
    longitude: Double? = nil, version: Int, cloudAnchors: [CloudARAnchor]? = nil,
    usedModels: [Int]? = nil, positioningEngine: PositioningEngineType
  ) {
    self.id = id
    self.uid = uid
    self.name = name
    self.file = file
    self.latitude = latitude
    self.longitude = longitude
    self.version = version
    self.cloudAnchors = cloudAnchors
    self.usedModels = usedModels
    self.positioningEngine = positioningEngine
  }
  
  public func downloadDestination(type: DownloadTypeProtocol) -> URL? {
    var modelDir = mapDirectory
    modelDir.appendPathComponent("\(id)_version_\(version).worldmap")
    return modelDir
  }
  
  public func uploadDestination(type: UploadTypeProtocol) -> URL? {
    return URL(string: "uploads/\(uid)/worldmap/\(id).worldmap")
  }
  
  public func uploadFile(type: UploadTypeProtocol, data: Data) -> File? {
    return File(name: name, data: data, fileName: "\(id).worldmap", contentType: nil)
  }
  
  public func load(service: ClientProtocol) async throws -> WorldMapWithARWorldMap {
    let mapWithoutARWorldMap = WorldMapWithARWorldMap(
      id: id, uid: uid, name: name, file: file, latitude: latitude, longitude: longitude,
      cloudAnchors: cloudAnchors, usedModels: usedModels,
      version: version, map: nil, positioningEngine: positioningEngine)
    
    if positioningEngine != .defaultEngine {
      // if prefer cloud anchor, then return map without ar world map
      return mapWithoutARWorldMap
    }
    
    guard let _ = downloadSource(type: WorldMapDownloadType.worldmap) else {
      // if map is empty, then return an ar map with empty map data
      return mapWithoutARWorldMap
    }
    
    let data = try await service.downloaderClient.download(
      file: self, type: WorldMapDownloadType.worldmap)
    guard let data = data else {
      throw WorldMapError(title: "Cannot download data", description: "Data is empty", code: 1)
    }
    guard
      let worldMap = try NSKeyedUnarchiver.unarchivedObject(ofClass: ARWorldMap.self, from: data)
    else {
      throw WorldMapError(title: "Cannot load world map", description: "WorldMap is empty", code: 2)
    }
    return WorldMapWithARWorldMap(
      id: id, uid: uid, name: name, file: file, latitude: latitude, longitude: longitude,
      cloudAnchors: cloudAnchors, usedModels: usedModels,
      version: version, map: worldMap, positioningEngine: positioningEngine)
  }
  
}

public struct WorldMapWithARWorldMap: WorldMapProtocol {
  public var id: Int
  
  public var uid: UUID
  
  public var name: String
  
  public var file: String?
  
  public var latitude: Double?
  
  public var longitude: Double?
  
  public var cloudAnchors: [MetopiaARCreatorCommon.CloudARAnchor]?
  
  public var usedModels: [Int]?
  
  public var version: Int
  
  public var map: ARWorldMap?
  
  public var positioningEngine: PositioningEngineType
  
  /**
   Download model associated with this used models
   - returns List of used models
   */
  public func downloadModels(client: ClientProtocol, findModelByName: @escaping FindModelByName)
  async -> [ModelWithEntity]
  {
    var usedModels: [ModelWithEntity] = []
    
    guard let models = self.usedModels else {
      return usedModels
    }
    
    for modelId in models {
      let foundModel = await findModelByName(modelId)
      
      if let foundModel = foundModel {
        let modelWithEntity = try! await foundModel.load(service: client)
        usedModels.append(modelWithEntity)
      }
    }
    return usedModels
  }
  
}
