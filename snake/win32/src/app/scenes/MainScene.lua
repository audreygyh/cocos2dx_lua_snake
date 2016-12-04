
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

-- require��Ӧ����
-- local Body = require("app.Body")
local Snake = require("app.Snake")
local Fence = require("app.Fence")
local AppleFactory = require("app.AppleFactory")
local BlockFactory = require("app.BlockFactory")

local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

local cMoveSpeed = 0.3
local rowBound = 5
local colBound = 8


function MainScene:onEnter() -- MainScene ����ִ��

		self:CreateScoreBoard() -- ������

		self:ProcessInput() -- ���touch�¼�
		self:ProcessKeyInput() -- ���̿���

		self:Reset()

		--self.snake = Snake.new(self) -- ����һ����
		--self.fence = Fence.new(rowBound, colBound, self)  -- ����Χǽ

		local tick = function()
			if self.stage == "running" then

				self.snake:Update() -- ������

				local headX , headY = self.snake:GetHeadGrid()
				local headX , headY = self.snake:GetHeadGrid()
        
        local b, index = self.blocks:Hit(headX,headY)
        
        if self.fence:CheckCollide(headX,headY)
                or self.snake:CheckCollideSelf() 
                or b ~= nil
            then
					self.stage = "dead"
					self.snake:Blink(function()

								self:Reset()


								end)
				elseif self.apple:CheckCollide(headX,headY) then
						self.apple:Generate() -- ƻ�����²���

						self.snake:Grow() -- �߱䳤

						self.score = self.score + 1 -- ������1
						self:SetScore(self.score)
				end
			end

		end -- end tick

		cc.Director:getInstance():getScheduler():scheduleScriptFunc(
			 tick,cMoveSpeed,false)

end



local function vector2Dir(x, y)

	if math.abs(x) > math.abs(y) then
		if x < 0 then
			return "left"
		else
			return "right"
	 end

	else

		if y > 0 then
			return "up"
		else
			return "down"
	  end

	end

end

-- ������¼�����
function MainScene:ProcessInput()

	local function onTouchBegan(touch, event)

		local location = touch:getLocation() -- �õ�����������(cocos2d-x ����)


-- �ж��ƶ��ķ���
		local snakex , snakey = self.snake:GetHeadGrid()
		local snake_fx,snake_fy = Grid2Pos(snakex,snakey)
		local finalX = location.x - snake_fx
		local finalY = location.y - snake_fy

		local dir = vector2Dir(finalX, finalY)
	    print("now dir",dir)
		self.snake:setDir(dir) -- �����ߵ��ƶ�����

	end

	local listener = cc.EventListenerTouchOneByOne:create()
	listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
	local eventDispatcher = self:getEventDispatcher()
	eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)

end


-- �����¼�����
function MainScene:ProcessKeyInput()

	local function keyboardPressed(keyCode,event)

		-- up
		if keyCode == 28 then
				print("up")
				self.snake:setDir("up") -- �����ߵ��ƶ�����
		-- down
		elseif keyCode == 29 then
				print("down")
				self.snake:setDir("down") -- �����ߵ��ƶ�����
		--left
		elseif keyCode == 26 then
				print("left")
				self.snake:setDir("left") -- �����ߵ��ƶ�����
		--right
		elseif keyCode == 27 then
				print("right")
				self.snake:setDir("right") -- �����ߵ��ƶ�����
		--end

		-- P
     elseif keyCode == 139 then
          print("P -- Pause")
          local director = cc.Director:getInstance()
          director:pause() -- ��ͣ

      --end

      -- R
      elseif keyCode == 141 then
          local director = cc.Director:getInstance()
          director:resume() -- �ָ�

      end
	end

	local listener = cc.EventListenerKeyboard:create()
	listener:registerScriptHandler(keyboardPressed, cc.Handler.EVENT_KEYBOARD_PRESSED)
	local eventDispatcher = self:getEventDispatcher()
	eventDispatcher:addEventListenerWithSceneGraphPriority(listener,self)

end


-- ��Ϸ��������
function MainScene:Reset()
	if self.apple ~= nil then
		self.apple:Reset()
	end

	if self.fence ~= nil then
		self.fence:Reset()
	end

	if self.snake ~= nil then
		self.snake:Kill()
	end
	-- ����ϰ���
	if self.blocks ~= nil then
		self.blocks:Reset()
	end
	self.blocks = BlockFactory.new(self)
	self:Load()

	self.snake = Snake.new(self) -- ����һ����
	self.fence = Fence.new(rowBound, colBound, self)  -- ����Χǽ
	self.apple = AppleFactory.new(rowBound, colBound, self)  -- ����apple

	self.stage = "running"
	self.score = 0
	self:SetScore(self.score)
end

-- �����ļ���
function MainScene:Load()
	local f = assert(dofile("scene.lua"))
	
	self.blocks:Reset()
	
	for _,t in ipairs(f) do
		self.blocks:Add(t.x, t.y, t.index)
	end
	
	print("main Loaded")
end

-- ������ʾ����
function MainScene:CreateScoreBoard()

	display.newSprite("applesign.png")
	:pos(display.right - 200 , display.cy + 150)
	:addTo(self)

	local ttfConfig = {}
	ttfConfig.fontFilePath = "arial.ttf"
	ttfConfig.fontSize = 30

	local score = cc.Label:createWithTTF(ttfConfig, "0")
	self:addChild(score)

	score:setPosition(display.right - 200 , display.cy + 80)

	self.scoreLabel = score

end

-- ���÷���
function MainScene:SetScore(s)
	self.scoreLabel:setString(string.format("%d",s))
end

return MainScene
