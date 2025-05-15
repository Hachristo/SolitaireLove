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
  if self.type == 1 then
    self:tableauUpdate()
  elseif self.type == 0 then
    self:acePileUpdate()
  elseif self.type == 2 then
    self:handUpdate()
  elseif self.type == 3 then
    self:discardUpdate()
  end
end

function PileClass:draw()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.rectangle("line", self.position.x, self.position.y, self.size.x, self.size.y, 6, 6)
  for _, card in ipairs(self.cards) do
    card:draw()
  end
end

function PileClass:tableauUpdate()
  for i, iCard in ipairs(self.cards) do
    if i == #self.cards then
      iCard.side = true
      iCard.draggable = true
      iCard.bottomCard = true
    else
      iCard.bottomCard = false
    end
  end
end

function PileClass:acePileUpdate()
  for i, iCard in ipairs(self.cards) do
    if i == #self.cards then
      iCard.side = true
      iCard.draggable = true
    else
      iCard.side = false
      iCard.draggable = false
    end
  end
end

function PileClass:handUpdate()
  for i, iCard in ipairs(self.cards) do
    if i == #self.cards then
      iCard.side = true
      iCard.draggable = true
    else
      iCard.side = true
      iCard.draggable = false
    end
  end
end

function PileClass:discardUpdate()
  for i, iCard in ipairs(self.cards) do
    iCard.side = false
    iCard.draggable = false
  end
end

function PileClass:checkForMouseOver(grabber)
  if grabber.grabPos == nil then
    return
  end
    
  local mousePos = grabber.currentMousePos
  local isMouseOver= false
  if self.type == TableauType.TABLEAU then
    isMouseOver = 
      mousePos.x > self.position.x and
      mousePos.x < self.position.x + self.size.x and
      mousePos.y > self.position.y and
      mousePos.y < (self.position.y + self.size.y) * 3
  else
    isMouseOver = 
      mousePos.x > self.position.x and
      mousePos.x < self.position.x + self.size.x and
      mousePos.y > self.position.y and
      mousePos.y < self.position.y + self.size.y
  end
  
  return isMouseOver
end

function PileClass:addCard(card)
  local spacing = 0
  -- only tableaus and hand have spacing
  if self.type == 1 or self.type == 2 then
    spacing = 1
  end
  table.insert(self.cards, card)
  for i, iCard in ipairs(self.cards) do
    iCard.position.x = self.position.x
    iCard.position.y = self.position.y + ((i-1) * 15 * spacing)
  end
end

function PileClass:removeCard(card)
  if card == nil then return end
  local index = -1;
  for i, iCard in ipairs(self.cards) do
    if card == iCard then
      index = i
    end
  end
  if index == -1 then return end
  table.remove(self.cards, index)
end

function PileClass:refreshPile()
  local spacing = 0
  -- only tableaus and hand have spacing
  if self.type == 1 or self.type == 2 then
    spacing = 1
  end
  for i, iCard in ipairs(self.cards) do
    iCard.position.x = self.position.x
    iCard.position.y = self.position.y + ((i-1) * 15 * spacing)
  end
end

function PileClass:getPileCards()
  return self.cards
end