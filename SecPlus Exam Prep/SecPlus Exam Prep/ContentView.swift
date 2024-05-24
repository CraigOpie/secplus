//
//  ContentView.swift
//  SecPlus Exam Prep
//
//  Created by Craig Opie on 5/24/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    @State private var questions: [Question] = []
    @State private var currentQuestionIndex = 0
    @State private var selectedAnswers: Set<String> = []
    @State private var correctAnswers = 0
    @State private var showResult = false
    @State private var mode: QuizMode?
    @State private var showMenu = true
    @State private var hasCheckedAnswer = false
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        if showMenu {
            menuView
        } else if showResult {
            resultView
        } else {
            quizView
        }
    }
    
    var menuView: some View {
        VStack(spacing: 30) {
            Text("SecPlus Practice Exam")
                .multilineTextAlignment(.center)
                .font(.title)
                .padding(.top, 50)

            Spacer()

            Button(action: {
                self.mode = .study
                self.showMenu = false
                self.loadQuestions()
            }) {
                Text("Study Mode")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.primary)
                    .cornerRadius(10)
            }
            .buttonStyle(MagicButtonEffect())

            Button(action: {
                self.mode = .exam
                self.showMenu = false
                self.loadQuestions()
            }) {
                Text("Exam Mode")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.primary)
                    .cornerRadius(10)
            }
            .buttonStyle(MagicButtonEffect())

            Spacer()
        }
        .padding()
    }
}

struct MagicButtonEffect: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .brightness(configuration.isPressed ? 0.1 : 0)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
