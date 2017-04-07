//
//  UZTextView.swift
//  UZTextView
//
//  Created by sonson on 2017/03/24.
//  Copyright © 2017年 sonson. All rights reserved.
//

import UIKit
import CoreText

extension Sequence where Iterator.Element == CGRect {
    fileprivate var union: CGRect {
        return reduce(CGRect.null, { (result, rect) -> CGRect in
            return result.union(rect)
        })
    }
}

extension CGRect {
    fileprivate func toViewCoordiante(scale: CGFloat, contentInset: UIEdgeInsets) -> CGRect {
        return CGRect(
            x: self.origin.x * scale + contentInset.left,
            y: self.origin.y * scale + contentInset.top,
            width: self.size.width * scale,
            height: self.size.height * scale
        )
    }
}

extension CGPoint {
    fileprivate func toTextCoordiante(scale: CGFloat, contentInset: UIEdgeInsets) -> CGPoint {
        return CGPoint(
            x: (self.x - contentInset.left) / scale,
            y: (self.y - contentInset.top) / scale
        )
    }
    internal func offsetBy(x: CGFloat, y: CGFloat) -> CGPoint {
        return CGPoint(
            x: self.x + x,
            y: self.y + y
        )
    }
}

extension NSAttributedString {
    /// A range of all string as CFRange.
    fileprivate var fullCFRange: CFRange {
        return CFRange(location: 0, length: self.length)
    }
    /// A range of all string as NSRange.
    fileprivate var fullNSRange: NSRange {
        return NSRange(location: 0, length: self.length)
    }
}

extension CFString {
    /// A range of all string as CFRange.
    fileprivate var fullCFRange: CFRange {
        let length = CFStringGetLength(self)
        return CFRange(location: 0, length: length)
    }
}

extension String {
    /// A range of all string as CFRange.
    fileprivate var fullCFRange: CFRange {
        return CFRange(location: 0, length: self.utf16.count)
    }
    
    /// A range of all string as NSRange.
    fileprivate var fullNSRange: NSRange {
        return NSRange(location: 0, length: self.utf16.count)
    }
}

extension CFRange {
    /// A range of all string as CFRange.
    fileprivate static var zero: CFRange {
        return CFRange(location: 0, length: 0)
    }
    
    /// Range as CountableRange<Int> including an end point.
    fileprivate var arangeIncludingEndIndex: CountableRange<Int> {
        return self.location..<(self.location + self.length + 1)
    }
    
    /// Range as CountableRange<Int> excluding an end point.
    fileprivate var arange: CountableRange<Int> {
        return self.location..<(self.location + self.length)
    }
    
    /// Convert to NSRange structure.
    fileprivate var nsrange: NSRange {
        return NSRange(location: self.location, length: self.length)
    }
}

extension NSRange {
    /// Range as CountableRange<Int> including an end point.
    fileprivate var arangeIncludingEndIndex: CountableRange<Int> {
        return self.location..<(self.location + self.length + 1)
    }
    
    /// Range as CountableRange<Int> excluding an end point.
    fileprivate var arange: CountableRange<Int> {
        return self.location..<(self.location + self.length)
    }
    
    /// Range means that it does not found anything.
    fileprivate static var notFound: NSRange {
        return NSRange(location: NSNotFound, length: 0)
    }
    
    /// Overload
    fileprivate static func == (lhs: NSRange, rhs: NSRange) -> Bool {
        return lhs.location == rhs.location && lhs.length == rhs.length
    }
    
    /// Overload
    fileprivate static func != (lhs: NSRange, rhs: NSRange) -> Bool {
        return lhs.location != rhs.location || lhs.length != rhs.length
    }
}

extension UITouch {
    /**
     Returns point with respect to the content insets.
     - parameter view: View on which the touch took place.
     - parameter inset: The distance that the string rendering area is inset from the view.
     - returns: CGPoint structure at which the touch took place with respect to the content insets.
     */
    fileprivate func location(in view: UIView, inset: UIEdgeInsets, scale: CGFloat) -> CGPoint {
        return self.location(in: view).toTextCoordiante(scale: scale, contentInset: inset)
    }
}

extension UIGestureRecognizer {
    /**
     Returns point which is offset by margin.
     - parameter view: A UIView object on which the gesture took place.
     - parameter inset: The distance that the string rendering area is inset from the view.
     - returns: CGPoint structure that points a location where UIGestureRecognizer recognizes an event with respect to the content insets.
     */
    fileprivate func location(in view: UIView, inset: UIEdgeInsets, scale: CGFloat) -> CGPoint {
        return self.location(in: view).toTextCoordiante(scale: scale, contentInset: inset)
    }
    
