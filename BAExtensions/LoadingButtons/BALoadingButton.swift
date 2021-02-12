//
//  BALoadingButton.swift
//  BAExtensions
//
//  Created by Betto Akkara on 04/02/21.
//

import UIKit

public enum BAButtonViews {
    case titleLabel
    case imageview
    case background
    case shadow
}
public enum LoaderType {
    case matirial_Loader
    case ball_Pulse
    case line_SpinFade
    case line_Scale
    case ball_Beat
    case ball_Spin
    case LBIndicator
    case line_Scale_Pulse
    case ball_Pulse_Sync
}

@available(iOS 13.0, *)
@IBDesignable
open class BALoadingButton: UIButton {

    // MARK: - Public variables

    /**
     Current loading state.
     */
    public var isLoading: Bool = false
    private var bgColor : UIColor? = .clear
    /**
     The flag that indicate if the shadow is added to prevent duplicate drawing.
     */

    public var shadowAdded: Bool = false
    // MARK: - Package-protected variables
    /**
     The loading indicator used with the button.
     */
    open var indicator: (UIView & IndicatorProtocol)?
    /**
     Set to true to add shadow to the button.
     */
    @IBInspectable open var withShadow: Bool = false
    /**
     Shadow view.
     */
    open var shadowLayer: UIView?
    /**
     Get all views in the button. Views include the button itself and the shadow.
     */
    open var entireViewGroup: [UIView] {
        var views: [UIView] = [self]
        if let shadow = self.shadowLayer {
            views.append(shadow)
        }
        return views
    }
    /**
     Button style for light mode and dark mode use. Only available on iOS 13 or later.
     */
    @available(iOS 13.0, *)
    public enum ButtonStyle {
        case fill
        case outline
    }

    var buttonStyle : ButtonStyle = .fill
    @IBInspectable open var fillStyle : Bool = true {
        didSet{
            self.buttonStyle = fillStyle ? .fill : .outline
        }
    }

    // Private properties
    private var loaderWorkItem: DispatchWorkItem?
    // Init
    public override init(frame: CGRect) {
        super.init(frame: frame)

    }

    /**
     Convenience init of theme button with required information
     
     - Parameter icon:      the icon of the button, it is be nil by default.
     - Parameter text:      the title of the button.
     - Parameter textColor: the text color of the button.
     - Parameter textSize:  the text size of the button label.
     - Parameter bgColor:   the background color of the button, tint color will be automatically generated.
     */
    public init(
        frame: CGRect = .zero,
        icon: UIImage? = nil,
        text: String? = nil,
        textColor: UIColor? = .white,
        font: UIFont? = nil,
        bgColor: UIColor = .black,
        cornerRadius: CGFloat = 12.0,
        withShadow: Bool = false
    ) {
        super.init(frame: frame)

        // Set the icon of the button
        if let icon = icon {
            self.setImage(icon)
        }
        // Set the title of the button
        if let text = text {
            self.setTitle(text)
            self.setTitleColor(textColor, for: .normal)
            self.titleLabel?.adjustsFontSizeToFitWidth = true
        }
        // Set button contents
        self.titleLabel?.font = font
        self.backgroundColor = bgColor
        self.bgColor = bgColor
        self.setBackgroundImage(UIImage(.lightGray), for: .disabled)
        self.contentEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        self.setCornerBorder(cornerRadius: cornerRadius)
        self.withShadow = withShadow
        self.cornerRadius = cornerRadius
    }

