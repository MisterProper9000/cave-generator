--
-- For more information on config.lua see the Project Configuration Guide at:
-- https://docs.coronalabs.com/guide/basics/configSettings
--

local aspectRatio = display.pixelHeight / display.pixelWidth
application =
{
	content =
	{
		width = aspectRatio > 1.5 and 900 or math.ceil( 1600 / aspectRatio ),
        height = aspectRatio < 1.5 and 1600 or math.ceil( 900 * aspectRatio ),
		scale = "letterBox",
		fps = 60,
		
		--[[
		imageSuffix =
		{
			    ["@2x"] = 2,
			    ["@4x"] = 4,
		},
		--]]
	},
}