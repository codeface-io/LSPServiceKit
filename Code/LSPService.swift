import FoundationToolz
import Foundation
import SwiftObserver

public struct LSPService {
    
    public static let api = API()
    
    private init() {}
    
    public struct API {
        
        internal init() {
            languages = Languages(rootURL: url)
            processID = ProcessID(rootURL: url)
        }
        
        public let languages: Languages
        
        public struct Languages {
            
            internal init(rootURL: URL) {
                url = rootURL + "languages"
            }
            
            public func get() -> Promise<Result<[String], URL.RequestError>> {
                Promise { url.get([String].self, handleResult: $0.fulfill) }
            }
            
            private let url: URL
        }
        
        public let processID: ProcessID
        
        public struct ProcessID {
            
            internal init(rootURL: URL) {
                url = rootURL + "processID"
            }
            
            public func get() -> Promise<Result<Int, URL.RequestError>> {
                Promise { url.get(Int.self, handleResult: $0.fulfill) }
            }
            
            private let url: URL
        }
        
        public func language(_ languageName: String) -> Language {
            Language(url: (url + "language") + languageName)
        }
        
        public struct Language {
            
            internal init(url: URL) {
                self.url = url
            }
            
            public func get() -> Promise<Result<String, URL.RequestError>> {
                Promise { url.get(String.self, handleResult: $0.fulfill) }
            }
            
            public func post(_ value: String) -> Promise<Result<Void, URL.RequestError>> {
                Promise { url.post(value, handleResult: $0.fulfill) }
            }
            
            public func connectToWebSocket() throws -> WebSocket {
                try (url + "websocket").webSocket()
            }
            
            private let url: URL
        }
        
        private let url = URL(string: "http://127.0.0.1:8080/lspservice/api")!
    }
}
