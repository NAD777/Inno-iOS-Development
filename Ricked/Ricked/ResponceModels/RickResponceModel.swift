//
//  RickResponceModel.swift
//  Ricked
//
//  Created by Антон Нехаев on 30.06.2023.
//

import Foundation


// MARK: - Welcome
struct CharacterResponseWelcome: Codable {
    let info: Info
    let results: [ResponseResult]
}

// MARK: - Info
struct Info: Codable {
    let count, pages: Int
    let next: String
    let prev: JSONNull?
}

// MARK: - Result
struct ResponseResult: Codable {
    let id: Int
    let name, species, type: String
    let status: ResponseStatus
    let gender: ResponseGender
    let origin, location: Location
    let image: String
    let episode: [String]
    let url: String
    let created: String
}

// MARK: - Location
struct Location: Codable {
    let name: String
    let url: String
}

enum ResponseGender: Codable {
    case female
    case male
    case genderless
    case unknown
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        
        switch rawValue {
        case "Female": self = .female
        case "Male": self = .male
        case "Genderless": self = .genderless
        case "unknown": self = .unknown
        default: throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid gender value")
        }
    }
}

enum ResponseStatus: Codable {
    case alive
    case dead
    case unknown
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        
        switch rawValue {
        case "Alive": self = .alive
        case "Dead": self = .dead
        case "unknown": self = .unknown
        default: throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid status value")
        }
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {
    
    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }
    
    public var hashValue: Int {
        return 0
    }
    
    public init() {}
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
