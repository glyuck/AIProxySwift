//
//  GeminiVeoRequestBody.swift
//  AIProxy
//
//  Created by Vladimir Lyukov on 28.06.2025.
//

import Foundation

/// See the Veo [prompt guide](https://ai.google.dev/gemini-api/docs/video#basics)
///
/// Veo is described in a few places:
/// - https://ai.google.dev/gemini-api/docs/video
/// - https://cloud.google.com/vertex-ai/generative-ai/docs/models
/// - https://cloud.google.com/vertex-ai/generative-ai/docs/model-reference/veo-video-generation
public struct GeminiVeoRequestBody: Encodable {
    public let instances: [Instance]
    public let parameters: Parameters

    public init(
        instances: [GeminiVeoRequestBody.Instance],
        parameters: GeminiVeoRequestBody.Parameters
    ) {
        self.instances = instances
        self.parameters = parameters
    }
}

extension GeminiVeoRequestBody {
    public struct Instance: Encodable {
        public let prompt: String?
        public let image: InputMedia?
        public let lastFrame: InputMedia?
        public let video: InputMedia?

        public init(
            prompt: String? = nil,
            image: InputMedia? = nil,
            lastFrame: InputMedia? = nil,
            video: InputMedia? = nil
        ) {
            self.prompt = prompt
            self.image = image
            self.lastFrame = lastFrame
            self.video = video
        }
    }

    public struct Parameters: Encodable {
        public typealias PersonGeneration = GeminiImagenRequestBody.Parameters.PersonGeneration

        public init(
            aspectRatio: String? = nil,
            durationSeconds: Int?,
            enhancePrompt: Bool? = nil,
            generateAudio: Bool? = nil,
            negativePrompt: String? = nil,
            personGeneration: GeminiImagenRequestBody.Parameters.PersonGeneration? = nil,
            sampleCount: Int? = nil,
            seed: Int? = nil,
            storageUri: String? = nil
        ) {
            self.aspectRatio = aspectRatio
            self.durationSeconds = durationSeconds
            self.enhancePrompt = enhancePrompt
            self.generateAudio = generateAudio
            self.negativePrompt = negativePrompt
            self.personGeneration = personGeneration
            self.sampleCount = sampleCount
            self.seed = seed
            self.storageUri = storageUri
        }

        /// The following are accepted values: "16:9" (default value), "9:16"
        public let aspectRatio: String?

        /// The length of video files that you want to generate.
        /// The following are the accepted values for each model:
        /// - veo-2.0-generate-001: 5-8. The default is 8.
        /// - veo-3.0-generate-preview: 8.
        public let durationSeconds: Int?

        /// Use Gemini to enhance your prompts. The default value is true.
        public let enhancePrompt: Bool?

        /// Required for veo-3.0-generate-preview. Generate audio for the video.
        /// generateAudio isn't supported by veo-2.0-generate-001.
        public let generateAudio: Bool?

        /// A text string that describes anything you want to discourage the model from generating.
        /// For example:
        /// - "overhead lighting, bright colors"
        /// - "people, animals"
        /// - "multiple cars, wind"
        public let negativePrompt: String?

        /// The safety setting that controls whether people or face generation is allowed. One of the following:
        /// - allow_adult (default value): allow generation of adults only
        /// - dont_allow: disallows inclusion of people/faces in images
        public let personGeneration: PersonGeneration?

        /// The number of output videos requested. Accepted values are 1-4.
        public let sampleCount: Int?

        /// A number to request to make generated videos deterministic. Adding a seed number
        /// with your request without changing other parameters will cause the model to produce the same videos.
        /// The accepted range is 0-4,294,967,295.
        public let seed: Int?

        /// A Cloud Storage bucket URI to store the output video, in the format gs://BUCKET_NAME/SUBDIRECTORY.
        /// If a Cloud Storage bucket isn't provided, base64-encoded video bytes are returned in the response.
        public let storageUri: String?
    }
}

extension GeminiVeoRequestBody.Instance {
    public struct InputMedia: Encodable {
        public let data: Data
        public let mimeType: String

        private enum CodingKeys: String, CodingKey {
            case bytesBase64Encoded
            case mimeType
        }

        public init(data: Data, mimeType: String) {
            self.data = data
            self.mimeType = mimeType
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(self.data.base64EncodedString(), forKey: .bytesBase64Encoded)
            try container.encode(self.mimeType, forKey: .mimeType)
        }
    }
}
