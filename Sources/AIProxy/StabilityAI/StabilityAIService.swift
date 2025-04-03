//
//  StabilityAIService.swift
//
//
//  Created by Lou Zell on 12/15/24.
//

import Foundation

public class StabilityAIService: ProxiedService {
    let requestFactory: AIProxyRequestFactory

    init(requestFactory: AIProxyRequestFactory) {
        self.requestFactory = requestFactory
    }

    /// Initiates a request to /v2beta/stable-image/generate/ultra
    ///
    /// - Parameters:
    ///   - body: The request body to send to aiproxy and StabilityAI. See this reference:
    ///           https://platform.stability.ai/docs/api-reference#tag/Generate/paths/~1v2beta~1stable-image~1generate~1ultra/post
    /// - Returns: The response as StabilityAIUltraResponse, wth image binary data stored on
    ///            the `imageData` property
    public func ultraRequest(
        body: StabilityAIUltraRequestBody
    ) async throws -> StabilityAIImageResponse {
        return try await self.stabilityRequestCommon(
            body: body,
            path: "/v2beta/stable-image/generate/ultra"
        )
    }

    /// Initiates a request to /v2beta/stable-image/generate/sd3
    ///
    /// - Parameters:
    ///   - body: The request body to send to aiproxy and StabilityAI. See this reference:
    ///           https://platform.stability.ai/docs/api-reference#tag/Generate/paths/~1v2beta~1stable-image~1generate~1sd3/post
    /// - Returns: The response as StabilityAIUltraResponse, wth image binary data stored on
    ///            the `imageData` property
    public func stableDiffusionRequest(
        body: StabilityAIStableDiffusionRequestBody
    ) async throws -> StabilityAIImageResponse {
        return try await self.stabilityRequestCommon(
            body: body,
            path: "/v2beta/stable-image/generate/sd3"
        )
    }

    public func stabilityRequestCommon<T: MultipartFormEncodable>(
        body: T,
        path: String
    ) async throws -> StabilityAIImageResponse {
        let boundary = UUID().uuidString
        let request = try await requestFactory.request(
            path: path,
            body: formEncode(body, boundary),
            verb: .post,
            contentType: "multipart/form-data; boundary=\(boundary)",
            additionalHeaders: ["Accept": "image/*"]
        )
        let (data, httpResponse) = try await BackgroundNetworker.makeRequestAndWaitForData(
            self.urlSession,
            request
        )
        return StabilityAIImageResponse(
            imageData: data,
            contentType: httpResponse.allHeaderFields["Content-Type"] as? String,
            finishReason: httpResponse.allHeaderFields["finish-reason"] as? String,
            seed: httpResponse.allHeaderFields["seed"] as? String
        )
    }
    
    /// Initiates a request to /v2beta/image-to-video
    /// - Parameters:
    ///   - body: The request body to send to aiproxy and StabilityAI. See this reference:
    ///           https://platform.stability.ai/docs/api-reference#tag/Image-to-Video/paths/~1v2beta~1image-to-video/post
    /// - Returns: The response as StabilityAIImageToVideoResponseBody, with video generation identifier
    public func imageToVideoRequest(
        body: StabilityAIImageToVideoRequestBody
    ) async throws -> StabilityAIImageToVideoResponseBody {
        let boundary = UUID().uuidString
        let request = try await requestFactory.request(
            path: "v2beta/image-to-video",
            body: formEncode(body, boundary),
            verb: .post,
            contentType: "multipart/form-data; boundary=\(boundary)",
            additionalHeaders: [:]
        )
        return try await makeRequestAndDeserializeResponse(request)
    }

    /// Initiates a request to /v2beta/image-to-video/result/<generationId>
    /// - Parameters:
    ///   - generationId: The identifier for the video generation task
    /// - Returns: The video data as Data, or nil if the generation is still in progress
    public func imageToVideoResultRequest(
        generationId: String
    ) async throws -> Data? {
        let request = try await requestFactory.request(
            path: "v2beta/image-to-video/result/\(generationId)",
            body: nil,
            verb: .get,
            contentType: nil,
            additionalHeaders: ["Accept": "video/*"]
        )
        let (data, httpResponse) = try await BackgroundNetworker.makeRequestAndWaitForData(
            self.urlSession,
            request
        )
        if httpResponse.statusCode == 202 {
            return nil
        } else if httpResponse.statusCode == 200 {
            return data
        }
        throw AIProxyError.unsuccessfulRequest(
            statusCode: httpResponse.statusCode,
            responseBody: String(data: data , encoding: .utf8) ?? ""
        )
    }
    
    public func editInpaintRequest(
        body: StabilityAIEditInpaintRequestBody
    ) async throws -> StabilityAIImageResponse {
        return try await self.stabilityRequestCommon(
            body: body,
            path: "/v2beta/stable-image/edit/inpaint"
        )
    }

    public func editEraseRequest(
        body: StabilityAIEditEraseRequestBody
    ) async throws -> StabilityAIImageResponse {
        return try await self.stabilityRequestCommon(
            body: body,
            path: "/v2beta/stable-image/edit/erase"
        )
    }
}
