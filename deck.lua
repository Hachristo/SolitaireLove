
DeckClass = {}
Suits = {
  [1] = "hearts",
  [2] = "clubs",
  [3] = "diamonds",
  [4] = "spades"
}
Numbers = {
  [1] = "01",
  [2] = "02",
  [3] = "03",
  [4] = "04",
  [5] = "05",
  [6] = "06",
  [7] = "07",
  [8] = "08",
  [9] = "09",
  [10] = "10",
  [11] = "11",
  [12] = "12",
  [13] = "13"
}

function DeckClass:new(discard, seed)
  local deck = {}
  local metadata = {__index = DeckClass}
  setmetatable(deck, metadata)
  
  deck.cards = {}
  deck.discard = discard
  deck.seed = seed
  
  math.randomseed(seed)
  
  return deck
end

function DeckClass:fillDeck()
  for n, suit in ipairs(Suits) do
    for i = 1, 13 do
      local card = "card_" .. Suits[n] .. "_" .. Numbers[i] .. ".png"
      table.insert(deck.cards, card)
    end
  end
end

function DeckClass:refillDeck()
  for _, tableCard in ipairs(self.discard.cards) do
    local card = "card_" .. tableCard.suit .. "_" .. tableCard.number .. ".png"
    table.insert(deck.cards, card)
  end
  local length = #self.discard.cards
  for i = 1, length do
    table.remove(self.discard.cards, 1)
  end
end

function DeckClass:popCard()
  local cardIndex = math.random(#deck.cards)
  local card = deck.cards[cardIndex]
  table.remove(deck.cards, cardIndex)
  return card
end

function DeckClass:removeTopCard()
  local card = deck.cards[1]
  table.remove(deck.cards, 1)
  return card
end