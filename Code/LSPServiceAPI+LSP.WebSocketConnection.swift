import SwiftLSP

extension LSPService.API.Language
{
    func connectToLSPWebSocket() throws -> LSP.WebSocketConnection
    {
        try LSP.WebSocketConnection(webSocket: connectToWebSocket())
    }
}
