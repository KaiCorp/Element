import Cocoa
@testable import Utils

class SkinParser {
    static func totalWidth(_ skin:Skinable)->CGFloat {
        return width(skin) + /*self.margin(skin).hor +*/ self.border(skin).hor// + self.padding(skin).hor
    }
    static func totalHeight(_ skin:Skinable)->CGFloat {
        return height(skin) + /*self.margin(skin).ver +*/ self.border(skin).ver /*+ self.padding(skin).ver*/
     }
    /**
     * Returns width
     */
    static func width(_ skin:Skinable)->CGFloat {
//        guard let element = skin.parent else{
//            let parents = NSViewParser.parents(skin as! NSView)
//            Swift.print("parents: " + "\(parents)")
//            fatalError("element not available: skin: \(skin)")
//
//        }
        return StyleMetricParser.width(skin) ?? skin.parent?.frame.width ?? {()->CGFloat in fatalError("err")}()//  !element.getWidth().isNaN ? element.getWidth() : skin.getWidth()
    }
    /**
     * Returns height
     */
    static func height(_ skin:Skinable)->CGFloat {
//        guard let element = skin.parent else{
//            let parents = NSViewParser.parents(skin as! NSView)
//            Swift.print("parents: " + "\(parents)")
//            fatalError("element not available: skin: \(skin)")
//        }
        return StyleMetricParser.height(skin) ?? skin.parent?.frame.height ?? {()->CGFloat in fatalError("err")}()// !skin.parent!.getHeight().isNaN ? skin.parent!.getHeight() : skin.getHeight()
    }
    /**
     * Returns the position when margin and padding is taken into account
     */
    static func relativePosition(_ skin:Skinable)->CGPoint {
        let margin:Margin = self.margin(skin)
        let border:Border = self.border(skin)
        let padding:Padding = self.padding(skin)
        let offset:CGPoint = self.offset(skin)
        let x:CGFloat = /*(skin.element as NSView).x*/ margin.left + border.left + padding.left + offset.x
        let y:CGFloat = /*(skin.element as NSView).y*/ margin.top + border.top + padding.top + offset.y
        return CGPoint(x,y)
    }
    /**
     * Returns margin
     */
    static func margin(_ skin:Skinable)->Margin{// :TODO: ⚠️️ possibly rename to relativeMargin
        return StyleMetricParser.margin(skin)
    }
    /**
     * Returns border
     */
    static func border(_ skin:Skinable)->Border {
        let lineOffsetType:OffsetType = StylePropertyParser.lineOffsetType(skin);
        let value:Any? = StylePropertyParser.value(skin, "line-thickness")
        let lineThickness:CGFloat =  value != nil ? value as! CGFloat : 0
        return Border([lineOffsetType.top == OffsetType.outside ? lineThickness : 0, lineOffsetType.right == OffsetType.outside ? lineThickness : 0,lineOffsetType.bottom == OffsetType.outside ? lineThickness : 0,lineOffsetType.left == OffsetType.outside ? lineThickness : 0])
    }
    static func padding(_ skin:Skinable)->Padding{// :TODO: possibly rename to relativePadding
        return StyleMetricParser.padding(skin)
    }
    static func offset(_ skin:Skinable)->CGPoint{// :TODO: possibly rename to relativeOffset
        return StyleMetricParser.offset(skin)
    }
    static func float(_ skin:Skinable,_ depth:Int = 0)->String?{
        return StylePropertyParser.value(skin,CSS.Align.float,depth) as? String
    }
    static func clear(_ skin:Skinable)->String? {
        return StylePropertyParser.value(skin,CSS.Align.clear) as? String
    }
    static func display(_ skin:Skinable)->String? {
        return StylePropertyParser.value(skin,CSS.Align.display) as? String
    }
}
