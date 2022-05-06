import FoundationToolz
import Foundation
import SwiftObserver

public enum LSPServiceAPI
{
    struct Languages
    {
        static func get() -> Promise<Result<[String], URL.RequestError>>
        {
            Promise { url.get([String].self, handleResult: $0.fulfill) }
        }
        
        private static let url = LSPServiceAPI.url + "languages"
    }
    
    public struct ProcessID
    {
        public static func get() -> Promise<Result<Int, URL.RequestError>>
        {
            Promise { url.get(Int.self, handleResult: $0.fulfill) }
        }
        
        private static let url = LSPServiceAPI.url + "processID"
    }
    
    public struct Language
    {
        public struct Name
        {
            public init(_ languageName: String)
            {
                url = Language.url + languageName
            }
            
            func get() -> Promise<Result<String, URL.RequestError>>
            {
                Promise { url.get(String.self, handleResult: $0.fulfill) }
            }
            
            func post(_ value: String) -> Promise<Result<Void, URL.RequestError>>
            {
                Promise { url.post(value, handleResult: $0.fulfill) }
            }
            
            func connectToWebSocket() throws -> WebSocket
            {
                try (url + "websocket").webSocket()
            }
            
            private let url: URL
        }
        
        private static let url = LSPServiceAPI.url + "language"
    }
    
    private static let url = URL(string: "http://127.0.0.1:8080/lspservice/api")!
}
