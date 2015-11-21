import Foundation
/*
* @Note  having seperate values: hasStyleChanged and :hasSizeChanged and hasSkinState changed is usefull for optimization
* TODO: possibly add setPosition();
* TODO: a sleeker way to refresh the skin is needed for now we use setState(SkinStates.NONE)
* TODO: look to cssedit which takes priority the htm set width or the css set width?
*/
class Skin:FlippedView,ISkin{
    var decoratable:IGraphicDecoratable!
    var style:IStyle?
    var state:String
    var width:CGFloat?;
    var height:CGFloat?;
    var element:IElement?
    var hasStyleChanged:Bool = false;
    var hasStateChanged:Bool = false;
    var hasSizeChanged:Bool = false;
    override var wantsDefaultClipping:Bool{return false}//avoids clipping the view
    init(_ style:IStyle? = nil, _ state:String = "", _ element:IElement? = nil){
        self.style = style;
        self.state = state;
        self.element = element;
        width = element!.width;// :TODO: is this necassary?
        Swift.print("element!.width" + "\(element!.width)")
        height = element!.height;// :TODO: is this necassary?
        super.init(frame: NSRect(x: 0, y: 0, width: 100, height: 100))
    }
    /**
     * Required by super class
     */
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /**
    * Resets skinState
    */
    func draw(){
        hasStyleChanged = false;
        hasSizeChanged = false;
        hasStateChanged = false;
    }
    /**
     * Sets the style instance to apply to the skin also forces a redraw.
     * @Note this is a great way to update an skin without querying StyleManager
     */
    func setStyle(style:IStyle){
        hasStyleChanged = true;
        self.style = style;
        draw();
    }
    /**
     * sets the skin state and forces a redraw
     * @Note forces a lookup of the style in the StyleManager, since it has to look for the correct state of the style
     */
    func setSkinState(state:String){
        hasStateChanged = true;
        self.state = state;
        style = StyleResolver.style(element!)/*looping through the entire styleManager isnt a good idea for just a state change*/
        draw();
    }
    /**
     * Sets the width and height of skin also forces a redraw.
     * @Note similar to setStyle, this does not querry the styleManger when called
     */
    func setSize(width:Int, height:Int){
        fatalError("not implemented yet")
    }
}