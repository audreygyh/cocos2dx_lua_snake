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

local Block = class("Block")

function Block:ctor(node)
	self.node = node
end

-- ���õ�ǰ���ϰ��� index = 1,2,3 ..�����Լ����ϰ���ͼƬ��Ŀ
function Block:Set(index)

	if self.sp ~= nil then
		self.node:removeChild(self.sp)
	end	
	
	self.index = index 
	self.sp = display.newSprite(string.format("block%d.png",index)) --ת��ͼƬ��ַ
	self.node:addChild(self.sp)
	
end

-- ����λ��
function Block:SetPos(x, y)
	local rbound = rowBound -1 
	local cbound = colBound -1 

	local posx , posy = Grid2Pos(x, y)	
	self.sp:setPosition(posx, posy)
			
	self.x = x
	self.y = y
	
end

-- �������
function Block:Clear()
	self.node:removeChild(self.sp)
end

function Block:CheckCollide(x,y)

	if x == self.x and y == self.y then
		return true
	end

	return false
end

return Block