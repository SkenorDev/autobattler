HEX_DIRECTIONS = {
    { 1,  0 },  -- east
    { 1, -1 },  -- northeast
    { 0, -1 },  -- northwest
    { -1, 0 },  -- west
    { -1, 1 },  -- southwest
    { 0,  1 },  -- southeast
}
function move(piece)
  target=piece.target
  hex = hexGrid[piece.x][piece.y]
  hex.occupied =false
  if target.x+1<piece.x then
    piece.x=piece.x-1
  end
    if target.x-1>piece.x then
    piece.x=piece.x+1
  end
    if target.y+1<piece.y then
    piece.y=piece.y-1
  end
    if target.y-1>piece.y then
    piece.y=piece.y+1
  end
  hex = hexGrid[piece.x][piece.y]
  hex.occupied =true
  end
  
function canAttack(x, y, tx, ty,range)
local a = offsetToAxial(x, y)
local b = offsetToAxial(tx, ty)
return hexDistance(a, b) <= range
end