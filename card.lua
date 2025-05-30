
require "vector"

CardClass = {}

CARD_STATE = {
  IDLE = 0,
  MOUSE_OVER = 1,
  GRABBED = 2
}

SPRITE_SIZE = 8
SPRITE_SCALE = 1

function CardClass:new(xPos, yPos, sprite, draggable, faceUp)
  local card = {}
  local metadata = {__index = CardClass}
  setmetatable(card, metadata)
  
  card.position = Vector(xPos, yPos)
  card.size = Vector(50, 70)
  card.scale = SPRITE_SCALE
  card.state = CARD_STATE.IDLE
  card.side = faceUp
  card.bottomCard = faceUp
  
  
  start, _ = string.find(sprite, "_") + 1
  finish = string.find(sprite, "_", string.find(sprite, "_") + 1) - 1
  card.suit = string.sub(sprite, start, finish)
  card.number = string.sub(sprite, -6, -5)
  
  card.image = love.graphics.newImage("Sprites/" .. sprite)
  card.back = love.graphics.newImage("Sprites/card_back.png")
  
  card.draggable = draggable
  
  return card
end

function CardClass:update()
  
end

function CardClass:draw()
  if self.side then
    love.graphics.draw(self.image, self.position.x, self.position.y, 0, self.scale, self.scale)
  else
    love.graphics.draw(self.back, self.position.x, self.position.y, 0, self.scale, self.scale)
  end
end

function CardClass:checkForMouseOver(grabber)
  if self.state == CARD_STATE.GRABBED or not self.draggable then
    return
  end
    
  local mousePos = grabber.currentMousePos
  local isMouseOver = false
  if self.bottomCard then
    isMouseOver = mousePos.x > self.position.x and
      mousePos.x < self.position.x + self.size.x and
      mousePos.y > self.position.y and
      mousePos.y < self.position.y + self.size.y
  else
    isMouseOver = 
      mousePos.x > self.position.x and
      mousePos.x < self.position.x + self.size.x and
      mousePos.y > self.position.y and
      mousePos.y < self.position.y + (self.size.y / 5)
  end
  
  self.state = isMouseOver and CARD_STATE.MOUSE_OVER or CARD_STATE.IDLE
end