function hexDistance(a, b)
  local dq = a.q - b.q
  local dr = a.r - b.r
  return (math.abs(dq) + math.abs(dr) + math.abs(dq + dr)) / 2
end

function offsetToAxial(x, y)
  local q = x
  local r = y - math.floor((x + 1) / 2)
  return {q = q, r = r}
end