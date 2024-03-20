########################################################################################

class Code # class to store and manipulate code strings

    def initialize()
        @code = [] # array to hold generated code
    end

    def printCode()
        print @code  # prints code
    end

    def getCode()
        return @code # returns code
    end

    def genCode() # function that generates code for a computer player

        @code = []
        possAns = ["r", "o", "y", "g", "b", "i", "v"] # generates from this array of possible code letters

        for i in 1..4 do # appends 4 random letters to the code array
            num = rand(0..6)
            @code.append(possAns[num])
        end
    
        print "\nNew code successfully generated." # success message
    
    end

    def codeValidity() # checks if code includes ONLY valid letters (used to debug and check user input)

        valid = true

        if @code.length != 4
            valid = false # if the length of the code is too long or short, it's automatically invalid
        end

        @code.each do |letter|
            if !["r", "o", "y", "g", "b", "i", "v"].include?(letter)
                valid = false # if any letter is non-valid, the code is automatically invalid
            end
        end

        return valid

    end

    def chooseCode(array) # initializes a code with a user's desired letters
        @code = array
    end

    def codeCheck(codeKey)

        hintKey = [] # an array to hold the feedback after code comparison

        for i in 0..3 do
            if @code[i] == codeKey.getCode[i]
                hintKey.append("!") # appends an ! if the letter is the correct color and position
            elsif codeKey.getCode.include?(@code[i])
                hintKey.append("?") # appends an ? if the letter is the correct color but wrong position
            else
                hintKey.append("X") # appends an X if the letter is not in the code
            end
        end

        return hintKey # returns the hint array
    
    end

end

########################################################################################

