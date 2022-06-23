//
//  UserModel.swift
//  FavoritePages
//
//  Created by Mert Karahan on 2.06.2022.
//

import Foundation

struct FavoriteModel: Codable {
    let pageUrl: String
    var pageTitle: String
}

extension Encodable {
    var dictionary: [String: Any]? {
//        Struct'ı encode edip dictionary tipine çeviren kod
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}