    /**
     Convenience init of material design button using system default colors. This initializer
     reflects dark mode colors on iOS 13 or later platforms. However, it will ignore any custom
     colors set to the button.
     
     - Parameter icon:         the icon of the button, it is be nil by default.
     - Parameter text:         the title of the button.
     - Parameter font:         the font of the button label.
     - Parameter cornerRadius: the corner radius of the button. It is set to 12.0 by default.
     - Parameter withShadow:   set true to show the shadow of the button.
     - Parameter buttonStyle:  specify the button style. Styles currently available are fill and outline.
     */
    @available(iOS 13.0, tvOS 13.0, *)
    public convenience init(icon: UIImage? = nil, text: String? = nil, font: UIFont? = nil,
                            cornerRadius: CGFloat = 12.0, withShadow: Bool = false, style: ButtonStyle) {
        switch style {
        case .fill:
            self.init(icon: icon, text: text, textColor: .label, font: font,
                      bgColor: .systemFill, cornerRadius: cornerRadius, withShadow: withShadow)
        case .outline:
            self.init(icon: icon, text: text, textColor: .label, font: font,
                      bgColor: .clear, cornerRadius: cornerRadius, withShadow: withShadow)
            self.setCornerBorder(color: .label, cornerRadius: cornerRadius)
        }
        self.indicator!.color = .label
    }

