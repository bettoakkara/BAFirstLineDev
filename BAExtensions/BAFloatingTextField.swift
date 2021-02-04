//
//  FloatingTextFiled.swift
//  BAExtensions
//
//  Created by Betto Akkara on 04/02/21.
//

import Foundation
import UIKit

@IBDesignable
@objc open class BAFloatingTextField: UITextField {
    /**
     The formatter used before displaying content in the title label.
     This can be the `title`, `selectedTitle` or the `errorMessage`.
     The default implementation converts the text to uppercase.
     */
    open var titleFormatter: ((String) -> String) = { (text: String) -> String in
        if #available(iOS 9.0, *) {
            return text.localizedUppercase
        } else {
            return text.uppercased()
        }
    }

    fileprivate var bottomLineView : UIView?
    fileprivate var labelPlaceholder : UILabel?
    fileprivate var labelErrorPlaceholder : UILabel?
    fileprivate var showingError : Bool = false

    fileprivate var bottomLineViewHeight : NSLayoutConstraint?
    fileprivate var placeholderLabelHeight : NSLayoutConstraint?
    fileprivate var errorLabelHieght : NSLayoutConstraint?

    /// Disable Floating Label when true.
    @IBInspectable open var disableFloatingLabel : Bool = false

    /// Shake Bottom line when Showing Error ?
    @IBInspectable open var shakeLineWithError : Bool = true

    /// Change Bottom Line Color.
    @IBInspectable open var lineColor : UIColor = UIColor.black {
        didSet{
            self.floatTheLabel()
        }
    }

    /// Change line color when Editing in textfield
    @IBInspectable open var selectedLineColor : UIColor = UIColor.blue{
        didSet{
            self.floatTheLabel()
        }
    }

    /// Change placeholder color.
    @IBInspectable open var placeHolderColor : UIColor = UIColor.lightGray {
        didSet{
            self.floatTheLabel()
        }
    }

    /// Change placeholder color while editing.
    @IBInspectable open var selectedPlaceHolderColor : UIColor = UIColor(red: 19/256.0, green: 141/256.0, blue: 117/256.0, alpha: 1.0){
        didSet{
            self.floatTheLabel()
        }
    }

    /// Change Error Text color.
    @IBInspectable open var errorTextColor : UIColor = UIColor.red{
        didSet{
            self.labelErrorPlaceholder?.textColor = errorTextColor
            self.floatTheLabel()
        }
    }

    /// Change Error Line color.
    @IBInspectable open var errorLineColor : UIColor = UIColor.red{
        didSet{
            self.floatTheLabel()
        }
    }
    @IBInspectable var rightImage : UIImage?{
        didSet{
            let imageTemp = UIImageView(image: rightImage)
            imageTemp.contentMode = .scaleAspectFit

            let image = imageTemp.image?.withRenderingMode(.alwaysTemplate)
            let imageView = UIImageView(image: image)
            imageView.tintColor = UIColor.blue
            self.rightView = imageView
            // select mode -> .never .whileEditing .unlessEditing .always
            self.rightViewMode = .always
        }
    }
    //MARK:- Set Text
    override open var text:String?  {
        didSet {
            if showingError {
                self.hideErrorPlaceHolder()
            }
            floatTheLabel()
        }
    }
    override open func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(copy(_:)) || action == #selector(paste(_:)) {
            return false
        }
        return true
    }
    override open var placeholder: String? {
        willSet {
            if newValue != "" {
                self.labelPlaceholder?.text = newValue
            }
        }
    }

    open var errorText : String? {
        willSet {
            self.labelErrorPlaceholder?.text = newValue
        }
    }

    //MARK:- UITtextfield Draw Method Override
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        self.upadteTextField(frame: CGRect(x:self.frame.minX, y:self.frame.minY, width:rect.width, height:rect.height));
    }

    // MARK:- Loading From NIB
    override open func awakeFromNib() {
        super.awakeFromNib()
        self.initialize()
    }

    // MARK:- Intialization
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }

    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.initialize()
    }

    // MARK:- Text Rect Management
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x:self.leftView?.bounds.size.width ?? 0, y:10, width:bounds.size.width, height: bounds.size.height - 24);
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x:self.leftView?.bounds.size.width ?? 0, y:10, width:bounds.size.width, height:bounds.size.height - 24);
    }

    //MARK:-  Filed Becomes First Responder
    override open func becomeFirstResponder() -> Bool {
        let result = super.becomeFirstResponder()
        self.textFieldDidBeginEditing()
        return result
    }

    //MARK:-  Filed Resigns Responder
    override open func resignFirstResponder() -> Bool {
        let result =  super.resignFirstResponder()
        self.textFieldDidEndEditing()
        return result
    }

    //MARK:- Show Error Label
    public func showError() {
        showingError = true;
        self.showErrorPlaceHolder();
    }
    public func hideError() {
        showingError = false;
        self.hideErrorPlaceHolder();
        floatTheLabel()
    }

    public func showErrorWithText(errorText : String) {
        self.errorText = errorText;
        self.labelErrorPlaceholder?.text = self.errorText
        showingError = true;
        self.showErrorPlaceHolder();
    }


}

