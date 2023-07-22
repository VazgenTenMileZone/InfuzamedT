//
//  LoginManager.swift
//  Infuzamed
//
//  Created by Vazgen on 7/13/23.
//

import Foundation
import Security

final class LoginManager: NSObject {
    static let shared = LoginManager()
    
    override private init() {
        super.init()
    }
    
    func login(login: String?, password: String?, success: @escaping (Bool) -> ()) {
        guard let login, let password, !login.isEmpty, !password.isEmpty else { return }
        let loginURL = URL(string: "http://ec2-54-215-231-89.us-west-1.compute.amazonaws.com:8085/api/oauth/token")!

        var loginRequest = URLRequest(url: loginURL)
        loginRequest.httpMethod = "POST" // Adjust the HTTP method as needed
        loginRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        loginRequest.setValue("*/*", forHTTPHeaderField: "accept")

        let loginParameters: [String: Any] = [
            "password": password,
            "userName": login
        ]

        // Convert the login parameters to JSON data
        if let jsonData = try? JSONSerialization.data(withJSONObject: loginParameters) {
            // Set the request body with the JSON data
            loginRequest.httpBody = jsonData
        }

        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        
        let task = session.dataTask(with: loginRequest) { [weak self] data, response, error in
            if let error = error {
                print("Error: \(error)")
                DispatchQueue.main.async {
                    success(false)
                }
                return
            }

            // Handle the response and data received
            if let httpResponse = response as? HTTPURLResponse {
                print("Status code: \(httpResponse.statusCode)")

                if let responseData = data {
                    // Parse and use the response data as needed
                    // Example: Convert the response data to a JSON object
                    if let json = try? JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] {
                        // Process the JSON response
                        DispatchQueue.main.async {
                            print("Response JSON: \(json)")
                            guard let accessToken = json["accessToken"] as? String else {
                                success(false)
                                return
                            }
                            self?.saveTokenToKeychain(token: accessToken)
                            success(true)
                        }
                    }
                }
            }
        }
        // Start the URLSession data task
        task.resume()
    }
    
    // Function to save the token in the Keychain
    func saveTokenToKeychain(token: String) {
        let serviceName = "InfuzamedService" // Provide a unique service name for your app
        
        if let tokenData = token.data(using: .utf8) {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: serviceName,
                kSecValueData as String: tokenData,
                kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked // Adjust the accessibility level as needed
            ]
            
            let status = SecItemAdd(query as CFDictionary, nil)
            
            if status == errSecSuccess {
                print("Token saved to Keychain successfully")
            } else {
                print("Failed to save token to Keychain with status: \(status)")
            }
        }
    }
    
    func retrieveTokenFromKeychain() -> String? {
        let serviceName = "InfuzamedService" // Same service name used when saving
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        if status == errSecSuccess,
           let tokenData = result as? Data,
           let tokenString = String(data: tokenData, encoding: .utf8)
        {
            return tokenString
        } else {
            print("Failed to retrieve token from Keychain with status: \(status)")
            return nil
        }
    }
}
