require "piece"
function spawnPiece(x,y,team)
     return PieceClass:new(x,y,team)
end

function spawnAlly(x,y)
  table.insert(allies, spawnPiece(x,y,0))
end

function spawnEnemy(x,y)
  table.insert(enemies, spawnPiece(x,y,1))
  end