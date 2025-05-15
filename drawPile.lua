
require "vector"
require "card"

DrawPileClass = {}

function DrawPileClass:new(xPos, yPos, cards, deck, hand, discard)
  local drawPile = {}
  local metadata = {__index = DrawPileClass}
  setmetatable(drawPile, metadata)
  
  drawPile.position = Vector(xPos, yPos)
  drawPile.size = Vector(50, 70)
  drawPile.cards = cards
  drawPile.deck = deck
  drawPile.hand = hand
  drawPile.discard = discard
  
  drawPile.sprite = love.graphics.newImage("Sprites/card_back.png")
  
  drawPile.buffer = true
  
  return drawPile
end

function DrawPileClass:draw()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.draw(self.sprite, self.position.x, self.position.y, 0, 1, 1)
end

function DrawPileClass:update()
  if love.mouse.isDown(1) and self:checkForMouseOver() and self.buffer then
    self:drawCards()
    self.buffer = false
  end
  if not love.mouse.isDown(1) then
    self.buffer = true
  end
  
end

function DrawPileClass:checkForMouseOver()
  local mousePos = Vector(
    love.mouse.getX(),
    love.mouse.getY()
  )
  local isMouseOver = 
    mousePos.x > self.position.x and
    mousePos.x < self.position.x + self.size.x and
    mousePos.y > self.position.y and
    mousePos.y < self.position.y + self.size.y
  
  return isMouseOver
end

function DrawPileClass:drawCards()
  local handCards = self.hand:getPileCards()
  for i = 1, 3 do
    self.hand:removeCard(handCards[1])
    self.discard:addCard(handCards[1])
  end
  local loops = math.min(#self.deck.cards, 3)
  for i = 1, loops do
    local card1 = CardClass:new(250, 135, self.deck:popCard(), true, true)
    table.insert(self.cards, card1)
    self.hand:addCard(card1)
  end
end