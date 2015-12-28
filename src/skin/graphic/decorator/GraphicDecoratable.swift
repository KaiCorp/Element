import Cocoa
/**
 * Manifesto:
 * 1. This class should only provide access to the graphic instance
 * 2. Contain all the instructions to draw on the graphic
 * NOTE: it should not contain style, size or position
 * TODO: Remove the getGraphics
 */
class GraphicDecoratable:AbstractGraphicDecoratable {
    var decoratable:IGraphicDecoratable
    override var graphic:BaseGraphic {return decoratable.graphic}
    init(_ decoratable:IGraphicDecoratable){
        self.decoratable = decoratable
        super.init()/*this doesnt init anything, its ust needed to support the setting of self as delegate*/
        graphic.selector = self.handleSelector
    }
    /**
     * Setup the geometry and init the display process of fill and line
     */
    override func draw() {
        //Swift.print("GraphicDecoratable.draw()" )
        if(getGraphic().fillStyle != nil){drawFill();graphic.fillShape.setNeedsDisplay();}/*setup the fill geometry*//*draw the fileShape*/
        if(getGraphic().lineStyle != nil){drawLine();graphic.lineShape.setNeedsDisplay();}/*setup the line geometry*//*draw the fileShape*/
    }
    /**
     * This method starts the actual drawing of the path and style to the context (for fill and stroke)
     * NOTE: This method gets its call from the Graphic instance through a functional selector. Which gets its call through a instance selector. The call is fired when OSX deems it right to be fired. This is initiated by setNeedsDisplay calls on the line and the fill shape (This )
     */
    func handleSelector(layer: CALayer,ctx:CGContext) {
        //Swift.print("GraphicDecoratable.handleSelector()")
        if(layer === graphic.fillShape){
            //Swift.print("fillShape: ")
            graphic.fillShape.graphics.context = ctx
            if(graphic.fillStyle != nil){fill()}
        }else if(layer === graphic.lineShape){
            //Swift.print("lineShape")
            graphic.lineShape.graphics.context = ctx
            if(graphic.lineStyle != nil){line()}
        }
    }
    /**
     * Stops implicit animation from happening
     * NOTE: Remember to set the delegate of your CALayer instance to an instance of a class that at least extends NSObject. In this example we extend NSView.
     * NOTE: this is a delegate method for the shapes in Graphic
     * NOTE: this method is also called on every frame of the animation it seems
     */
     /*
     override func actionForLayer(layer: CALayer, forKey event: String) -> CAAction? {
     //Swift.print("actionForLayer")
     return NSNull()
     }
     */
    /*
    func displayLayer(layer: CALayer){
    Swift.print("displayLayer")
    }
    */
    /**
     * This method results in the actual drawing to the context
     */
    override func fill(){
        //Swift.print("GraphicDecoratable.fill()")
        beginFill()
        //drawFill()/*this method can be called before beginFill*/
        stylizeFill()
    }
    /**
     * This method results in the setting of filling type to the graphics instance
     * NOTE: Conceptually this is equvielnt to the applyLineStyle call
     */
    override func beginFill(){
        //Swift.print("GraphicDecoratable.beginFill()")
        decoratable.beginFill()
    }
    /**
     * This method results in the setting of the "fill-path" to the graphics instance
     */
    override func drawFill(){
        //Swift.print("GraphicDecoratable.drawFill()")
        decoratable.drawFill()
    }
    /**
     * This method results the actual drawing of the fill to the context (based on what is attached on the graphics instance at the moment)
     */
    override func stylizeFill(){
        decoratable.stylizeFill()
    }
    /**
     * 
     */
    override func line(){
        //Swift.print("GraphicDecoratable.line()")
        applyLineStyle()
        //drawLine()/*this method can be called before beginFill*/
        stylizeLine()
    }
    /**
     * NOTE: Conceptually this is equvielnt to the beginFill call
     */
    override func applyLineStyle(){
        decoratable.applyLineStyle()
    }
    /**
     * This method results in the setting of the "line-path" to the graphics instance
     */
    override func drawLine(){
        decoratable.drawLine()
    }
    /**
     * This method results the actual drawing of the stroke to the context (based on what is attached on the graphics instance at the moment)
     */
    override func stylizeLine(){
        decoratable.stylizeLine()
    }
    /**
     * Returns _decoratable.graphic
     * @Note: we use decoratable.graphic to get to the graphics object, regardless of how many layers of decorators above.
     */
    override func getGraphic() -> BaseGraphic{
        return self.decoratable.getGraphic()
    }
    override func getDecoratable()->IGraphicDecoratable{return decoratable}/*new*/
}
