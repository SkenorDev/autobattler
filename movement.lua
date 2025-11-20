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