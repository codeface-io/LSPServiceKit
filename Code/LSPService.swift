import FoundationToolz
import Foundation

public struct LSPService {
    
    internal static let api = API()
    
    private init() {}
    
    internal struct API {
        
        internal init() {
            processID = ProcessID(rootURL: url)
        }
        
        public let processID: ProcessID
        
        public struct ProcessID {
            
            internal init(rootURL: URL) {
                url = rootURL + "processID"
            }
            
            public func get() async throws -> Int {
                try await url.get(Int.self)
            }
            
            private let url: URL
        }
        
        public func language(_ languageName: String) -> Language {
            Language(url: (url + "language") + languageName,
                     language: languageName)
        }
        
        public struct Language {
            
            internal init(url: URL, language: String) {
                self.url = url
                self.language = language
            }
            
            public func connectToWebSocket() throws -> WebSocket {
                try (url + "websocket").webSocket()
            }
            
            private let url: URL
            internal let language: String
        }
        
        private let url = URL(string: "http://127.0.0.1:8080/lspservice/api")!
    }
}
