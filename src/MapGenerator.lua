local memoryBitmap = require( "plugin.memoryBitmap" )

local M = {}

local i_width = 16*7
local i_heigth =  9*7
print(i_width, i_heigth)

local f_randomFillPercent = 88 -- how many walls will be in our caves (in range (0,100))
local arr_map = {} -- integer array defines where will be the walls of caves
local arr_tmp = {} -- same as arr_map for calculating neighbours

local i_seed -- int with random seed
local b_useRandomSeed = true -- will we use randomply generated seed or will use s_seed instead



local function RandomFillMap() -- fill arr_map
    if b_useRandomSeed then
        i_seed = os.time()
    end
    math.randomseed( i_seed )

    for x = 1, i_width do
    	arr_map[x] = {}
    	arr_tmp[x] = {}
        for y = 1, i_heigth do
        	if x == 1 or x == i_width or y == 1 or y == i_heigth then
        		arr_map[x][y] = 0
        	else
        	    arr_map[x][y] = (math.random(1,100)-1 < f_randomFillPercent) and 0 or 1
        	end
        	arr_tmp[x][y] = arr_map[x][y]
        end
    end
end


local function GetNeighbourCount(gridX, gridY) -- get number of neighbour black pixels
	local n = 0

	for x = gridX-1, gridX+1 do
    	for y = gridY-1, gridY+1 do
    		if (y > 1 and x > 1 and x < i_width and y < i_heigth) then
            	if (y ~= gridY and x ~= gridX ) then
            		n = n + 1 - arr_map[x][y]
            	end
            else
            	n = n + 1
            end
    	end
    end

    return n
end

local function SmoothMap() -- make noise smoother
	
	for x = 1, i_width do
    	for y = 1, i_heigth do
    		neighbourCount = GetNeighbourCount(x,y)
    		if  (neighbourCount < 3) then
    			arr_tmp[x][y] = 1
    		elseif (neighbourCount > 4) then
    			arr_tmp[x][y] = 0
    		end

    	end
    end
    for x = 1, i_width do
    	for y = 1, i_heigth do
    		arr_map[x][y] = arr_tmp[x][y]
    	end
    end
end

local function ClearArtifacts()
	for x = 2, i_width-1 do
    	for y = 2, i_heigth-1 do
    		if(arr_tmp[x][y] == 0 and arr_tmp[x+1][y] == 1 and arr_tmp[x-1][y] == 1 and arr_tmp[x][y+1] == 1 and arr_tmp[x][y-1] == 1) then
    			arr_tmp[x][y] = 1
    		end
    	end
    end
    for x = 2, i_width-1 do
    	for y = 2, i_heigth-1 do
    		if(arr_tmp[x][y] == 1 and arr_tmp[x+1][y] == 0 and arr_tmp[x-1][y] == 0 and arr_tmp[x][y+1] == 0 and arr_tmp[x][y-1] == 0) then
    			arr_tmp[x][y] = 0
    		end
    	end
    end
    for x = 2, i_width-1 do
    	for y = 2, i_heigth-1 do
    		if(arr_tmp[x][y] == 1 and arr_tmp[x+1][y] == 0 and arr_tmp[x-1][y] == 0 and math.random(1,6) > 4) then
    			arr_tmp[x][y] = 0
    		end
    		if(arr_tmp[x][y] == 1 and arr_tmp[x][y+1] == 0 and arr_tmp[x][y-1] == 0 and math.random(1,6) > 4) then
    			arr_tmp[x][y] = 0
    		end
    	end
    end
    for x = 1, i_width do
    	for y = 1, i_heigth do
    		arr_map[x][y] = arr_tmp[x][y]
    	end
    end
end

local function GenerateMap()
	RandomFillMap()
	for iter = 1, 4 do
		SmoothMap()
	end
	ClearArtifacts()
end	

function M.onDraw()
	GenerateMap()


	local tex = memoryBitmap.newTexture(
    {
        width = i_width,
        height = i_heigth,
        format = "rgb"
    })

    local bitmap = display.newImageRect( tex.filename, tex.baseDir, display.actualContentWidth, display.actualContentHeight )
	bitmap.x = display.contentCenterX
	bitmap.y = display.contentCenterY
	
	for x = 1, tex.width do
    	for y = 1, tex.height do
        	tex:setPixel( x, y, arr_map[x][y], arr_map[x][y], arr_map[x][y])
        	tex:invalidate()
    	end
	end
	tex:releaseSelf()

end

return M