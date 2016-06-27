local bump = require "lib/bump"

local tileW, tileH, tileset, quads, tileTable


local function addBlock(x,y,w,h)
  local block = {x=x, y=y, w=w, h=h, isBlock=true}
  blocks[#blocks+1] = block
  world:add(block, x, y, w, h)
end

function loadMap(path)
  love.filesystem.load(path)()
end

function newMap(tileWidth, tileHeight, tilesetPath, tileString, quadInfo)
  
  tileW = tileWidth
  tileH = tileHeight
  tileset = love.graphics.newImage(tilesetPath)
  
  local tilesetW, tilesetH = tileset:getWidth(), tileset:getHeight()
  
  quads = {}
  
  for _,info in ipairs(quadInfo) do
    quads[info[1]] = love.graphics.newQuad(info[2], info[3], tileW,  tileH, tilesetW, tilesetH)
  end
  
  tileTable = {}
  
  local width = #(tileString:match("[^\n]+"))

  for x = 1,width,1 do tileTable[x] = {} end

  local rowIndex,columnIndex = 1,1
  for row in tileString:gmatch("[^\n]+") do
    assert(#row == width, 'Map is not aligned: width of row ' .. tostring(rowIndex) .. ' should be ' .. tostring(width) .. ', but it is ' .. tostring(#row))
    columnIndex = 1
    for character in row:gmatch(".") do
      tileTable[columnIndex][rowIndex] = character
      if character ~= " " then
          addBlock(35*(columnIndex-1), 35*(rowIndex-1), 35, 35)
      end
      columnIndex = columnIndex + 1
    end
    rowIndex=rowIndex+1
  end
end

function drawMap()
  for columnIndex,column in ipairs(tileTable) do
    for rowIndex,char in ipairs(column) do
      local x,y = (columnIndex-1)*tileW, (rowIndex-1)*tileH
      if char ~= " " then -- MUDAR
        love.graphics.draw(tileset, quads[ char ] , x, y)
      end
    end
  end
end
