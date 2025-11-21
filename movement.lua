function move(piece)
  target=piece.target
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
  end
  
function isNear(x,y,tx,ty)
if ty % 2 ==1 then
  if x==tx and y==ty-1 then
    return true
    end
  if x==tx+1 and y==ty-1 then
    return true
  end
    if x==tx+1 and y==ty then
    return true
  end
      if x==tx+1 and y==ty+1 then
    return true
  end
      if x==tx and y==ty+1 then
    return true
  end
      if x==tx-1 and y==ty then
    return true
  end
else
  if x==tx-1 and y == ty -1 then
    return true
  end
  if x==tx and y == ty -1 then
    return true
  end
    if x==tx and y == ty +1 then
    return true
  end
     if x==tx+1 and y == ty  then
    return true
  end
       if x==tx and y == ty+1  then
    return true
  end
      if x==tx-1 and y == ty+1  then
    return true
  end
      if x==tx-1 and y == ty then
    return true
  end
  end
  return false
  end
  