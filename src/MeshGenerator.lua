function extended (child, parent)
    setmetatable(child,{__index = parent}) 
end

local Node = {}
function Node:new(pos)
	local public = {}
        public.m_pos = pos
        public.vertexIndex = -1

    setmetatable(object,self)
	self.__index = self
	return object
end

local ControlNode = {}
function ControlNode:new(pos, active, squareSize)
	local public = {}
		public.m_above = Node:new({x = pos.x, y = pos.y + squareSize/2, })
		public.m_right = Node:new({x = pos.x + squareSize/2, y=pos.y })
		public.m_active = active
		public.base = Node:new(pos)
end

local Square = {}
function  Square:new(topLeft)
	local public = {}
		public.topLeft = ControlNode:new()
end