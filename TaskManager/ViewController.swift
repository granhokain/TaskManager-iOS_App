//
//  ViewController.swift
//  TaskManager
//
//  Created by Rafael Martins on 18/04/19.
//  Copyright © 2019 Rafael Martins. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var tasks: NSFetchedResultsController<Task> {
        if _tasks != nil {
            return _tasks!
        }
        let request = NSFetchRequest<Task>()
        request.entity = NSEntityDescription.entity(forEntityName: "Task", in: context)
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        let result = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        result.delegate = self
        _tasks = result
        
        do { try _tasks!.performFetch() }
        catch let error { print((error as NSError)) }
        
        return _tasks!
    }
    var _tasks: NSFetchedResultsController<Task>? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //informo que o delegade do meu textField é minha propria classe
        taskNameTextField.delegate = self
        //Calcula o tamanho da linha automaticamente de acordo com o tamanho da tarefa
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    @IBAction func addTask() {
        //Verifica se o campo está vazio
        if taskNameTextField.text == "" {
            return
        }
        //Adiciona a tarefa a lista de tarefas com CoreData(Banco de dados)
        let newTask = NSEntityDescription.insertNewObject(forEntityName: "Task", into: context) as! Task
        newTask.name = taskNameTextField.text
        //Salva a tarefa no banco de dados
        saveContext()
        //Limpa o campo de texto depois de adicionar
        taskNameTextField.text = ""
        //Recolhe o teclado apos adicionar
        taskNameTextField.resignFirstResponder()
    }
    
    //UITableViewDataSource
    //- Métodos obrigatórios que devem ser implementados ao usar o tableView
    //Esse primeira função precisamos informar quantas linhas terá a tabela
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Informamos o tamanho da lista
        return tasks.fetchedObjects?.count ?? 0
    }
    //Esse segunda função precisamos informar a célula para cada índice informado na tabela
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath) as UITableViewCell
        
        configureCell(cell: cell, atIndexPath: indexPath as NSIndexPath)
        
        return cell
    }
    //Essa terceira função é utilizada para excluir uma tarefa
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //Se for para remover, é excluido a tarefa do indice informado
        if editingStyle == .delete {
            //Maneira de deletar quando é usado o CoreData(Banco de dados)
            context.delete(tasks.object(at: indexPath) as NSManagedObject)
            //Salva a atualização
            saveContext()

        }
    }
    
    //UITextFieldDelegate
    //- Método utilizado para quando é clicado no enter do teclado
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Chama o método de adidionar a tarefa ao clicar no enter do teclado
        addTask()
        return true
    }
    
    //NSFetchedResultsControllerDelegate
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?){
        switch type {
        case NSFetchedResultsChangeType.insert:
            tableView.insertRows(at:[newIndexPath!], with: .fade)
        case NSFetchedResultsChangeType.delete:
            tableView.deleteRows(at:[indexPath!], with: .fade)
        case NSFetchedResultsChangeType.update:
            configureCell(cell: tableView.cellForRow(at: indexPath!)!, atIndexPath: indexPath! as NSIndexPath)
        default:
            return
        }
    }
    
    //Configura a célula da tabela
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        //Captura o índice do array daquela célula
        let task = tasks.fetchedObjects![indexPath.row] as Task
        cell.textLabel?.text = task.name
    }
    
    func saveContext(){
        //Salva as alterações
        do { try context.save()}
        catch let error { print((error as NSError))}
    }
    

    
}

