import UIKit

public typealias SwipeActionHandler = (RowSwipeAction) -> Void

protocol ContextualActionProtocol {
    var title: String? { get }
    var actionBackgroundColor: UIColor? { get set }
    var actionImage: UIImage? { get set }
}

public class RowSwipeAction: ContextualActionProtocol {
    let style: Style
    var title: String?
    var actionBackgroundColor: UIColor?
    var actionImage: UIImage?
    let handler: SwipeActionHandler
    
    public init(style: Style, title: String? = nil, backgroundColor: UIColor? = nil, image: UIImage? = nil, handler: @escaping SwipeActionHandler) {
        self.style = style
        self.title = title
        self.actionBackgroundColor = backgroundColor
        self.actionImage = image
        self.handler = handler
    }
    
    func contextualAction() -> ContextualActionProtocol {
        var action: ContextualActionProtocol
        
        if #available(iOS 11, *) {
            action = UIContextualAction(style: self.style.contextualActionStyle, title: self.title, handler: { [weak self] (_, _, completion) in
                if let `self` = self {
                    self.handler(self)
                    completion(true)
                }
            })
        } else {
            action = UITableViewRowAction(style: self.style.actionStyle, title: self.title, handler: { [weak self] (_, _) in
                if let `self` = self {
                    self.handler(self)
                }
            })
        }
        
        if let color = self.actionBackgroundColor {
            action.actionBackgroundColor = color
        }
        
        if let image = self.actionImage {
            action.actionImage = image
        }
        
        return action
    }
    
    public enum Style{
        case normal
        case destructive
        
        @available(iOS 11.0, *)
        var contextualActionStyle: UIContextualAction.Style {
            switch self{
                case .normal:
                    return UIContextualAction.Style.normal
                
                case .destructive:
                    return UIContextualAction.Style.destructive
            }
        }
        
        var actionStyle: UITableViewRowAction.Style {
            switch self{
                case .normal:
                    return UITableViewRowAction.Style.normal
                
                case .destructive:
                    return UITableViewRowAction.Style.destructive
            }
        }
    }
}

public struct RowSwipeConfiguration {
    private let swipeActions: [RowSwipeAction]
    public let performsActionWithFullSwipe: Bool
    
    public init(actions: [RowSwipeAction], performsActionWithFullSwipe: Bool = false) {
        self.swipeActions = actions
        self.performsActionWithFullSwipe = performsActionWithFullSwipe
    }
    
    var actions: [ContextualActionProtocol]{
        return self.swipeActions.map { $0.contextualAction() }
    }
}

extension UITableViewRowAction: ContextualActionProtocol {
    var actionBackgroundColor: UIColor? {
        get {
            return self.backgroundColor
        }
        
        set {
            self.backgroundColor = self.actionBackgroundColor
        }
    }
    
    var actionImage: UIImage? {
        get {
            return nil
        }
        
        set {}
    }
}

@available(iOS 11.0, *)
extension UIContextualAction: ContextualActionProtocol {
    var actionBackgroundColor: UIColor? {
        get {
            return self.backgroundColor
        }
        
        set {
            if let color = actionBackgroundColor {
                self.backgroundColor = color
            }
        }
    }
    
    var actionImage: UIImage? {
        get {
            return self.image
        }
        
        set {
            self.image = self.actionImage
        }
    }
}

public protocol ContextualStyle {}
extension UITableViewRowAction.Style: ContextualStyle {}

@available(iOS 11.0, *)
extension UIContextualAction.Style: ContextualStyle {}
