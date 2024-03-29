@testable import LSPServiceKit
import SwiftLSP
import XCTest

final class LSPServiceKitTests: XCTestCase {

    func testEndpointURLs() throws {
        XCTAssertEqual(LSPService.api.url.absoluteString,
                       "http://127.0.0.1:8080/lspservice/api")
        
        XCTAssertEqual(LSPService.api.language("swift").websocket.url.absoluteString,
                       "http://127.0.0.1:8080/lspservice/api/language/swift/websocket")
    }
    
    func testEndpointURLLanguageIsCaseSensitive() throws {
        XCTAssertEqual(LSPService.api.language("Swift").websocket.url.absoluteString,
                       "http://127.0.0.1:8080/lspservice/api/language/Swift/websocket")
    }
}
