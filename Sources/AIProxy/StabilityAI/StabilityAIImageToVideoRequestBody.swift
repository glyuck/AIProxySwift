//
//  StabilityAIImageToVideoRequestBody.swift
//  AIProxy
//
//  Created by Vladimir Lyukov on 13.03.2025.
//

import Foundation

// The models below are derived from this reference:
// https://platform.stability.ai/docs/api-reference#tag/Generate/paths/~1v2beta~1stable-image~1generate~1sd3/post
public struct StabilityAIImageToVideoRequestBody: MultipartFormEncodable {

    // MARK: Required

    /// The source image used in the video generation process.
    /// - The image must be in jpeg format
    /// - Supported Dimensions:
    ///   1024x576
    ///   576x1024
    ///   768x768
    public let image: Data

    // MARK: Optional

    /// How strongly the video sticks to the original image. Use lower values
    /// to allow the model more freedom to make changes and higher values
    /// to correct motion distortions.
    /// Possible values: `[ 0.0 .. 10.0 ]`
    /// Default value: `1.8`
    public let cfgScale: Double?

    /// Lower values generally result in less motion in the output video, while higher values generally result in more motion. This parameter corresponds to the motion_bucket_id parameter from the paper.
    /// Possible values: `[ 1 .. 255 ]`
    /// Default value: `127`
    public let motionBucketId: Int?

    /// A specific value that is used to guide the 'randomness' of the generation. (Omit this
    /// parameter or pass `0` to use a random seed.)
    /// Possible values: `[ 0 .. 4294967294 ]`
    public let seed: Int?

    public var formFields: [FormField] {
        let theFields: [FormField] = [
            .fileField(name: "image", content: image, contentType: "image/jpeg", filename: "aiproxy.jpg"),
            self.cfgScale.flatMap { .textField(name: "cfg_scale", content: String($0)) },
            self.motionBucketId.flatMap { .textField(name: "motion_bucket_id", content: String($0)) },
            self.seed.flatMap { .textField(name: "seed", content: String($0)) },
        ].compactMap { $0 }

        return theFields

    }

    // This memberwise initializer is autogenerated.
    // To regenerate, use `cmd-shift-a` > Generate Memberwise Initializer
    // To format, place the cursor in the initializer's parameter list and use `ctrl-m`
    public init(
        image: Data,
        cfgScale: Double? = nil,
        motionBucketId: Int? = nil,
        seed: Int? = nil
    ) {
        self.image = image
        self.cfgScale = cfgScale
        self.motionBucketId = motionBucketId
        self.seed = seed
    }
}
