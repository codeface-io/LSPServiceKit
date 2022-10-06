import SwiftLSP
import FoundationToolz

public extension LSPService {
    
    static func connectToLSPServer(forLanguageNamed languageName: String) throws -> LSP.Server {
        let lspServerConnection = try api.language(languageName).websocket.connectToLSPWebSocket()
        return LSP.Server(connection: lspServerConnection,
                          languageName: languageName)
    }
}