    fileprivate var stateDescription: String {
        switch state {
        case .began:
            return "began"
        case .cancelled:
            return "cancelled"
        case .changed:
            return "changed"
        case .ended:
            return "ended"
        case .failed:
            return "failed"
        case .possible:
            return "possible"
        }
    }
}

/**
 Typographic bounds of a CTLine.
 */
fileprivate struct TypographicBounds {
    let width: CGFloat
    let ascent: CGFloat
    let descent: CGFloat
    let leading: CGFloat
}

/**
 Get typofrahics bounds from CTLine.
 - parameter line: The line from which to obtain the typofrahics bounds.
 - returns: A TypographicBounds structure that contains attributes of specified line.
 */
fileprivate func CTLineGetTypographicBounds(_ line: CTLine) -> TypographicBounds {
    var ascent: CGFloat = 0
    var descent: CGFloat = 0
    var leading: CGFloat = 0
    let width = CTLineGetTypographicBounds(line, &ascent, &descent, &leading)
    return TypographicBounds(width: CGFloat(width), ascent: ascent, descent: descent, leading: leading)
}

/**
 Property of line.
 */
fileprivate struct LineInfo {
    /// CTLine of a line.
    let line: CTLine
    /// Origin of a line.
    let origin: CGPoint
    /// Index range of a line.
    let range: NSRange
    /**
     Returns the rectangle of a line.
     - parameter contentSize: Size of a string content. It uses in order to compensate Y origin of line.
     - returns: A rectangle of line as CGRect considering Y direction and Y origin.
     */
    func getRect(contentSize: CGSize) -> CGRect {
        let typographicBounds = CTLineGetTypographicBounds(self.line)
        let lineRectSize = CGSize(width: typographicBounds.width, height: typographicBounds.ascent + typographicBounds.descent)
        let lineRectOrigin = origin.offsetBy(x: 0, y: -typographicBounds.descent)
        let lineRectInverted = CGRect(origin: lineRectOrigin, size: lineRectSize)
        return CGRect(origin: CGPoint(x: lineRectOrigin.x, y: contentSize.height - lineRectInverted.maxY), size: lineRectSize)
    }
}

/**
 Gets the range of characters that originally spawned the glyphs in the line.
 - parameter line: The line from which to obtain the string range.
 - returns: A NSRange structure that contains the range over the backing store string that spawned the glyphs, or if the function fails for any reason, an empty range.
 */
fileprivate func CTLineGetStringNSRange(_ line: CTLine) -> NSRange {
    let lineCFRange = CTLineGetStringRange(line)
    return NSRange(location: lineCFRange.location, length: lineCFRange.length)
}

/**
 Returns an array of LineInfo objects in the frame.
 - parameter frame: The frame whose line array is returned.
 - returns: Array object containing the LineInfo objects that have line object, origin and indices, or, if there are no lines in the frame, an array with no elements.
 */
fileprivate func CTFrameGetLineInfo(_ frame: CTFrame) -> [LineInfo] {
    guard let lines = CTFrameGetLines(frame) as? [CTLine] else { return [] }
    var lineOrigins = [CGPoint](repeating: .zero, count: lines.count)
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), &lineOrigins)
    guard lines.count == lineOrigins.count else { return [] }
    
    return zip(lines, lineOrigins).map({
        let range = CTLineGetStringNSRange($0.0)
        return LineInfo(line: $0.0, origin: $0.1, range: range)
    })
}

/**
 The value of this attribute is an CGRect object. The default value of this property is nil, indicating no information about the area.
 */
public let UZTextViewLinkRect = "UZTextViewLinkRect"

/**
 The value of this attribute is an NSRange ofject.
 */
public let UZTextViewLinkRange = "UZTextViewLinkRange"

/**
 The methods of this protocol allow the delegate to manage selecting string, tapping link in the view and long tapping it in the view.
 */
public protocol UZTextViewDelegate: class {
    /**
     Tells the delegate that the link which contains ```attribute``` was tapped.
     Returns menu items to display in an element's contextual menu.
     - parameter textView: The text view in which the link is tapped.
     - parameter attribute: The attributes for the linke at which user tapped.
     */
    func textView(_ textView: UZTextView, didClickLinkAttribute attribute: Any)
    
    /**
     Tells the delegate that the link which contains ```attribute``` was tapped longly.
     - parameter textView: The text view in which the link is longly tapped.
     - parameter attribute: The attributes for the linke at which user tapped.
     */
    func textView(_ textView: UZTextView, didLongTapLinkAttribute attribute: Any)
    
    /**
     Tells the delegate that selecting of the specified text view has begun.
     - parameter textView: The text view in which editing began.
     */
    func selectingStringBegun(_ textView: UZTextView)
    
