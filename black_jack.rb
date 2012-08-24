#!/bin/env ruby
# encoding: utf-8

class Card
    attr_reader :suit, :rank

    @@suit_characters = {
        spade: '♠',
        club: '♣',
        diamond: '♦',
        heart: '♥'
    }

    @@rank_characters = {
        11 => 'J',
        12 => 'Q',
        13 => 'K',
        14 => 'A'
    }
    (2..10).each {|i| @@rank_characters[i] = i.to_s }

    def initialize(suit, rank)
        @suit = suit
        @rank = rank
    end

    public
    def value
        if @rank <= 10 then
            return @rank
        elsif @rank <= 13 then
            return 10
        else
            return 11
        end
    end

    def lowValue
        val = value
        return 1 if val == 11
        return val
    end

    def to_s
        @@rank_characters[@rank]+@@suit_characters[@suit]
    end
end

class Hand
    include Comparable
    attr_reader :cards

    def initialize(cards)
        @cards = cards || []
    end

    def <=>(other)
        value <=> other.value
    end

    public
    def addCard(card)
        @cards.push(card)
    end

    def value
        total = 0
        aces = 0
        @cards.each do |card|
            cardValue = card.lowValue
            aces += 1 if cardValue == 1
            total += cardValue
        end
        while aces > 0 and total <= 11
            aces -= 1
            total += 10
        end
        return total
    end

    def busted?
        return value > 21
    end

    def to_s
        @cards.to_s
    end
end

class Deck
    attr_reader :cards
    def initialize
        @cards = []
        suits = [:spade, :heart, :club, :diamond]
        suits.each do |suit|
            (2..14).each do |rank| 
                @cards.push(Card.new(suit,rank))
            end
        end
    end

    public
    def drawCard
        @cards.delete_at(rand(@cards.length))
    end

    def drawCards(number)
        cards = []
        number.times { cards.push(drawCard) }
        return cards
    end

    def to_s
        @cards.each do |card|
            puts card
        end
    end
end

class Player
    include Comparable
    attr_reader :hand, :name, :dealer

    def initialize(name, dealer)
        @name = name
        @dealer = dealer
    end

    def <=>(other)
        @hand <=> other.hand
    end

    public
    def drawCards(deck)
        @hand = Hand.new(deck.drawCards(2))
    end

    def busted?
        @hand.busted?
    end

    def score
        @hand.value
    end

    def to_s
        dealer = @dealer ? '*' : ''
        "#{dealer}#{@name}'s hand is worth #{score()}. They are holding: #{@hand}"
    end
end

class BlackJack
    def initialize(players)
        @players = players
    end

    def start
        @deck = Deck.new
        @players.each{|player| player.drawCards(@deck) }
        winners = determine_winners
        announce_winners(winners)
    end

    public
    def announce_winners(winners)
        if !winners then
            puts "all players busted\n\n"
        elsif winners.length == 1 then 
            puts "the winner is #{winners.first.name}\n\n"
        elsif winners.length > 1 then
            first_names = winners[0,winners.size-1].map{|player| player.name}.join', '
            comma = winners.size > 2 ? ',' : ''
            last_name = winners.last.name
            #jon and julie ... jon, rusty, and julie
            puts "the winners are #{first_names}#{comma} and #{last_name}\n\n"
        end
        @players.sort.reverse.each do |player|
            puts player
        end

        puts "\n*indicates the dealer"
    end


    def determine_winners
        sorted_players = @players.find_all{|player| !player.busted?}.sort
        return nil if sorted_players.empty?

        high_score = sorted_players.last.score
        winners = sorted_players.find_all{|player| player.score == high_score}

        #was one of the winners the dealer
        dealer = winners.find_all{|player| player.dealer}
        winners = dealer if dealer.length > 0
        return winners
    end
end

jon = Player.new("Jon",true)
julie = Player.new("Julie",false)
rusty = Player.new("Rusty",false)
jenny = Player.new("Jenny",false)

game = BlackJack.new([jon,julie,rusty,jenny])
game.start
