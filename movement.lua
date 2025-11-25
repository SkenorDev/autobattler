HEX_DIRECTIONS = {
    { 1,  0 },  -- east
    { 1, -1 },  -- northeast
    { 0, -1 },  -- northwest
    { -1, 0 },  -- west
    { -1, 1 },  -- southwest
    { 0,  1 },  -- southeast
}
function move(piece)
    local target = piece.target
    if not target then return end

    local startAx = offsetToAxial(piece.x, piece.y)
    local goalAx  = offsetToAxial(target.x, target.y)

    local bestDir = nil
    local bestDist = math.huge

    for _, d in ipairs(HEX_DIRECTIONS) do
        local nq = startAx.q + d[1]
        local nr = startAx.r + d[2]

        -- convert candidate back to offset coords
        local candX = nq
        local candY = nr + math.floor((nq + 1) / 2)

        -- prevent going out of bounds
        if candX >= 0 and candX <= 7 and candY >= 0 and candY <= 7 then
            
            -- OPTIONAL: prevent moving onto occupied hex
            if not hexGrid[candX][candY].occupied then
                
                -- compute distance
                local dist = hexDistance({q = nq, r = nr}, goalAx)
                
                if dist < bestDist then
                    bestDist = dist
                    bestDir = {q = nq, r = nr}
                end
            end
        end
    end

    -- no valid move found
    if not bestDir then return end

    -- convert direction to offset coords
    local newX = bestDir.q
    local newY = bestDir.r + math.floor((bestDir.q + 1) / 2)

    -- update occupancy
    hexGrid[piece.x][piece.y].occupied = false
    piece.x = newX
    piece.y = newY
    hexGrid[piece.x][piece.y].occupied = true
end

function canAttack(x, y, tx, ty,range)
local a = offsetToAxial(x, y)
local b = offsetToAxial(tx, ty)
return hexDistance(a, b) <= range
end