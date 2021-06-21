//
//  CustomColorSlider.swift
//
import UIKit

public class CustomColorSlider: UIControl {
    
    static var defaultThumbWidth:CGFloat = 10.0
    static var defaultHeight:CGFloat = 10.0
    
    var minimumValue: CGFloat = 18.5
    var maximumValue: CGFloat = 30
    open var defaultValue: CGFloat = 28
    static let colorArray : [Any] = [UIColor.blue.cgColor,
                                     UIColor.green.cgColor,
                                     UIColor.green.cgColor,
                                     UIColor.yellow.cgColor,
                                     UIColor.red.cgColor]
    
    
    fileprivate var _trackLayer:CAGradientLayer = {
        let track = CAGradientLayer()
        track.startPoint = CGPoint(x: 0.0, y: 0.5)
        track.endPoint = CGPoint(x: 1.0, y: 0.5)
        track.locations = [0.0, 0.2, 0.6, 0.7,1.0]
        track.colors = colorArray
        track.cornerRadius = defaultHeight / 2.0
        return track
    }()
    
    fileprivate var _overlaythumbLayer:CALayer = {
        let thumb = CALayer()
        thumb.backgroundColor = UIColor.white.cgColor
        return thumb
    }()
    
    fileprivate var _thumbLayer:CALayer = {
        let thumb = CALayer()
        thumb.backgroundColor = UIColor.black.cgColor
        return thumb
    }()
    
    open var actionBlock:(CustomColorSlider,CGFloat)->() = {slider,newValue in }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonSetup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonSetup()
    }
    
    override public func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        commonSetup()
    }
    
    fileprivate func commonSetup() {
        self.layer.delegate = self
        self.backgroundColor = UIColor.clear
        self.layer.addSublayer(_trackLayer)
        self.layer.addSublayer(_overlaythumbLayer)
        _overlaythumbLayer.addSublayer(_thumbLayer)
    }
    
    override public func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        
        if layer != self.layer {return}
        
        let w = self.bounds.width
        let y = self.bounds.height/2 - CustomColorSlider.defaultHeight/2
        
        _trackLayer.frame = CGRect(x: 0, y: y, width: w, height: CustomColorSlider.defaultHeight)
        _overlaythumbLayer.frame = CGRect(x: 0, y: 0, width: CustomColorSlider.defaultThumbWidth, height: CustomColorSlider.defaultHeight + 10)
        _thumbLayer.frame = CGRect(x: 1, y: 1, width: CustomColorSlider.defaultThumbWidth - 2, height: CustomColorSlider.defaultHeight + 8)
        
        updateThumbPosition()
        
    }
    
    
    //MARK: - Private Methods
    
    fileprivate func updateThumbPosition(){
        let diff = maximumValue - minimumValue
        let perc = CGFloat((defaultValue - minimumValue) / diff)
        
        let halfHeight = self.bounds.height / 2.0
        let trackWidth = _trackLayer.bounds.width - (CustomColorSlider.defaultThumbWidth * 2)
        let left = _trackLayer.position.x - trackWidth/2.0
        
        _overlaythumbLayer.position = CGPoint(x: left + (trackWidth * perc), y: halfHeight)
        //updateThumbColor(for: defaultValue)
        
    }
    
    fileprivate func updateThumbColor(for value: CGFloat) {
        if value < 18.5 {
            _thumbLayer.backgroundColor = UIColor.blue.cgColor
        } else if value >= 18.5 , value <= 24.9 {
            _thumbLayer.backgroundColor = UIColor.green.cgColor
        } else if value >= 25, value <= 29.9 {
            _thumbLayer.backgroundColor = UIColor.yellow.cgColor
        } else if value >= 30 {
            _thumbLayer.backgroundColor = UIColor.red.cgColor
        }
    }
    
    func setValue(_ values:CGFloat, animated:Bool = true) {
        defaultValue = max(min(values,self.maximumValue),self.minimumValue)
        updateThumbPosition()
    }
    
    
    fileprivate func valueForLocation(_ point:CGPoint)->CGFloat {
        
        let left = self.bounds.origin.x
        let w = self.bounds.width
        
        let diff = CGFloat(self.maximumValue - self.minimumValue)
        let perc = max(min((point.x - left) / w ,1.0), 0.0)
        return (perc * diff) + CGFloat(self.minimumValue)
    }
    
    
    //MARK: - Touch Tracking
    
    override public func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let pt = touch.location(in: self)
        
        let center = _overlaythumbLayer.position
        let diameter = max(CustomColorSlider.defaultHeight,44.0)
        let r = CGRect(x: center.x - diameter/2.0, y: center.y - diameter/2.0, width: diameter, height: diameter)
        if r.contains(pt){
            sendActions(for: UIControl.Event.touchDown)
            return true
        }
        return false
    }
    
    fileprivate func extractedFunc(_ newValue: CGFloat) {
        actionBlock(self,newValue)
    }
    
//    override public func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
//        let pt = touch.location(in: self)
//        let newValue = valueForLocation(pt)
//        setValue(newValue, animated: true)
//        sendActions(for: UIControl.Event.valueChanged)
//        extractedFunc(newValue)
//
//        return true
//    }
//
//    override public func endTracking(_ touch: UITouch?, with event: UIEvent?) {
//        if let pt = touch?.location(in: self){
//            let newValue = valueForLocation(pt)
//            setValue(newValue, animated: true)
//        }
//        actionBlock(self,defaultValue)
//        sendActions(for: [UIControl.Event.valueChanged, UIControl.Event.touchUpInside])
//
//    }
}
