import Foundation
import Rswift

class AuthViewModel {
    
    private weak var coordinator: Coordinator?
    private weak var userDataService: UserDataService?
    
    var authState: Observable<AuthState> = Observable(AuthState.signUp)
    
    private var credentials = Credentials() {
        didSet {
            login = credentials.login
            password = credentials.password
        }
    }
    
    private var login = ""
    private var password = ""
    
    var credentialsInputErrorMessage: Observable<String> = Observable("")
    var isUsernameTextFieldHighLighted: Observable<Bool> = Observable(false)
    var isPasswordTextFieldHighLighted: Observable<Bool> = Observable(false)
    var errorMessage: Observable<String?> = Observable(nil)
    
    init(
        coordinator: Coordinator,
        userDataService: UserDataService,
        authState: Observable<AuthState>) {
            
            self.coordinator = coordinator
            self.authState = authState
            self.userDataService = userDataService
        }
}

extension AuthViewModel {
    
    
}

// MARK: - Navigate

extension AuthViewModel {
    
    func startSignUp() {
        coordinator?.navigate(.signUp)
    }
    
    func startSignIn() {
        coordinator?.navigate(.signIn)
    }
}

// MARK: - Login

extension AuthViewModel {
    func updateCredentials(username: String, password: String, otp: String? = nil) {
        credentials.login = username
        credentials.password = password
    }
    
    func signIn() {
        userDataService?.credentials = credentials
        coordinator?.navigate(.home)
    }
}

// MARK: - CredentialsInputStatus

extension AuthViewModel {
    enum CredentialsInputStatus {
        case Correct
        case Incorrect
    }
    
    func credentialsInput() -> CredentialsInputStatus {
        if login.isEmpty && password.isEmpty {
            credentialsInputErrorMessage.value = "Please provide username and password"
            return .Incorrect
        }
        if login.isEmpty {
            credentialsInputErrorMessage.value = "Username field is empty"
            isUsernameTextFieldHighLighted.value = true
            return .Incorrect
        }
        if password.isEmpty {
            credentialsInputErrorMessage.value = "Password field is empty"
            isPasswordTextFieldHighLighted.value = true
            return .Incorrect
        }
        return .Correct
    }
}

