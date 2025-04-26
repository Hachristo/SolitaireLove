io.stdout:setvbuf("no")
require "vector"

PileClass = {}

function PileClass:new(xPos, yPos, tableau)
  local pile = {}
  local metadata = {__index = PileClass}
  setmetatable(pile, metadata)
  
  pile.position = Vector(xPos, yPos)
  pile.size = Vector(50, 70)
  pile.cards = {}
  
  pile.type = tableau
  
  return pile
end

function PileClass:update()
  for i, iCard in ipairs(self.cards) do
    if i == #self.cards then
      iCard.side = true
      iCard.draggable = true
--    else
--      iCard.side = false
--      iCard.draggable = false
    end
  end
end

function PileClass:draw()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.rectangle("line", self.position.x, self.position.y, self.size.x, self.size.y, 6, 6)
  
  for _, card in ipairs(self.cards) do
    card:draw()
  end
end

function PileClass:checkForMouseOver(grabber)
  if grabber.grabPos == nil then
    return
  end
    
  local mousePos = grabber.currentMousePos
  local isMouseOver = 
    mousePos.x > self.position.x and
    mousePos.x < self.position.x + self.size.x and
    mousePos.y > self.position.y and
    mousePos.y < self.position.y + self.size.y
  
  return isMouseOver
end

function PileClass:addCard(card)
  table.insert(self.cards, card)
  for i, iCard in ipairs(self.cards) do
    iCard.position.x = self.position.x --+ self.size.x / 2
    iCard.position.y = self.position.y + ((i-1) * 15 * self.type)
  end
end

function PileClass:removeCard(card)
  table.remove(self.cards)
  for i, iCard in ipairs(self.cards) do
    card.position.x = self.position.x --+ self.size.x / 2
    card.position.y = (self.position.y + self.size.y / 2) + ((i-1) * 15 * self.type)
  end
end