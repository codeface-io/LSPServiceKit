import SwiftLSP
import FoundationToolz
import Foundation
import SwiftyToolz

public extension LSP {
    
    class ServerManager: ObservableObject {
        
        public static let shared = ServerManager()
        
        private init() {}
        
        public func initializeServer(for codebase: CodebaseLocation) async throws -> LSP.Server {
            serverIsWorking = false
            let server = try await createServer(forLanguageNamed: codebase.languageName)
            let processID = try await LSPService.api.processID.get()
            _ = try await server.request(.initialize(folder: codebase.folder, clientProcessID: processID))
            try await server.notify(.initialized)
            serverIsWorking = true
            return server
        }
        
        private func createServer(forLanguageNamed languageName: String) async throws -> LSP.Server {
            
            let server = try LSPService.connectToLSPServer(forLanguageNamed: languageName)
            
            await server.handleNotificationFromServer { notification in
                //            log("Server sent notification:\n\(notification.method)\n\(notification.params?.description ?? "nil params")")
            }
            
            await server.handleErrorOutputFromServer { _ in
                //            log("\(language.capitalized) language server sent message via stdErr:\n\($0)")
            }
            
            await server.handleConnectionShutdown { error in
                log(error.readable)
                self.serverIsWorking = false
            }
            
            return server
        }
        
        @Published public var serverIsWorking = false
    }
}
