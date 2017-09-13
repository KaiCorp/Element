import Cocoa
@testable import Utils

class SliderListUtils{//⚠️️ This can probably be removed, as the same code is in SliderParser or alike, at least move to SliderParser
    /**
     * Returns the progress og the sliderList (used when we scroll with the scrollwheel/touchpad) (0-1)
     */
    static func progress(_ delta:CGFloat,_ sliderInterval:CGFloat,_ sliderProgress:CGFloat)->CGFloat{
        let scrollAmount:CGFloat = (delta/30)/sliderInterval/*_scrollBar.interval*/
//        Swift.print("🍏scrollAmount: " + "\(scrollAmount)")
        let currentScroll:CGFloat = sliderProgress - scrollAmount/*The minus sign makes sure the scroll works like in OSX LION*/
//        Swift.print("🍐 currentScroll: " + "\(currentScroll)")
        return currentScroll.clip(0, 1)/*Clamps the num between 0 and 1*/
    }
    /**
     * new (0-1)
     */
    static func progress(_ delta:CGPoint, _ interval:CGPoint, _ sliderProgress:CGPoint)->CGPoint{
        let x:CGFloat = progress(delta.x, interval.x, sliderProgress.x)
        let y:CGFloat = progress(delta.y, interval.y, sliderProgress.y)
        return CGPoint(x,y)
    }
    /**
     * new (0-1)
     */
    static func progress(_ event:NSEvent, _ dir:Dir, _ interval:CGFloat, _ progress:CGFloat)->CGFloat{
        let delta:CGFloat = dir == .ver ? event.deltaY : event.deltaX
        let progress:CGFloat = SliderListUtils.progress(delta, interval, progress)
        return progress
    }
}
