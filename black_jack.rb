require_relative 'card'
require_relative 'hand'
require_relative 'deck'
require_relative 'player'

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

players = [
    Player.new("Jon",true),
    Player.new("Julie",false),
    Player.new("Rusty",false),
    Player.new("Jenny",false)
]

game = BlackJack.new(players)
game.start
