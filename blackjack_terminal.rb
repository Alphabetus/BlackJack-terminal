# REQUIRED GEMS
require "tty-screen"
# NEEDED VARS
$terminalWidth = TTY::Screen.width
$dealerHand = []
$playerHand = []
cardName  = ["A", "K", "Q", "J", 10, 9, 8, 7, 6, 5, 4, 3, 2]
suits = ["♠", "♥", "♦", "♣"]
numberOfDecks = 4
$cardList = []
$gameOnPlayer = 1
$dealerHandValue = 0
$playerHandValue = 0
$playerAces11 = 0
$dealerAces11 = 0
$activeDeal = nil
# METHODS
# return card value according to card
def giveCardValue(card)
  #get first char of string
  cardRank = card[0]
  # switch case for the respective card value
  # first lets give the letters a value, then we convert the remaining items to integer because thats what they are and we assign the correct value.
  case cardRank
  when "Q", "K", "J"
    value = 10
  when "A"
    # lets check who is the $activeDeal
    if $activeDeal === "me"
      $playerAces11 += 1
    end
    if $activeDeal === "cpu"
      $dealerAces11 += 1
    end
    value = 11
  else
    if cardRank === "1"
      value = (cardRank.to_i * 10)
    else
      value = cardRank.to_i
    end

  end

  return value
end

# deal card to given player
def deal(player)

  case player
  when "cpu"
    card = $cardList.shuffle.delete_at(0)
    cardValue = giveCardValue(card)
    $dealerHand << card
    $dealerHandValue = $dealerHandValue + cardValue
  when "player"
    card = $cardList.shuffle.delete_at(0)
    cardValue = giveCardValue(card)
    $playerHand << card
    $playerHandValue = $playerHandValue + cardValue
  end

end

def getPlayerHand
  myHand = ""
  $playerHand.each do |card|
    myHand.insert(0, card + " ")
  end

  return myHand
end

def getDealerHand
  hisHand = ""
  $dealerHand.each do |card|
    hisHand.insert(0, card + " ")
  end

  return hisHand
end

def restartGame
  puts "\n\n"
  puts "-" * $terminalWidth

  questionBoot = "Would you like to play again? 'yes' or 'no'."
  goReboot = 0
  puts questionBoot
  while goReboot === 0 do

    case gets.chomp.downcase
    when "yes"
      puts "Get ready, new round will start soon..."
      goReboot = 1
      sleep(2)
      load("blackjack_terminal.rb")
    when "no"
      puts "Game will now end."
      sleep (1)
      puts "Bye"
      puts "-" * $terminalWidth
      exit
    else
      puts "Wrong answer..."
      puts questionBoot
    end

  end
end
# END OF METHODS

# CREATE DECK OF CARDS

numberOfDecks.times do
  cardName.each do |card|
    suits.each do |suit|
      $cardList << card.to_s + suit
    end
  end
end


# INITIAL DISPLAY
system("clear")
puts "-" * $terminalWidth
puts ""
puts "Welcome to my Blackjack script! Feel free to loose all your imaginary money..."
puts "\nRULES:\n\n"
puts "The game is played with 4 complete decks."
puts "CPU goes first and draws 2 cards, only one is visible."
puts "After that it is your turn!\n"
puts "The main objective is to get as close as possible to 21 without going over it."
puts "If you go over you loose. Once you hit stop CPU will play."
puts "CPU will only ask for card if he his below 17."
puts "If CPU goes over 21 you automatically win with any value."
puts "Aces can be worth 1 or 11 points. They change automatically to avoid bursting."
puts "-" * $terminalWidth
puts "\n"

#get permission to start game
goQuestion = "Are you ready to start? Type 'yes' to play or 'no' to abort."
puts goQuestion
goGame = 0
while goGame === 0 do
  case gets.chomp.downcase
  when "no"
    puts "Game aborted. Bye."
    exit
  when "yes"
    puts "\nGood luck, game is about to start.\n\n"
    goGame = 1
    sleep(1)
  else
    puts "Wrong answer. Try again."
    puts goQuestion
  end
end

# game is starting deal 2 dealer cards & 2 player cards
$activeDeal = "cpu"
2.times do
  deal("cpu")
end

$activeDeal = "me"
2.times do
  deal("player")
end

# validate initial double ace...
if $playerAces11 > 1
  $playerAces11 -= 1
  $playerHandValue -= 10
end

if $dealerAces11 > 1
  $dealerAces11 -= 1
  $dealerHandValue -= 10
