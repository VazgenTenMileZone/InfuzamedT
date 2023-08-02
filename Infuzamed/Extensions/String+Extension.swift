//
//  String+Extension.swift
//  Infuzamed
//
//  Created by Vazgen on 8/3/23.
//

import Foundation

extension String {
    func jsonWithJWT() -> [String: Any]? {
        
        let parts = self.components(separatedBy: ".")

        guard parts.count == 3 else { return nil}

        let header = parts[0]
        let payload = parts[1]
        let signature = parts[2]
        
        var stringTobeEncoded = payload.replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        let paddingCount = payload.count % 4
        for _ in 0..<paddingCount {
            stringTobeEncoded += "="
        }
        
        guard let payloadData = Data(base64Encoded: stringTobeEncoded) else {
            fatalError("payload could not converted to data")
        }
            return try? JSONSerialization.jsonObject(
            with: payloadData,
            options: []) as? [String: Any]
    }
}
