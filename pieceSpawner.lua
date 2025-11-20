require "piece"
function spawnPiece(x,y,name,team)
     return PieceClass:new(x,y,name,team)
end

function spawnAlly(x,y,name)
  table.insert(allies, spawnPiece(x,y,name,0))
end

function spawnEnemy(x,y,name)
  table.insert(enemies, spawnPiece(x,y,name,1))
  end