end

system("clear")
# this is the player sided card loop
while $gameOnPlayer === 1 && $playerHandValue < 21 do
  myHand = getPlayerHand
  # display player & dealer cards
  puts "DEALER HAND: ⛞  #{$dealerHand[0]}"
  puts "YOUR HAND: #{myHand}."
  # ask if wants more cards or stay
  puts "Would you like to 'hit' or 'stay'?"
  case gets.chomp.downcase
  when "hit"
    $activeDeal = "me"
    deal("player")
    # lets check if there is an Ace. Because if it is... it can be 1 or 11.
    # so, in here im checking $playerAces11 to check the number of aces that are worth 11 points.
    # If there is any still worth 11 points i remove 1 integer from $playerAces11 and 10 points from $playerHandValue
    if $playerAces11 > 0
      $playerAces11 -= 1
      $playerHandValue -= 10
    end

  when "stay"
    puts "You decided to stay."
    $gameOnPlayer = 0
  else
    puts "Ups... error... only 'hit' or 'stay'."
  end
sleep(1.0/2.0)
system("clear")
end

# LOOP ENDED lets find out why
myHand = getPlayerHand

if $playerHandValue === 21
  puts "YOUR HAND: #{myHand}"
  puts "Wow! 21."
end

if $playerHandValue > 21
  puts "YOUR HAND: #{myHand}"
  puts "Ups! You bursted your hand. You have #{$playerHandValue} points."
  puts "You lost... Dealer won!\n"
  restartGame
end

if $gameOnPlayer === 0
  puts "YOUR HAND: #{myHand}"
end

sleep(1)
# lets make the dealer play :)
puts "\nNow it is time for the dealer to reveal his second card and draw...\n"

hisHand = getDealerHand
sleep(1.0/2.0)
if $dealerHandValue === 21
  puts "DEALER HAND: #{hisHand}"
  puts "Dealer has Blackjack!"
end

if $dealerHandValue > 21
  puts "DEALER HAND: #{hisHand}"
  puts "Dealer has bursted"
end

if $dealerHandValue >= 17 && $dealerHandValue < 21
  puts "DEALHER HAND: #{hisHand}"
  puts "Dealer has more than 17 points. Dealer stays."
end

if $dealerHandValue < 17
  puts "DEALER HAND: #{hisHand}"
  puts "\nDealer will now draw..."
end
sleep(3)

system("clear")
while $dealerHandValue < 17 do
  # lets get some cleanup here
  puts "\n"
  $activeDeal = "cpu"
  deal("cpu")
  # lets check if there is an Ace. Because if it is... it can be 1 or 11.
  # so, in here im checking $dealerAces11 to check the number of aces that are worth 11 points.
  # If there is any still worth 11 points i remove 1 integer from $dealerAces11 and 10 points from $dealerHandValue
  if $dealerAces11 > 0
    $dealerAces11 -= 1
    $dealerHandValue -= 10
  end
  hisHand = getDealerHand
  puts "DEALER HAND: #{hisHand}"

  # dealer game loop runned for the last time
  # lets understand why!
  if $dealerHandValue > 21
    puts "Dealer has bursted!"
  end

  if $dealerHandValue >= 17 && $dealerHandValue < 21
    puts "Dealer reached at least 17 points. Dealer stays."
  end

  if $dealerHandValue === 21
    puts "Dealer has 21!"
  end

  if $dealerHandValue < 17
    puts "Dealer has less than 17. Will draw again."
  end

  puts "Your hand: #{getPlayerHand}"

  sleep(3)
  system("clear")
end

# alright.. loops are over... lets get some outputs and find the winner...

puts "\n"
hisHand = getDealerHand
myHand = getPlayerHand
if $dealerHandValue > 21 # you won.. he bursted
  puts "You WON!\nDealer has bursted"
  puts "DEALER HAND: #{hisHand}"
  puts "YOUR HAND: #{myHand}"
else
  puts "DEALHER HAND: #{hisHand}"
  puts "Dealer has #{$dealerHandValue} points.\n"
  puts "YOUR HAND: #{myHand}"
  puts "You have #{$playerHandValue} points."

  if $dealerHandValue > $playerHandValue
    puts "\nYou lost!"
  elsif $dealerHandValue === $playerHandValue
    puts "\nIt's a tie!"
  else
    puts "\nCongratulations... You WON!"
  end

end

#done lets get the user the chance to play again.
restartGame
