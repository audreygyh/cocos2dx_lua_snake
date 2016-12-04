
local Body = class("Body")

-- nodeΪcocos2dx-���ڵ�
function Body:ctor(snake , x, y, node, isHead)

	self.snake = snake
	self.X = x
	self.Y = y
	
	if isHead then -- �����Ƿ���ͷ��,�ò�ͬ��ͼƬ���� 
		self.sp = cc.Sprite:create("head.png")
	else
		self.sp = cc.Sprite:create("body.png")
	end
	
	node:addChild(self.sp)
	
	self:Update()
	
end

-- �����Լ���λ��
function Body:Update()
	
	local posx,posy = Grid2Pos(self.X , self.Y)
	self.sp:setPosition(posx,posy)
end

return Body