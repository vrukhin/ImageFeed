import Foundation

let AccessKey = "XpPomELrVMrC-Nq2rveKG6hdHbH0rMkQnVN4SF5M5vc"
let SecretKey = "lLIDFsCxLBx3_WnRiydhODcF5f9IcqtQ1MQ-IOKDfIk"
let RedirectURI = "urn:ietf:wg:oauth:2.0:oob"
let AccessScope = "public+read_user+write_likes"

let DefaultBaseUrl = URL(string: "https://api.unsplash.com")!
let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseUrl: URL
    let authURLString: String
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(
            accessKey: AccessKey,
            secretKey: SecretKey,
            redirectURI: RedirectURI,
            accessScope: AccessScope,
            defaultBaseUrl: DefaultBaseUrl,
            authURLString: UnsplashAuthorizeURLString)
    }
    
    init(
        accessKey: String,
        secretKey: String,
        redirectURI: String,
        accessScope: String,
        defaultBaseUrl: URL,
        authURLString: String
    ) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseUrl = defaultBaseUrl
        self.authURLString = authURLString
    }
}
