-- ====================================
-- Level Manager
-- Handles level data, loading, limits
-- ====================================

levels = {
    {
        id = 1,
        pieceLimit = 10,

        enemySpawns = {
            { type = "Warrior", x = 1, y = 2 },
            { type = "Warrior", x = 3, y = 2 },
            { type = "Warrior", x = 5, y = 2 },
            { type = "Tank", x = 2, y = 3 },
            { type = "Archer", x = 1, y = 0 },
            { type = "Archer", x = 5, y = 0 },
        },

        allySpawns = {
            -- optional allies for future levels
        }
    },
    {
        id = 2,
        pieceLimit = 5,

        enemySpawns = {
            { type = "Warrior", x = 1, y = 2 },
            { type = "Warrior", x = 3, y = 2 },
            { type = "Warrior", x = 5, y = 2 },
            { type = "Archer", x = 1, y = 0 },
            { type = "Archer", x = 5, y = 0 },
        },

        allySpawns = {
            -- optional allies for future levels
        }
    },
    {
        id = 3,
        pieceLimit = 8,

        enemySpawns = {
            { type = "Warrior", x = 1, y = 2 },
            { type = "Warrior", x = 2, y = 2 },
            { type = "Warrior", x = 3, y = 2 },
            { type = "Warrior", x = 4, y = 2 },
            { type = "Warrior", x = 5, y = 2 },
            { type = "Archer", x = 1, y = 0 },
            { type = "Archer", x = 5, y = 0 },
        },

        allySpawns = {
            -- optional allies for future levels
        }
    }
}

currentLevelIndex = 1
maxPieces = 0
usedPieces = 0


-- Reset grid occupancy
local function clearGrid()
    if not hexGrid then return end
    for x, column in pairs(hexGrid) do
        for y, hex in pairs(column) do
            hex.occupied = false
        end
    end
end


-- ===============================
-- Load Level Function
-- ===============================
function loadLevel(level)
    allies = {}
    enemies = {}

    clearGrid()

    -- Spawn enemies
    for _, e in ipairs(level.enemySpawns or {}) do
        if e.type == "Warrior" then
            spawnWarrior(e.x, e.y, 1)
        elseif e.type == "Archer" then
            spawnArcher(e.x, e.y, 1)
        elseif e.type == "Tank" then
            spawnTank(e.x, e.y, 1)
        end
    end

    -- Spawn any pre-placed allies
    for _, a in ipairs(level.allySpawns or {}) do
        if a.type == "Warrior" then
            spawnWarrior(a.x, a.y, 0)
        elseif a.type == "Archer" then
            spawnArcher(a.x, a.y, 0)
        elseif a.type == "Tank" then
            spawnTank(a.x, a.y, 0)
        end
    end

    maxPieces = level.pieceLimit or 0
    usedPieces = 0
    
    gameState = "placement"
    placementPhase = true
    battlePhase = false
    usedPieces = 0

end



