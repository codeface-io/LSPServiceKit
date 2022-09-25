import SwiftLSP
import FoundationToolz
import Foundation
import SwiftyToolz

public extension LSP {
    
    class ServerManager: ObservableObject {
        
        public static let shared = ServerManager()
        
        private init() {}
        
        public func getServer(for codebase: CodebaseLocation) async throws -> LSP.ServerCommunicationHandler {
            
            if let activeCodebase = codebaseLocation, activeCodebase == codebase,
                let server, serverIsWorking {
                return server
            }
            
            reset()
            
            // create new initialized server
            let newServer = try await createServer(forLanguage: codebase.language)
            let processID = try await LSPService.api.processID.get()
            _ = try await newServer.request(.initialize(folder: codebase.folder,
                                                        clientProcessID: processID))
            try await newServer.notify(.initialized)
            
            // set result
            codebaseLocation = codebase
            server = newServer
            serverIsWorking = true
            
            return newServer
        }
        
        private func createServer(forLanguage language: String) async throws -> LSP.ServerCommunicationHandler {
            
            let server = try LSPService.api.language(language.lowercased()).connectToLSPServer()
            
            await server.handleNotificationFromServer { notification in
                //            log("Server sent notification:\n\(notification.method)\n\(notification.params?.description ?? "nil params")")
            }
            
            await server.handleErrorOutputFromServer { _ in
                //            log("\(language.capitalized) language server sent message via stdErr:\n\($0)")
            }
            
            await server.handleConnectionShutdown { error in
                log(error.readable)
                self.reset()
            }
            
            return server
        }
        
        private func reset()
        {
            serverIsWorking = false
            codebaseLocation = nil
            server = nil
        }
        
        @Published public var serverIsWorking = false
        private var codebaseLocation: CodebaseLocation? = nil
        private var server: LSP.ServerCommunicationHandler? = nil
    }
}
