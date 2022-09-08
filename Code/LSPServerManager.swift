import SwiftLSP
import FoundationToolz
import Foundation
import SwiftyToolz

public class LSPServerManager: ObservableObject {
    
    public static let shared = LSPServerManager()
    
    private init() {}
    
    public func getServer(for project: ProjectLocation,
                          handleError: @escaping (Error) -> Void = { log($0) }) async throws -> LSP.ServerCommunicationHandler {
        
        if let activeProject = self.project,
           activeProject == project,
           let server = server,
           let initialization = initialization {
            // server has been created and initialization started for this project
            try await initialization.assumeSuccess()
            return server
        }
        
        // we have to recreate and initialize the server
        self.project = project
        
        let createdServer = try createServer(language: project.language,
                                             handleError: handleError)
        server = createdServer
        
        let createdInitialization = Self.initialize(createdServer,
                                                    for: project)
        initialization = createdInitialization
        
        serverIsWorking = true
        
        try await createdInitialization.assumeSuccess()
        
        return createdServer
    }
    
    private func createServer(language: String,
                              handleError: @escaping (Error) -> Void) throws -> LSP.ServerCommunicationHandler {
        
        let server = try LSPService.api.language(language.lowercased()).connectToLSPServer()
        
        server.serverDidSendNotification = { notification in
            //            log("Server sent notification:\n\(notification.method)\n\(notification.params?.description ?? "nil params")")
        }
        
        server.serverDidSendErrorOutput = { _ in
            //            log("\(language.capitalized) language server sent message via stdErr:\n\($0)")
        }
        
        server.connection.didSendError = { [weak self, weak server] error in
            // TODO: do we (why don't we?) need to nil the server after the websocket sent an error, so that the server gets recreated and the websocket connection reinstated?? do we need to close the websocket connection?? ... maybe the LSPServerConnection protocol needs to expose more functions for handling the connection itself, like func closeConnection() and var connectionDidClose ...
            
            server?.connection.close()
            self?.serverIsWorking = false
            
            handleError(error)
        }
        
        server.connection.didClose = { [weak self] in
            log(warning: "LSP websocket connection did close")
            
            self?.serverIsWorking = false
        }
        
        return server
    }
    
    private static func initialize(_ server: LSP.ServerCommunicationHandler,
                                   for project: ProjectLocation) -> Task<Void, Error> {
        Task {
            let processID = try await LSPService.api.processID.get()
            
            let _ = try await server.request(.initialize(folder: project.folder,
                                                         clientProcessID: processID))
            
            //            try log(initializeResult: initializeResult)
            
            try await server.notify(.initialized)
        }
    }
    
    private var project: ProjectLocation? = nil
    private var initialization: Task<Void, Error>? = nil
    private var server: LSP.ServerCommunicationHandler? = nil
    
    @Published public var serverIsWorking = false
}

public extension Task where Success == Void
{
    func assumeSuccess() async throws { try await value }
}
