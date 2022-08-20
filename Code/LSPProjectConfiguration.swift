import Foundation

public struct LSPProjectConfiguration: Codable, Equatable
{
    public init(folder: URL, language: String, codeFileEndings: [String])
    {
        self.folder = folder
        self.language = language
        self.codeFileEndings = codeFileEndings
    }
    
    public var folder: URL
    public let language: String
    public let codeFileEndings: [String]
}
