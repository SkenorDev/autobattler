require "piece"
function spawnPiece(x,y,range,attack,hp,team)
     return PieceClass:new(x,y,range,attack,hp,team)
end

function spawnAlly(x,y,range,attack,hp)
    hex = hexGrid[x][y]
    if hex.occupied==false then
  table.insert(allies, spawnPiece(x,y,range,attack,hp,0))
  hex.occupied=true
  end
end

function spawnEnemy(x,y,range,attack,hp)
    hex = hexGrid[x][y]
    if hex.occupied==false then
  table.insert(enemies, spawnPiece(x,y,range,attack,hp,1))
  hex.occupied=true
  end
end
--spawnEnemy(7,7,1,1,10)
function spawnWarrior(x,y,team) 
  if team == 1 then
    spawnEnemy(x,y,1,1,10)
  else 
    spawnAlly(x,y,1,1,10)
  end
end
function spawnArcher(x,y,team) 
  if team == 1 then
    spawnEnemy(x,y,2,10,20)
  else 
    spawnAlly(x,y,2,10,20)
  end
end
function spawnTank(x,y,team)
  if team == 1 then
    spawnEnemy(x,y,1,2,100)
  else 
    spawnAlly(x,y,1,2,100)
  end
end