class Board

    def initialize 
        #initializes instance variables for the board object
        @p1Disp = "" # these format the player names in a display for the board
        @p2Disp = ""
        @p1 = "" 
        @p2 = ""
        @score1 = 0 # set score to zero to begin
        @score2 = 0
        @twoPlayer = false # default player num is 1
        @triesLeft = 10 # set number of tries to 10 to start
        @board = ""

    end

    def beginTwoPlayer() # initializes and returns a board for two players

        # setting player names for formatting
        @p1Disp = "      Player 1"
        @p2Disp = "      |        Player 2"
        @p1 = "Player 1"
        @p2 = "Player 2"
        @twoPlayer = true # recording that it is a two person game
    
        #created a specific board for 10 attempts for formatting reasons
        displayBoard = "
        +---------------------------------------------------+
        |       MASTERMIND      |    ATTEMPTS LEFT: 10/10   |
        +-----------------------+---------------------------+
        |#{@p1Disp}: #{@score1}#{@p2Disp}: #{@score2}        |
        +-------+-------+-------+-------+-------------------+
        |   1   |   2   |   3   |   4   |       hint!       |
        +-------+-------+-------+-------+-------------------+
        |       |       |       |       |         |         |
        |       |       |       |       +---------+---------+
        |       |       |       |       |         |         |
        +-------+-------+-------+-------+-------------------+\n\n"

        return displayBoard

    end

    def beginOnePlayer() # initializes and returns a board for one player and a computer

    # setting player names for formatting
        @p1Disp = "       Player"
        @p2Disp = "       |        Computer"
        @p1 = "Player"
        @p2 = "Computer "
        @twoPlayer = false # recording that it is NOT a two person game

        #needed a specific board for 10 attempts for formatting reasons
        displayBoard = "
        +---------------------------------------------------+
        |       MASTERMIND      |    ATTEMPTS LEFT: 10/10   |
        +-----------------------+---------------------------+
        |#{@p1Disp}: #{@score1}#{@p2Disp}: #{@score2}        |
        +-------+-------+-------+-------+-------------------+
        |   1   |   2   |   3   |   4   |       hint!       |
        +-------+-------+-------+-------+-------------------+
        |       |       |       |       |         |         |
        |       |       |       |       +---------+---------+
        |       |       |       |       |         |         |
        +-------+-------+-------+-------+-------------------+\n\n"

        return displayBoard
        
    end

    def updateBoard(userGuess, hintKey)

        # concatenates the board string with each new player attempt and new player feedback
        @board += ("
        |       |       |       |       |    " + hintKey[0] + "    |    " + hintKey[1] + "    |
        |   " + userGuess[0] + "   |   " + userGuess[1] + "   |   " + userGuess[2] + "   |   " + userGuess[3] + "   +---------+---------+
        |       |       |       |       |    " + hintKey[2] + "    |    " + hintKey[3] + "    |
        +-------+-------+-------+-------+-------------------+")

        @triesLeft -= 1 # records the number of attempts left

    end

    def printBoard() # prints the board
        # returns the scoreboard concatenated with the cumulative string of player attempts
        print "
        +---------------------------------------------------+
        |       MASTERMIND      |    ATTEMPTS LEFT: #{@triesLeft}/10    |
        +-----------------------+---------------------------+
        |#{@p1Disp}: #{@score1}#{@p2Disp}: #{@score2}        |
        +-------+-------+-------+-------+-------------------+
        |   1   |   2   |   3   |   4   |       hint!       |
        +-------+-------+-------+-------+-------------------+" + @board + "\n\n"
    end

    def printScores() # prints the final scores of the game

        puts "\n*************************************************************************"
        puts " ########################    FINAL SCORES   ############################"
        puts "*************************************************************************\n"
    
        print "          +------------------------+--------------------------+
          | #{@p1Disp}: #{@score1}#{@p2Disp}: #{@score2}       |
          +------------------------+--------------------------+\n"
        puts "*************************************************************************\n"

    end

    def resetBoard() # resets board
        @board = ""
        @triesLeft = 10
    end

    def updateScore1() # updates score and sends a little winner's message
        @score1 += 1
        print "\n#{@p1} wins!\n"
    end

    def updateScore2()  # updates score and sends a little winner's message
        @score2 += 1
        print "\n#{@p2} wins!\n"
    end

    def tries # returns number of tries left
        return @triesLeft
    end

end

########################################################################################

class MastermindGame

    def initialize(playerNum)
        # instance variables for each game
        @codeKey = Code.new # stores the correct code
        @score1 = 0 # set default scores to zero
        @score2 = 0 
        @playerCount = playerNum # player count is given
        @board = Board.new # new board for the game
        @gameWin = false
    end

    def beginGame()

        if @playerCount == 2 # if playing against a friend

            # print("\e[14;0H") # clears output screen to make for a cleaner display
            # print("\e[J")

            print "\nA code can be created using a four-letter combination of the following colors: \n"
            print "red (R), orange (O), yellow (Y), green (G), blue (B), indigo (I), and violet (V). \n"
            print "\nWhich player would like to select the code? (1 / 2): "
            @codePlayer = gets.chomp.to_i
            while @codePlayer != 1 && @codePlayer != 2 # error checking
                print "\nError: Invalid input. Please select again: "
                @codePlayer = gets.chomp.to_i
            end
            @guessPlayer = ((@codePlayer % 2) + 1) # uses remainder to find the other player
            print "\nPlayer #{@codePlayer}, please enter the desired code, separated by spaces: "
            userInput = gets.chomp.downcase.split(" ")
            @codeKey.chooseCode(userInput)

            while !@codeKey.codeValidity() # check validity of the user-selected code
                print "Error: Invalid input. Please enter again: "
                userInput = gets.chomp.downcase.split(" ")
                @codeKey.chooseCode(userInput)
            end

            print "\n\nCode stored!"
            print "\nBeginning game"
            print "."
            sleep 0.33
            print "."
            sleep 0.60
            puts "."
            sleep 0.60 # clears screen so the other player doesn't see it in the input stream

            # print("\e[14;0H")
            # print("\e[J")

            print @board.beginTwoPlayer()

        elsif @playerCount == 1 # playing against a computer

            @codePlayer = 2 # computer is the code master
            @guessPlayer = "Player"
            @codeKey.genCode() # generates a code
            print @board.beginOnePlayer()

        end

        while @gameWin == false && @board.tries > 0 # while loop runs each round as long as the game is not won and the guessing player
                                                    # has tries left
            startRound()
        end

        if @playerCount == 2
            if @gameWin == true # if the guessing player correctly guessed the code, they win
                if @guessPlayer == 1
                    @board.updateScore1() # so update the score of whoever the guessing player was
                elsif @guessPlayer == 2
                    @board.updateScore2() # so update the score of whoever the guessing player was
                end
            elsif @gameWin == false && @board.tries <= 0 # if the guessing player ran out of tries, the code player wins
                print "#{@guessPlayer} is out of tries. "
                if @codePlayer == 1
                    @board.updateScore1() # so update the score of whoever the code player was
                elsif @codePlayer == 2
                    @board.updateScore2() # so update the score of whoever the code player was
                end
            end
        elsif @playerCount == 1
            if @gameWin == true # if the player correctly guessed the code, they win
                @board.updateScore1()
            elsif @gameWin == false && @board.tries <= 0 # if the player ran out of tries, the computer wins
                print "You are out of tries :( "
                @board.updateScore2()
            end
        end

        # resetting gameWin and the board in case the player wants to play again
        @gameWin = false
        @board.resetBoard()

    end

    def startRound() # runs for every round of one game

        # array to hold user input and a code object to hold the user's guess
        userArr = []
        userGuess = Code.new

        if @playerCount == 2
            print "\nPlayer #{@guessPlayer}, please enter a guess, separated by spaces: " 
        else
            print "\nPlease enter a guess, separated by spaces: "
        end

        userArr = gets.chomp.downcase.split(" ") # split guess into array
        userGuess.chooseCode(userArr) # save guess into code object

        while !userGuess.codeValidity()
            print "Error: Invalid input. Please enter again: "
            userArr = gets.chomp.downcase.split(" ")
            userGuess.chooseCode(userArr)
        end

        # print("\e[14;0H") # clear screen in preparation to print new board
        # print("\e[J")

        # checking code
        hintKey = userGuess.codeCheck(@codeKey)

        if (hintKey == ["!", "!", "!", "!"])
            @gameWin = true # if all code is right, game is won!
        end

        # update and print board
        @board.updateBoard(userArr, hintKey)
        @board.printBoard()

    end

    def finalScores()
        # printing final scoreboard
        @board.printScores()
    end

end

########################################################################################

#intro message
puts "\n*************************************************************************"
puts " #########################    MASTERMIND   #############################"
puts "*************************************************************************\n\n"

puts "This program allows you to play Mastermind against a computer generated 
code. Possible colors are red (R), orange (O), yellow (Y), green (G), 
blue (B), indigo (I), and violet (V). \n\n" # program intro

puts "*************************************************************************"

print "\nWould you like to (1) play against the computer, or
                  (2) play against a friend, or
                  (3) read the instructions? (1 / 2 / 3): "
playernumber = gets.chomp.to_i
answer = "y" # setting a variable for program rerun

if playernumber == 3 # instructions
    puts "HOW TO PLAY:"
    puts "One player, either a friend or the computer, creates a 4-letter code made"
    puts "up of the possible colors seen above. The other player then has 10 attempts"
    puts "to guess the correct combinations of colors. Duplicates are allowed."
    puts "\nThe hint column on the right side of the box tells us if the color and "
    puts "position is correct (!), if the color is correct and the position is wrong"
    puts "(?), and if the color isn't included in the code at all (X)."
    print "\nWould you like to (1) play against the computer, or
                  (2) play against a friend? (1 / 2): "
    playernumber = gets.chomp.to_i
end

while playernumber != 1 && playernumber != 2
    print "\nError: Invalid input. Please select again: "
    playernumber = gets.chomp.to_i
end

newGame = MastermindGame.new(playernumber) # initialize new game with desired player number

while answer == "y"

    newGame.beginGame()
    print "\nWould you like to play another round? Enter Y for yes, enter any other "
    print "\nkey to exit: "
    answer = gets.chomp.downcase
    print("\e[2J\e[0;0H")
    puts "\n*************************************************************************"
    puts " #########################    MASTERMIND   #############################"
    puts "*************************************************************************\n\n"

    puts "This program allows you to play Mastermind against a computer generated 
code. Possible colors are red (R), orange (O), yellow (Y), green (G), 
blue (B), indigo (I), and violet (V). \n\n" # program intro

    print "*************************************************************************"

end
newGame.finalScores() # print scores
puts "\nThank you for playing!" # goodbye message
puts "Quitting program... "