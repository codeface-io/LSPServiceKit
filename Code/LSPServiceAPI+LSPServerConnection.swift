import SwiftLSP
import FoundationToolz

public extension LSPServiceAPI.Language.Name
{
    func connectToLSPServer() throws -> LSP.ServerConnection
    {
        try LSP.ServerConnection(synchronousConnection: connectToLSPWebSocket())
    }
}
