import SwiftLSP

extension LSPService.APIComponent.LanguageComponent.WebSocketComponent {
    
    func connectToLSPWebSocket() throws -> LSP.WebSocketConnection {
        try LSP.WebSocketConnection(webSocket: connect())
    }
}
