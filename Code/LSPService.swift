import FoundationToolz
import Foundation

/**
 A namespace that precisely mirrors the LSPService web API
 
 For example, you obtain a websocket connection to a Swift LSP server like this:
 
 ```swift
 let connection = try LSPService.api.language("Swift").websocket.connectToLSPWebSocket()
 ```
 
 You would then create an `LSP.ServerCommunicationHandler` (a.k.a. `LSP.Server`) with the connection:
 
 ```swift
 let server = LSP.Server(connection: connection, languageName: "Swift")
 ```
 
 An LSP server initialize request requires the client's process ID. Since LSPService is the actual client, you might want to request its processID and use it in the initialization request:
 
 ```swift
 // Get the process ID of LSPService
 let processID = try await LSPService.api.processID.get()

 // Initialize server with codebase folder
 _ = try await server.request(.initialize(folder: codebaseFolderURL,
                                          clientProcessID: processID))

 // Notify server that we are initialized
 try await server.notify(.initialized)
 ```
 */
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
