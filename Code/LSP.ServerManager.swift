import SwiftLSP
import FoundationToolz
import Foundation
import SwiftyToolz

public extension LSP {
    
    /**
     Creates a fully initialized `LSP.Server` and indicates wheter an active server is working
     */
    class ServerManager: ObservableObject {
        
        public static let shared = ServerManager()
        
        private init() {}
        
        // TODO: test this interaction with the server, is this test possible without "dependency injection", i.e. how would we model the interaction logic in order to extract it? return some sort of "workflow" or "interaction" type??
        
        // TODO: how do we link to `LSP.CodebaseLocation` in the documentation comments? ``LSP/CodebaseLocation`` does not work, maybe because LSP is defined in a different module ...
        
        /**
         Creates a fully initialized `LSP.Server` for an `LSP.CodebaseLocation`
         */
        public func initializeServer(for codebase: CodebaseLocation) async throws -> LSP.Server {
            serverIsWorking = false
            
            let server = try await createServer(forLanguageNamed: codebase.languageName)
            
            /// we need to wait a little before sending our first request in order to increase the probability that LSPService had a chance to actually configure the websocket. this is because vapor does not allow LSPService to configure the websocket before returning the websocket connection. for all intents and purposes, this is a Vapor bug.
            try await Task.sleep(nanoseconds: 100_000_000)
            
            _ = try await server.request(.initialize(folder: codebase.folder))
            
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
        
        /**
         Indicates whether a server has been initialized and has not produced any errors yet
         
         This can be used to inform the whole application about the current availability of an LSP server. Clients may not just read but also set the property, in particular when a problem has occured.
         */
        @Published public var serverIsWorking = false
    }
}
