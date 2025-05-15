
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
  if #self.heldObject == 0 then
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
    if self.prevPile == nil then return end
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
    self.grabPos = nil
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
  
  local validPlacement = false
  if self.currentPile == nil then return end
  if self.currentPile.type == 1 then
    validPlacement = self:checkValidTableauPosition()
  elseif self.currentPile.type == 0 then
    validPlacement = self:checkValidAcePilePosition()
  else
    validPlacement = false;
  end


  if isValidReleasePosition and validPlacement then
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
    if self.prevPile ~= nil then
      self.prevPile:refreshPile()
    end
  end

  for _, card in ipairs(self.heldObject) do
    card.state = 0
  end

  for k in pairs(self.heldObject) do
    self.heldObject[k] = nil
  end
  self.grabPos = nil
end

function GrabberClass:checkValidTableauPosition()
  local topCard = self.currentPile:getPileCards()[#self.currentPile:getPileCards()]
  local bottomCard = self.heldObject[1]
  if topCard == nil then
    if tonumber(bottomCard.number) == 13 then
      return true
    else
      return false
    end
  end
  if topCard.suit == "hearts" or topCard.suit == "diamonds" then
    if bottomCard.suit == "hearts" or bottomCard.suit == "diamonds" then
      print("wrong suit")
      return false
    elseif tonumber(topCard.number) - tonumber(bottomCard.number) ~= 1 then
      print("wrong number")
      return false
    else
      return true
    end
  elseif topCard.suit == "spades" or topCard.suit == "clubs" then
    if bottomCard.suit == "spades" or bottomCard.suit == "clubs" then
      print("wrong suit")
      return false
    elseif tonumber(topCard.number) - tonumber(bottomCard.number) ~= 1 then
      print("wrong number")
      return false
    else
      return true
    end
  end
end

function GrabberClass:checkValidAcePilePosition()
  if #self.heldObject > 1 then return false end
  local topCard = self.heldObject[1]
  local bottomCard = self.currentPile:getPileCards()[#self.currentPile:getPileCards()]
  if bottomCard == nil then
    if tonumber(topCard.number) == 1 then return true end
  end
  if topCard.suit == bottomCard.suit then
    if tonumber(topCard.number) - tonumber(bottomCard.number) == 1 then
      return true
    else
      return false
    end
  end
end