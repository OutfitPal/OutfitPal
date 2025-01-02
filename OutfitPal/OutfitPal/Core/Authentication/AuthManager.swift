//
//  AuthManager.swift
//  OutfitPal
//
//  Created by Maxwell Kumbong on 1/1/25.
//


import Foundation
import Firebase
import FirebaseAuth
import GoogleSignIn
import FirebaseCore



@MainActor
final class AuthManager: ObservableObject{
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var showAccountDeletedAlert = false
    private var userListener: ListenerRegistration?

    init(){
        self.userSession = Auth.auth().currentUser

        
        Task{
            await fetchUser()
        }
    }

    func googleClientInit() async throws -> AuthCredential{
        guard let topVC = Utilities.topViewController() else {
            throw URLError(.cannotFindHost)
        }
        
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            throw URLError(.badServerResponse)
        }
                
        let config = GIDConfiguration(clientID: clientID)
                
        GIDSignIn.sharedInstance.configuration = config
        let gidSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)

 
        let accessToken = gidSignInResult.user.accessToken.tokenString
                
        guard let idToken = gidSignInResult.user.idToken?.tokenString else {
            throw URLError(.badServerResponse)
        }
        
        let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                         accessToken: accessToken)
        return credential
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        do{
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        }catch{
            print("Debug: Unable to signIn \(error.localizedDescription)")
            throw error
        }
    }
    
    
    func setupUserExistenceCheck() {
        guard let currentUser = userSession else { return }
        
        let db = Firestore.firestore()
        let userDocRef = db.collection("users").document(currentUser.uid)
        

        userListener = userDocRef.addSnapshotListener { [weak self] snapshot, error in
            if let error = error {
                print("Debug: Error listening for user changes: \(error.localizedDescription)")
                return
            }
            
            // If document doesn't exist or is deleted
            if snapshot == nil || !snapshot!.exists {
                // Sign out user from the app
                self?.showAccountDeletedAlert = true
                self?.signOut()
//                Task {
//                    try? await Auth.auth().signOut()
//                    DispatchQueue.main.async {
//                        self?.userSession = nil
//                    }
//                }
            }
        }
    }
    
    func startMonitoringUser() {
            setupUserExistenceCheck()
        }
        

        func cleanupUserMonitoring() {
            userListener?.remove()
            userListener = nil
        }
    
    func signInNoEmailOrPassword(credential: AuthCredential) async throws{
        do{
            let db = Firestore.firestore()
            
            let result = try await Auth.auth().signIn(with: credential)

            let firebaseUser = result.user

          
            let userDocRef = db.collection("users").document(firebaseUser.uid)

            // Check if the user document exists
            let snapshot = try await userDocRef.getDocument()
            if !snapshot.exists {
                try await firebaseUser.delete()
                self.userSession = nil
                self.currentUser = nil
                throw NSError(domain: "AuthError", code: 401, userInfo: [NSLocalizedDescriptionKey: "No account exists with the provided credentials."])
            }
            self.userSession = result.user
            // Fetch user details to update current app state
            await fetchUser()
            
            setupUserExistenceCheck()
        }catch{
            print("Debug: Unable to signIn \(error.localizedDescription)")
            self.userSession = nil
                    self.currentUser = nil
            throw error
        }
    }
    
    
    
    
    
    func signInWithGoogle() async throws {
       
        let credential = try await googleClientInit()

        return try await signInNoEmailOrPassword(credential: credential)
    }

    
    
    
    
    func signUpWithGoogle() async throws {
        let credential = try await googleClientInit()
        
        do {

            let result = try await Auth.auth().signIn(with: credential)
            let firebaseUser = result.user
            

            let user = User(
                id: firebaseUser.uid,
                fullName: firebaseUser.displayName ?? "",
                email: firebaseUser.email ?? "",
                profilePictureURL: firebaseUser.photoURL?.absoluteString,
                wardrobe: [],
                savedOutfits: [],
                shoppingPreferences: ShoppingPreferences(preferredBrands: [],
                                                         preferredColors: [],
                                                         budgetRange: "Not Set",
                                                         size: "Not Set"),
                weeklySchedule: [:],
                location: "",
                followers: [],
                following: [],
                joinedDate: Date() // Current date as join date
            )
            let encodedUser = try JSONEncoder().encode(user)
            guard let userDictionary = try JSONSerialization.jsonObject(with: encodedUser) as? [String: Any] else {
                        print("Failed to convert user to dictionary")
                        return
                    }
            let db = Firestore.firestore()
            try await db.collection("users").document(user.id).setData(userDictionary)

            self.userSession = firebaseUser
            await fetchUser()

            setupUserExistenceCheck()
            
        } catch {
 
            if let user = Auth.auth().currentUser {
                try await user.delete()
                self.signOut()
            }
            print("Debug: Failed to sign up with Google: \(error.localizedDescription)")
            throw error
        }
    }
    
    

    func signOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
            cleanupUserMonitoring()
        }catch{
            print("Debug: Unable to signout: \(error.localizedDescription)")
        }
    }
    
    
    func deleteAccount() {
        do{
            guard let user = Auth.auth().currentUser else {
                    print("Debug: No user found.")
                    return
                }
            
            let db = Firestore.firestore()
                
            // Deletes the user's document from Firestore
            db.collection("users").document(user.uid).delete { error in
                if let error = error {
                    print("Debug: Failed to delete user data from Firestore: \(error.localizedDescription)")
                } else {
                    print("Debug: User data deleted from Firestore.")
                    
                    // Proceed to delete the user from Firebase Authentication
                    user.delete { error in
                        if let error = error {
                            print("Debug: Unable to delete account: \(error.localizedDescription)")
                        } else {
                            self.currentUser = nil
                            self.userSession = nil
                            print("Debug: User account deleted successfully.")
                        }
                    }
                }
            }

        
        }
        
    }
    
    
    func fetchUser() async {
        guard let userId = Auth.auth().currentUser?.uid else {
            self.currentUser = nil
            return
        }

        do {
            let snapshot = try await Firestore.firestore().collection("users").document(userId).getDocument()
            guard let data = snapshot.data() else {
                self.currentUser = nil
                return
            }

            let user = try JSONDecoder().decode(User.self, from: JSONSerialization.data(withJSONObject: data))
            self.currentUser = user
        } catch {
            print("Debug: Failed to fetch user: \(error.localizedDescription)")
            self.currentUser = nil
        }
    }

    
}
