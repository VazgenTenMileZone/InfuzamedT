//
//  NetworkManager.swift
//  Infuzamed
//
//  Created by Vazgen on 7/30/23.
//

import Foundation

final class NetworkManager {
    static func post(urlString: String, parameters: [String: Any]  = [:]) {
        // Create the URL
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        // Convert the parameters to JSON data
        do {
            // Convert the login parameters to JSON data
            let jsonData = try JSONSerialization.data(withJSONObject: parameters)

            // Create the URL request
            var request = URLRequest(url: url)
            let token = LoginManager.shared.retrieveTokenFromKeychain() ?? ""
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = "POST"
            request.setValue("*/*", forHTTPHeaderField: "accept")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
   

            // Set the request body with the JSON data
            request.httpBody = jsonData

            // Create the URLSession configuration (optional)
            let config = URLSessionConfiguration.default

            // Create the URLSession
            let session = URLSession(configuration: config)

            // Create the data task
            let task = session.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }

                // Check if there's a response data
                if let data = data {
                    // Parse the response data (if applicable)
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        print("Response JSON: \(json)")
                    } catch {
                        print("Error parsing response: \(error.localizedDescription)")
                    }
                }
            }

            // Start the data task
            task.resume()
        } catch {
            print("Error converting parameters to JSON: \(error.localizedDescription)")
        }
    }
}