    // draw
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        if shadowAdded || !withShadow { return }
        shadowAdded = true
        // Set up shadow layer
        shadowLayer = UIView(frame: self.frame)
        guard let shadowLayer = shadowLayer else { return }
        shadowLayer.setAsShadow(bounds: bounds, cornerRadius: self.cornerRadius)
        self.superview?.insertSubview(shadowLayer, belowSubview: self)
    }

    // Required init
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    /**
     Display the loader inside the button.
     
     - Parameter userInteraction: Enable the user interaction while displaying the loader.
     - Parameter completion:      The completion handler.
     */
    open func showLoader(userInteraction: Bool, _ completion: LBCallback = nil) {
        showLoader([.titleLabel, .imageview], userInteraction: userInteraction, completion)
    }

    /**
     Show a loader inside the button with image.
     - Parameter userInteraction: Enable user interaction while showing the loader.
     */
    open func showLoaderWithImage(userInteraction: Bool = false) {
        showLoader([.titleLabel], userInteraction: userInteraction)
    }

    /**
     Display the loader inside the button.
     - Parameter viewsToBeHidden: The views such as titleLabel, imageViewto be hidden while showing loading indicator.
     - Parameter userInteraction: Enable the user interaction while displaying the loader.
     - Parameter completion:      The completion handler.
     */
    open func showLoader(_ viewsToBeHidden: [BAButtonViews?], userInteraction: Bool = true, loaderType : LoaderType? = .matirial_Loader, color : UIColor? = .blue,_ completion: LBCallback = nil) {

        switch loaderType {
        case .matirial_Loader:
            self.indicator = MaterialLoadingIndicator(color: color!)
            break
        case .ball_Pulse:
            self.indicator = BallPulseIndicator(color: color!)
            break
        case .line_SpinFade:
            self.indicator = LineSpinFadeLoader(color: color!)
            break
        case .line_Scale:
            self.indicator = LineScaleIndicator(color: color!)
            break
        case .ball_Beat:
            self.indicator = BallBeatIndicator(color: color!)
            break
        case .ball_Spin:
            self.indicator = BallSpinFadeIndicator(color: color!)
            break
        case .LBIndicator:
            self.indicator = LBIndicator(color: color!)
            break
        case .line_Scale_Pulse:
            self.indicator = LineScalePulseIndicator(color: color!)
            break
        case .ball_Pulse_Sync:
            self.indicator = BallPulseIndicator(color: color!)
            break
        default:
            self.indicator = MaterialLoadingIndicator(color: color!)
            break
        }

        guard !self.subviews.contains(indicator!) else { return }
        // Set up loading indicator and update loading state
        isLoading = true
        self.isUserInteractionEnabled = userInteraction
        indicator!.radius = min(0.7*self.frame.height/2, indicator!.radius)
        indicator!.alpha = 0.0
        self.addSubview(self.indicator!)
        indicator!.center = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        // Clean up
        loaderWorkItem?.cancel()
        loaderWorkItem = nil
        // Create a new work item
        loaderWorkItem = DispatchWorkItem { [weak self] in
            guard let self = self, let item = self.loaderWorkItem, !item.isCancelled else { return }
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: { () -> Void in
                self.transform = CGAffineTransform(scaleX: 0.1, y: 1)
                self.shadowLayer?.transform = CGAffineTransform(scaleX: 0.1, y: 1)
                self.alpha = 0.0
                self.shadowLayer?.alpha = 0.0
                guard !item.isCancelled else { return }
                self.isLoading ? self.indicator!.startAnimating() : self.hideLoader()
            }, completion: { (completed: Bool) -> Void in
                UIView.transition(with: self, duration: 0.1, options: .curveEaseOut, animations: {
                    self.alpha = 1
                    self.transform = CGAffineTransform(scaleX: 1, y: 1)
                    self.indicator!.alpha = 1.0
                    self.indicator!.center = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
                    viewsToBeHidden.forEach {
                        switch $0 {
                        case .background:
                            self.bgColor = self.backgroundColor
                            self.backgroundColor = .clear
                            break
                        case .imageview:
                            self.imageView?.alpha = 0.0
                            break
                        case .shadow:
                            if self.shadowAdded == true{
                                self.shadowLayer?.alpha = 0.0
                            }
                            break
                        case .titleLabel:
                            self.titleLabel?.alpha = 0.0
                            break
                        case .none:
                            break
                        }
                    }
                }) { _ in
                    completion?()
                }
            })
        }
        loaderWorkItem?.perform()
    }

    /**
     Hide the loader displayed.
     - Parameter completion: The completion handler.
     */
    open func hideLoader(_ completion: LBCallback = nil) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            guard self.subviews.contains(self.indicator!) else { return }
            // Update loading state
            self.isLoading = false
            self.isUserInteractionEnabled = true
            self.indicator!.stopAnimating()
            // Clean up
            self.indicator!.removeFromSuperview()
            self.loaderWorkItem?.cancel()
            self.loaderWorkItem = nil
            // Create a new work item
            self.loaderWorkItem = DispatchWorkItem { [weak self] in
                guard let self = self, let item = self.loaderWorkItem, !item.isCancelled else { return }
                self.transform = CGAffineTransform(scaleX: 0, y: 1)
                self.shadowLayer?.transform = CGAffineTransform(scaleX: 0, y: 1)
                UIView.transition(with: self, duration: 0.3, options: .beginFromCurrentState, animations: {
                    self.titleLabel?.alpha = 1.0
                    self.imageView?.alpha = 1.0
                    self.backgroundColor = self.bgColor
                    self.transform = CGAffineTransform(scaleX: 1, y: 1)
                    if self.shadowAdded == true{
                        self.shadowLayer?.alpha = 1.0
                        self.shadowLayer?.transform = CGAffineTransform(scaleX: 1, y: 1)
                    }

                }) { _ in
                    guard !item.isCancelled else { return }
                    completion?()
                }
            }
            self.loaderWorkItem?.perform()
        }
    }
    /**
     Make the content of the button fill the button.
     */
    public func fillContent() {
        self.contentVerticalAlignment = .fill
        self.contentHorizontalAlignment = .fill
    }
    // layoutSubviews
    open override func layoutSubviews() {
        super.layoutSubviews()
    }
    // MARK: Touch
    // touchesBegan
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    }
    // touchesEnded
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
    }
    // touchesCancelled
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
    }
    // touchesMoved
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
    }
}
// MARK: - UIActivityIndicatorView
extension UIActivityIndicatorView: IndicatorProtocol {
    public var radius: CGFloat {
        get {
            return self.frame.width/2
        }
        set {
            self.frame.size = CGSize(width: 2*newValue, height: 2*newValue)
            self.setNeedsDisplay()
        }
    }
    
    public var color: UIColor {
        get {
            return self.tintColor
        }
        set {
            let ciColor = CIColor(color: newValue)
            self.style = newValue.RGBtoCMYK(red: ciColor.red, green: ciColor.green, blue: ciColor.blue).key > 0.5 ? .gray : .white
            self.tintColor = newValue
        }
    }
    // unused
    public func setupAnimation(in layer: CALayer, size: CGSize) {}

}
