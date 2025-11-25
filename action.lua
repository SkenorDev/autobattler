require "piece"
require "movement"
require "attack"

function action(piece)
  if piece.target ==nil then
    return
    end
    target=piece.target
  if canAttack(piece.x,piece.y,target.x,target.y,piece.range) == false then 
  move(piece)
else 
  attack(piece)
  end

  end