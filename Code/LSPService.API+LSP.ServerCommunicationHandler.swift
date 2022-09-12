import SwiftLSP
import FoundationToolz

public extension LSPService.API.Language {
    
    func connectToLSPServer() throws -> LSP.ServerCommunicationHandler {
        try LSP.ServerCommunicationHandler(connection: connectToLSPWebSocket(),
                                           language: language)
    }
}
