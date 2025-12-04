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
function spawnWarrior(x, y, team)
    local stats = getUpgradedStats("Warrior")

    if team == 1 then
        spawnEnemy(x, y, stats.range, stats.atk, stats.hp, "WarriorEnemy")
    else
        spawnAlly(x, y, stats.range, stats.atk, stats.hp, "Warrior")
    end
end

function spawnArcher(x, y, team)
    local stats = getUpgradedStats("Archer")

    if team == 1 then
        spawnEnemy(x, y, stats.range, stats.atk, stats.hp, "ArcherEnemy")
    else
        spawnAlly(x, y, stats.range, stats.atk, stats.hp, "Archer")
    end
end

function spawnTank(x, y, team)
    local stats = getUpgradedStats("Tank")

    if team == 1 then
        spawnEnemy(x, y, stats.range, stats.atk, stats.hp, "TankEnemy")
    else
        spawnAlly(x, y, stats.range, stats.atk, stats.hp, "Tank")
    end
end
