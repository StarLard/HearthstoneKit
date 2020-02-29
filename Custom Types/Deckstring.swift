//
//  Deckstring.swift
//  HearthstoneKit
//
//  Created by Caleb Friden on 2/28/20.
//

import Foundation

/// A type that represents a deck in a form that can be exported an imported from Hearthstone
public struct Deckstring: Hashable {
    // MARK: Properties
    /// The name of the deck.
    public let name: String
    /// The ID of the format of the deck.
    public let formatID: BlizzardIdentifier
    /// The ID of the hero for the deck.
    public let heroID: BlizzardIdentifier
    /// A map where keys are card IDs and values are quantities of that card.
    public let cards: [BlizzardIdentifier: Int]
    /// The string representation of the deck.
    public let rawValue: String
    
    // MARK: Import
    
    /// Creates a new deckstring from a string exported from the game.
    /// - Parameter rawValue: The string representation of the deckstring as it is exported from hearthstone.
    public init(rawValue: String) throws {
        var deckstring = ""
        var name = ""
        
        rawValue.enumerateLines {
            (line, _) in
            if line.first != "#" {
                deckstring = line
            } else if String(line.prefix(3)) == "###"{
                let index = line.index(line.startIndex, offsetBy: 3)
                name = String(line[index...]).trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }
        
        var frmtNumber: Int = 0
        var heroes: [Int] = []
        var cards: [BlizzardIdentifier: Int] = [:]
        
        let decodedBase64 = Data(base64Encoded: deckstring)
        
        guard let decodedData = decodedBase64 else {
            throw DeckstringError.invalidInput
        }
        
        let inputStream = InputStream.init(data: decodedData)
        inputStream.open()
        
        let header = try Self.number(fromVarInt: inputStream)
        if header != 0 {
            throw DeckstringError.invalidInput
        }
        
        let version = try Self.number(fromVarInt: inputStream)
        if version != 1 {
            throw DeckstringError.invalidInput
        }
        
        frmtNumber = try Self.number(fromVarInt: inputStream)
        
        let numHeroes = try Self.number(fromVarInt: inputStream)
        
        for _ in 0..<numHeroes {
            let x = try Self.number(fromVarInt: inputStream)
            heroes.append(x)
        }
        
        let numOneOfs = try Self.number(fromVarInt: inputStream)
        
        for _ in 0..<numOneOfs {
            let x = try Self.number(fromVarInt: inputStream)
            cards[BlizzardIdentifier(rawValue: x)] = 1
        }
        
        let numTwoOfs = try Self.number(fromVarInt: inputStream)
        
        for _ in 0..<numTwoOfs {
            
            let x = try Self.number(fromVarInt: inputStream)
            cards[BlizzardIdentifier(rawValue: x)] = 2
        }
        
        let numXOfs = try Self.number(fromVarInt: inputStream)
        
        for _ in 0..<numXOfs {
            let id = try Self.number(fromVarInt: inputStream)
            let x = try Self.number(fromVarInt: inputStream)
            cards[BlizzardIdentifier(rawValue: id)] = Int(x)
        }
        
        inputStream.close()
        
        guard let heroNum = heroes.first else {
            throw DeckstringError.invalidInput
        }
        
        self.name = name
        self.heroID = BlizzardIdentifier(rawValue: heroNum)
        self.formatID = BlizzardIdentifier(rawValue: frmtNumber)
        self.cards = cards
        self.rawValue = rawValue
    }
    
    // MARK: Export
    
    /// Creates a new deckstring from the given parameters.
    /// - Parameters:
    ///   - name: The name of the deck.
    ///   - formatID: The ID of the format of the deck.
    ///   - heroID: The ID of the hero for the deck.
    ///   - cards: A map where keys are card IDs and values are quantities of that card.
    public init(name: String, formatID: BlizzardIdentifier, heroID: BlizzardIdentifier, cards: Dictionary<BlizzardIdentifier, Int>) {
        self.rawValue = """
        ### \(name)\n
        \(Self.varIntData(from: cards, formatID: formatID, heroID: heroID).base64EncodedString())\n
        # To use this deck, copy it to your clipboard and create a new deck in Hearthstone\n
        """
        self.name = name
        self.cards = cards
        self.heroID = heroID
        self.formatID = formatID
    }
}

private extension Deckstring {
    static func number(fromVarInt reader: InputStream) throws -> Int {
        
        var value: UInt64   = 0
        var shifter: UInt64 = 0
        var index = 0
        var counter = 0
        
        repeat {
            var buffer = [UInt8](repeating: 0, count: 10)
            
            if reader.read(&buffer, maxLength: 1) < 0 {
                throw DeckstringError.badInputStreamRead
            }
            
            let buf = buffer[0]
            
            if buf < 0x80 {
                if index > 9 || index == 9 && buf > 1 {
                    throw DeckstringError.varintOverflow
                }
                let retVal = value | UInt64(buf) << shifter
                return Int(retVal)
            }
            value |= UInt64(buf & 0x7f) << shifter
            shifter += 7
            index += 1
            counter += 1
            if counter >= 100 {
                throw DeckstringError.varintOverflow
            }
        } while true
    }
    
