//
//  File.swift
//  
//
//  Created by Qiwei Li on 11/17/22.
//

import Foundation
import Supabase


public class SupabaseServiceClient: NetworkRequestServiceProtocol {
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
    
    public func createWorldMap(worldMap: WorldMap) async throws {
        try await self.client.database.from(table: .worldMap).insert(values: worldMap).execute()
    }
    
    public func editWorldMap(worldMap: WorldMap) async throws {
        let oldVersion = worldMap.version
        var worldMap = worldMap
        worldMap.version = oldVersion + 1
        try await self.client.database
            .from(table: .worldMap)
            .update(values: worldMap)
            .match(query: ["version": oldVersion, "id": worldMap.id!])
            .execute()
    }
    
    public func deleteWorldMap(worldMap: WorldMap) async throws {
        try await self.client.database.from(table: .worldMap).delete().match(query: ["id": String(worldMap.id!)]).execute()
    }
    
    public func fetchCategories(for worldMap: WorldMap, with user: User) async throws -> [Category] {
        let result = try await self.client.database.from(table: .category)
            .select(columns: "*, model(*)")
            .eq(column: "wid", value: worldMap.id!)
            .eq(column: "uid", value: user.id.uuidString)
            .execute()
        
        let categories = try result.decoded(to: [Category].self)
        return categories
    }
    
    public func editCategory(category: CategoryUpdateDto) async throws -> Category {
        let result = try await self.client.database
            .from(table: .category)
            .update(values: category)
            .execute()
        return try result.decoded(to: [Category].self).first!
    }
    
    public func deleteCategory(category: Category) async throws {
        try await self.client.database.from(table: .category).delete().match(query: ["id": category.id]).execute()
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
        let oldVersion = model.version
        var model = model
        model.version = oldVersion + 1
        try await self.client.database
            .from(table: .model)
            .update(values: model)
            .match(query: ["version": oldVersion, "id": model.id])
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
    
    let client: Supabase.SupabaseClient
    
    public required init(url: URL, key: String) {
        client = Supabase.SupabaseClient(supabaseURL: url, supabaseKey: key)
        self.url = url
    }
}
