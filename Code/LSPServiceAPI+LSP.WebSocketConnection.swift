import SwiftLSP

extension LSPServiceAPI.Language.Name
{
    func connectToLSPWebSocket() throws -> LSP.WebSocketConnection
    {
        try LSP.WebSocketConnection(webSocket: connectToWebSocket())
    }
}
