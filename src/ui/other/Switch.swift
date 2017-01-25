import Cocoa

class Switch:HSlider,ICheckable{
    //var tempThumbWidth:CGFloat
    //override var thumbWidth:CGFloat {get{return thumb?.getWidth() ?? 0}set{_ = newValue}}
    private var isChecked:Bool
    init(_ width:CGFloat, _ height:CGFloat, _ thumbWidth:CGFloat = NaN,_ isChecked:Bool = false, _ parent:IElement? = nil, _ id:String? = nil, _ classId:String? = nil) {
        //self.tempThumbWidth = thumbWidth.isNaN ? height:thumbWidth
        self.isChecked = isChecked
        Swift.print("isChecked: " + "\(isChecked)")
        super.init(width,height,thumbWidth,isChecked ? 1:0,parent,id)
    }
    override func createThumb() {
        thumb = addSubView(SwitchButton(thumbWidth, height,self))
        Swift.print("isChecked: " + "\(isChecked)")
        setProgressValue(isChecked ? 1:0)
    }
    override func onThumbMove(event:NSEvent) -> NSEvent{
        let event = super.onThumbMove(event: event)
        Swift.print("progress: " + "\(progress)")
        /*if(progress < 0.5 && isChecked){
            setChecked(false)//set disable
        }else if(progress > 0.5 && !isChecked){
            setChecked(true)//set enable
        }*/
        /*bg*/
        let style:IStyle = StyleModifier.clone(skin!.style!,skin!.style!.name)/*we clone the style so other Element instances doesnt get their style changed aswell*/// :TODO: this wont do if the skin state changes, therefor we need something similar to DisplayObjectSkin
        var styleProperty = style.getStyleProperty("fill") /*edits the style*/
        if(styleProperty != nil){//temp
            let green:NSColor = NSColorParser.nsColor(UInt(0x39D149))
            let color:NSColor = NSColor.white.blended(withFraction: progress, of: green)!
            styleProperty!.value = color
            skin!.setStyle(style)/*updates the skin*/
        }
        /*Thumb*/
        let thumbStyle:IStyle = thumb!.skin!.style!//StyleModifier.clone(thumb!.skin!.style!, thumb!.skin!.style!.name)
        var thumbStyleProperty = thumbStyle.getStyleProperty("line",1) /*edits the style*/
        if(thumbStyleProperty != nil){//temp
            let green:NSColor = NSColorParser.nsColor(UInt(0x39D149))
            let grey:NSColor = NSColorParser.nsColor(UInt(0xDCDCDC))
            let color:NSColor = grey.blended(withFraction: progress, of: green)!
            thumbStyleProperty!.value = color
            thumb!.skin!.setStyle(thumbStyle)/*updates the skin*/
        }
        return event
    }
    override func onThumbDown() {
        super.onThumbDown()
        let thumbStyle:IStyle = thumb!.skin!.style!//StyleModifier.clone(thumb!.skin!.style!, thumb!.skin!.style!.name)
        var thumbStyleProperty = thumbStyle.getStyleProperty("margin-left",1) /*edits the style*/
        thumbStyleProperty!.value = 0
        thumb!.skin!.setStyle(thumbStyle)
        Swift.print("thumbStyleProperty!.value: " + "\(thumbStyleProperty!.value)")
    }
    /**
     * NOTE: We need to get the event after mouseUpEvent, which is either upInside or upOutside. 
     * NOTE: If we use up event then another call gets made to the style and the properties we set doesn't attach, this is a bug
     */
    func onThumbUpInsideOrOutside() {
        let thumbStyle:IStyle = thumb!.skin!.style!//StyleModifier.clone(thumb!.skin!.style!, thumb!.skin!.style!.name)
        var thumbStyleProperty = thumbStyle.getStyleProperty("margin-left",1) /*edits the style*/
        thumbStyleProperty!.value = progress == 1 ? 20 : 0
        let green:NSColor = NSColorParser.nsColor(UInt(0x39D149))
        let grey:NSColor = NSColorParser.nsColor(UInt(0xDCDCDC))
        var thumbLineStyleProperty = thumbStyle.getStyleProperty("line",1)
        thumbLineStyleProperty!.value = progress == 1 ? green : grey
        thumb!.skin!.setStyle(thumbStyle)/*updates the skin*/
        Swift.print("val: " + "\(thumb!.skin!.style!.getStyleProperty("margin-left",1)?.value)")
        Swift.print("thumbStyle.getStyleProperty(line,1): " + "\(thumb!.skin!.style!.getStyleProperty("line",1)?.value)")
    }
    override func onEvent(_ event:Event) {
        //Swift.print("\(self.dynamicType)" + ".onEvent() event: " + "\(event)")
        if(event.origin === thumb && event.type == ButtonEvent.upInside){onThumbUpInsideOrOutside()}
        else if(event.origin === thumb && event.type == ButtonEvent.upOutside){onThumbUpInsideOrOutside()}
        super.onEvent(event)/*forward events, or stop the bubbeling of events by commenting this line out*/
    }
    /**
     * Sets the self.isChecked variable (Toggles between two states)
     */
    func setChecked(_ isChecked:Bool) {
        self.isChecked = isChecked
        setSkinState(getSkinState())
    }
    func getChecked() -> Bool {
        return isChecked
    }
    override func getSkinState() -> String {
        return isChecked ? SkinStates.checked + " " + super.getSkinState() : super.getSkinState()
    }
    required init(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
}
class SwitchButton:Button{
    override func mouseDown(_ event: MouseEvent) {
        super.mouseDown(event)
    }
    override func mouseUp(_ event: MouseEvent) {
        super.mouseUp(event)
    }
    override func mouseUpInside(_ event: MouseEvent) {
        super.mouseUpInside(event)
    }
    
    /*override func getClassType() -> String {
     return "\(Button.self)"
     }*/
}
