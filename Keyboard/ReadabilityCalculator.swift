//
//  Readability.swift
//  Readability-Swift
//
//  Created by Bracken Spencer <bracken.spencer@gmail.com>.
//  Copyright (c) 2014-2015 Bracken Spencer. All rights reserved.
//

// Automated Readability Index: automatedReadabilityIndexForString
//          Coleman–Liau Index: colemanLiauIndexForString
//  Flesch-Kincaid Grade Level: fleschKincaidGradeLevelForString
//         Flesch Reading Ease: fleschReadingEaseForString
//           Gunning Fog Index: gunningFogScoreForString
//                  SMOG Grade: smogGradeForString

import Foundation
import UIKit

class ReadabilityCalculator {
    
    class func automatedReadabilityIndexForString(string: String) -> NSDecimalNumber {
        let readability = ReadabilityCalculator()
        let totalWords = Float(readability.wordsInString(string))
        let totalSentences = Float(readability.sentencesInString(string))
        let totalAlphanumericCharacters = Float(readability.alphanumericCharactersInString(string))
        
        // Formula from http://en.wikipedia.org/wiki/Automated_Readability_Index
        let score = 4.71 * (totalAlphanumericCharacters / totalWords) + 0.5 * (totalWords / totalSentences) - 21.43
        
        return readability.roundFloat(score, places: 1)
    }
    
    class func colemanLiauIndexForString(string: String) -> NSDecimalNumber {
        let readability = ReadabilityCalculator()
        let totalWords = Float(readability.wordsInString(string))
        let totalSentences = Float(readability.sentencesInString(string))
        let totalAlphanumericCharacters = Float(readability.alphanumericCharactersInString(string))
        
        // Formula from http://en.wikipedia.org/wiki/Coleman–Liau_index
        let score = 5.88 * (totalAlphanumericCharacters / totalWords) - 0.296 * (totalSentences / totalWords) - 15.8
        
        return readability.roundFloat(score, places: 1)
    }
    
    class func fleschKincaidGradeLevelForString(string: String) -> NSDecimalNumber {
        let readability = ReadabilityCalculator()
        let totalWords = Float(readability.wordsInString(string))
        let totalSentences = Float(readability.sentencesInString(string))
        let alphaNumeric = readability.alphanumericString(string)
        let totalSyllables = Float(SyllableCounter.sharedInstance.count(alphaNumeric))
        
        // Formula from http://en.wikipedia.org/wiki/Flesch–Kincaid_readability_tests
        let score = 0.39 * (totalWords / totalSentences) + 11.8 * (totalSyllables / totalWords) - 15.59
        
        return readability.roundFloat(score, places: 1)
    }
    
    class func fleschReadingEaseForString(string: String) -> NSDecimalNumber {
        let readability = ReadabilityCalculator()
        let totalWords = Float(readability.wordsInString(string))
        let totalSentences = Float(readability.sentencesInString(string))
        let alphaNumeric = readability.alphanumericString(string)
        let totalSyllables = Float(SyllableCounter.sharedInstance.count(alphaNumeric))
        
        // Formula from http://en.wikipedia.org/wiki/Flesch–Kincaid_readability_tests
        let score = 206.835 - 1.015 * (totalWords / totalSentences) - 84.6 * (totalSyllables / totalWords)
        
        
        // find grade this way
        let ASL = (totalWords / totalSentences)
        let ASW = (totalSyllables / totalWords)
        
        let grade = (0.39 * ASL) + (11.8 * ASW) - 15.59
        
        
        return readability.roundFloat(score, places: 1)
    }
    
    class func gunningFogScoreForString(string: String) -> NSDecimalNumber {
        let readability = ReadabilityCalculator()
        let totalWords = Float(readability.wordsInString(string))
        let totalSentences = Float(readability.sentencesInString(string))
        let totalComplexWords = Float(readability.complexWordsInString(string))
        
        // Formula for http://en.wikipedia.org/wiki/Gunning_fog_index
        let score = 0.4 * ( (totalWords / totalSentences) + 100 * (totalComplexWords /  totalWords) )
        
        return readability.roundFloat(score, places: 1)
    }
    
    class func smogGradeForString(string: String) -> NSDecimalNumber {
        let readability = ReadabilityCalculator()
        let totalPolysyllables = Float(readability.polysyllableWordsInString(string, excludeCommonSuffixes: false))
        let totalSentences = Float(readability.sentencesInString(string))
        
        // Formula for http://en.wikipedia.org/wiki/Gunning_fog_index
        let score = 1.043 * sqrtf(totalPolysyllables * (30 / totalSentences) + 3.1291)
        
        return readability.roundFloat(score, places: 1)
    }
    
    
    class func textualGrade(score:NSDecimalNumber) -> String {
        // http://www.thewriter.com/what-we-think/readability-checker/results
        var text = ""
        let s:Int = Int(score)
        
        switch s {
        case 100...999:
            text = "Fourth grade"
        case 90...100:
            text = "Fifth"
        case 80...90:
            text = "Sixth"
        case 70...80:
            text = "Seventh"
        case 65...70:
            text = "Eighth"
        case 60...65:
            text = "Ninth"
        case 50...60:
            text = "High school"
        case 40...50:
            text = "High school senior"
        case 30...40:
            text = "University"
        default:
            text = ""
        }
        return text
    }
    
    
    // MARK: Helpers
    
