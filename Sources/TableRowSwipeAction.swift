import UIKit

public typealias SwipeActionHandler = (RowSwipeAction) -> Void

protocol ContextualActionProtocol {
    var title: String? { get }
    var backgroundColor: UIColor? { get set }
    var image: UIImage? { get set }
}
public class RowSwipeAction: ContextualActionProtocol {
    let style: Style
    let title: String?
    var backgroundColor: UIColor?
    var image: UIImage?
    let handler: SwipeActionHandler
    
    public init(style: Style, title: String? = nil, backgroundColor: UIColor? = nil, image: UIImage? = nil, handler: @escaping SwipeActionHandler) {
        self.style = style
        self.title = title
        self.backgroundColor = backgroundColor
        self.image = image
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
        
        if let color = self.backgroundColor {
            action.backgroundColor = color
        }
        
        if let image = self.image {
            action.image = image
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
        
        var actionStyle: UITableViewRowActionStyle {
            switch self{
                case .normal:
                    return UITableViewRowActionStyle.normal
                
                case .destructive:
                    return UITableViewRowActionStyle.destructive
            }
        }
    }
}

public struct RowSwipeConfiguration {
    private let swipeActions: [RowSwipeAction]
    public let performsActionWithFullSwipe: Bool
    
    init(actions: [RowSwipeAction], performsActionWithFullSwipe: Bool = false) {
        self.swipeActions = actions
        self.performsActionWithFullSwipe = performsActionWithFullSwipe
    }
    
    var actions: [ContextualActionProtocol]{
        return self.swipeActions.map { $0.contextualAction() }
    }
}

extension UITableViewRowAction: ContextualActionProtocol {
    var image: UIImage? {
        get {
            return nil
        }
        
        set {}
    }
}

@available(iOS 11.0, *)
extension UIContextualAction: ContextualActionProtocol {}

public protocol ContextualStyle {}
extension UITableViewRowActionStyle: ContextualStyle {}

@available(iOS 11.0, *)
extension UIContextualAction.Style: ContextualStyle {}
