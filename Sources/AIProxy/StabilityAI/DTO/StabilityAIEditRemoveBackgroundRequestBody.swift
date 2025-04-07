//
//  StabilityAIEditRemoveBackgroundRequestBody.swift
//  AIProxy
//
//  Created by Vladimir Lyukov on 04.04.2025.
//

import Foundation

// The models below are derived from this reference:
// https://platform.stability.ai/docs/api-reference#tag/Edit/paths/~1v2beta~1stable-image~1edit~1remove-background/post
public struct StabilityAIEditRemoveBackgroundRequestBody: MultipartFormEncodable {

    // MARK: Required

    /// The image you wish to remove the background from.
    /// - Supported Formats:
    ///   jpeg
    ///   png
    ///   webp
    /// - Validation Rules:
    ///   Every side must be at least 64 pixels
    ///   Total pixel count must be between 4,096 and 9,437,184 pixels
    public let image: Data

    // MARK: Optional

    /// Dictates the `content-type` of the generated image
    /// Defaults to `png`
    public let outputFormat: StabilityAIEditRemoveBackgroundOutputFormat?

    public var formFields: [FormField] {
        let theFields: [FormField] = [
            .fileField(name: "image", content: image, contentType: "image/jpeg", filename: "aiproxy.jpg"),
            self.outputFormat.flatMap { .textField(name: "output_format", content: $0.rawValue) },
        ].compactMap { $0 }

        return theFields
    }

    public init(
        image: Data,
        outputFormat: StabilityAIEditRemoveBackgroundOutputFormat? = nil
    ) {
        self.image = image
        self.outputFormat = outputFormat
    }
}

public enum StabilityAIEditRemoveBackgroundOutputFormat: String {
    case png
    case webp
}
