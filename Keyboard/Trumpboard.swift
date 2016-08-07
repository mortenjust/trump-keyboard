import UIKit

/*
This is the demo keyboard. If you're implementing your own keyboard, simply follow the example here and then
set the name of your KeyboardViewController subclass in the Info.plist file.
*/

let kCatTypeEnabled = "kCatTypeEnabled"

class Trumpboard: KeyboardViewController {
    
    var shouldCorrect = true;
    var previousWord = ""
    var corrections = 0
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        NSUserDefaults.standardUserDefaults().registerDefaults([kCatTypeEnabled: true])
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        
        let i = UIImage(named: "trumpOverlay")
        let iv = UIImageView(image: i!)
        iv.alpha = 0.5
        view.addSubview(iv)
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func keyPressed(key: Key) {
        
        
        var thisChar:String = ""
        var prevChar : Character?
        var context: String = ""
        
        
        let textDocumentProxy = self.textDocumentProxy
        
        var keyOutput = key.outputForCase(self.shiftState.uppercase())
        
        print("KEY")
        
        thisChar = keyOutput

        if let c = textDocumentProxy.documentContextBeforeInput {
            context = c
            var index = context.endIndex
            index = index.predecessor()
            prevChar = context[index]
        } else {
            prevChar = Character(" ")
        }
        
        if ((thisChar == " " || thisChar == "." || thisChar == ",")
            && !(thisChar == " " && prevChar! == ",")) { // but not after a space after a comma
            
            // get current word
            let fullContext = context
            let words = fullContext.componentsSeparatedByString(" ")
            
            let lastWord = words.last?
                .stringByTrimmingCharactersInSet(NSCharacterSet.punctuationCharacterSet())
                .stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            
            
            // TODO: When the replaced word contains the original one, we get in trouble
            
//            print("PREVIOUS \(previousWord) and \(lastWord!)")
//            if previousWord.lowercaseString == lastWord!.lowercaseString {
//                shouldCorrect = false
//                print("DONT CORRECT")
//            }
            
            
            
        
            var didCorrect = false
            var correctedWord = ""
            
            if NSUserDefaults.standardUserDefaults().boolForKey(kSpelling) && shouldCorrect {
                if let autoCorrected = Textalizer().correctWordFor(lastWord!) {
                    keyOutput = autoCorrected + thisChar
                    correctedWord = autoCorrected
                    print("===> Corrections (spell, autoCorrectdd: ): \(corrections)")
                    didCorrect = true
                }
            }
            
            
            // 123456789.
            
            
            if NSUserDefaults.standardUserDefaults().boolForKey(kTrump) && shouldCorrect{
                if let autoCorrected = Textalizer().replaceWord(lastWord!, context: context) {
                    keyOutput = autoCorrected + thisChar
                    print("===> Corrections (textaly): \(corrections)")
                    didCorrect = true
                    correctedWord = autoCorrected
                }
            }
            
            
            if didCorrect {
                backspaceString(lastWord!)
                showWordSplash(correctedWord)
                didCorrect = false
                correctedWord = ""
            }
        }
        
        if thisChar == " " && prevChar! == "."  {
            keyOutput = Textalizer().reactToPeriod(context)
            textDocumentProxy.insertText(keyOutput)
            return
        }
                
        textDocumentProxy.insertText(keyOutput)
        updateReadabilityScore(context)
    }
    
    func backspaceString(s:String){
        print("BACKSPACING \(s)")
        for _ in s.characters {
            textDocumentProxy.deleteBackward()
        }
    }
    
    func updateReadabilityScore(text:String){
        var score = ReadabilityCalculator.fleschReadingEaseForString(text)
        
        if score == NSDecimalNumber.notANumber()
        || score == 0.0
        || text.characters.count < 10 {
            
            score = 0
            
            }
        

        //let t = ReadabilityCalculator.textualGrade(score)
        
        broadcastForBanner(Float(score))
    }
    
    
    func broadcastForBanner(score:Float){
        let nc = NSNotificationCenter.defaultCenter()
        nc.postNotificationName("scoreUpdate",
                                object:nil,
                                userInfo:["score":score]
                                );
    }
    
    override func setupKeys() {
        super.setupKeys()        
    }
    
    override func createBanner() -> TrumpboardBanner? {
        
        return TrumpboardBanner(globalColors: self.dynamicType.globalColors, darkMode: false, solidColorMode: self.solidColorMode())
    }
    
    func showWordSplash(w:String){
        print("showwordspalsh")
        let splash = UILabel(frame: self.view.bounds)
        splash.frame.origin.y = 100
        splash.text = w
        
        splash.font = UIFont(name: "AvenirNext-HeavyItalic", size: 40)
        splash.adjustsFontSizeToFitWidth = true
        splash.minimumScaleFactor = 0.1
        splash.textAlignment = .Center
        self.view.addSubview(splash)
        UIView.animateWithDuration(4, delay: 0,
                                   usingSpringWithDamping: 1,
                                   initialSpringVelocity: 1,
                                   options: [], animations: {
            splash.center.y = 10
            splash.alpha = 0
            }) { (done) in
                splash.removeFromSuperview()
        }
        
    }

}
