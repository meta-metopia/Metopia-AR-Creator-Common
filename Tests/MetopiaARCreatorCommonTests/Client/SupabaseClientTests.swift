//
//  SupabaseClientTests.swift
//  
//
//  Created by Qiwei Li on 11/17/22.
//

import XCTest
@testable import MetopiaARCreatorCommon

class MockSupabaseAuthenticationClient: NetworkRequestAuthProtocol {
    var user: MetopiaARCreatorCommon.User?
    
    func signIn(email: String, password: String) async throws -> MetopiaARCreatorCommon.Session {
        return MetopiaARCreatorCommon.Session(accessToken: "a", tokenType: "b", expiresIn: 1, refreshToken: "c", user: User(id: UUID()))
    }
    
    func signOut() async throws {
        
    }
    
    func signUp(email: String, password: String) async throws {
        
    }
    
    func refresh() async throws {
        
    }
    
    var url: URL
    
    required init(url: URL, key: String) {
        self.url = url
    }
}


final class SupabaseClientTests: XCTestCase {
    let url = URL(string: "https://google.com")!
    
    func testInit() throws {
       let client = SupabaseClient(url: url, key: "mock_key")
       XCTAssertNotNil(client.authenticationClient)
    }
    
    func testInit2() throws {
        let auth = MockSupabaseAuthenticationClient(url: url, key: "mock_key")
        let client = SupabaseClient(url: url, key: "mock_key", authenticationClient: auth)
        XCTAssertNotNil(client.authenticationClient)
    }

}
