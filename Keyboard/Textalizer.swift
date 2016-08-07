//
//  Textalizer.swift
//  TastyImitationKeyboard
//
//  Created by Morten Just Petersen on 7/23/16.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit

class Textalizer: NSObject {
    var periodReactions = [
        " Let me tell you this: ",
        " I have to tell you, ",
        " One thing I wanted to leave you with, ",
        " The horror is beyond description. ",
        " This is a very dark moment in America’s history. ",
        " I refuse to be politically correct. ",
        " You're fired! ",
        " It's rigged. ",
        " People are telling me, ",
        " How does that help us? ",
        " Did you know that? ",
        " You know why? ",
        " Now, I didn't say this. This is what people have said. "
        
    ]
    
    var replaceWords = [
        "hillary"   :"Crooked Hillary",
        "tim"       :"job-crushing Tim",
        "ted"       :"Lyin' Ted",
        "bernie"     :"Crazy Bernie",
        "mike"      :"job-creating Mike",
        "marco"     :"Little Marco",
        "jeb"   : "Low-energy Jeb",
        "liz" : "Goofy Elizabeth",
        "paul" : "Truly weird Senator Rand Paul",
        
        "deconstructs" : "cripples",
        "hands" : "huge hands",
        "huge" : "yuge",
        "mexican" : "rapist",
        "mexicans" : "criminals",
        "ben" : "Psychopath Ben",
        "kasich" : "1 for 38 Kasich",
        "woman" : "gold digger",
        "women" : "bimbos",
        "big" : "yuge",
        "good" : "great",
        "unintelligent" : "moron",
        "poor" : "loser",
        "disabled" : "moron",
        "repulsive" : "disgusting",
        "sickening" : "disgusting",
        "gross" : "disgusting",
        "shocking" : "disgusting",
        "nasty" : "disgusting",
        "off-putting" : "disgusting",
        "nauseating" : "disgusting",
        "repellent" : "disgusting",
        "revolting" : "disgusting",
        "abhorrent" : "disgusting",
        "offensive" : "disgusting",
        "stomach-churning" : "disgusting",
        "unpalatable" : "disgusting",
        "horrifying" : "disgusting",
        "obnoxious" : "disgusting",
        "hateful" : "disgusting",
        "extremely" : "very",
        "exceedingly" : "very",
        "acutely" : "very",
        "abundantly" : "very",
        "singularly" : "very",
        "uncommonly" : "very",
        "decidedly" : "very",
        "particularly" : "very",
        "supremely" : "very",
        "terrifically" : "very",
        "remarkably" : "very",
        "mightily" : "very",
        "awfully" : "very",
        "devilishly" : "very",
        "majorly" : "very",
        "vast" : "great",
        "substantial" : "great",
        "significant" : "great",
        "appreciable" : "great",
        "extraordinary" : "great",
        "extensive" : "great",
        "enormous" : "great",
        "humongous" : "great",
        "ginormous" : "great",
        "veritable" : "great",
        "renowned" : "great",
        "famous" : "great",
        "dominant" : "great",
        "potent" : "great",
        "awe-inspiring" : "great",
        "powerful" : "great",
        "imposing" : "great",
        "skillful" : "great",
        "talented" : "great",
        "brilliant" : "great",
        "virtouso" : "great",
        "outstanding" : "great",
        "accomplished" : "great",
        "marvelous" : "great",
        "enjoyable" : "great",
        "pleasant" : "great",
        "splendid" : "great",
        "fantastic" : "great",
        "fabulous" : "great",
        "splendiferous" : "great",
        "super" : "great",
        "hunky-dory" : "great",
        "swell" : "great",
        "geek" : "loser",
        "hoser" : "loser",
        "washout" : "loser",
        "democrat" : "loser",
        "underachiever" : "loser",
        "runner-up" : "loser",
        "very" : "very, very",
        "trust" : "believe",
        "brexit" : "Brexit...which I was right about..."
        // tremendous
    ]
    
    
    var packedReplaceables = [ // for the massive collapsing of language
        "fool, ass, halfwit, dunce, dolt, ignoramus, cretin, moron, imbecile, simpleton, informal dope, ninny, nincompoop, chump, dimwit, dumbo, dummy, dum-dum, loon, dork, sap, jackass, blockhead, jughead, bonehead, knucklehead, fathead, butthead, numbskull, numbnuts, dumb-ass, doofus, clod, dunderhead, ditz, lummox, knuckle-dragger, dipstick, thickhead, meathead, meatball, wooden-head, airhead, pinhead, lamer, lamebrain, peabrain, birdbrain, mouth-breather, scissorbill, jerk, nerd, donkey, nitwit, twit, boob, twerp, hoser, schmuck, bozo, turkey, chowderhead, dingbat mook, asshat"
            : "idiot",
        "fool, idiot, ass, blockhead, dunce, dolt, ignoramus, imbecile, cretin, dullard, simpleton, clod, nitwit, halfwit, dope, ninny, nincompoop, chump, dimwit, dingbat, dipstick, goober, coot, goon, dumbo, dummy, ditz, dumdum, fathead, numbskull, numbnuts, dunderhead, thickhead, airhead, butthead, flake, lamer, lamebrain, zombie, nerd, peabrain, birdbrain, scissorbill, jughead, mouth-breather, jerk, donkey, twit, goat, dork, twerp, hoser, schmuck, bozo, boob, turkey, schlep, chowderhead, dumbhead, goofball, goof, goofus, galoot, lummox, knuckle-dragger, klutz, putz, schlemiel, sap, meatball, dumb cluck"
            : "moron",
        "fortification, barricade, bulwark, stockade, barrier, fence, impediment, hindrance, block, roadblock"
            : "wall",
        "converse, chat, consult" : "talk",
        "enjoyed, exhilerated, stirred, electrified, galvanized, aroused, exhilarated"
            : "thrilled",
        "discharging, settling, expending, disbursing"
            : "paying",
        "discharge, settle, expend, disburse"
            : "pay",
        "excited, cheerful, cheery, merry, joyful, jovial, jolly, jocular, gleeful, carefree, untroubled, delighted, smiling, beaming, grinning, lighthearted, pleased, contented, content, satisfied, gratified, buoyant, radiant, sunny, blithe, joyous, beatific,  elated, blissful, euphoric, overjoyed, exultant, rapturous"
        : "happy"

    ]
    
    
    override init() {
        // unpack the synonym entries
        for p in packedReplaceables {
            let words = p.0.componentsSeparatedByString(", ")
            for w in words {
                replaceWords[w] = p.1
            }
        }
    }
    
    func replaceWord(word:String, context:String) -> String? {
        return replaceWords[word.lowercaseString]
    }
    
    func reactToPeriod(context:String) -> String {
    
        var reaction = ""
        
        // only do this every other time
        if(arc4random() % 5 == 1) {
            let index = Int(arc4random() % UInt32(periodReactions.count))
            reaction = periodReactions[index]
        } else {
            reaction = " "
        }
        
        return reaction
    }
    
    func correctWordFor(w:String) -> String? {
        let u = UITextChecker()
        let r = u.rangeOfMisspelledWordInString(w, range: NSMakeRange(0, w.characters.count), startingAt: 0, wrap: false, language: "en-us")
        let c = u.guessesForWordRange(r, inString: w, language: "en-us")?.first as? String
        return c
    }
    
    
}
