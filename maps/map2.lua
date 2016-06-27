local tileString = [[
^##############################################^
^                                              ^
^                                              ^
^                                      ########^
^#####                                         ^
^                                              ^
^     ######             ##########            ^
^                                              ^
^                                              ^
^                  #######                     ^
^         #####                                ^
^                                              ^
^                                              ^
################################################
]]

  local quadInfo = { 
    { ' ',  0,  0 }, -- grass 
    { '#', 35,  0 }, -- box
    { '^', 105, 0 }, -- boxTop
    { '*',  0, 0  }  -- flowers
  }

 newMap(35,35,'/images/Tile32.png',tileString,quadInfo)