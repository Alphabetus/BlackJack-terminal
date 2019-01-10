# BlackJack on Ruby > For terminal

This project was created only to test my Ruby skills.  
It is a simple game will allow you to have some fun on your terminal while playing Blackjack.

## Features
- 4 decks, 52 cards per deck.
- Stay / Hit options.
- Play non stop until you close game.
- Aces are worth 1 or 11 points depending on drawn cards.
- Dealer respects real BJ rules. He stays over 17 and hits on below.
- While player turn lasts, dealer has only 1 visible card.

## Dependencies
- Ruby 2.6.0
- Gem 'tty-screen' (https://github.com/piotrmurach/tty-screen)

Note: 'tty-screen' is not _really_ needed. I'm using it to get screen width to make some separators.  

## Instructions *with* gem 'tty-screen'
1. Clone the project to your desired location.
2. Install GEM with command `$ gem install tty-screen`.
2. Run game with command `$ ruby /path/to/file/blackjack_terminal.rb`.
3. Have fun!

## Instructions *without* gem 'tty-screen'
1. Clone the project to your desired location.
2. Open `blackjack_terminal.rb` on your favourite text editor.
3. Comment out `require "tty-screen"`.
4. Replace `$terminalWidth = TTY::Screen.width` with `$terminalWidth = INTEGER_NUMBER`
5. Run game with command `$ ruby /path/to/file/blackjack_terminal.rb`.
6. Have fun!
