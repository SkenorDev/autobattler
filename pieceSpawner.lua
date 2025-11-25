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
    spawnEnemy(x,y,1,25,500,"WarriorEnemy")
  else 
    spawnAlly(x,y,1,25,500,"Warrior")
  end
end
function spawnArcher(x,y,team) 
  if team == 1 then
    spawnEnemy(x,y,5,30,350,"ArcherEnemy")
  else 
    spawnAlly(x,y,5,30,350,"Archer")
  end
end
function spawnTank(x,y,team)
  if team == 1 then
    spawnEnemy(x,y,1,10,800,"TankEnemy")
  else 
    spawnAlly(x,y,1,10,800,"Tank")
  end
end