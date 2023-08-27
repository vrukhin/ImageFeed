//
//  OAuth2Service.swift
//  Image Feed
//
//  Created by Павел Врухин on 27.06.2023.
//

import Foundation
import WebKit

final class OAuth2Service {
    
    static let shared = OAuth2Service()
    private let tokenStorage = OAuthTokenStorage.shared
    
    private let urlSession = URLSession.shared
    
    private var task: URLSessionTask?
    private var lastCode: String?
    
    private (set) var authtoken: String? {
        get {
            return tokenStorage.token
        }
        set {
            return tokenStorage.token = newValue!
        }
    }
    
    func clean() {
       HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
       WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
          records.forEach { record in
             WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
          }
       }
        tokenStorage.token = nil
    }
    
    private init() { }
    
    func fetchAuthToken(
        _ code: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        assert(Thread.isMainThread)
        if lastCode == code { return }
        task?.cancel()
        lastCode = code
        let request = authTokenRequest(code: code)
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let body):
                let authToken = body.accessToken
                self.authtoken = authToken
                completion(.success(authToken))
                self.task = nil
            case .failure(let error):
                self.lastCode = nil
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
}

extension OAuth2Service {
    
    private func authTokenRequest(code: String) -> URLRequest {
        URLRequest.makeHTTPRequest(
            path: "/oauth/token"
            + "?client_id=\(AuthConfiguration.standard.accessKey)"
            + "&&client_secret=\(AuthConfiguration.standard.secretKey)"
            + "&&redirect_uri=\(AuthConfiguration.standard.redirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            httpMethod: "POST",
            baseURL: URL(string: "https://unsplash.com")!
        )
    }
}
