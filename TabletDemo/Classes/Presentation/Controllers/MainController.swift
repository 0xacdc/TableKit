//
//  MainController.swift
//  TabletDemo
//
//  Created by Max Sokolov on 16/04/16.
//  Copyright © 2016 Tablet. All rights reserved.
//

import UIKit
import Tablet

class MainController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableDirector = TableDirector(tableView: tableView)
        }
    }
    var tableDirector: TableDirector!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*let rowBuilder = TableRowBuilder<String, StoryboardImageTableViewCell>(items: ["1", "1", "1", "1"])
            .action(.click) { [unowned self] data in
                
                self.performSegueWithIdentifier("headerfooter", sender: nil)
            }*/
        
        
        
        
        let a = TableRowAction<String, StoryboardImageTableViewCell>(.click) {
            (row) in
            
        }
        
        
        
        let row1 = TableRow<String, StoryboardImageTableViewCell>(item: "1")
        let row2 = TableRow<String, StoryboardImageTableViewCell>(item: "2")
        let row3 = TableRow<String, StoryboardImageTableViewCell>(item: "3", actions: [a])
       
        
        row1
            .action(TableRowAction(.click) { (row) in
            
                
            })
            .action(TableRowAction(.click) { (row) -> String in
                
                return ""
            })
        
        

        let section = TableSection(headerTitle: "", footerTitle: "", rows: [row1, row2, row3])
        
        
        
        tableDirector.append(section: section)
        
        
        
        
        
        
        /*rowBuilder
            .addAction(TableRowAction(type: .Click) { (data) in
            
                
            })
        
        rowBuilder
            .delete(indexes: [0], animated: .None)
            .insert(["2"], atIndex: 0, animated: .None)
            .update(index: 0, item: "", animated: .None)
            .move([1, 2], toIndexes: [3, 4])
        
        
        
        //tableView.moveRowAtIndexPath(<#T##indexPath: NSIndexPath##NSIndexPath#>, toIndexPath: <#T##NSIndexPath#>)
        //tableView.deleteRowsAtIndexPaths(<#T##indexPaths: [NSIndexPath]##[NSIndexPath]#>, withRowAnimation: <#T##UITableViewRowAnimation#>)
        //tableView.insertRowsAtIndexPaths(<#T##indexPaths: [NSIndexPath]##[NSIndexPath]#>, withRowAnimation: <#T##UITableViewRowAnimation#>)
        //tableView.reloadRowsAtIndexPaths(<#T##indexPaths: [NSIndexPath]##[NSIndexPath]#>, withRowAnimation: <#T##UITableViewRowAnimation#>)
        
        //tableView.moveSection(0, toSection: 0)
        //tableView.reloadSections([], withRowAnimation: .None)
        //tableView.deleteSections([], withRowAnimation: .None)
        //tableView.insertSections([], withRowAnimation: .None)
        
        //tableDirector.performBatchUpdates {
        //}*/
        
        //tableDirector.append(section: section)
    }
}