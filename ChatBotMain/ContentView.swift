//
//  ContentView.swift
//  ChatBotMain
//
//
//

import SwiftUI
import OpenAI


class ChatController: ObservableObject {
    @Published var messages: [Message] = []
    
    let openAI = OpenAI(apiToken: "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")
    init() {
            // Append the bot's welcome message without triggering OpenAI
            messages.append(Message(content: "Hello! How can I assist you today?", isUser: false))
        }
    func sendNewMessage(content: String) {
        let userMessage = Message(content: content, isUser: true)
        self.messages.append(userMessage)
        getBotReply()
    }
    
    func getBotReply() {
        let query = ChatQuery(
            messages: self.messages.map({
                .init(role: .user, content: $0.content)!
            }),
            model: .gpt4
        )
        
        openAI.chats(query: query) { result in
            switch result {
            case .success(let success):
                guard let choice = success.choices.first else {
                    return
                }
                guard let message = choice.message.content?.string else { return }
                DispatchQueue.main.async {
                    self.messages.append(Message(content: message, isUser: false))
                }
            case .failure(let failure):
                print(failure)
                
            }
            
        }
    }
    }
  
struct Message: Identifiable {
    var id: UUID = .init()
    var content: String
    var isUser: Bool
}

struct ContentView: View {
    @StateObject var chatController: ChatController = .init()
    @State var string: String = ""
    var body: some View {NavigationView {
        VStack {
            
            VStack {
                ScrollView {
                    ForEach(chatController.messages) {
                        message in
                        MessageView(message: message)
                            .padding(5)
                        
                    }
                }
            }
            Divider()
            HStack {
                TextField("Ask Anything...", text: self.$string, axis: .vertical)
                    .padding(5)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(15)
                Button {
                    self.chatController.sendNewMessage(content: string)
                    string = ""
                } label: {
                    Image(systemName: "paperplane")
                }
            }
            .padding()
        } .navigationBarTitle("DJTX AI V1", displayMode: .inline) // Set the app name as the title
    }
    }
}

struct MessageView: View {
    var message: Message
   
    var body: some View {
        Group {
            if message.isUser {
                HStack {
                    Spacer()
                    Text(message.content)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        
                }
            } else {
                HStack {
                    Text(message.content)
                        .padding()
                        .background(Color.purple)
                        .foregroundColor(Color.white)
                       
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    Spacer()
                }
            }
        }
    }
}


#Preview {
    ContentView()
}
