import SwiftLSP
import FoundationToolz

public extension LSPService.APIComponent.LanguageComponent.WebSocketComponent {
    
    func connectToLSPServer() throws -> LSP.ServerCommunicationHandler {
        try LSP.ServerCommunicationHandler(connection: connectToLSPWebSocket(),
                                           language: url.lastPathComponent)
    }
}
