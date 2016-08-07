//: Playground - noun: a place where people can play

import UIKit


var packedReplaceables = [
    "fool, ass, halfwit, dunce, dolt, ignoramus, cretin, moron, imbecile, simpleton, informal dope, ninny, nincompoop, chump, dimwit, dumbo, dummy, dum-dum, loon, dork, sap, jackass, blockhead, jughead, bonehead, knucklehead, fathead, butthead, numbskull, numbnuts, dumb-ass, doofus, clod, dunderhead, ditz, lummox, knuckle-dragger, dipstick, thickhead, meathead, meatball, wooden-head, airhead, pinhead, lamer, lamebrain, peabrain, birdbrain, mouth-breather, scissorbill, jerk, nerd, donkey, nitwit, twit, boob, twerp, hoser, schmuck, bozo, turkey, chowderhead, dingbat mook, asshat" : "idiot",
    "fool, idiot, ass, blockhead, dunce, dolt, ignoramus, imbecile, cretin, dullard, simpleton, clod, nitwit, halfwit, dope, ninny, nincompoop, chump, dimwit, dingbat, dipstick, goober, coot, goon, dumbo, dummy, ditz, dumdum, fathead, numbskull, numbnuts, dunderhead, thickhead, airhead, butthead, flake, lamer, lamebrain, zombie, nerd, peabrain, birdbrain, scissorbill, jughead, mouth-breather, jerk, donkey, twit, goat, dork, twerp, hoser, schmuck, bozo, boob, turkey, schlep, chowderhead, dumbhead, goofball, goof, goofus, galoot, lummox, knuckle-dragger, klutz, putz, schlemiel, sap, meatball, dumb cluck" : "moron",
]

var replaceWords = [String:String]()


for p in packedReplaceables {
    let words = p.0.componentsSeparatedByString(", ")
    for w in words {
        replaceWords[w] = p.1
    }
}

replaceWords