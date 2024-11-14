import SwiftUI

enum Player: String {
    case x = "X"
    case o = "O"
}

class TicTacToe: ObservableObject {
    @Published var board: [[String]]
    @Published var currentPlayer: Player
    
    init() {
        self.board = [[" ", " ", " "], [" ", " ", " "], [" ", " ", " "]]
        self.currentPlayer = .x
    }
    
    func makeMove(row: Int, col: Int) -> Bool {
        if row < 0 || row > 2 || col < 0 || col > 2 || board[row][col] != " " {
            return false
        }
        board[row][col] = currentPlayer.rawValue
        return true
    }
    
    func checkWinner() -> Player? {
        for i in 0..<3 {
            if board[i][0] == board[i][1] && board[i][1] == board[i][2] && board[i][0] != " " {
                return currentPlayer
            }
            if board[0][i] == board[1][i] && board[1][i] == board[2][i] && board[0][i] != " " {
                return currentPlayer
            }
        }
        
        if board[0][0] == board[1][1] && board[1][1] == board[2][2] && board[0][0] != " " {
            return currentPlayer
        }
        if board[0][2] == board[1][1] && board[1][1] == board[2][0] && board[0][2] != " " {
            return currentPlayer
        }
        
        return nil
    }
    
    func isBoardFull() -> Bool {
        for row in board {
            for cell in row {
                if cell == " " {
                    return false
                }
            }
        }
        return true
    }
    
    func switchPlayer() {
        currentPlayer = (currentPlayer == .x) ? .o : .x
    }
    
    func resetGame() {
        self.board = [[" ", " ", " "], [" ", " ", " "], [" ", " ", " "]]
        self.currentPlayer = .x
    }
}

struct ContentView: View {
    @StateObject private var game = TicTacToe()
    @State private var gameOver = false
    @State private var winner: Player?
    @State private var isDraw = false
    
    var body: some View {
        VStack {
            Spacer(minLength: 20) // Adds space between the top and the first row of the game board
            
            // Game board section
            VStack {
                ForEach(0..<3) { row in
                    HStack {
                        ForEach(0..<3) { col in
                            Button(action: {
                                if game.makeMove(row: row, col: col) {
                                    if let winner = game.checkWinner() {
                                        self.winner = winner
                                        self.gameOver = true
                                    } else if game.isBoardFull() {
                                        self.isDraw = true
                                        self.gameOver = true
                                    } else {
                                        game.switchPlayer()
                                    }
                                }
                            }) {
                                Text(game.board[row][col])
                                    .font(.system(size: 60))
                                    .frame(width: 100, height: 100)
                                    .background(Color.gray.opacity(0.3))
                                    .foregroundColor(.black)
                                    .cornerRadius(10)
                                    .padding(5)
                            }
                            .disabled(game.board[row][col] != " " || gameOver)
                        }
                    }
                }
            }
            
            Spacer(minLength: 20) // Adds space between the game board and the game result section
            
            // Game status and play again button section
            if gameOver {
                VStack {
                    if let winner = winner {
                        Text("\(winner.rawValue) wins!")
                            .font(.largeTitle)
                            .padding()
                    } else if isDraw {
                        Text("It's a Draw!")
                            .font(.largeTitle)
                            .padding()
                    }
                    
                    Button(action: {
                        game.resetGame()
                        gameOver = false
                        winner = nil
                        isDraw = false
                    }) {
                        Text("Play Again")
                            .font(.title)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding(.bottom, 20) // Adds space at the bottom of the screen
            } else {
                Text("\(game.currentPlayer.rawValue)'s turn")
                    .font(.title)
                    .padding()
            }
            
            Spacer() // Adds space between the play again button and the bottom of the screen
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
