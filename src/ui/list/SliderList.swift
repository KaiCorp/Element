import Cocoa

class SliderList : List{
    private var slider:VSlider?
    private var sliderInterval:CGFloat?
    
    override func resolveSkin() {
        super.resolveSkin()
        //sliderInterval = Swift.floor(getItemsHeight() - height)/itemHeight;// :TODO: use ScrollBarUtils.interval instead?// :TODO: explain what this is in a comment
        //slider = addSubView(VSlider(itemHeight,height,0,0,self)) as? VSlider
    
    }
    
    override func scrollWheel(theEvent: NSEvent) {
        Swift.print("theEvent: " + "\(theEvent)")
        super.scrollWheel(theEvent)
    }
}
