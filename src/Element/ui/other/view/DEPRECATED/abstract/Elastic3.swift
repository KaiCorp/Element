import Cocoa
@testable import Utils

protocol Elastic3:Progressable3{
    var moverGroup:MoverGroup? {get set}
}
extension Elastic3{
    /**
     * PARAM: value: contentContainer x/y value
     */
    func setProgress(_ value:CGFloat,_ dir:Dir){
        disableAnim {contentContainer.layer?.position[dir] = value}
    }
    func setProgress(_ point:CGPoint){
        disableAnim {contentContainer.layer?.position = point}
    }
}