    func roundFloat(floatToRound: Float, places: Int16) -> NSDecimalNumber {
        let stringFromFloat = NSString(format: "%.13f", floatToRound)
        let decimalNumber = NSDecimalNumber(string: stringFromFloat as String)
        let decimalNumberHandler = NSDecimalNumberHandler(roundingMode: .RoundPlain, scale: places, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
        let decimalNumberRounded = decimalNumber.decimalNumberByRoundingAccordingToBehavior(decimalNumberHandler)
        
        return decimalNumberRounded
    }
    
    func wordsInString(string: NSString) -> Int {
        let readability = ReadabilityCalculator()
        
        return readability.countInString(.ByWords, stringToSearch: string as String)
    }
    
    func sentencesInString(string: NSString) -> Int {
        let readability = ReadabilityCalculator()
        
        return readability.countInString(.BySentences, stringToSearch: string as String)
    }
    
    func countInString(stringOption: NSStringEnumerationOptions, stringToSearch: String) -> Int {
        let searchRange = stringToSearch.startIndex..<stringToSearch.endIndex
        var count = 0
        
        stringToSearch.enumerateSubstringsInRange(searchRange, options: stringOption) {
            substring, substringRange, enclosingRange, stop in
            count = count + 1
        }
        
        return count
    }
    
    func alphanumericCharactersInString(stringToCount: String) -> Int {
        let characterSet = NSCharacterSet.alphanumericCharacterSet().invertedSet
        let componentsSeparated = stringToCount.componentsSeparatedByCharactersInSet(characterSet)
        var count = 0
        
        for words in componentsSeparated {
            count = count + (words as NSString).length
        }
        
        return count
    }
    
    func alphanumericString(stringToConvert: String) -> String {
        let string = stringToConvert as NSString
        let readability = ReadabilityCalculator()
        let characterSet = NSCharacterSet.alphanumericCharacterSet().invertedSet
        let componentsSeparated: NSArray = string.componentsSeparatedByCharactersInSet(characterSet)
        let componentsJoined: NSString = componentsSeparated.componentsJoinedByString(" ")
        let cleaned = readability.cleanupWhiteSpace(componentsJoined as String)
        
        return readability.cleanupWhiteSpace(cleaned as String)
    }
    
    func cleanupWhiteSpace(stringToClean: String) -> String {
        let string = stringToClean as NSString
        let squashed: NSString = string.stringByReplacingOccurrencesOfString("[ ]+", withString: " ", options: .RegularExpressionSearch, range: NSMakeRange(0, string.length))
        let characterSet = NSCharacterSet.whitespaceAndNewlineCharacterSet()
        let trimmed: NSString = squashed.stringByTrimmingCharactersInSet(characterSet)
        
        return trimmed as String
    }
    
    func isWordPolysyllable(word: String, excludeCommonSuffixes: Bool) -> Bool {
        var polysyllable = false
        
        if SyllableCounter.sharedInstance.count(word) > 2 {
            
            if excludeCommonSuffixes {
                
                if !word.lowercaseString.hasSuffix("es") && !word.lowercaseString.hasSuffix("ed") && !word.lowercaseString.hasSuffix("ing") {
                    polysyllable = true
                }
                
            } else {
                polysyllable = true
            }
            
        }
        
        return polysyllable
    }
    
    func polysyllableWordsInString(stringToCount: String, excludeCommonSuffixes: Bool) -> Int {
        let readability = ReadabilityCalculator()
        let searchRange = stringToCount.startIndex..<stringToCount.endIndex
        var count = 0
        
        stringToCount.enumerateSubstringsInRange(searchRange, options: .ByWords) {
            substring, substringRange, enclosingRange, stop in
            
            if readability.isWordPolysyllable(substring!, excludeCommonSuffixes: excludeCommonSuffixes) {
                count = count + 1
            }
        }
        
        return count
    }
    
    func isWordCapitalized(word: String) -> Bool {
        let characterSet = NSCharacterSet.uppercaseLetterCharacterSet()
        let firstCharacter = (word as NSString).characterAtIndex(0)
        
        return characterSet.characterIsMember(firstCharacter)
    }
    
    func complexWordsInString(stringToCount: String) -> Int {
        let readability = ReadabilityCalculator()
        let searchRange = stringToCount.startIndex..<stringToCount.endIndex
        var count = 0
        
        stringToCount.enumerateSubstringsInRange(searchRange, options: .ByWords) {
            substring, substringRange, enclosingRange, stop in
            
            // Attemping the complex word suggestions at http://en.wikipedia.org/wiki/Gunning_fog_index
            let polysyllable = readability.isWordPolysyllable(substring!, excludeCommonSuffixes: true)
            let properNoun = readability.isWordCapitalized(substring!)
            let familiarJargon = false // TODO
            let compound = false // TODO
            
            if polysyllable && !properNoun && !familiarJargon && !compound {
                count = count + 1
            }
            
        }
        
        return count
    }
    
}