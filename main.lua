-- Zac Emerzian
-- CMPM 121 - Pickup
-- 4-11-25
io.stdout:setvbuf("no")

require "card"
require "grabber"
require "pile"
require "drawPile"
require "deck"

function love.load()
  love.window.setMode(960, 640)
  love.graphics.setBackgroundColor(0, 0.7, 0.2, 1)
  
  grabber = GrabberClass:new()
  deck = DeckClass:new()
  deck:fillDeck()
  cardTable = {}
  pileTable = {}
  
  table.insert(pileTable, PileClass:new(100, 300, 1))
  table.insert(pileTable, PileClass:new(200, 300, 1))
  table.insert(pileTable, PileClass:new(300, 300, 1))
  table.insert(pileTable, PileClass:new(400, 300, 1))
  table.insert(pileTable, PileClass:new(500, 300, 1))
  table.insert(pileTable, PileClass:new(600, 300, 1))
  table.insert(pileTable, PileClass:new(700, 300, 1))
  
  table.insert(pileTable, PileClass:new(400, 100, 0))
  table.insert(pileTable, PileClass:new(500, 100, 0))
  table.insert(pileTable, PileClass:new(600, 100, 0))
  table.insert(pileTable, PileClass:new(700, 100, 0))
  
  table.insert(pileTable, PileClass:new(200, 100, 2))
  
  table.insert(pileTable, PileClass:new(300, 100, 3))
  
  drawPile = DrawPileClass:new(100, 100, cardTable, deck, pileTable[12])
  
  gameSetup()
end

function love.update()
  grabber:update()
  drawPile:update()
  
  checkForMouseMoving()  
  
  for _, card in ipairs(cardTable) do
    card:update()
  end
  for _, pile in ipairs(pileTable) do
    pile:update()
  end
end

function love.draw()
  drawPile:draw()
  for _, card in ipairs(cardTable) do
    card:draw() --card.draw(card)
  end
  for _, pile in ipairs(pileTable) do
    pile:draw()
  end
  
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.print("Mouse: " .. tostring(grabber.currentMousePos.x) .. ", " .. tostring(grabber.currentMousePos.y))
end

function checkForMouseMoving()
  if grabber.currentMousePos == nil then
    return
  end
  
  for _, card in ipairs(cardTable) do
    card:checkForMouseOver(grabber)
  end
end

function gameSetup()
  local cardNum = 1
  for i = 1, 7 do
    for n = 1, i do
      local faceUp = n == i
      table.insert(cardTable, CardClass:new(0, 0, deck:popCard(), faceUp, faceUp))
      pileTable[i]:addCard(cardTable[cardNum])
      cardNum = cardNum + 1
    end
  end
end