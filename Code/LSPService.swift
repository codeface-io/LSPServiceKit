import FoundationToolz
import Foundation
import SwiftyToolz

/**
 A namespace that mirrors the (now tiny) LSPService web API
 
 Obtain a websocket connection to a Swift LSP server like this:
 
 ```swift
 let connection = try LSPService.api.language("Swift").websocket.connectToLSPWebSocket()
 ```
 
 Then create an `LSP.ServerCommunicationHandler` (a.k.a. `LSP.Server`) with the connection:
 
 ```swift
 let server = LSP.Server(connection: connection, languageName: "Swift")
 ```
 
 Or do both the above steps in one line:
 
 ```swift
 let server = try LSPService.connectToLSPServer(forLanguageNamed: "Swift")
 ```
 */
public enum LSPService {

    public static func isRunning() async -> Bool {
        do {
            _ = try await get()
            return true
        } catch {
            log("LSPServer is not running.")
            return false
        }
    }
    
    public static func get() async throws -> String {
        let dataResult = try await url.get()
        
        guard let stringResult = dataResult.utf8String else {
            throw "Requested data cannot be interpreted as UTF-8 string."
        }
        
        return stringResult
    }
    
    public static let api = APIComponent()
    
    public struct APIComponent {
        
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
        
        internal let url = LSPService.url + "lspservice/api"
    }
    
    internal static let url = URL(string: "http://127.0.0.1:8080")!
}
