import Cocoa
@testable import Utils

class GradientSlider:HNodeSlider{
    var gradient:IGradient?
    init(_ width:CGFloat = NaN, _ height:CGFloat = NaN, _ nodeWidth:CGFloat = NaN, _ gradient:IGradient? = nil, _ startProgress:CGFloat = 0, _ endProgress:CGFloat = 1, _ parent:IElement? = nil, _ id:String = "") {
        super.init(width, height, nodeWidth, startProgress, endProgress, parent, id)
        setGradient(gradient!)
    }
    func setGradient(_ gradient:IGradient){
        //print("setGradient"+gradient.colors)
        self.gradient = gradient
        //print("_gradient: " + _gradient)
        let style:IStyle = StyleModifier.clone(skin!.style!,skin!.style!.name)/*We clone the style so other Element instances doesn't get their style changed as well*/// :TODO: this won't do if the skin state changes, therefor we need something similar to DisplayObjectSkin
        var styleProperty = style.getStyleProperty("fill",0) /*Edits the style*/
        //Swift.print("styleProperty: " + "\(styleProperty)")
        //Swift.print("color.hex: " + "\(color.hexString)")
        if(styleProperty != nil){//temp
            //Swift.print("styleProperty!.value: ")
            styleProperty!.value = gradient/*edits the style*/
            skin!.setStyle(style)/*Updates the skin*/
        }
        //skin.setState(SkinStates.NONE)/*update the skin*/
        skin!.setStyle(style)/*Updates the skin*/
    }
    override func onStartNodeMove(event:NSEvent)-> NSEvent? {
        //Swift.print("GradientSlider.onStartNodeMove() ")
        let ratio:CGFloat = startProgress//round(/* * 255*/)
        //Swift.print("ratio: " + "\(ratio)")
        gradient!.locations = [ratio,gradient!.locations[1]]
        setGradient(gradient!)
        return super.onStartNodeMove(event:event)
    }
    override func onEndNodeMove(event:NSEvent)-> NSEvent? {
        //Swift.print("GradientSlider.onEndNodeMove() ")
        let ratio:CGFloat = endProgress//round( * 255)
        //Swift.print("ratio: " + "\(ratio)")
        gradient!.locations = [gradient!.locations[0],ratio]
        setGradient(gradient!)
        return super.onEndNodeMove(event:event)
    }
    required init(coder:NSCoder) {fatalError("init(coder:) has not been implemented")}
}