local cGridSize = 33
local scaleRate = 1 / display.contentScaleFactor

-- �����Զ��������õ�ʵ��Ӧ����ʾ��cocos2d-x����λ��
function Grid2Pos(x,y)

	local visibleSize = cc.Director:getInstance():getVisibleSize() -- ��ȡ�����ֻ�������Ļ�ߴ�

	local origin = cc.Director:getInstance():getVisibleOrigin() -- ��ȡ�ֻ�������ԭ�������,��Ļ�����Ͻ�

	local finalX = origin.x + visibleSize.width / 2 + x * cGridSize * scaleRate
	local finalY = origin.y + visibleSize.height / 2 + y * cGridSize * scaleRate

	return finalX,finalY

end

local cMoveSpeed = 0.3
local rowBound = 5
local colBound = 8

-------------------------------------------


local Fence = require("app.Fence")
local Block = require("app.Block")
local BlockFactory = require("app.BlockFactory")

local EditorScene = class("EditorScene", function()
    return display.newScene("EditorScene")
end)

local cMaxBlock = 3 -- �ϰ�����Ŀ 

function EditorScene:onEnter()
	self.fence = Fence.new(rowBound, colBound,self) --Χǽ
	
	-- �����λ�� ��ʼ��Ϊ���Ͻ�
	self.curX = 0
	self.curY = 0
	self.curIndex = 0 -- ѡ����������

	self:SwitchCursor(1)
	self:ProcessInput()
	self.blockFactory = BlockFactory.new(self)
	
end


-- �����¼�����
function EditorScene:ProcessInput()
	
	local function keyboardPressed(keyCode,event)
		
		-- up
		if keyCode == 28 then
			self:MoveCursor(0,1)
		-- down
		elseif keyCode == 29 then
			self:MoveCursor(0,-1)
		--left
		elseif keyCode == 26 then
			self:MoveCursor(-1,0)
		--right
		elseif keyCode == 27 then
			self:MoveCursor(1,0)
		-- pageUp
		elseif keyCode == 38 then
			self:SwitchCursor(-1)
		-- pageDown
		elseif keyCode == 44 then
			self:SwitchCursor(1)

		
		-- enter
		elseif keyCode == 35 then
			self:Place()
		
		-- delete
		elseif keyCode == 23 then
			self:Delete()
		
		-- F3 �����ļ�
		elseif keyCode == 49 then 
			self:Load()
		-- F4 ����Ϊ�ļ�
		elseif keyCode == 50 then
			self:Save()
		
		end
		
	end
	
	local listener = cc.EventListenerKeyboard:create()
	listener:registerScriptHandler(keyboardPressed, cc.Handler.EVENT_KEYBOARD_PRESSED)
	local eventDispatcher = self:getEventDispatcher()
	eventDispatcher:addEventListenerWithSceneGraphPriority(listener,self)
	
end

-- �������� �ƶ���� 
function EditorScene:MoveCursor(deltaX,deltaY)
	self.cur:SetPos(self.curX + deltaX, self.curY+deltaY)
	self.curX = self.cur.x
	self.curY = self.cur.y
	
end

-- �����л��ϰ��� delta=1 Ϊ��һ������ ��-1 Ϊ��һ���ϰ���
function EditorScene:SwitchCursor(delta)
	if self.cur == nil then
	 	self.cur = Block.new(self)
	end
	
	local newIndex = self.curIndex + delta
	newIndex = math.max(newIndex, 1)
	newIndex = math.min(newIndex, cMaxBlock)
	
	self.curIndex = newIndex
	
	self.cur:Set(newIndex)
	self.cur:SetPos(self.curX, self.curY)
	
end

-- ����һ������
function EditorScene:Place()
	if self.blockFactory:Hit(self.cur.x,self.cur.y) then
		return
	end
	self.blockFactory:Add(self.curX, self.curY, self.cur.index)
end


-- ɾ������
function EditorScene:Delete()
	self.blockFactory:Remove(self.cur.x, self.cur.y)
end


-- lua�ļ����� F4
function EditorScene:Save()

	local f = assert(io.open("scene.lua", "w"))
	
	f:write("return {\n")
	self.blockFactory:Save(f)
	f:write("}\n")
	
	f:close()
	
	print("saved")
	
end

-- F3
function EditorScene:Load() 
	local f = assert(dofile("scene.lua"))
	
	self.blockFactory:Reset()
	
	for _,t in ipairs(f) do
		self.blockFactory:Add(t.x, t.y, t.index)
	end
	
	print("Loaded")
end

return EditorScene