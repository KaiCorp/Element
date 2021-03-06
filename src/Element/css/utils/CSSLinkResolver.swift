import Foundation
@testable import Utils
/**
 * EXAMPLE: Swift.print(CSSLinkResolver.resolveLinks("Button{fill:<ButtonBase>;} ButtonBase{fill:green;line:blue;} CheckButton{line:<ButtonBase>;}"))//Button{fill:green;} ButtonBase{fill:green;line:blue;} CheckButton{line:blue;}
 * TODO: rename this class to CSSPointerResolver? Since it can be confused with resolving css View container urls?
 */
class CSSLinkResolver {
    enum Pattern{
        static let precedingWith:String = "(?<=\\;|^|\\{)"
        static let whiteSpace:String = "[\\n\\s\\t\\v\\r]*?"
        static let nameGroup:String = "([\\w \\,\\[\\]\\.\\#\\:\\-]+?)"
        static let valueGroup:String = "(.+?)(?=\\;)"
        static let linkProperty:String = precedingWith + whiteSpace + nameGroup + "\\:" + valueGroup   
    }
    enum CSSElementType:Int{ case name = 1, value}
    /**
     * Returns a CSS string with all css links resolved, a css link is where a key points to another key to obtain its value
     * NOTE: this method is recursive and traverses down through all its decendants. Think of a tree diagram
     * NOTE: also resolves the weight of each style and merges styles according to the CSS methodology
     * NOTE: you could also do a forward for loop and then offset the range as your traverse the matches
     * TODO: ⚠️️ the replaceRange method may slow things down research a better replace method
     * EXAMPLE: resolveLinks("CustomButton{fill:yellow;} CustomButton:down{fill:green;}")//This is the log if you log the name and values: Name: fill, Value: yellow, Name: fill,Value: green
     */
    static func resolveLinks(_ string:String)->String{
        let matches = RegExp.matches(string, Pattern.linkProperty)
        return matches.reversed().reduce(string){ string,match in
            let name = match.value(string, CSSElementType.name.rawValue)
            let value = match.value(string, CSSElementType.value.rawValue)
            let replacementString:String = Utils.replaceLinks(value,name,string)
            let range:NSRange = match.range(at: 2)/*The range of the value*/
            return (string as NSString).replacingCharacters(in: range, with: replacementString)
        }
    }
}
private class Utils {
    enum Pattern{
        static let sansBracket:String = "(?<=<)[\\w \\:]+?(?=>)"
        enum Value{
            static let precedingWith:String = "(?<="
            static let subcedingWith:String = "\\{)(.|\\n)+?(?=\\})"
            static func pattern(_ linkName:String) -> String {
                return precedingWith + linkName + subcedingWith
            }
        }
    }
    /**
     * Replaces the value with the value from the key pointer
     * PARAM: cssString: is the original css string in its entirety (not a form of excerpt)
     * NOTE: there is no speed benefit of optimizing querrying for linkedStyleProperty
     * NOTE: the sansBracketPattern basically finds the content inside the "<" and the ">"
     * NOTE: you could also maybe loop backwards an replace that way, then you wouldnt have to store a new index
     * TODO: write an example
     */
    static func replaceLinks(_ string:String,_ linkPropName:String,_ cssString:String)->String{
        let matches = RegExp.matches(string, Pattern.sansBracket)
        let result:(difference:Int,string:String) = matches.filter{ match in/*<--the diff from each replace, replace 4 char with 6 then diff is += 2 etc, replace less then substract*/
                match.numberOfRanges > 0/*match = the link name>*/
            }.reduce((difference:0,string:string)){ result,match in/*Loops through the pattern*/
                var range:NSRange = match.range(at: 0)//StringRangeParser.stringRange(string, start, end)
                range.location = range.location + result.difference//difference
                let linkNameSansBrackets:String = (string as NSString).substring(with: range)/*the link name>*/
                let linkedStyleProperty:String = propertyValue(cssString,linkNameSansBrackets,linkPropName)/*replacementString*/
                range.location = range.location-1//add the < char
                range.length = range.length+2//add the > char
                let difference = (linkedStyleProperty.count - range.length)
                let str = (string as NSString).replacingCharacters(in: range, with: linkedStyleProperty)
                return (result.difference + difference,str)
            }
        return result.string
    }
    /**
     * Returns a style property value by parsing through PARAM: string and tries to find a match that matches both PARAM: linkName and PARAM: propertyName
     * PARAM: linkName the linkname is style name to search for
     * PARAM: propertyName is the property name for the property value to be returned
     * PARAM: string is the entire css document combined into 1 string
     * TODO: ⚠️️ write an example
     * TODO: ⚠️️ you can write a more precise expression to match the content of a style block
     */
    private static func propertyValue(_ string:String,_ linkName:String,_ propertyName:String)->String{
        let pattern:String = Pattern.Value.pattern(linkName)
        let match:[String] = string.match(pattern)
        if let matchStr = match[safe:0]{/*This try catch method is here so it's easier to debug which linkName threw*/
            return value(matchStr,propertyName)
        }else{
            fatalError("no match found for linkName: " + linkName+" with propertyName: " + propertyName )
        }
    }
    /**
     * Returns a propertyValue from PARAM: str (a style block)
     * PARAM: string a style block
     * PARAM: propName the property name for the property value to be returned
     * write an example
     * TODO: you can write a more precise expression to match the content of a style block
     */
    private static func value(_ string:String,_ propName:String)->String{
        let pattern:String = "(?<=" + propName + "\\:).+?(?=\\;)"
        let match:[String] = string.match(pattern)
        if let matchStr = match[safe:0]{/*This try catch method is here so its easier to debug which propName threw an error*/
            return matchStr
        }else{
            fatalError(" string:>"+string+"<"+" propName:>"+propName+"<")
        }
    }
}
