//
//  UserDefaultsWrapper.swift
//  PairChecker
//
//  Created by Yunjae Kim on 2022/03/28.
//

import Foundation

@propertyWrapper
struct UserDefaultWrapper<T: Codable> {
    private let key: String
    
    var wrappedValue: T? {
        get {
            guard let data = UserDefaults.standard.object(forKey: key) as? Data else { return nil }
            return try? JSONDecoder().decode(T.self, from: data)
        }
        set {
            if newValue == nil { UserDefaults.standard.removeObject(forKey: key) }
            else {
                guard let encoded = try? JSONEncoder().encode(newValue) else { return }
                UserDefaults.standard.set(encoded, forKey: key)
            }
        }
    }
    
    init(key: String) {
        self.key = key
    }
}
