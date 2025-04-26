
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

function DeckClass:new()
  local deck = {}
  local metadata = {__index = DeckClass}
  setmetatable(deck, metadata)
  
  deck.cards = {}
  
  math.randomseed(os.time())
  
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

function DeckClass:popCard()
  local cardIndex = math.random(#deck.cards)
  local card = deck.cards[cardIndex]
  table.remove(deck.cards, cardIndex)
  return card
end