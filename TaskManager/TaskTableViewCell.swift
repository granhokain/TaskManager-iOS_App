//
//  TaskTableViewCell.swift
//  TaskManager
//
//  Created by Rafael Martins on 22/04/19.
//  Copyright © 2019 Rafael Martins. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    //Variáveis com a posição inicial e a cor inicial antes de começar a arrastar o componente
    var initialPosition: CGPoint?
    var initialColor: UIColor?
    //Variáveis com flags que informam se deve excluir ou completar a tarefa quando terminar de arrastar o componente
    var deleteOnDragRelease: Bool!
    var completeOnDragRelease: Bool!
    //Variável com a tarefa que deve ser informado como parametro no delegate
    var task: Task?
    //Variável com o tipo do delegate que foi implementado
    var delegate: TaskTableViewCellDelegate?
    

    //Criação da célula editada
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //Seta as cores dos componentes de acordo com a extensão TaskmanagerColors
        self.backgroundColor = UIColor.frontColor()
        self.textLabel?.textColor = UIColor.cellFontColor()
        
        //Controle dos gestos de swipe para direita e para a esquerda
        //UIPanGestureRecognizer - Gesto de quando é pressionado e arrastado
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        //Informa que o delegade é a própria classe
        gesture.delegate = self
        //Adiciona o recognizer a classe
        self.addGestureRecognizer(gesture)
    }
    
    // Função para o reconhecimento do gesto
    @objc func handlePan(recognizer: UIPanGestureRecognizer){
        //Gesto de quando o dedo toca na tela e segura sem arrastar o componente(ou seja a célula) é inicializado esse método
        if recognizer.state == .began {
            initialPosition = self.center
            initialColor = self.backgroundColor
        }
        
        //Gesto de quando o componente(ou seja a célula) começa a ser arrastado é inicializado esse método
        if recognizer.state == .changed {
            let translation = recognizer.translation(in: self)
            self.center = CGPoint(x: initialPosition!.x + translation.x, y: initialPosition!.y)
            deleteOnDragRelease = self.frame.origin.x < (-self.frame.size.width / 2)
            completeOnDragRelease = self.frame.origin.x > (self.frame.size.width / 2)
            
            if deleteOnDragRelease! {
                self.backgroundColor = UIColor.deletedTaskColor()
            }else if completeOnDragRelease! {
                self.backgroundColor = UIColor.completedTaskColor()
            }else {
                self.backgroundColor = initialColor
            }
        }
        
        //Gesto de quando solta o dedo da tela é inicializado esse método
        if recognizer.state == .ended {
            let originalFrame = CGRect(x:0, y: self.frame.origin.y, width: self.bounds.size.width, height: self.bounds.size.height)
            if deleteOnDragRelease! {
                if task != nil {
                    delegate?.taskItemDeleted(task: task!)
                }
            } else if completeOnDragRelease {
                UIView.animate(withDuration: 0.2, animations: {self.frame = originalFrame})
                if task != nil {
                    delegate?.taskItemCompleted(task: task!)
                }
            }else {
                UIView.animate(withDuration: 0.2, animations: {self.frame = originalFrame})
            }
        }
    }
    
    //Função para retornar se deve interceptar o gesto ou não
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let recognizer = gestureRecognizer as! UIPanGestureRecognizer
        //Controla em que direção o gesto foi feito
        let translation = recognizer.translation(in: self.superview)
        
        //Verifica se é gesto horizontal
        if abs(translation.x) > abs(translation.y){
            return true
        }
        return false
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
