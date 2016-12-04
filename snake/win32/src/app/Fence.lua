
local Fence = class("Fence")


function Fence:fenceGenerator(node, bound, callback)

	for i = -bound, bound do
		local sp = cc.Sprite:create("fence.png")
		local posx,posy = callback(i)
		sp:setPosition(posx,posy)
		node:addChild(sp)

		table.insert(self.fenceSpArray,sp)
	end
end

function Fence:ctor(rowBound, colBound, node)

	self.rowBound = rowBound -- ��Ļ�������ϻ��� �� ��������
	self.colBound = colBound -- ��Ļ����������� �� ��������
	self.fenceSpArray = {}
	self.node = node

	-- up
	self:fenceGenerator(node, colBound,function(i)
		return Grid2Pos(i, rowBound)
	end)

	-- down
	self:fenceGenerator(node, colBound,function(i)
		return Grid2Pos(i, -rowBound)
	end)

	-- left
	self:fenceGenerator(node, rowBound,function(i)
		return Grid2Pos(-colBound, i)
	end)

	-- right
	self:fenceGenerator(node, rowBound,function(i)
		return Grid2Pos(colBound, i)
	end)

end

-- �ж��Ƿ���Χǽ��ײ
function Fence:CheckCollide(x,y)
	return x == self.colBound or
				 x == -self.colBound or
				 y == self.rowBound or
				 y == -self.rowBound
end

function Fence:Reset()

	for _,sp in ipairs(self.fenceSpArray) do
		self.node:removeChild(sp)
	end

end

return Fence
