import SwiftLSP
import FoundationToolz
import Foundation
import SwiftyToolz

public extension LSP {
    
    class ServerManager: ObservableObject {
        
        public static let shared = ServerManager()
        
        private init() {}
        
        public func getServer(for codebase: CodebaseLocation,
                              handleConnectionError: @escaping (Error) -> Void = { log($0) }) async throws -> LSP.ServerCommunicationHandler {
            
            if let activeCodebase = self.codebaseLocation,
               activeCodebase == codebase,
               let server = server,
               let initialization {
                // server has been created and initialization started for this codebase
                try await initialization.assumeSuccess()
                return server
            }
            
            // we have to recreate and initialize the server
            self.codebaseLocation = codebase
            
            let createdServer = try await createServer(language: codebase.language,
                                                       handleConnectionError: handleConnectionError)
            server = createdServer
            
            let createdInitialization = Self.initialize(createdServer, for: codebase)
            initialization = createdInitialization
            
            serverIsWorking = true
            
            try await createdInitialization.assumeSuccess()
            
            return createdServer
        }
        
        private func createServer(language: String,
                                  handleConnectionError: @escaping (Error) -> Void) async throws -> LSP.ServerCommunicationHandler {
            
            let server = try LSPService.api.language(language.lowercased()).connectToLSPServer()
            
            await server.setNotificationHandler { notification in
                //            log("Server sent notification:\n\(notification.method)\n\(notification.params?.description ?? "nil params")")
            }
            
            await server.setErrorOutputHandler { _ in
                //            log("\(language.capitalized) language server sent message via stdErr:\n\($0)")
            }
            
            await server.connection.didSendError = { error in
                // TODO: do we (why don't we?) need to nil the server after the websocket sent an error, so that the server gets recreated and the websocket connection reinstated?? do we need to close the websocket connection?? ... maybe the LSPServerConnection protocol needs to expose more functions for handling the connection itself, like func closeConnection() and var connectionDidClose ...
                
                Task {
                    await server.connection.close()
                    self.serverIsWorking = false
                    handleConnectionError(error)
                }
            }
            
            await server.connection.didClose = { [weak self] in
                log(warning: "LSP websocket connection did close")
                
                self?.serverIsWorking = false
            }
            
            return server
        }
        
        private static func initialize(_ server: LSP.ServerCommunicationHandler,
                                       for codebase: CodebaseLocation) -> Task<Void, Error> {
            Task {
                let processID = try await LSPService.api.processID.get()
                
                let _ = try await server.request(.initialize(folder: codebase.folder,
                                                             clientProcessID: processID))
                
                //            try log(initializeResult: initializeResult)
                
                try await server.notify(.initialized)
            }
        }
        
        private var codebaseLocation: CodebaseLocation? = nil
        private var initialization: Task<Void, Error>? = nil
        private var server: LSP.ServerCommunicationHandler? = nil
        
        @Published public var serverIsWorking = false
    }
}
