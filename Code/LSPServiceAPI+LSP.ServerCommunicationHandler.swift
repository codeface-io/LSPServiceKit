import SwiftLSP
import FoundationToolz

public extension LSPServiceAPI.Language.Name
{
    func connectToLSPServer() throws -> LSP.ServerCommunicationHandler
    {
        try LSP.ServerCommunicationHandler(connection: connectToLSPWebSocket())
    }
}
