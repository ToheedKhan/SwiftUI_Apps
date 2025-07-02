//
//  XCTAssertThrowsErrorAsync.swift
//  UserListTests
//
//  Created by Toheed Khan on 02/07/25.
//

import XCTest

func XCTAssertThrowsErrorAsync(
    _ expression: @autoclosure @escaping () async throws -> Void,
    _ message: String = "",
    file: StaticString = #filePath,
    line: UInt = #line
) async {
    do {
        try await expression() //  forward the closure by calling ()
        XCTFail("Expected error but got success. " + message, file: file, line: line)
    } catch {
        // Expected error was thrown
    }
}

//OR
/*
func XCTAssertThrowsErrorAsync<T>(
    _ expression: @autoclosure @escaping () async throws -> T,
    _ message: String = "",
    file: StaticString = #filePath,
    line: UInt = #line
) async {
    do {
        _ = try await expression()
        XCTFail("Expected error but got success. " + message, file: file, line: line)
    } catch {
        // Expected
    }
}

// Then you can use - await XCTAssertThrowsErrorAsync(try await self.useCase.execute())
*/
