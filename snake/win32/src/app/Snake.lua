local Snake = class("Snake")

local Body = require("app.Body")

local cInitLen = 3 -- �߳�ʼ����

-- ���캯��
function Snake:ctor(node)

	self.BodyArray = {} -- Body��������
	self.node = node
	self.MoveDir = "left" -- �ߵĳ�ʼ�ƶ�����

	for i = 1,cInitLen do
		self:Grow(i == 1)
	end

end


--ȡ����β
function Snake:GetTailGrid()
	if #self.BodyArray == 0 then -- ������ͷ��λ��Ϊ(0,0)
		return 0,0
	end

	local tail = self.BodyArray[#self.BodyArray]

	return tail.X,tail.Y

end

-- �߱䳤
function Snake:Grow(isHead)

	local tailX,tailY = self:GetTailGrid()
	local body = Body.new(self,tailX,tailY,self.node,isHead)

	table.insert(self.BodyArray,body)

end

-- ���ݷ���ı�����
local function OffsetGridByDir(x,y,dir)
	if dir == "left" then
		return x - 1, y
	elseif dir == "right" then
		return x + 1, y
	elseif dir == "up" then
		return x, y + 1
	elseif dir == "down" then
		return x, y - 1
	end

	print("Unkown dir", dir)
	return x, y
end


-- �����ߵ��ƶ����� �����ߣ�����BodyArrayһ��һ����ǰ�ƶ�
function Snake:Update()

	if #self.BodyArray == 0 then
		return
	end

	for i = #self.BodyArray , 1 , -1 do

		local body = self.BodyArray[i]

		if i == 1 then -- ��ͷλ�� �� ���򣬵õ�һ���µ�λ�� �����ͷ
			body.X, body.Y = OffsetGridByDir(body.X, body.Y, self.MoveDir)
		else
			local front = self.BodyArray[i-1]
			body.X, body.Y = front.X, front.Y
		end

		body:Update()

	end

end


-- ȡ����ͷ
function Snake:GetHeadGrid()
	if #self.BodyArray == 0 then
		return nil
	end

	local head = self.BodyArray[1]

	return head.X, head.Y

end

-- ���÷���
function Snake:setDir(dir)
		 local  hvTable = {
        ["left"] = "h",
        ["right"] = "h",
        ["up"] = "v",
        ["down"] = "v",
    }
    -- ˮƽ ����ֱ�Ļ���
    if hvTable[dir] == hvTable[self.MoveDir] then
        return
    else
        self.MoveDir = dir
        
         -- ȡ����ͷ
        local head = self.BodyArray[1]

        -- ˳ʱ����ת����ʼ����Ϊleft
        local rotTable ={
            ["left"] = 0,
            ["up"] = 90,
            ["right"] = 180,
            ["down"] = -90,
        }
        -- �þ���ͼƬ��ת���Ըı���ʾ
        head.sp:setRotation(rotTable[self.MoveDir])
        
    end
end

-- ����֮�����˸Ч��
function Snake:Blink(callback)

	for index,body in ipairs (self.BodyArray) do
		local blink = cc.Blink:create(3,5)

		if index == 1 then -- ��ͷ
			local a = cc.Sequence:create(blink, cc.CallFunc:create(callback))
			body.sp:runAction(a)
		else
			body.sp:runAction(blink) -- ����
		end

	end -- for

end

function Snake:Kill()
	for _,body in ipairs(self.BodyArray) do
		self.node:removeChild(body.sp)
	end
end

function Snake:CheckCollideSelf()
    if #self.BodyArray < 2 then
        return false
    end

    local headX, headY = self.BodyArray[1].X , self.BodyArray[1].Y

    for i = 2, #self.BodyArray do
        local body = self.BodyArray[i]

        if body.X == headX and body.Y == headY then
            return true;
        end
    end

    return false
end

return Snake
