//
//  FirebaseAuthManager.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/6.
//

import FirebaseAuth
import AuthenticationServices
import CryptoKit

class FirebaseAuthManager: NSObject {
    
    var currentNonce: String?
    
    var controller: UIViewController?
    
    func performSignin(_ controller: UIViewController) {
        
        self.controller = controller
        
        let request = createAppleIDRequest()
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        
        authorizationController.delegate = self
        
        authorizationController.presentationContextProvider = self
        
        authorizationController.performRequests()
        
    }
    
    func createAppleIDRequest() -> ASAuthorizationAppleIDRequest {
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        
        let request = appleIDProvider.createRequest()
        
        request.requestedScopes = []
        
        let nonce = randomNonceString()
        
        request.nonce = sha256(nonce)
        
        currentNonce = nonce
        
        return request
    }
}

extension FirebaseAuthManager: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            guard let nonce = currentNonce else {
                
                fatalError("Invalid state: A login callback was received, but no login request was sent")
            }
            
            guard let appleIDToken = appleIDCredential.identityToken else {
                
                print("Unable to fetch identity token")
                
                return
            }
            
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                
                return
            }
            
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
            
            Auth.auth().signIn(with: credential) { (result, error) in
                
                if let user = result?.user {
                    
                    print("signed in as \(user.uid)m email: \(user.email ?? "unknow")")
                }
            }
        }
    }
}

extension FirebaseAuthManager: ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        
        guard let view = self.controller?.view, let window = view.window else {
            
            fatalError("view is nil with sign in with apple")
        }
        
        return window
    }
}

// Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce

private func randomNonceString(length: Int = 32) -> String {
    
    precondition(length > 0)
    
    let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
    
    var result = ""
    
    var remainingLength = length
    
    while remainingLength > 0 {
        
        let randoms: [UInt8] = (0 ..< 16).map { _ in
            
            var random: UInt8 = 0
            
            let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
            
            if errorCode != errSecSuccess {
                
                fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
            }
            
            return random
        }
        
        randoms.forEach { random in
            
            if remainingLength == 0 {
                
                return
            }
            
            if random < charset.count {
                
                result.append(charset[Int(random)])
                
                remainingLength -= 1
            }
        }
    }
    
    return result
}

// Unhashed nonce.

@available(iOS 13, *)

private func sha256(_ input: String) -> String {
    
    let inputData = Data(input.utf8)
    
    let hashedData = SHA256.hash(data: inputData)
    
    let hashString = hashedData.compactMap {
        
        return String(format: "%02x", $0)
        
    }.joined()
    
    return hashString
}