    /**
     Tells the delegate that selecting of the specified text view has ended.
     - parameter textView: The text view in which editing ended.
     */
    func selectingStringEnded(_ textView: UZTextView)
}

/**
 Clickable and selectable text view for iOS/macOS/watchOS/tvOS
 */
public class UZTextView: UIView {
    /// margin for tapping the characters.
    static let tapMargin = CGFloat(8)
    
    /// The CTFrame opaque type represents a frame containing multiple lines of text. The frame object is the output resulting from the text-framing process performed by a framesetter object.
    private var ctframe: CTFrame!
    /// The CTFramesetter opaque type is used to generate text frames. That is, CTFramesetter is an object factory for CTFrame objects.
    private var ctframeSetter: CTFramesetter!
    /// CGSize structure which contains the size of string which will be rendered in the view. This size and ```contentInset``` is the size of the view.
    private var contentSize: CGSize = .zero
    /// The distance that the string rendering area is inset from the view. This inset and ```contentSize``` is the size of the view.
    public var contentInset: UIEdgeInsets = .zero {
        didSet { updateLayout() }
    }
    
    /// UIGestureRecognizer which detects long press in order to parse words from the string of the view.
    private var longPressGestureRecognizer: UILongPressGestureRecognizer?
    
    /// NSRange structure which contains the range user currently selects text. If no text is selected, this value is set to NSRange.notFound.
    var selectedRange = NSRange.notFound
    /// NSRange structure which contains the range user currently is tapping link object among the text. If no link object is selected, this value is set to NSRange.notFound.
    private var tappedLinkRange = NSRange.notFound
    
    ///
    private var selectedColor: UIColor = .clear
    
    ///
    private var tappedLinkColor: UIColor = .clear
    
    /// Delegate of UZTextViewDelegate protocol
    public weak var delegate: UZTextViewDelegate?
    
    /// Cursor status
    private var cursorStatus = CursorStatus.none
    
    /// The cursor of the left side of the selection.
    private let leftCursor = UZCursor.createLeftCursor()
    /// The cursor of the right side of the selection.
    private let rightCursor = UZCursor.createRightCursor()
    /// The loupe for selecting text in the view.
    private let loupe = UZLoupe()
    
    /// debug flag
    public var isDebugMode = false {
        didSet { setNeedsDisplay() }
    }

    /// The styled text displayed by the view
    public var attributedString: NSAttributedString = NSAttributedString(string: "") {
        didSet { updateLayout() }
    }
    
    /// Scaling parameter of string rendering.
    /// When scale is not one, attributed string is rendered without any warpping.
    /// Scale must be more than zero.
    public var scale: CGFloat = CGFloat(1) {
        didSet { updateLayout() }
    }
    
    /// The text displayed by the label, read only
    public var string: String {
        return attributedString.string
    }
    
    /**
     Estimate the size of an attributed string.
     - parameter attributedString: Attributed string to be rendered.
     - parameter width: The length which restrict the width of the attributed string.
     - parameter inset: The distance that the string rendering area is inset from the view, default is UIEdgeInsets.zero.
     - returns: CGSize structure which contains the size of an attributed string.
     */
    public static func size(of attributedString: NSAttributedString, restrictedWithin width: CGFloat, inset: UIEdgeInsets = .zero) -> CGSize {
        let setter = CTFramesetterCreateWithAttributedString(attributedString)
        let restrictedSize = CGSize(width: width - (inset.left + inset.right), height: CGFloat.greatestFiniteMagnitude)
        let size = CTFramesetterSuggestFrameSizeWithConstraints(setter, attributedString.fullCFRange, nil, restrictedSize, nil)
        return CGSize(width: size.width + (inset.left + inset.right), height: size.height + (inset.top + inset.bottom))
    }
    
    // MARK: -
    
    public override var tintColor: UIColor! {
        didSet {
            selectedColor = tintColor.withAlphaComponent(0.2)
            tappedLinkColor = tintColor.withAlphaComponent(0.2)
            leftCursor.tintColor = tintColor
            rightCursor.tintColor = tintColor
            loupe.tintColor = tintColor
            setNeedsDisplay()
        }
    }
    
    override public var frame: CGRect {
        didSet { updateLayout() }
    }
    
    override public var bounds: CGRect {
        didSet { updateLayout() }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupGestureRecognizer()
        prepareSubviews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupGestureRecognizer()
        prepareSubviews()
    }
    
    override public func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        // Offset
        context.translateBy(x: contentInset.left, y: contentInset.top)
        
        if scale != 1 {
            context.scaleBy(x: scale, y: scale)
        }
        
        drawAttributedString(context)
        drawBackgroundOfSelectedCharacters(context)
        drawBackgroundOfTappedLinkCharacters(context)
        drawStrikeThroughLine(context)
        
