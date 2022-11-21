//
//  File.swift
//
//
//  Created by Qiwei Li on 11/17/22.
//

import Foundation
import Supabase
import SupabaseStorage

public class SupabaseStorageClient: NetworkRequestStorageProtocol {
    public var url: URL

    public var client: Supabase.SupabaseClient

    public required init(url: URL, key: String) {
        client = Supabase.SupabaseClient(supabaseURL: url, supabaseKey: key)
        self.url = url
    }

    public func deleteObject(at paths: [String]) async throws {
        _ = try await client.storage.from(id: "metopia").remove(paths: paths)
    }

    public func upsertObject(at path: String, file: File, isUpdate: Bool) async throws {
        if !isUpdate {
            _ = try await client.storage.from(id: "metopia").upload(path: path, file: .init(name: file.name, data: file.data, fileName: file.fileName, contentType: file.contentType), fileOptions: nil)
        } else {
            _ = try await client.storage.from(id: "metopia").update(path: path, file: .init(name: file.name, data: file.data, fileName: file.fileName, contentType: file.contentType), fileOptions: nil)
        }
    }
}
