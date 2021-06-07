//
//  ChatInputAccessaryView.swift
//  MachingApp
//
//  Created by 田中　玲桐 on 2021/04/18.
//

import UIKit

protocol chatInputAccessaryViewDelegate:class {
    func tappedSendButton(text:String)
}

class ChatInputAccessaryView:UIView{
    
    @IBOutlet weak var chatTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    
    
    @IBAction func tappedSendButton(_ sender: Any){
        
        guard let text=chatTextView.text else {return}
        delegate?.tappedSendButton(text: text)
    }
    
    weak var delegate:chatInputAccessaryViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        nibInit()
        setupView()
        chatTextView.frame = .zero
        sendButton.frame = .zero
        autoresizingMask = .flexibleHeight
    
    }
    
    private func setupView(){
        chatTextView.layer.cornerRadius=15
        chatTextView.layer.borderColor = UIColor.rgb(red: 230, green: 230, blue: 230).cgColor
        chatTextView.layer.borderWidth=1
        sendButton.layer.cornerRadius=15

        sendButton.isEnabled=false
        
        chatTextView.text=""
        chatTextView.delegate=self
    }
    func removeText(){
        chatTextView.text=""
        sendButton.isEnabled=false
    }
    
    private func nibInit(){
        let nib=UINib(nibName: "ChatInputAccessaryView", bundle: nil)
        guard let view=nib.instantiate(withOwner: self, options: nil).first as? UIView
        else {return}
        view.frame=self.bounds
        view.autoresizingMask=[.flexibleHeight,.flexibleWidth]
        self.addSubview(view)
 
    }
    override var intrinsicContentSize: CGSize{
        return .zero
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
extension ChatInputAccessaryView:UITextViewDelegate{
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty{
            sendButton.isEnabled=false
        }else{
            sendButton.isEnabled=true
        }
    }
}

