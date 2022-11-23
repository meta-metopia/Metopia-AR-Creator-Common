//
//  File.swift
//
//
//  Created by Qiwei Li on 11/17/22.
//

import Alamofire
import Foundation
import Supabase

public class SupabaseServiceClient: NetworkRequestServiceProtocol {
  public func fetchWorldMapBy(id: Int) async throws -> WorldMap {
    let result = try await self.client.database.from(table: .worldMap)
      .select(columns: "*")
      .eq(column: "id", value: id)
      .execute()

    let worldMap = try? result.decoded(to: [WorldMap].self)
    guard let foundWorldMap = worldMap?.first else {
      throw WorldMapError(
        title: "Cannot find world map.", description: "Cannot find world map with given id \(id)",
        code: 1)
    }
    return foundWorldMap
  }

  public func fetchWorldMaps(user: User) async throws -> [WorldMap] {
    let result = try await self.client.database
      .from(table: .worldMap)
      .select(columns: "*")
      .eq(column: "uid", value: user.id.uuidString)
      .order(column: "inserted_at")
      .execute()
    let worldMaps = try result.decoded(to: [WorldMap].self)
    return worldMaps
  }

  public func createWorldMap(worldMap: WorldMapCreateDto) async throws {
    try await self.client.database.from(table: .worldMap).insert(values: worldMap).execute()
  }

  public func editWorldMap(worldMap: WorldMap) async throws {
    try await self.client.database
      .from(table: .worldMap)
      .update(values: worldMap)
      .match(query: ["id": worldMap.id])
      .execute()
  }

  public func deleteWorldMap(worldMap: WorldMap) async throws {
    try await self.client.database.from(table: .worldMap).delete().match(query: [
      "id": String(worldMap.id)
    ]).execute()
  }

  public func fetchCategories(for worldMap: WorldMap, with user: User) async throws -> [Category] {
    let result = try await self.client.database.from(table: .category)
      .select(columns: "*, model(*)")
      .eq(column: "wid", value: worldMap.id)
      .eq(column: "uid", value: user.id.uuidString)
      .execute()

    let categories = try result.decoded(to: [Category].self)
    return categories
  }

  public func editCategory(category: CategoryUpdateDto) async throws -> CategoryUpdateDto {
    let result = try await self.client.database
      .from(table: .category)
      .update(values: category)
      .execute()
    return try result.decoded(to: [CategoryUpdateDto].self).first!
  }

  public func deleteCategory(category: Category) async throws {
    try await self.client.database.from(table: .category).delete().match(query: ["id": category.id])
      .execute()
  }

  public func createCategory(category: CategoryCreateDto) async throws {
    try await self.client.database.from(table: .category).insert(values: category).execute()
  }

  public func createModel(model: ModelCreateDto) async throws -> Model {
    let result = try await self.client.database
      .from(table: .model)
      .insert(values: model, returning: .representation)
      .execute()
    let uploadedModel = try result.decoded(to: [Model].self).first!
    return uploadedModel
  }

  public func editModel(model: Model) async throws {
    try await self.client.database
      .from(table: .model)
      .update(values: model)
      .match(query: ["id": model.id])
      .execute()
  }

  public func deleteModel(model: Model) async throws {
    try await self.client.database.from(table: .model)
      .delete()
      .match(query: ["id": model.id, "version": model.version])
      .execute()
  }

  public func getModelById(id: Int) async throws -> Model? {
    let result = try await self.client.database.from(table: .model)
      .select(columns: "*")
      .eq(column: "id", value: id)
      .execute()

    let model = try? result.decoded(to: [Model].self)
    guard let foundModel = model?.first else { return nil }
    return foundModel
  }

  public func getCategoriesWithModels(worldMapId: Int) async throws -> [Category] {
    let resp = try await client.database.from("category")
      .select(columns: "*, model(*)")
      .eq(column: "wid", value: worldMapId)
      .execute()
    let categories = try resp.decoded(to: [Category].self)
    return categories
  }

  public var url: URL
  
  public var functionUrl: URL {
    get {
      let string = url.absoluteString
      let paths = string.components(separatedBy: ".supabase.co")
      let newString = paths[0] + ".functions" + ".supabase.co"
      return URL(string: newString)!
    }
  }

  let client: Supabase.SupabaseClient

  public required init(url: URL, key: String) {
    client = Supabase.SupabaseClient(supabaseURL: url, supabaseKey: key)
    self.url = url
  }

  public func deleteWorldMapData(worldMapId: Int) async throws -> WorldMap {
    guard let accessToken = client.auth.session?.accessToken else {
      throw WorldMapError(title: "", description: "No accesstoken", code: 0)
    }
    let path = "delete-worldmap/\(worldMapId)"
    let requestURL = functionUrl.appendingPathComponent(path)
            let task = AF.request(requestURL, method: .delete, headers: ["Authorization": "Bearer \(accessToken)"]).serializingDecodable(WorldMap.self)
    let result = try await task.value
    return result
  }
}
