import Foundation

public protocol NetworkRequestProtocol {
    var url: URL { get }

    init(url: URL, key: String)
}

public protocol NetworkRequestAuthProtocol: NetworkRequestProtocol {
    /**
     Authenticated user session.
     Will be null if user doesn't sign in.
     */
    var user: User? { get }

    /**
     Sign in user with email and password
     - parameter email: user's email address
     - parameter password: user's password
     - returns: user session
     */
    func signIn(email: String, password: String) async throws -> Session

    /**
     Sign out current user
     */
    func signOut() async throws

    /**
     Sign up user with email and password
     - parameter email: user's email address
     - parameter password: user's password
     - returns: user session
     */
    func signUp(email: String, password: String) async throws

    /**
     Refresh current user when needed
     */
    func refresh() async throws
}

//
// protocol SupabaseStorageProtocol {
//    func deleteObject(at: [String]) async throws
//
//    func upsertObject(at path: String, file: File, isUpdate: Bool) async throws
// }
//
// protocol SupabaseServiceProtocol: SupabaseAuthProtocol, SupabaseStorageProtocol {
//    /**
//     Fetch list of world maps by user
//     - parameter user: Signed in user session
//     - returns: List of world maps
//     */
//    func fetchWorldMaps(user: User) async throws -> [WorldMap]
//
//    /**
//     Create a new world map
//     - parameter worldMap: New WorldMap
//     */
//    func createWorldMap(worldMap: WorldMap) async throws
//
//    /**
//     Edit world map by given world map
//     - parameter worldMap: World Map to be edited
//     */
//    func editWorldMap(worldMap: WorldMap) async throws
//
//    /**
//     Delete world map by given world map
//     - parameter worldMap: The given world map
//     */
//    func deleteWorldMap(worldMap: WorldMap) async throws
//
//    /**
//     Fetch list of categories
//     - parameter for: Which world map
//     - parameter with: The user of the categories
//     - returns: List of categories
//     */
//    func fetchCategories(for worldMap: WorldMap, with user: User) async throws -> [Category]
//
//    /**
//     Edit given category
//     - parameter category: Given category
//     */
//    func editCategory(category: CategoryUpdate) async throws -> Category
//
//    /**
//     Delete the given category
//     - parameter category: Given category
//     */
//    func deleteCategory(category: Category) async throws
//
//    /**
//     Create a category
//     */
//    func createCategory(category: CategoryCreate) async throws
//
//    /**
//     Create a new model
//     */
//    func createModel(model: ModelCreate) async throws -> Model
//
//    /**
//     Edit given model
//     */
//    func editModel(model: Model) async throws
//
//    /**
//     Delete the given model
//     */
//    func deleteModel(model: Model) async throws
//
//    /**
//     Get Model by model id
//     */
//    func getModelById(id: Int) async throws -> Model?
//
//    /**
//     Get categories with models using world map id
//     */
//    func getCategoriesWithModels(worldMapId: Int) async throws -> [Category]
// }
