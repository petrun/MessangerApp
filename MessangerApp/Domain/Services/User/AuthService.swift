import FirebaseAuth

protocol AuthServiceProtocol {
    typealias UserId = String
    var currentUserId: String? { get }

    func login(
        withEmail email: String,
        password: String,
        completion: @escaping (Result<UserId, Error>) -> Void
    )

    func logout(completion: @escaping () -> Void)

    func register(
        withEmail email: String,
        password: String,
        completion: @escaping (Result<UserId, Error>) -> Void
    )
}

class AuthService: AuthServiceProtocol {
    private let auth = Auth.auth()

    var currentUserId: String? {
        Auth.auth().currentUser?.uid
    }

    func login(
        withEmail email: String,
        password: String,
        completion: @escaping (Result<UserId, Error>) -> Void
    ) {
        auth.signIn(withEmail: email, password: password) { result, error in
            guard let result = result else {
                completion(.failure(error!))
                return
            }
            completion(.success(result.user.uid))
        }
    }

    func logout(completion: @escaping () -> Void) {
        do {
            try auth.signOut()
            completion()
        } catch {
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }

    func register(
        withEmail email: String,
        password: String,
        completion: @escaping (Result<UserId, Error>) -> Void
    ) {
        auth.createUser(withEmail: email, password: password) { result, error in
            guard let result = result else {
                completion(.failure(error!))
                return
            }
            completion(.success(result.user.uid))
        }
    }
}
