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
