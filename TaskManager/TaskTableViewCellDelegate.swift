//
//  TaskTableViewCellDelegate.swift
//  TaskManager
//
//  Created by Rafael Martins on 22/04/19.
//  Copyright © 2019 Rafael Martins. All rights reserved.
//

import Foundation

protocol TaskTableViewCellDelegate {
    
    func taskItemDeleted (task: Task) //Chamado quando a tarefa é deletada
    func taskItemCompleted(task: Task) //Chamado quando a tarefa é completada
    
}