    static func varInt(from number: Int) -> [UInt8] {
        let value = UInt64(number)
        var buffer = [UInt8]()
        var val: UInt64 = value
        
        while val >= 0x80 {
            buffer.append((UInt8(truncatingIfNeeded: val) | 0x80))
            val >>= 7
        }
        
        buffer.append(UInt8(val))
        return buffer
    }
    
    static func varIntData(from cards: Dictionary<BlizzardIdentifier, Int>, formatID: BlizzardIdentifier, heroID: BlizzardIdentifier) -> Data {
        var varIntArray: [UInt8] = []
        var oneOfs: [BlizzardIdentifier] = []
        var twoOfs: [BlizzardIdentifier] = []
        var xOfs: [(BlizzardIdentifier, Int)] = []
        
        func append(number: Int) {
            varIntArray.append(contentsOf: varInt(from: number))
        }
        
        for (cardID, cardQuantity) in cards {
            switch cardQuantity {
            case 1:
                oneOfs.append(cardID)
            case 2:
                twoOfs.append(cardID)
            default:
                xOfs.append((cardID, cardQuantity))
            }
        }
        
        append(number: 0)
        append(number: 1)
        append(number: formatID.rawValue)
        
        let heroIDs = [heroID]
        append(number: heroIDs.count)
        for id in heroIDs {
            append(number: id.rawValue)
        }
        
        append(number: oneOfs.count)
        for cardID in oneOfs {
            append(number: cardID.rawValue)
        }
        
        append(number: twoOfs.count)
        for cardID in twoOfs {
            append(number: cardID.rawValue)
        }
        
        append(number: xOfs.count)
        for (cardID, cardQuantity) in xOfs {
            append(number: cardID.rawValue)
            append(number: cardQuantity)
        }
        return Data(varIntArray)
    }
}

/// An error thrown when failing to import a deck.
public enum DeckstringError: CustomNSError {
    public static let errorDomain: String = "DeckstringError"
    
    /// Encountered an error while attempting to read data from input stream.
    case badInputStreamRead
    /// Buffer overflowed while reading a var int.
    case varintOverflow
    /// Attempted to import a string that was not a valid deck.
    case invalidInput
    
    public var errorUserInfo: [String : Any] {
        switch self {
        case .badInputStreamRead:
            return ["Debug Description" : "Encountered an error while attempting to read data from input stream."]
        case .varintOverflow:
            return ["Debug Description" : "Buffer overflowed while reading a var int."]
        case .invalidInput:
            return ["Debug Description" : "Input string was not a valid deckstring."]
        }
    }
}
