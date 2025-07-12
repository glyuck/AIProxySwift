//
//  GeminiVeoStatusResponseBody.swift
//  AIProxy
//
//  Created by Vladimir Lyukov on 28.06.2025.
//

import Foundation

public struct GeminiVeoStatusResponseBody: Decodable {
    public let name: String
    public let done: Bool?
    public let response: Response?
}

extension GeminiVeoStatusResponseBody {
    public struct Response: Decodable {
        public struct GenerateVideoResponse: Decodable {
            public struct GeneratedSample: Decodable {
                public struct Video: Decodable {
                    public let uri: URL?
                }

                public let video: Video
            }

            public let generatedSamples: [GeneratedSample]?
        }

        public let generateVideoResponse: GenerateVideoResponse?
    }
}
