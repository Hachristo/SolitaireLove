
require "vector"

GrabberClass = {}

function GrabberClass:new()
  local grabber = {}
  local metadata = {__index = GrabberClass}
  setmetatable(grabber, metadata)

  grabber.previousMousePos = nil
  grabber.currentMousePos = nil

  grabber.grabPos = nil

  grabber.currentPile = nil
  grabber.prevPile = nil

  -- NEW: we'll want to keep track of the object (ie. card) we're holding
  grabber.heldObject = {}

  return grabber
end

function GrabberClass:update()
  self.currentMousePos = Vector(
    love.mouse.getX(),
    love.mouse.getY()
  )

  -- Click (just the first frame)
  if love.mouse.isDown(1) and self.grabPos == nil then
    self:grab()
  end
  -- Release
  if love.mouse.isDown(1) and self.grabPos ~= nil then
    self:drag()
  end
  if not love.mouse.isDown(1) and self.grabPos ~= nil then
    self:release()
  end  
end

function GrabberClass:grab()
  self.grabPos = self.currentMousePos
  for _, card in ipairs(cardTable) do
    if card.state == 1 then
      table.insert(self.heldObject, card)
      card.state = 2
    end
  end
  if self.heldObject == {} then
    self.grabPos = nil
  else
    local prevPrevPile = nil
    for i, pile in ipairs(pileTable) do
      for x, card in ipairs(pile.cards) do
        if self.heldObject[1] == card then
          prevPrevPile = pile
        end
      end
    end
    if prevPrevPile ~= nil then
      self.prevPile = prevPrevPile
    end
    local indexReached = false
    for _, card in ipairs(self.prevPile.cards) do
      if indexReached then
        table.insert(self.heldObject, card)
      end
      if card == self.heldObject[1] then
        indexReached = true
      end
    end
  end
end

function GrabberClass:drag()
  self.grabPos = self.currentMousePos
  --self.heldObject.position = self.grabPos
  for i, card in ipairs(self.heldObject) do
    card.position = self.grabPos + Vector(0, (i - 1) * 15)
  end
end

function GrabberClass:release()
  -- NEW: some more logic stubs here
  if self.heldObject == {} then -- we have nothing to release
    return
  end

  -- TODO: eventually check if release position is invalid and if it is
  -- return the heldObject to the grabPosition
  self.grabPos = self.currentMousePos
  local isValidReleasePosition = false -- *insert actual check instead of "true"*
  self.currentPile = nil
  for _, pile in ipairs(pileTable) do
    isValidReleasePosition = pile:checkForMouseOver(self)
    if isValidReleasePosition then
      self.currentPile = pile
      break
    end
  end


  if isValidReleasePosition then
    if self.prevPile ~= nil then
      for _, card in ipairs(self.heldObject) do
        self.prevPile:removeCard(card)
      end
--      self.prevPile:removeCard(self.heldObject)
    end
    if self.currentPile ~= nil then
      for _, card in ipairs(self.heldObject) do
        self.currentPile:addCard(card)
      end
--      self.currentPile:addCard(self.heldObject)
    end
  else
    self.prevPile:refreshPile()
  end

  for _, card in ipairs(self.heldObject) do
    card.state = 0
  end

  for k in pairs(self.heldObject) do
    self.heldObject[k] = nil
  end
  self.grabPos = nil
end