//
//  GeminiVeoResponseBody.swift
//  AIProxy
//
//  Created by Vladimir Lyukov on 28.06.2025.
//

public struct GeminiVeoResponseBody: Decodable {
    public let name: String

    public init(name: String) {
        self.name = name
    }
}
