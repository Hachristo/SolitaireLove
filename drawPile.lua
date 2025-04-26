
require "vector"
require "card"

DrawPileClass = {}

function DrawPileClass:new(xPos, yPos, cards, deck)
  local drawPile = {}
  local metadata = {__index = DrawPileClass}
  setmetatable(drawPile, metadata)
  
  drawPile.position = Vector(xPos, yPos)
  drawPile.size = Vector(50, 70)
  drawPile.cards = cards
  drawPile.drawnCards = {}
  drawPile.deck = deck
  
  drawPile.buffer = true
  
  return drawPile
end

function DrawPileClass:draw()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.rectangle("line", self.position.x, self.position.y, self.size.x, self.size.y, 6, 6)
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
  if #self.deck.cards < 3 then
    if #self.deck.cards == 0 then
      return
    elseif #self.deck.cards == 1 then
      local card1 = CardClass:new(250, 135, self.deck:popCard(), true, true)
      table.insert(self.cards, card1)
      table.insert(self.drawnCards, card1)
    else
      local card1 = CardClass:new(250, 135, self.deck:popCard(), true, true)
      table.insert(self.cards, card1)
      table.insert(self.drawnCards, card1)
      local card2 = CardClass:new(225, 135, self.deck:popCard(), false, true)
      table.insert(self.cards, card1)
      table.insert(self.drawnCards, card1)
    end
  end
  for i, card in ipairs(self.drawnCards) do
    card.position.x = 200
    card.position.y = 135
    card.draggable = false
  end
  local card1 = CardClass:new(200, 135, self.deck:popCard(), false, true)
  local card2 = CardClass:new(225, 135, self.deck:popCard(), false, true)
  local card3 = CardClass:new(250, 135, self.deck:popCard(), true, true)
  table.insert(self.cards, card1)
  table.insert(self.cards, card2)
  table.insert(self.cards, card3)
  table.insert(self.drawnCards, card1)
  table.insert(self.drawnCards, card2)
  table.insert(self.drawnCards, card3)
end