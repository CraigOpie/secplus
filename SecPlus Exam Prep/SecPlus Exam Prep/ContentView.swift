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
    
    var resultView: some View {
        VStack(spacing: 30) {
            Text(correctAnswers >= (questions.count / 10 * 8) ? "Pass" : "Fail")
                .font(.largeTitle)
                .fontWeight(.bold)

            VStack(alignment: .leading, spacing: 15) {
                Text("Performance Breakdown")
                    .font(.title2)

                Text("Percentage Correct: \(Int(Double(correctAnswers) / Double(questions.count) * 100))%")
                Text("Questions Correct: \(correctAnswers)")
                Text("Questions Incorrect: \(questions.count - correctAnswers)")
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)

            Button(action: retryQuiz) {
                Text("Retry")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.primary)
                    .cornerRadius(10)
            }
            .buttonStyle(MagicButtonEffect())
        }
        .padding()
    }
    
    var quizView: some View {
        VStack(spacing: 20) {
            HStack {
                ProgressBar(progress: Double(currentQuestionIndex) / Double(questions.count))
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.85)

                Spacer(minLength: 10)

                Button(action: {
                    self.showMenu = true
                    self.retryQuiz()
                }) {
                    Image(systemName: "xmark")
                        .padding(10)
                        .background(colorScheme == .dark ? Color.black : Color.white)
                        .foregroundColor(.primary)
                        .clipShape(Circle())
                }
                .buttonStyle(MagicButtonEffect())
            }

            if !questions.isEmpty {
                Text(questions[currentQuestionIndex].question)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.primary)

                ForEach(questions[currentQuestionIndex].allOptions, id: \.self) { option in
                    Button(action: {
                        if !hasCheckedAnswer {
                            if selectedAnswers.contains(option) {
                                selectedAnswers.remove(option)
                            } else {
                                selectedAnswers.insert(option)
                            }
                        }
                    }) {
                        Text(option)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(buttonColor(for: option))
                            .foregroundColor(.primary)
                            .overlay(correctBorder(for: option))
                            .cornerRadius(10)
                            .blur(radius: shouldBlur(option: option) ? 5 : 0)
                    }
                    .buttonStyle(MagicButtonEffect())
                }

                Spacer()

                Button(action: {
                    if hasCheckedAnswer {
                        moveToNextQuestion()
                    } else {
                        checkAnswer()
                    }
                }) {
                    Text(hasCheckedAnswer ? "Next Question" : "Submit")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(!selectedAnswers.isEmpty ? Color.green : Color.gray)
                        .foregroundColor(.primary)
                        .cornerRadius(10)
                }
                .buttonStyle(MagicButtonEffect())
                .disabled(selectedAnswers.isEmpty)
                .padding(.bottom, 20)
            }
        }
        .padding()
        .onAppear(perform: loadQuestions)
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
