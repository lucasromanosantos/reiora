local tileString = [[
^#######################^
^                       ^
^                       ^
^                       ^
^                       ^
^                       ^
^                       ^
^                       ^
^                       ^
^                       ^
^         #####         ^
^                       ^
^  ####           ####  ^
^                       ^
^         #####         ^
^                       ^
^                       ^
^                       ^
#########################
]]

  local quadInfo = { 
    { ' ',  0,  0 }, -- grass 
    { '#', 32,  0 }, -- box
    { '^', 32, 32 }, -- boxTop
    { '*',  0, 32 }  -- flowers
  }

 newMap(32,32,'/images/countryside.png',tileString,quadInfo)