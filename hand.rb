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
