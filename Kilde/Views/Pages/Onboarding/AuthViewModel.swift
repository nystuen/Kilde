import SwiftUI
import _AuthenticationServices_SwiftUI
import CryptoKit
import CommonCrypto
import FirebaseAuth
import GoogleSignIn
import Firebase

@MainActor
class AuthViewModel: ObservableObject {
    
    var currentNonce: String?
    @Published var userSession: FirebaseAuth.User?
    //@Published var currentUser: User?
    @Published var errorMessage: String?
    
    
    init() {
        self.userSession = Auth.auth().currentUser
        
    }
    
    func handleSignInWithGoogle() async throws -> Void {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        let topViewController = UIApplication.shared.rootViewController()
        
        let signInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topViewController)
        
        guard let idToken: String = signInResult.user.idToken?.tokenString else {
            throw URLError(.badURL)
        }
        let accessToken: String = signInResult.user.accessToken.tokenString
        
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        let result = try await Auth.auth().signIn(with: credential)
        withAnimation {
            userSession = result.user
        }
        // Getting JWT for communicating with server
        // ...
        
        //task.resume()
    }
    
    //    func handleSignInWithGoogle() {
    //        GIDSignIn.sharedInstance.signIn(withPresenting: UIApplication.shared.rootViewController()) { result, error in
    //            if let error = error {
    //                self.errorMessage = error.localizedDescription
    //                return
    //            }
    //
    //            Task {
    //                do {
    //                    guard let user = result?.user else { return }
    //                    guard let idToken = user.idToken else { return }
    //                    let accessToken = user.accessToken
    //                    let credential = OAuthProvider(providerID: idToken.tokenString, auth: accessToken)
    //                    let result = try await Auth.auth().signIn(with: credential)
    //                    withAnimation {
    //                        userSession = result.user
    //                    }
    //                    //currentUser = result.user
    //                    //await updateDisplayName                } catch {
    //                    self.errorMessage = error.localizedDescription
    //                }
    //            }
    //      }
    //    }
    
    func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]
        let nonce = randomNonceString()
        currentNonce = nonce
        request.nonce = sha256(nonce)
    }
    
    
    func handleSignInWithAppleCompletion(_ result: Result<ASAuthorization, Error>) {
        if case .failure(let failure) = result {
            errorMessage = failure.localizedDescription
        } else if case .success(let success) = result {
            if let appleIDCredential = success.credential as? ASAuthorizationAppleIDCredential {
                guard let nonce = currentNonce else {
                    fatalError("Invalid state: A login callback was received, but no login request was sent.")
                }
                guard let appleIDToken = appleIDCredential.identityToken else {
                    errorMessage = "Unable to fetch identity token"
                    return
                }
                guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                    errorMessage = "Unable to serialize token string from data: \(appleIDToken.debugDescription)"
                    return
                }
                
                let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
                
                Task {
                    do {
                        let result = try await Auth.auth().signIn(with: credential)
                        withAnimation {
                            userSession = result.user
                        }
                        //currentUser = result.user
                        //await updateDisplayName
                    } catch {
                        print("Error authenticating: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            withAnimation {
                userSession = nil
            }
        } catch {
            print(error)
            errorMessage = errorMessage?.localizedCapitalized
        }
    }
    
    
    func loginWithGmail() {
        // Simulate Gmail login
        // Replace this with your actual Gmail authentication code
        print("Logged in with Gmail")
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError(
                "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
        }
        
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        
        let nonce = randomBytes.map { byte in
            // Pick a random character from the set, wrapping around if needed.
            charset[Int(byte) % charset.count]
        }
        
        return String(nonce)
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
}
