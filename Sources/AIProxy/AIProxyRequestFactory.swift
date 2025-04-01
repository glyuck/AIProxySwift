//
//  AIProxyRequestFactory.swift
//  AIProxy
//
//  Created by Vladimir Lyukov on 03.04.2025.
//

import Foundation

protocol AIProxyRequestFactory {
    func request(
        path: String,
        body: Data?,
        verb: AIProxyHTTPVerb,
        contentType: String?,
        additionalHeaders: [String: String]
    ) async throws -> URLRequest
}

class AIProxyProxiedRequestFactory: AIProxyRequestFactory {
    private let partialKey: String
    private let serviceURL: String
    private let clientID: String?

    internal init(partialKey: String, serviceURL: String, clientID: String?) {
        self.partialKey = partialKey
        self.serviceURL = serviceURL
        self.clientID = clientID
    }

    func request(
        path: String,
        body: Data?,
        verb: AIProxyHTTPVerb,
        contentType: String? = nil,
        additionalHeaders: [String: String] = [:]
    ) async throws -> URLRequest {
        try await AIProxyURLRequest.create(
            partialKey: self.partialKey,
            serviceURL: self.serviceURL,
            clientID: self.clientID,
            proxyPath: path,
            body: body,
            verb: verb,
            contentType: contentType,
            additionalHeaders: additionalHeaders
        )
    }
}

class AIProxyDirectRequestFactory: AIProxyRequestFactory {
    let baseURL: String
    let additionalHeaders: [String: String]

    init(baseURL: String, additionalHeaders: [String : String]) {
        self.baseURL = baseURL
        self.additionalHeaders = additionalHeaders
    }

    func request(
        path: String,
        body: Data?,
        verb: AIProxyHTTPVerb,
        contentType: String? = nil,
        additionalHeaders: [String: String] = [:]
    ) async throws -> URLRequest {
        try AIProxyURLRequest.createDirect(
            baseURL: self.baseURL,
            path: path,
            body: body,
            verb: verb,
            contentType: contentType,
            additionalHeaders: self.additionalHeaders.merging(additionalHeaders) { _, new in new }
        )
    }
}
