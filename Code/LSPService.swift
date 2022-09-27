import FoundationToolz
import Foundation

public enum LSPService {
    
    public static let api = APIComponent()
    
    public struct APIComponent {
        
        internal init() {
            processID = ProcessIDComponent(rootURL: url)
        }
        
        public let processID: ProcessIDComponent
        
        public struct ProcessIDComponent {
            
            internal init(rootURL: URL) {
                url = rootURL + "processID"
            }
            
            public func get() async throws -> Int {
                try await url.get(Int.self)
            }
            
            internal let url: URL
        }
        
        public func language(_ languageName: String) -> LanguageComponent {
            LanguageComponent(url: (url + "language") + languageName)
        }
        
        public struct LanguageComponent {
            
            internal init(url: URL) {
                websocket = WebSocketComponent(url: url + "websocket")
            }
            
            public let websocket: WebSocketComponent
            
            public struct WebSocketComponent
            {
                public func connect() throws -> WebSocket {
                    try url.webSocket()
                }
                
                let url: URL
            }
        }
        
        internal let url = URL(string: "http://127.0.0.1:8080/lspservice/api")!
    }
}