fileprivate extension BAFloatingTextField {

    //MARK:- FLoating Initialzation.
    func initialize() -> Void {

        self.clipsToBounds = true
        /// Adding Bottom Line
        addBottomLine()

        /// Placeholder Label Configuration.
        addFloatingLabel()

        /// Error Placeholder Label Configuration.
        addErrorPlaceholderLabel()
        /// Checking Floatibility
        if self.text != nil && self.text != "" {
            self.floatTheLabel()
        }

    }

    //MARK:- ADD Bottom Line
    func addBottomLine(){

        if bottomLineView?.superview != nil {
            return
        }
        //Bottom Line UIView Configuration.
        bottomLineView = UIView()
        bottomLineView?.backgroundColor = lineColor
        bottomLineView?.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(bottomLineView!)

        let leadingConstraint = NSLayoutConstraint.init(item: bottomLineView!, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        let trailingConstraint = NSLayoutConstraint.init(item: bottomLineView!, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint.init(item: bottomLineView!, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -13)
        bottomLineViewHeight = NSLayoutConstraint.init(item: bottomLineView!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 1)

        self.addConstraints([leadingConstraint,trailingConstraint,bottomConstraint])
        bottomLineView?.addConstraint(bottomLineViewHeight!)

        self.addTarget(self, action: #selector(self.textfieldEditingChanged), for: .editingChanged)
    }

    @objc func textfieldEditingChanged(){
        if showingError {
            hideError()
        }
    }

    //MARK:- ADD Floating Label
    func addFloatingLabel(){

        if labelPlaceholder?.superview != nil {
            return
        }

        var placeholderText : String? = labelPlaceholder?.text
        if self.placeholder != nil && self.placeholder != "" {
            placeholderText = self.placeholder!
        }
        labelPlaceholder = UILabel()
        labelPlaceholder?.text = placeholderText
        labelPlaceholder?.textAlignment = self.textAlignment
        labelPlaceholder?.textColor = placeHolderColor
        labelPlaceholder?.font = UIFont(name: (self.font?.fontName ?? "helvetica"), size: 12)
        labelPlaceholder?.backgroundColor = UIColor.clear
        labelPlaceholder?.isHidden = true
        labelPlaceholder?.sizeToFit()
        labelPlaceholder?.translatesAutoresizingMaskIntoConstraints = false
        //self.setValue(placeHolderColor, forKeyPath: "_placeholderLabel.textColor")
        self.setPlaceholderColor(placeHolderColor)
        if labelPlaceholder != nil {
            self.addSubview(labelPlaceholder!)
        }
        let leadingConstraint = NSLayoutConstraint.init(item: labelPlaceholder!, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        let trailingConstraint = NSLayoutConstraint.init(item: labelPlaceholder!, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint.init(item: labelPlaceholder!, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        placeholderLabelHeight = NSLayoutConstraint.init(item: labelPlaceholder!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 10)

        self.addConstraints([leadingConstraint,trailingConstraint,topConstraint])
        labelPlaceholder?.addConstraint(placeholderLabelHeight!)

    }

    func setPlaceholderColor(_ color: UIColor) {
        // Color
        var attributes: [NSAttributedString.Key: Any] = [.foregroundColor: color]
        var range = NSRange(location: 0, length: 1)

        // Font
        if let text = attributedText, text.length > 0, let attrs = attributedText?.attributes(at: 0, effectiveRange: &range), let font = attrs[.font] {
            attributes[.font] = font
        }
        else if let font = font {
            attributes[.font] = font
        }
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: attributes)
    }

    func addErrorPlaceholderLabel() -> Void {
        DispatchQueue.main.async {

            if self.labelErrorPlaceholder?.superview != nil{
                return
            }
            self.labelErrorPlaceholder = UILabel()
            self.labelErrorPlaceholder?.text = self.errorText
            self.labelErrorPlaceholder?.textAlignment = self.textAlignment
            self.labelErrorPlaceholder?.textColor = self.errorTextColor
            self.labelErrorPlaceholder?.font = UIFont(name: (self.font?.fontName ?? "helvetica"), size: 10)
            self.labelErrorPlaceholder?.sizeToFit()
            self.labelErrorPlaceholder?.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(self.labelErrorPlaceholder!)

            let trailingConstraint = NSLayoutConstraint.init(item: self.labelErrorPlaceholder!, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
            let topConstraint = NSLayoutConstraint.init(item: self.labelErrorPlaceholder!, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
            self.errorLabelHieght = NSLayoutConstraint.init(item: self.labelErrorPlaceholder!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 10)

            self.addConstraints([trailingConstraint,topConstraint])
            self.labelErrorPlaceholder?.addConstraint(self.errorLabelHieght!)
        }
    }

    func showErrorPlaceHolder() {
        DispatchQueue.main.async {

            self.bottomLineViewHeight?.constant = 1;

            if self.errorText != nil && self.errorText != "" {
                self.errorLabelHieght?.constant = 15;
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                    self.bottomLineView?.backgroundColor = self.errorLineColor;
                    self.layoutIfNeeded()
                }, completion: nil)
            }else{
                self.errorLabelHieght?.constant = 0;
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                    self.bottomLineView?.backgroundColor = self.errorLineColor;
                    self.layoutIfNeeded()
                }, completion: nil)
            }

            if self.shakeLineWithError {
                self.bottomLineView?.shake()
            }
        }
    }

    func hideErrorPlaceHolder(){

        DispatchQueue.main.async {

            self.showingError = false;
            if self.errorText == nil || self.errorText == "" {
                return
            }
            self.errorLabelHieght?.constant = 0;
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                self.layoutIfNeeded()
            }, completion: nil)

        }
    }

    //MARK:- Float & Resign
    func floatTheLabel() -> Void {
        DispatchQueue.main.async {
            if self.text == "" && self.isFirstResponder {
                self.floatPlaceHolder(selected: true)
            }else if self.text == "" && !self.isFirstResponder {
                self.resignPlaceholder()
            }else if self.text != "" && !self.isFirstResponder  {
                self.floatPlaceHolder(selected: false)
            }else if self.text != "" && self.isFirstResponder {
                self.floatPlaceHolder(selected: true)
            }
        }
    }

    //MARK:- Upadate and Manage Subviews
    func upadteTextField(frame:CGRect) -> Void {
        self.frame = frame;
        self.initialize()
    }

    //MARK:- Float  Filed Placeholder Label
    func floatPlaceHolder(selected:Bool) -> Void {
        DispatchQueue.main.async {
            self.labelPlaceholder?.isHidden = false
            if selected {

                self.bottomLineView?.backgroundColor = self.showingError ? self.errorLineColor : self.selectedLineColor

                self.labelPlaceholder?.textColor = self.selectedPlaceHolderColor

                self.bottomLineViewHeight?.constant = 1
                // self.setValue(self.selectedPlaceHolderColor, forKeyPath: "_placeholderLabel.textColor")
                self.setPlaceholderColor(self.selectedPlaceHolderColor)

            }else {
                self.bottomLineView?.backgroundColor = self.showingError ? self.errorLineColor : self.lineColor;
                self.bottomLineViewHeight?.constant = 1;
                self.labelPlaceholder?.textColor = self.placeHolderColor
                // self.setValue(placeHolderColor, forKeyPath: "_placeholderLabel.textColor")
                self.setPlaceholderColor(self.placeHolderColor)
            }

            if self.disableFloatingLabel == true {
                self.labelPlaceholder?.isHidden = true
                return
            }

            if self.placeholderLabelHeight?.constant == 15 {
                return
            }
        }
        DispatchQueue.main.async {
            self.placeholderLabelHeight?.constant = 15;
            self.labelPlaceholder?.font = UIFont(name: (self.font?.fontName ?? "helvetica"), size: 12)
        }
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2, animations: {
                self.layoutIfNeeded()
            })
        }
    }

    //MARK:- Resign the Placeholder
    func resignPlaceholder() -> Void {

        // self.setValue(self.placeHolderColor, forKeyPath: "_placeholderLabel.textColor")
        self.setPlaceholderColor(self.placeHolderColor)
        DispatchQueue.main.async {
            self.bottomLineView?.backgroundColor = self.showingError ? self.errorLineColor : self.lineColor;
            self.bottomLineViewHeight?.constant = 1;
        }
        if disableFloatingLabel {
            DispatchQueue.main.async {
                self.labelPlaceholder?.isHidden = true
                self.labelPlaceholder?.textColor = self.placeHolderColor;

                UIView.animate(withDuration: 0.2, animations: {
                    self.layoutIfNeeded()
                })
            }
            return
        }

        placeholderLabelHeight?.constant = self.frame.height
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, animations: {
                self.labelPlaceholder?.font = UIFont(name: (self.font?.fontName ?? "helvetica"), size: 12)
                self.labelPlaceholder?.textColor = self.placeHolderColor
                self.layoutIfNeeded()
            }) { (finished) in
                self.labelPlaceholder?.isHidden = true
                self.placeholder = self.labelPlaceholder?.text
            }
        }

    }

    //MARK:-  Filed Begin Editing.
    func textFieldDidBeginEditing() -> Void {
        if showingError {
            self.hideErrorPlaceHolder()
        }
        if !self.disableFloatingLabel {
            self.placeholder = ""
        }
        self.floatTheLabel()
        self.layoutSubviews()
    }

    //MARK:-  Filed Begin Editing.
    func textFieldDidEndEditing() -> Void {
        self.floatTheLabel()
    }
}

//MARK:- Shake
extension UIView {
    func shake() {

        DispatchQueue.main.async {
            let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
            animation.timingFunction = CAMediaTimingFunction(name: .linear)
            animation.duration = 0.6
            animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
            self.layer.add(animation, forKey: "shake")
        }

    }
}

