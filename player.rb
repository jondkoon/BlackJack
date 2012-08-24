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
