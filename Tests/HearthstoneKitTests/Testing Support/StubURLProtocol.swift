//
//  StubURLProtocol.swift
//  HearthstoneKit_Tests
//

import Foundation

/// Intercepts requests made through a session from `makeSession(statusCode:body:)`, records them, and replies with a canned response
/// so request-building can be tested without the network.
final class StubURLProtocol: URLProtocol {
    /// Records the requests sent through one stubbed session.
    final class Stub: @unchecked Sendable {
        let statusCode: Int
        let body: Data
        private let lock = NSLock()
        private var recordedRequests: [URLRequest] = []

        init(statusCode: Int, body: Data) {
            self.statusCode = statusCode
            self.body = body
        }

        var requests: [URLRequest] { lock.withLock { recordedRequests } }

        fileprivate func record(_ request: URLRequest) {
            lock.withLock { recordedRequests.append(request) }
        }
    }

    // Tests run in parallel, so each session tags its requests with an ID that maps back to its own stub.
    private static let stubIDHeader = "X-Stub-ID"
    private static let lock = NSLock()
    nonisolated(unsafe) private static var stubs: [String: Stub] = [:]

    static func makeSession(statusCode: Int = 200, body: Data = Data("{}".utf8)) -> (URLSession, Stub) {
        let id = UUID().uuidString
        let stub = Stub(statusCode: statusCode, body: body)
        lock.withLock { stubs[id] = stub }

        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [StubURLProtocol.self]
        configuration.httpAdditionalHeaders = [stubIDHeader: id]
        return (URLSession(configuration: configuration), stub)
    }

    override class func canInit(with request: URLRequest) -> Bool { true }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        guard let id = request.value(forHTTPHeaderField: Self.stubIDHeader),
              let stub = Self.lock.withLock({ Self.stubs[id] }),
              let url = request.url,
              let response = HTTPURLResponse(url: url, statusCode: stub.statusCode, httpVersion: nil, headerFields: nil) else {
            client?.urlProtocol(self, didFailWithError: URLError(.unsupportedURL))
            return
        }
        stub.record(request)
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: stub.body)
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}
