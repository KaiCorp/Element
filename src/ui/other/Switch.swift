import Cocoa

class Switch:HSlider,ICheckable{
    var thumbAnimator:Animator?
    var bgAnimator:Animator?
    var progressAnimator:Animator?
    let green:NSColor = NSColorParser.nsColor(UInt(0x39D149))
    let grey:NSColor = NSColorParser.nsColor(UInt(0xDCDCDC))
    var offColor:NSColor = NSColor.white
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
    /**
     *
     */
    func interpolateColor(){
        /*bg*/
        let style:IStyle = StyleModifier.clone(skin!.style!,skin!.style!.name)/*We clone the style so other Element instances doesnt get their style changed aswell*/// :TODO: this wont do if the skin state changes, therefor we need something similar to DisplayObjectSkin
        var styleProperty = style.getStyleProperty("fill") /*Edits the style*/
        if(styleProperty != nil){//temp
            let color:NSColor = offColor.blended(withFraction: progress, of: green)!
            styleProperty!.value = color
            skin!.setStyle(style)/*updates the skin*/
        }
        /*Thumb*/
        let thumbStyle:IStyle = thumb!.skin!.style!//StyleModifier.clone(thumb!.skin!.style!, thumb!.skin!.style!.name)
        var thumbStyleProperty = thumbStyle.getStyleProperty("line",1) /*edits the style*/
        if(thumbStyleProperty != nil){//temp
            let color:NSColor = grey.blended(withFraction: progress, of: green)!
            thumbStyleProperty!.value = color
            thumb!.skin!.setStyle(thumbStyle)/*updates the skin*/
        }
    }
    override func onThumbMove(event:NSEvent) -> NSEvent{
        let event = super.onThumbMove(event: event)
        //Swift.print("progress: " + "\(progress)")
        interpolateColor()
        return event
    }
    override func onThumbDown() {
        super.onThumbDown()
        let style:IStyle = thumb!.skin!.style!//StyleModifier.clone(thumb!.skin!.style!, thumb!.skin!.style!.name)
        var widthProp = style.getStyleProperty("width",1)
        widthProp!.value = 80
        var marginProp = style.getStyleProperty("margin-left",1) /*edits the style*/
        marginProp!.value = progress == 1 ? 20  : 0
        thumb!.skin!.setStyle(style)/*updates the skin*/
        
        /*Thumb Anim*/
        if(thumbAnimator != nil){thumbAnimator!.stop()}
        thumbAnimator = Animator(Animation.sharedInstance,0.2,0,1,thumbAnim,Easing.easeLinear)
        thumbAnimator!.start()
        
        /*bg Anim*/
        if(progress == 0){//must be in off state
            if(bgAnimator != nil){bgAnimator!.stop()}
            bgAnimator = Animator(Animation.sharedInstance,0.2,0,1,bgAnim,Easing.easeLinear)
            bgAnimator!.start()
        }
    }
    /**
     * NOTE: We need to get the event after mouseUpEvent, which is either upInside or upOutside. 
     * NOTE: If we use up event then another call gets made to the style and the properties we set doesn't attach, this is a bug
     */
    func onThumbUpInsideOrOutside() {
        let style:IStyle = thumb!.skin!.style!//StyleModifier.clone(thumb!.skin!.style!, thumb!.skin!.style!.name)
        
        var lineProp = style.getStyleProperty("line",1)
        lineProp!.value = progress == 1 ? green : grey
        
        var widthProp = style.getStyleProperty("width",1)
        widthProp!.value = 100
        var marginProp = style.getStyleProperty("margin-left",1) /*edits the style*/
        marginProp!.value = 0
        
        
        thumb!.skin!.setStyle(style)/*updates the skin*/
        /*Thumb Anim*/
        if(thumbAnimator != nil){thumbAnimator!.stop()}
        thumbAnimator = Animator(Animation.sharedInstance,0.2,1,0,thumbAnim,Easing.easeLinear)
        thumbAnimator!.start()
        
        /*BG Anim*/
        if(progress == 0){//must be in off state
            if(bgAnimator != nil){bgAnimator!.stop()}
            bgAnimator = Animator(Animation.sharedInstance,0.2,1,0,bgAnim,Easing.easeLinear)
            bgAnimator!.start()
        }
        
        setChecked(!isChecked)
    }
    func bgAnim(value:CGFloat){
        Swift.print("bgAnim: " + "\(value)")
        let style:IStyle = StyleModifier.clone(skin!.style!,skin!.style!.name)/*we clone the style so other Element instances doesnt get their style changed aswell*/// :TODO: this wont do if the skin state changes, therefor we need something similar to DisplayObjectSkin
        var fillProp = style.getStyleProperty("fill") /*edits the style*/
        //let curColor:NSColor = fillProp!.value as! NSColor
        offColor = NSColor.white.blended(withFraction: value, of: grey)!
        fillProp!.value = offColor
        skin!.setStyle(style)
    }
    func thumbAnim(value:CGFloat){
        Swift.print("thumbAnim: " + "\(value)")
        let style:IStyle = thumb!.skin!.style!//StyleModifier.clone(thumb!.skin!.style!, thumb!.skin!.style!.name)
        var marginProp = style.getStyleProperty("margin-left",1) /*edits the style*/
        marginProp!.value = progress == 1 ? 20 * (1-value) : 0
        var widthProp = style.getStyleProperty("width",1)
        widthProp!.value = 80 + (20 * value)
        //Swift.print("thumbStyleProperty!.value: " + "\(thumbStyleProperty!.value)")
        thumb!.skin!.setStyle(style)
    }
    func progressAnim(value:CGFloat){
        setProgressValue(value)
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
        if(progressAnimator != nil){thumbAnimator!.stop()}
        if(isChecked){/*Animate setProgress from 1 - 0*/
            progressAnimator = Animator(Animation.sharedInstance,0.2,1,0,progressAnim,Easing.easeLinear)
        }else if (progress == 1){/*Animate setProgress from 0 - 1*/
            progressAnimator = Animator(Animation.sharedInstance,0.2,0,1,progressAnim,Easing.easeLinear)
        }
        progressAnimator!.start()
        self.isChecked = isChecked
        //setSkinState(getSkinState())
    }
    func getChecked() -> Bool {
        return isChecked
    }
    override func getSkinState() -> String {
        return isChecked ? SkinStates.checked + " " + super.getSkinState() : super.getSkinState()
    }
    required init(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
}

/*
 if(progress < 0.5 && isChecked){
 setChecked(false)//set disable
 }else if(progress > 0.5 && !isChecked){
 setChecked(true)//set enable
 }*/

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