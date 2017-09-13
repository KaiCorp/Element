import Cocoa
@testable import Utils

class BarGraph:Graph {
    static var playgroundMode:Bool = false
    var bars:[Bar] = []
    var tempVValues:[CGFloat]/*we need a temp storage for the random data*/
    override var vValues:[CGFloat] {return tempVValues}
    override var ratio: CGFloat {return 4/4}/*square look*/
    /*Gesture related*/
    var twoFingersTouches:[String:NSTouch]?/*temp storage for the twoFingerTouches data*/
    /*Animation related*/
    var animator:Animator?
    var initGraphPts:[CGPoint] = []/*Animates from these points*/
    /*Debugging*/
    var gestureHUD:GestureHUD?
    init(_ width:CGFloat, _ height:CGFloat, _ parent:ElementKind?, _ id: String? = nil) {
        tempVValues = GraphUtils.randomVerticalValues(count:7,min:0,max:40)//random data is set on init
        super.init(size:CGSize(width,height),id:id)
        self.acceptsTouchEvents = true/*Enables gestures*/
        self.wantsRestingTouches = true/*Makes sure all touches are registered. Doesn't register when used in playground*/
        gestureHUD = GestureHUD(self)
    }
    override func createGraph() {
        createBars()
        //createGraphPoints()
    }
    override func createLeftBar() {}/*dont create the leftBar*/
    override func createBottomBar() {}/*dont create the bottomBar*/
    /**
     * Creates the Bars
     */
    func createBars(){
        graphPts.forEach{
            let barHeight:CGFloat = $0.y.distance(to:newSize!.height - spacing!.height)// - $0.y
            let bar:Bar = graphArea!.addSubView(Bar(NaN,barHeight,graphArea))//width is set in the css
            bars.append(bar)
            bar.setPosition($0)
        }
    }
    /**
     * Horizontal lines (static)
     */
    func createHLines(){
        let count:Int = vValues.count-2
        var y:CGFloat = spacing!.height
        for _ in 0..<count{
            let hLine = graphArea!.addSubView(Element(newSize!.width-(spacing!.width*2),NaN,graphArea,"hLine"))
            hLine.setPosition(CGPoint(spacing!.width,y))
            y += spacing!.height
        }
    }
    /**
     * Iterate the graph datas
     */
    func iterate(){
        Swift.print("iterate")
        updateGraph()
    }
    /**
     *
     */
    func updateGraph(){
        tempVValues = GraphUtils.randomVerticalValues(count:7,min:0,max:40)//random data is set
        Swift.print("tempVValues: " + "\(tempVValues)")
        //recalc the maxValue
        maxValue = GraphUtils.maxValue(vValues)//NumberParser.max(vValues)//Finds the largest number in among vValues
      
        initGraphPts = bars.map{$0.frame.origin}//grabs the location of where the pts are now
        let config:GraphUtils.GraphConfig = GraphUtils.GraphConfig(size: newSize!, position: newPosition!, spacing: spacing!, vValues: vValues, maxValue: maxValue!, leftMargin: 100, topMargin: 100)
        graphPts = GraphUtils.points(config:config)
       
        if(animator != nil){animator!.stop()}/*stop any previous running animation*/
        animator = Animator(AnimProxy.shared,0.5,0,1,interpolateValue,Quad.easeIn)
        animator!.start()
    }
    /**
     * Interpolates between 0 and 1 while the duration of the animation
     */
    func interpolateValue(_ val:CGFloat){
        //Swift.print("interpolateValue() val: \(val)")
        for e in 0..<graphPts.count{
            let pos:CGPoint = initGraphPts[e].interpolate(graphPts[e], val)/*interpolates from one point to another*/
            //if(i == 0){Swift.print("pos.y: " + "\(pos.y)")}
            let barHeight:CGFloat = pos.y.distance(to: newSize!.height - (spacing!.height ))//pos.y 
            let bar:Bar = bars[e]
            bar.setPosition(CGPoint(bar.frame.origin.x,pos.y))
            bar.setBarHeight(barHeight)
            bar.graphic!.draw()
        }
    }
    /**
     * Detects when touches are made
     * NOTE: event.localPos(self) equals the pos of the mouseCursor
     */
    override func touchesBegan(with event:NSEvent) {
        //Swift.print("touchesBeganWithEvent: " + "\(event)")
        twoFingersTouches = GestureUtils.twoFingersTouches(self, event)
        /*Debug*/
        gestureHUD!.touchesBegan(event)
    }
    /**
     * Detects if a two finger left or right swipe has occured
     */
    override func touchesMoved(with event:NSEvent) {
        //Swift.print("touchesMovedWithEvent: " + "\(event)")
        /*swipe detection*/
        let swipeType:SwipeType = GestureUtils.swipe(self, event, twoFingersTouches)
        if (swipeType == .right){
            Swift.print("swipe right")
            iterate()
        }else if(swipeType == .left){
            Swift.print("swipe left")
            iterate()
        }else{
            //Swift.print("swipe none")
        }
        /*Debug*/
        gestureHUD!.touchesMoved(event)
    }
    /**
     * NOTE: playground doesnt fire a touch up when there is only one touch detected. to work aroudn this limitation you have to detect any touch and then when there are only 2, delete all debugCircs
     */
    override func touchesEnded(with event:NSEvent) {//for debugging
        Swift.print("touchesEndedWithEvent: " + "\(event)")
        //Swift.print("event.phase.type: " + "\(event.phase.type)" + " event.phase: " + "\(event.phase)")
        /*Debug*/
        gestureHUD!.touchesEnded(event)
    }
    override func touchesCancelled(with event:NSEvent) {//for debugging
        Swift.print("touchesCancelledWithEvent: " + "\(event)")
        
    }
    override func createVLines(_ size:CGSize, _ position:CGPoint, _ spacing:CGSize) {//we don't want VLines in the BarGraph
        //createHLines()//instead of vLines we create hLines if needed
    }
    override func getClassType() -> String {return "\(Graph.self)"}
    required init(coder:NSCoder) { fatalError("init(coder:) has not been implemented")}
}
class Bar:Element{
    //Use Graphics lib instead of the skin framework to draw the bars.
    //Stub out the code first, then test
    var graphic:RoundRectGraphic?//<--we could also use PolyLineGraphic, but we may support curvey Graphs in the future
    
