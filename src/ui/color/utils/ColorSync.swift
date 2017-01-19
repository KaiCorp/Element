import Cocoa
@testable import Utils
/**
 * NOTE: the way it works is that the broadcaster and receiver are set by the user interaction with the GUI, and then you call ColorSync.onColorChange(event as! ColorInputEvent) and ColorSync decides what is receiving at that point in time
 * EXAMPLE:
 * let singleton = ColorSync.sharedInstance
 * singleton.test()
 */
class ColorSync {
    static let sharedInstance = ColorSync()//TODO:I Don't think this needs to be a singleton
    private init() {} /*This prevents others from using the default '()' initializer for this class.*/ 
    static var receiver:IColorInput?
    static var broadcaster:IColorInput?
    static func onColorChange(_ event:ColorInputEvent){
        print("ColorSync.onColorChange" + "\(ColorSync.receiver)")
        if(ColorSync.receiver != nil) {
            print("_receiver: " + "\(ColorSync.receiver)")
            //print("event.target: " + event.target);
            //print("event.currentTarget: " + event.currentTarget);
            ColorSync.broadcaster = event.origin as? IColorInput
            ColorSync.receiver!.setColorValue(event.color!)
            ColorSync.receiver!.onEvent(ColorInputEvent(ColorInputEvent.change,event.origin))
        }
    }
    /**
     * NOTE: This sets the color of the broadcaster not the receiver
     */
    class func setColor(_ color:NSColor) {
        if (ColorSync.broadcaster != nil) {ColorSync.broadcaster!.setColorValue(color)}
    }
}
