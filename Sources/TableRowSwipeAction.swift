import UIKit

public typealias SwipeActionHandler = (RowSwipeAction, IndexPath) -> Void

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
    
    init(style: Style, title: String? = nil, backgroundColor: UIColor? = nil, image: UIImage? = nil, handler: @escaping SwipeActionHandler) {
        self.style = style
        self.title = title
        self.backgroundColor = backgroundColor
        self.image = image
        self.handler = handler
    }
    
    func contextualAction(indexPath: IndexPath) -> ContextualActionProtocol {
        var action: ContextualActionProtocol
        
        if #available(iOS 11, *) {
            action = UIContextualAction(style: self.style.contextualActionStyle, title: self.title, handler: { [weak self] (contextualAction, view, completion) in
                if let `self` = self {
                    self.handler(self, indexPath)
                    completion(true)
                }
            })
        } else {
            action = UITableViewRowAction(style: self.style.actionStyle, title: self.title, handler: { [weak self] (rowAction, indexPath) in
                if let `self` = self {
                    self.handler(self, indexPath)
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
    public let indexPath: IndexPath
    public let performsActionWithFullSwipe: Bool
    
    init(indexPath: IndexPath, actions: [RowSwipeAction], performsActionWithFullSwipe: Bool = false) {
        self.indexPath = indexPath
        self.swipeActions = actions
        self.performsActionWithFullSwipe = performsActionWithFullSwipe
    }
    
    var actions: [ContextualActionProtocol]{
        return self.swipeActions.map { $0.contextualAction(indexPath: self.indexPath) }
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
