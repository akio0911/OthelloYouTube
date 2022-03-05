//
//  OthelloTests.swift
//  OthelloTests
//
//  Created by YouTube on 2022/03/04.
//

import XCTest
@testable import Othello

class OthelloTests: XCTestCase {

    func test_位置() throws {
        XCTAssertNotNil(位置(x: 0, y: 0))
        XCTAssertNil(位置(x: 3, y: 8))
        XCTAssertNil(位置(x: 4, y: -1))
    }
    
    func test_マス() {
        XCTAssertEqual(ボード().マス(position: .init(x: 0, y: 0)!), .空)
        
        XCTAssertEqual(ボード().マス(position: .init(x: 3, y: 3)!), .白)
        XCTAssertEqual(ボード().マス(position: .init(x: 4, y: 3)!), .黒)
        
        XCTAssertEqual(ボード().マス(position: .init(x: 7, y: 7)!), .空)
    }
    
    func test_隣の位置() {
        XCTAssertEqual(
            位置(x: 2, y: 2)?.隣の位置(direction: .上),
            位置(x: 2, y: 1)
        )
        
        XCTAssertEqual(
            位置(x: 2, y: 1)?.隣の位置(direction: .上),
            位置(x: 2, y: 0)
        )
        
        XCTAssertEqual(
            位置(x: 2, y: 0)?.隣の位置(direction: .上),
            nil
        )
    }
    
    func test_線上のマス() {
        XCTAssertEqual(
            ボード().線上のマス(start: .init(x: 3, y: 3)!, direction: .右上)
                .map { $0.0 },
            [
                位置(x: 3, y: 3)!,
                位置(x: 4, y: 2)!,
                位置(x: 5, y: 1)!,
                位置(x: 6, y: 0)!
            ]
        )
        
        XCTAssertEqual(
            ボード().線上のマス(start: .init(x: 3, y: 3)!, direction: .右上)
                .map { $0.1 },
            [
                マス.白,
                マス.空,
                マス.空,
                マス.空,
            ]
        )
    }
    
    func test_連続を取り除く() {
        XCTAssertEqual(Array<Int>().連続を取り除く(), Array<Int>())
        XCTAssertEqual([1].連続を取り除く(), [1])
        XCTAssertEqual([1,1,1].連続を取り除く(), [1])
        XCTAssertEqual([1,2,3].連続を取り除く(), [1,2,3])
        XCTAssertEqual([1,2,2,3,3,3].連続を取り除く(), [1,2,3])
    }
    
    func test_置けるかどうか() {
        XCTAssertEqual([マス.空].置けるかどうか(color: .黒), false)
        XCTAssertEqual([マス.黒].置けるかどうか(color: .黒), false)
        XCTAssertEqual([マス.白].置けるかどうか(color: .黒), false)

        XCTAssertEqual([マス.黒, .黒].置けるかどうか(color: .黒), false)
        XCTAssertEqual([マス.空, .黒].置けるかどうか(color: .黒), false)
        
        XCTAssertEqual([マス.空, .黒, .黒].置けるかどうか(color: .黒), false)
        XCTAssertEqual([マス.空, .白, .黒].置けるかどうか(color: .黒), true)
        XCTAssertEqual([マス.白, .黒, .白].置けるかどうか(color: .黒), false)

        XCTAssertEqual([マス.空, .白, .白, .白, .黒].置けるかどうか(color: .黒), true)
        
        XCTAssertEqual([マス.空, .黒, .白, .黒, .白].置けるかどうか(color: .黒), false)
    }
    
    func test_ボード_置けるかどうか() {
        XCTAssertEqual(
            ボード().置けるかどうか(position: .init(x: 3, y: 2)!, color: .黒),
            true
        )
        
        XCTAssertEqual(
            ボード().置けるかどうか(position: .init(x: 5, y: 3)!, color: .黒),
            false
        )
    }
}
