//
//  GeminiVeoStatusRequestBody.swift
//  AIProxy
//
//  Created by Vladimir Lyukov on 28.06.2025.
//

public struct GeminiVeoStatusRequestBody: Encodable {
    public let operationName: String

    public init(operationName: String) {
        self.operationName = operationName
    }
}
