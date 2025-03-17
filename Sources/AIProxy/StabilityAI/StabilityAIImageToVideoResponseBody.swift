//
//  StabilityAIImageToVideoResponseBody.swift
//  AIProxy
//
//  Created by Vladimir Lyukov on 13.03.2025.
//

import Foundation

public struct StabilityAIImageToVideoResponseBody: Decodable {
    /// The id of a generation, typically used for async generations, that can
    /// be used to check the status of the generation or retrieve the result.
    /// String (GenerationID) = 64 characters
    public let id: String
}
