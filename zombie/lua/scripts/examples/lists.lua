


--  Incrementing a list
for i = 0, 3 do
  print( i )
end




--  Decrementing a list
--  It would be nice if I could do this
--[[
for i = 3, 0 do
  print( i )
end
--]]

--  However, I can do this
--[[
local endlist = 3
for i = 0, endlist do
  index = abs( ( i - endlist ) * -1 )
  print( index )
end
--]]
