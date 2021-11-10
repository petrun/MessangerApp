import FirebaseAuth

protocol AuthServiceProtocol {
    var currentUserId: String? { get }

    func login(
        withEmail email: String,
        password: String,
        completion: @escaping (Result<User, Error>) -> Void
    )

    func logout(completion: @escaping () -> Void)

    func register(
        withEmail email: String,
        password: String,
        completion: @escaping (Result<User, Error>) -> Void
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
        completion: @escaping (Result<User, Error>) -> Void
    ) {
        auth.signIn(withEmail: email, password: password) { result, error in
            guard let result = result else {
                completion(.failure(error!))
                return
            }
            completion(.success(result.user))
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
        completion: @escaping (Result<User, Error>) -> Void
    ) {
        auth.createUser(withEmail: email, password: password) { result, error in
            guard let result = result else {
                completion(.failure(error!))
                return
            }
            completion(.success(result.user))
        }
    }
}