        // for debug
        if isDebugMode {
            drawBoundingBoxesOfAllCharacters(context)
            drawCursorHitRects(context)
        }
    }
    
    // MARK: -
    
    private enum CursorStatus {
        case none
        case movingLeftCursor
        case movingRightCursor
    }
    
    /**
     Adjust rectangles which to tap cursors.
     If left cursor and right cursor overlapped, their sizes must be resize in order to avoid it.
     - parameter leftCursorRect:
     - parameter rightCursorRect:
     - returns:
     */
    private func adjustCursorTappingAreas(leftCursorRect: CGRect , rightCursorRect: CGRect) -> (CGRect, CGRect) {
        var tempLeftCursorRect = leftCursorRect.insetBy(dx: -UZTextView.tapMargin, dy: -UZTextView.tapMargin)
        var tempRightCursorRect = rightCursorRect.insetBy(dx: -UZTextView.tapMargin, dy: -UZTextView.tapMargin)
        
        let intercect = tempLeftCursorRect.intersection(tempRightCursorRect)
        
        if intercect.size.height <  tempLeftCursorRect.size.height {
            tempLeftCursorRect.size.height -= intercect.size.height / 2
            tempRightCursorRect.origin.y += intercect.size.height / 2
            tempRightCursorRect.size.height -= intercect.size.height / 2
        } else {
            tempLeftCursorRect.size.width -= intercect.size.width / 2
            tempRightCursorRect.origin.x += intercect.size.width / 2
            tempRightCursorRect.size.width -= intercect.size.width / 2
        }
        
        return (tempLeftCursorRect, tempRightCursorRect)
    }
    
    /**
     Control cursor to select string in the view.
     - parameter point: CGPoint structure which contains the location at which user is tapping.
     */
    private func manageCursorWhenTouchesBegan(at point: CGPoint) {
        var leftCursorRect = rectForCursor(at: selectedRange.location, side: .left)
        var rightCursorRect = rectForCursor(at: selectedRange.location + selectedRange.length - 1, side: .right)
        
        (leftCursorRect, rightCursorRect) = adjustCursorTappingAreas(leftCursorRect: leftCursorRect, rightCursorRect: rightCursorRect)
        
        if leftCursorRect.contains(point) {
            cursorStatus = .movingLeftCursor
            longPressGestureRecognizer?.isEnabled = false
        } else if rightCursorRect.contains(point) {
            cursorStatus = .movingRightCursor
            longPressGestureRecognizer?.isEnabled = false
        } else {
            let index = characterIndex(at: point)
            if !(selectedRange.arange ~= index) {
                selectedRange = .notFound
            }
        }
    }
    
    /**
     Control cursor to select string in the view.
     - parameter point: CGPoint structure which contains the location at which user is dragging.
     */
    private func manageCursorWhenTouchesMoved(at point: CGPoint) {
        switch cursorStatus {
        case .movingLeftCursor:
            let index = characterIndex(at: point)
            if index != NSNotFound {
                let length = selectedRange.length + selectedRange.location - index
                if length > 0 {
                    selectedRange.location = index
                    selectedRange.length = length
                }
            }
        case .movingRightCursor:
            let index = characterIndex(at: point)
            if index != NSNotFound {
                let length = index - selectedRange.location + 1
                if length > 0 {
                    selectedRange.length = length
                }
            }
        default:
            do {}
        }
    }
    
    /**
     Control cursor to select string in the view.
     - parameter point: CGPoint structure which contains the location at which user's tapping event is cancelled.
     */
    private func manageCursorWhenTouchesCancelled(at point: CGPoint) {
        cursorStatus = .none
        longPressGestureRecognizer?.isEnabled = true
    }
    
    /**
     Control cursor to select string in the view.
     - parameter point: CGPoint structure which contains the location at which user's tapping event is ended.
     */
    private func manageCursorWhenTouchesEnded(at point: CGPoint) {
        if selectedRange.length > 0 {
            let index = characterIndex(at: point)
            if selectedRange.arange ~= index {
                showUIMenuForSelectedString()
            }
        }
        cursorStatus = .none
        longPressGestureRecognizer?.isEnabled = true
    }
    
    // MARK: -
   
    public override func resignFirstResponder() -> Bool {
        return super.resignFirstResponder()
    }
    
    public override var canBecomeFirstResponder: Bool {
        return true
    }
    
    public override func copy(_ sender: Any?) {
        let stringToBeCopied = (self.string as NSString).substring(with: selectedRange)
        print(stringToBeCopied)
        UIPasteboard.general.string = stringToBeCopied
    }
    
    public override func selectAll(_ sender: Any?) {
        selectedRange = self.string.fullNSRange
        updateCursors()
        setNeedsDisplay()
    }
    
    public override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UZTextView.copy(_:)) {
            return true
        } else if action == #selector(UZTextView.selectAll(_:)) {
            return true
        }
        return false
    }
    
    // MARK: -
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let point = touch.location(in: self, inset: contentInset, scale: scale)
        
        UIMenuController.shared.setMenuVisible(false, animated: true)
        
        manageCursorWhenTouchesBegan(at: point)
        updateTappedLinkRange(at: point)
        setNeedsDisplay()
        updateCursors()
        if cursorStatus != .none {
            loupe.isHidden = false
            if let delegate = delegate {
                delegate.selectingStringBegun(self)
            }
        }
        updateLoupe(touch: touch)
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let point = touch.location(in: self, inset: contentInset, scale: scale)
        
        /// ignore z movement
        guard touch.location(in: self) != touch.previousLocation(in: self) else { return }
        
        manageCursorWhenTouchesMoved(at: point)
        tappedLinkRange = .notFound
        setNeedsDisplay()
        updateCursors()
        updateLoupe(touch: touch)
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let point = touch.location(in: self, inset: contentInset, scale: scale)
        if cursorStatus != .none {
            if let delegate = delegate {
                delegate.selectingStringEnded(self)
            }
        }
        manageCursorWhenTouchesCancelled(at: point)
        tappedLinkRange = .notFound
        setNeedsDisplay()
        updateCursors()
        updateLoupe(touch: touch)
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let point = touch.location(in: self, inset: contentInset, scale: scale)
        if cursorStatus != .none {
            if let delegate = delegate {
                delegate.selectingStringEnded(self)
            }
        }
        testTappedLinkRange()   /// this method must be called before calling manageCursorWhenTouchesEnded
        manageCursorWhenTouchesEnded(at: point)
        setNeedsDisplay()
        updateCursors()
        updateLoupe(touch: touch)
        loupe.isHidden = true
    }
    
    // MARK: -
    
    /**
     Draw the attributed string in the view.
     - parameter context: The current graphics context.
     */
    private func drawAttributedString(_ context: CGContext) {
        context.saveGState()
        context.translateBy(x: 0, y: contentSize.height)
        context.scaleBy(x: 1, y: -1)
        context.textMatrix = CGAffineTransform.identity
        CTFrameDraw(ctframe, context)
        context.restoreGState()
    }
    
    private func drawBackgroundColor(_ context: CGContext) {
        attributedString.enumerateAttribute(NSBackgroundColorAttributeName, in: attributedString.fullNSRange, options: []) { (value, range, stop) in
            guard let color = value as? UIColor else { return }
            color.setFill()
            rectangles(with: range).forEach({
                context.fill($0)
            })
        }
    }
    
    /**
     Draw the background rectangles behind the selected characters.
     - parameter context: The current graphics context.
     */
    private func drawBackgroundOfSelectedCharacters(_ context: CGContext) {
        selectedColor.setFill()
        rectangles(with: selectedRange).forEach({
            context.fill($0)
        })
    }
    
    /**
     Draw the background rectangles behind the selected characters.
     - parameter context: The current graphics context.
     */
    private func drawBackgroundOfTappedLinkCharacters(_ context: CGContext) {
        tappedLinkColor.setFill()
        rectangles(with: tappedLinkRange).forEach({
            context.fill($0)
        })
    }
    
    /**
     Draw the strike through lines over the specified characters.
     - parameter context: The current graphics context.
     */
    private func drawStrikeThroughLine(_ context: CGContext) {
        attributedString.enumerateAttribute(NSStrikethroughStyleAttributeName, in: attributedString.fullNSRange, options: []) { (value, range, stop) in
            guard let width = value as? CGFloat else { return }
            rectangles(with: range).forEach({
                context.setLineWidth(width)
                context.move(to: CGPoint(x: $0.minX, y: $0.midY))
                context.addLine(to: CGPoint(x: $0.maxX, y: $0.midY))
                context.drawPath(using: .stroke)
            })
        }
    }
    
    // MARK: -
    
    /**
     For debugging.
     Draw the background rectangles behind the selected characters.
     - parameter context: The current graphics context.
     */
    private func drawBoundingBoxesOfAllCharacters(_ context: CGContext) {
        CTFrameGetLineInfo(ctframe).forEach({ (lineInfo) in
            let lineRect = lineInfo.getRect(contentSize: contentSize)
            let indices = lineInfo.range.arangeIncludingEndIndex.map({$0})
            zip(indices, indices.dropFirst()).forEach({
                let leftOffset = CTLineGetOffsetForStringIndex(lineInfo.line, $0.0, nil)
                let rightOffset = CTLineGetOffsetForStringIndex(lineInfo.line, $0.1, nil)
                let r = CGRect(x: lineInfo.origin.x + leftOffset, y: lineRect.minY, width: rightOffset - leftOffset, height: lineRect.size.height)
                context.stroke(r)
            })
        })
    }
    
    /**
     For debugging.
     Draw the rect where user can tap in order to dragging the selecting range.
     - parameter context: The current graphics context.
     */
    private func drawCursorHitRects(_ context: CGContext) {
        if selectedRange.length > 0 {
            var leftCursorRect = rectForCursor(at: selectedRange.location, side: .left)
            var rightCursorRect = rectForCursor(at: selectedRange.location + selectedRange.length - 1, side: .right)
            (leftCursorRect, rightCursorRect) = adjustCursorTappingAreas(leftCursorRect: leftCursorRect, rightCursorRect: rightCursorRect)
            UIColor.red.withAlphaComponent(0.5).setFill()
            context.fill(leftCursorRect)
            UIColor.green.withAlphaComponent(0.5).setFill()
            context.fill(rightCursorRect)
        }
    }
    
    // MARK: -
    
    /**
     Update the location of the loupe according to the ```UITouch``` object.
     - parameter touch: ```UITouch``` object which induced the event.
     */
    public func updateLoupe(touch: UITouch) {
        switch cursorStatus {
        case .movingLeftCursor:
            loupe.move(to: touch.location(in: self))
        case .movingRightCursor:
            loupe.move(to: touch.location(in: self))
        case .none:
            loupe.move(to: touch.location(in: self))
        }
    }
    
    /**
     Update the location of the loupe according to the ```UIGestureRecognizer``` object.
     - parameter gestureRecognizer: ```UIGestureRecognizer``` object which induced the event.
     */
    public func updateLoupe(gestureRecognizer: UIGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            loupe.isHidden = false
            loupe.move(to: gestureRecognizer.location(in: self))
        case .changed:
            loupe.move(to: gestureRecognizer.location(in: self))
        case .cancelled:
            loupe.move(to: gestureRecognizer.location(in: self))
        case .ended:
            loupe.isHidden = true
            loupe.move(to: gestureRecognizer.location(in: self))
        default:
            do {}
        }
    }
    
    // MARK: -
    
    /**
     Update the position of the cursor according to ```selectedRange``` property.
     If ```selectedRange```'s length is zero, makes cursor hidden.
     */
    private func updateCursors() {
        if selectedRange.length > 0 {
            do {
                let rects = rectangles(with: NSRange(location: selectedRange.location, length: 1))
                guard var rect = rects.first else { return }
                rect = rect.toViewCoordiante(scale: scale, contentInset: contentInset)
                leftCursor.updateLocation(in: rect)
                leftCursor.isHidden = false
            }
            do {
                let rects = rectangles(with: NSRange(location: selectedRange.location + selectedRange.length - 1, length: 1))
                guard var rect = rects.first else { return }
                rect = rect.toViewCoordiante(scale: scale, contentInset: contentInset)
                rightCursor.updateLocation(in: rect)
                rightCursor.isHidden = false
            }
        } else {
            leftCursor.isHidden = true
            rightCursor.isHidden = true
        }
    }
    
    /**
     Check whether the user tapped a link or did not. If any link is tapped, callback to the delegate it.
     */
    private func testTappedLinkRange() {
        if tappedLinkRange != .notFound {
            for i in tappedLinkRange.arange {
                var effectiveRange = NSRange.notFound
                let attribute = attributedString.attributes(at: i, effectiveRange: &effectiveRange)
                guard let _ = attribute[NSLinkAttributeName] else { continue }
                if let delegate = delegate {
                    delegate.textView(self, didClickLinkAttribute: attribute)
                }
                break
            }
            tappedLinkRange = .notFound
        }
    }
    
    /**
     Check whether the user tapped a link or did not. If any link is tapped, callback to the delegate it.
     */
    private func updateTappedLinkRange(at point: CGPoint) {
        let index = characterIndex(at: point)
        guard index != NSNotFound else { tappedLinkRange = .notFound; return }
        if selectedRange.arange ~= index { return }
        var effectiveRange = NSRange.notFound
        let attribute = self.attributedString.attributes(at: index, effectiveRange: &effectiveRange)
        guard let _ = attribute[NSLinkAttributeName] else { tappedLinkRange = .notFound; return }
        tappedLinkRange = effectiveRange
    }
    
    /**
     Update text layout in the view.
     This method must be called after resizing the view, updating the string and so on.
     */
    private func updateLayout() {
        
        if scale == 0 || scale < 0 {
            scale = 1
        }
        
        let horizontalMargin = contentInset.left + contentInset.right
        
        if scale != 1 {
            contentSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        } else {
            contentSize = CGSize(width: self.frame.size.width - horizontalMargin, height: CGFloat.greatestFiniteMagnitude)
        }
        
        selectedRange = .notFound
        tappedLinkRange = .notFound
        
        leftCursor.isHidden = true
        rightCursor.isHidden = true
        loupe.isHidden = true
        
        let frameSetter = CTFramesetterCreateWithAttributedString(attributedString)
        let frameSize = CTFramesetterSuggestFrameSizeWithConstraints(frameSetter, attributedString.fullCFRange, nil, contentSize, nil)
        contentSize.height = frameSize.height
        let contentRect = CGRect(origin: .zero, size: contentSize)
        let path = CGPath(rect: contentRect, transform: nil)
        ctframe = CTFramesetterCreateFrame(frameSetter, CFRange.zero, path, nil)
        ctframeSetter = frameSetter
        setNeedsDisplay()
    }
    
    // MARK: -
    
    /**
     Setup and attach gesture recognizer to the view.
     */
    private func setupGestureRecognizer() {
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(UZTextView.didChangeLongPressGesture(_:)))
        gestureRecognizer.minimumPressDuration = 0.5
        self.addGestureRecognizer(gestureRecognizer)
        longPressGestureRecognizer = gestureRecognizer
    }
    
    /**
     Dispatch a long press gesture event.
     - parameter gestureRecognizer: An UIGestureRecognizer object.
     */
    func didChangeLongPressGesture(_ gestureRecognizer: UILongPressGestureRecognizer) {
        let point = gestureRecognizer.location(in: self, inset: contentInset, scale: scale)
        switch gestureRecognizer.state {
        case .began:
            let index = characterIndex(at: point)
            var effectiveRange = NSRange.notFound
            if index != NSNotFound {
                var attribute = self.attributedString.attributes(at: index, effectiveRange: &effectiveRange)
                if let _ = attribute[NSLinkAttributeName] {
                    if let delegate = delegate {
                        attribute[UZTextViewLinkRange] = effectiveRange
                        delegate.textView(self, didLongTapLinkAttribute: attribute)
                    }
                } else {
                    selectedRange = rangeOfWord(at: point)
                    updateLoupe(gestureRecognizer: gestureRecognizer)
                }
            }
        case .changed:
            selectedRange = rangeOfWord(at: point)
            updateLoupe(gestureRecognizer: gestureRecognizer)
        case .ended:
            updateLoupe(gestureRecognizer: gestureRecognizer)
        default:
            do {}
        }
        setNeedsDisplay()
        updateCursors()
    }
    
    // MARK: -
    
    /**
     Prepare subviews, such as UZCursor and UZLoupe objects.
     */
    private func prepareSubviews() {
        leftCursor.frame = .zero
        self.addSubview(leftCursor)
        leftCursor.isHidden = true
        rightCursor.frame = .zero
        self.addSubview(rightCursor)
        rightCursor.isHidden = true
        loupe.textView = self
        
        selectedColor = tintColor.withAlphaComponent(0.2)
        tappedLinkColor = tintColor.withAlphaComponent(0.2)
        leftCursor.tintColor = tintColor
        rightCursor.tintColor = tintColor
        loupe.tintColor = tintColor
    }
    
    /**
     Returns CGRect array which contains rectangles around specified characters. If there are no characaters, returns an empty array.
     - parameter range: Index range which specifies the characters.
     - returns: CGRect array which contains rectangles around specified characters. A CGRect object is generated each line if the characters extend more than two lines.
     */
    private func rectangles(with range: NSRange) -> [CGRect] {
        guard range.length > 0 else { return [] }
        return CTFrameGetLineInfo(ctframe)
        .flatMap({
            let lineRect = $0.getRect(contentSize: contentSize)
            let intersect = NSIntersectionRange($0.range, range)
            if intersect.length > 0 {
                let leftOffset = CTLineGetOffsetForStringIndex($0.line, intersect.location, nil)
                let rightOffset = CTLineGetOffsetForStringIndex($0.line, NSMaxRange(intersect), nil)
                return CGRect(x: $0.origin.x + leftOffset, y: lineRect.minY, width: rightOffset - leftOffset, height: lineRect.size.height)
            } else {
                return nil
            }
        })
    }
    
    /**
     Show UIMenuController which handles selected string.
     - parameter point: CGPoint structure which contains the location at which user tapped.
     */
    private func showUIMenuForSelectedString() {
        let targetRect = rectangles(with: selectedRange)
            .map({
                $0.toViewCoordiante(scale: scale, contentInset: contentInset)
            })
            .reduce(CGRect.null, { (result, rect) -> CGRect in
                return rect.union(result)
            })
        self.becomeFirstResponder()
        UIMenuController.shared.setTargetRect(targetRect, in: self)
        UIMenuController.shared.setMenuVisible(true, animated: true)
    }
    
    /**
     Returns attributes as an dictionary from character at where user tapped.
     If character does not have any attributes, returns nil.
     - parameter point: CGPoint structure which contains location which user tapped.
     - returns: The attributes for the character at where user tapped.
     */
    public func attributes(at point: CGPoint) -> [String: Any]? {
        let pointForText = point.toTextCoordiante(scale: scale, contentInset: contentInset)
        let index = characterIndex(at: pointForText)
        guard index != NSNotFound else { return nil }
        var effectiveRange = NSRange.notFound
        var attributes = attributedString.attributes(at: index, effectiveRange: &effectiveRange)
        let rect = rectangles(with: effectiveRange).union
        attributes[UZTextViewLinkRect] = rect.toViewCoordiante(scale: scale, contentInset: contentInset)
        return attributes
    }
    
    /**
     Returns A NSRange structure that contains the range over the word user tapped, or if the function fails for any reason, an not found range.
     The word is detected using CFStringTokenizer.
     - parameter point: A CGPoint structure which contains a location at which user tapped.
     - returns: A NSRange structure that contains the range over the word user tapped, or if the function fails for any reason, an not found range.
     */
    func rangeOfWord(at point: CGPoint) -> NSRange {
        let index = characterIndex(at: point)
        guard index != NSNotFound else { return .notFound }
        
        let string = self.attributedString.string as CFString
        let range: CFRange = string.fullCFRange
        guard let tokenizer = CFStringTokenizerCreate(kCFAllocatorDefault, string, range, kCFStringTokenizerUnitWordBoundary, nil)
            else { return .notFound }
        
        var tokenType = CFStringTokenizerGoToTokenAtIndex(tokenizer, index)
        repeat {
            let range = CFStringTokenizerGetCurrentTokenRange(tokenizer)
            
            if range.arange ~= index {
                return range.nsrange
            }
            
            tokenType = CFStringTokenizerAdvanceToNextToken(tokenizer)
        } while tokenType.rawValue != 0
        
        return .notFound
    }
    
    /// Curosr position
    private enum CursorEdge {
        case left
        case right
    }
    
    /**
     Get rect of cursors.
     - parameter index: Index of character user is selecting.
     - parameter side: Position of cursor. This value must be .left if the index is the start index of a selected range, or be .right then other case.
     */
    private func rectForCursor(at index: Int, side: CursorEdge) -> CGRect {
        let rects = rectangles(with: NSRange(location: index, length: 1))
        
        guard var rect = rects.first else { return .zero }
        
        switch side {
        case .left:
            rect.size.width = 1
            rect = rect.insetBy(dx: -UZTextView.tapMargin, dy: 0)
        case .right:
            rect.origin.x = rect.origin.x + rect.size.width - 1
            rect.size.width = 1
            rect = rect.insetBy(dx: -UZTextView.tapMargin, dy: 0)
        }
        
        /// convert to view's coordinate
        /// adjust left or right edge
        if rect.origin.x / scale + contentInset.left < 0 {
            rect.origin.x = contentInset.left * scale
        }
        if (rect.origin.x + rect.size.width) / scale + contentInset.right > self.frame.size.width {
            rect.origin.x -= (self.frame.size.width - contentInset.right) * scale - rect.origin.x - rect.size.width
        }
        return rect
    }
  
    /**
     Returns index of the character user tapped in the view.
     - parameter point: A CGPoint structure which contains a location at which user tapped.
     - returns: Index of the character user tapped, or if the function fails for any reason, NSNotFound.
     */
    private func characterIndex(at point: CGPoint) -> Int {
        enum CharacterIndex: Error {
            case find(index: Int)
        }
        do {
            try CTFrameGetLineInfo(ctframe).forEach({ (lineInfo) in
                let lineRange = lineInfo.range
                let lineRect = lineInfo.getRect(contentSize: contentSize)
                guard lineRect.contains(point) else { return }
                let indices = lineRange.arangeIncludingEndIndex.map({$0})
                try zip(indices, indices.dropFirst()).forEach({
                    let leftOffset = CTLineGetOffsetForStringIndex(lineInfo.line, $0.0, nil)
                    let rightOffset = CTLineGetOffsetForStringIndex(lineInfo.line, $0.1, nil)
                    let r = CGRect(x: lineInfo.origin.x + leftOffset, y: lineRect.minY, width: rightOffset - leftOffset, height: lineRect.size.height)
                    if r.contains(point) {
                        throw CharacterIndex.find(index: $0.0)
                    }
                })
            })
        } catch CharacterIndex.find(let index) {
            return index
        } catch {
            return NSNotFound
        }
        return NSNotFound
    }
}
