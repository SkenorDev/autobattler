require "piece"
function spawnPiece(x,y,range,attack,hp,team,name)
     return PieceClass:new(x,y,range,attack,hp,team,name)
end

function spawnAlly(x,y,range,attack,hp,name)
    hex = hexGrid[x][y]
    if hex.occupied==false then
  table.insert(allies, spawnPiece(x,y,range,attack,hp,0,name))
  hex.occupied=true
  end
end

function spawnEnemy(x,y,range,attack,hp,name)
    hex = hexGrid[x][y]
    if hex.occupied==false then
  table.insert(enemies, spawnPiece(x,y,range,attack,hp,1,name))
  hex.occupied=true
  end
end
--spawnEnemy(7,7,1,1,10)
function spawnWarrior(x,y,team) 
  if team == 1 then
    spawnEnemy(x,y,1,1,10,name,"Warrior")
  else 
    spawnAlly(x,y,1,1,10,name,"Warrior")
  end
end
function spawnArcher(x,y,team) 
  if team == 1 then
    spawnEnemy(x,y,2,10,20,"Archer")
  else 
    spawnAlly(x,y,2,10,20,"Archer")
  end
end
function spawnTank(x,y,team)
  if team == 1 then
    spawnEnemy(x,y,1,2,100,"Tank")
  else 
    spawnAlly(x,y,1,2,100,"Tank")
  end
end