    override func resolveSkin() {
        //Swift.print("GraphLine.resolveSkin")
        skin = SkinResolver.skin(self)//you could use let style:IStyle = StyleResolver.style(element), but i think skin has to be created to not cause bugs
        //I think the most apropriate way is to make a custom skin and add it as a subView wich would implement :ISkin etc, see TextSkin for details
        //Somehow derive the style data and make a basegraphic with it
        //let lineStyle:ILineStyle = StylePropertyParser.lineStyle(skin!)!//<--grab the style from that was resolved to this component
        let fillStyle:FillStyleKind = StylePropertyParser.fillStyle(skin!)
        //LineStyleParser.describe(lineStyle)
        graphic = RoundRectGraphic(-getWidth()/2,0,getWidth(),getHeight(),Fillet(getWidth()/2),fillStyle,nil)
        _ = addSubView(graphic!.graphic)
        graphic!.draw()
    }
    //override func setSkinState(_ skinState:String) {
        //update the line, implement this if you want to be able to set the theme of this component
    //}
    override func setSize(_ width:CGFloat, _ height:CGFloat) {
        //update the line, implement this if you need win resize support for this component
    }
    /**
     *
     */
    func setBarHeight(_ height:CGFloat){
        let w = getWidth()
        if(height < w && height > 0){/*clamps the height to width unless its 0 at which point it doesn't render*/
            graphic?.setSizeValue(CGSize(w,w))
        }else{ //h >= w || h == 0
            graphic?.setSizeValue(CGSize(w,height))
        }
        graphic!.draw()
    }
}
