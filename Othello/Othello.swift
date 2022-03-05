//
//  Othello.swift
//  Othello
//
//  Created by YouTube on 2022/03/04.
//

import Foundation

enum 色 {
    case 黒
    case 白
    
    var 反転: 色 {
        switch self {
        case .白: return .黒
        case .黒: return .白
        }
    }
}

enum マス: Equatable {
    case 空
    case 黒
    case 白
    
    var color: 色? {
        switch self {
        case .空: return nil
        case .白: return .白
        case .黒: return .黒
        }
    }
}

struct ボード {
    static let サイズ = 8
    
    // → x
    // ↓ y
    private(set) var squares: [[マス]] = [
        [.空, .空, .空, .空, .空, .空, .空, .空],
        [.空, .空, .空, .空, .空, .空, .空, .空],
        [.空, .空, .空, .空, .空, .空, .空, .空],
        [.空, .空, .空, .白, .黒, .空, .空, .空],
        [.空, .空, .空, .黒, .白, .空, .空, .空],
        [.空, .空, .空, .空, .空, .空, .空, .空],
        [.空, .空, .空, .空, .空, .空, .空, .空],
        [.空, .空, .空, .空, .空, .空, .空, .空],
    ]
    
    func マス(position: 位置) -> マス {
        return squares[position.y][position.x]
    }
    
    func 線上のマス(start: 位置, direction: 方向) -> [(位置, マス)] {
        if let 隣の位置 = start.隣の位置(direction: direction) {
            // 隣の位置がボード内である
            return [(start, マス(position: start))]
                + 線上のマス(start: 隣の位置, direction: direction)
        } else {
            // 隣の位置がボード外である
            return [(start, マス(position: start))]
        }
    }
    
    func 置けるかどうか(position: 位置, color: 色) -> Bool {
        return 方向.allCases
            .map { 線上のマス(start: position, direction: $0).map { $0.1 } }
            .map { $0.置けるかどうか(color: color) }
            .contains(true)
    }
}

enum 方向: CaseIterable {
    case 上
    case 右上
    case 右
    case 右下
    case 下
    case 左下
    case 左
    case 左上
    
    var dx: Int {
        switch self {
        case .左上, .左, .左下: return -1
        case .上, .下: return 0
        case .右上, .右, .右下: return 1
        }
    }
    
    var dy: Int {
        switch self {
        case .左上, .上, .右上: return -1
        case .左, .右: return 0
        case .左下, .下, .右下: return 1
        }
    }
}

struct 位置: Equatable {
    init?(x: Int, y: Int) {
        guard (0..<ボード.サイズ).contains(x)
                && (0..<ボード.サイズ).contains(y) else {
            return nil
        }
        self.x = x
        self.y = y
    }
    
    let x: Int
    let y: Int
    
    func 隣の位置(direction: 方向) -> 位置? {
        return 位置(
            x: x + direction.dx,
            y: y + direction.dy
        )
    }
}

extension Array where Element: Equatable {
    func 連続を取り除く() -> [Element] {
        switch count {
        case 0:
            return []
        case 1:
            return self
        default:
            if self[0] == self[1] {
                return Array(self.dropFirst()).連続を取り除く()
            } else {
                return [self[0]] + Array(self.dropFirst()).連続を取り除く()
            }
        }
    }
}

extension Array where Element == マス {
    func 置けるかどうか(color: 色) -> Bool {
        let 連続除去済 = self.連続を取り除く()
        
        return 連続除去済.count >= 3
            && 連続除去済[0] == .空
            && 連続除去済[1].color == color.反転
            && 連続除去済[2].color == color
    }
}
