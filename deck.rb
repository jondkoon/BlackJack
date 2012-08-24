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
