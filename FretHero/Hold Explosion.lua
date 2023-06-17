local sButton = Var "Button"

-- lookup tables because math hard
local strumRotateTable =
{
    [0] = -15,
    [1] = -10,
    [2] = -5,
    [3] = 0,
    [4] = 5,
    [5] = 10,
    [6] = 15
}

local strumZPosTable =
{
    [0] = -2,
    [1] = 1,
    [2] = 3,
    [3] = 4,
    [4] = 3,
    [5] = 1,
    [6] = -2
}

local strumXPosTable =
{
    [1] = -152,
    [2] = -144,
    [3] = -136,
    [4] = -128,
    [5] = -120,
    [6] = -112,
    [7] = -104,
    [8] = -88,
    [9] = -80,
    [10] = -72,
    [11] = -64,
    [12] = -56,
    [13] = -48,
    [14] = -40,
    [15] = -24,
    [16] = -16,
    [17] = -8,
    [18] = 0,
    [19] = 8,
    [20] = 16,
    [21] = 24,
    [22] = 40,
    [23] = 48,
    [24] = 56,
    [25] = 64,
    [26] = 72,
    [27] = 80,
    [28] = 88,
    [29] = 104,
    [30] = 112,
    [31] = 120,
    [32] = 128,
    [33] = 136,
    [34] = 144,
    [35] = 152
}

local HoldExplosion = Def.ActorFrame{}

if string.find(sButton, "Strum") then
    for i = 1,35 do
        HoldExplosion[#HoldExplosion+1] = Def.ActorFrame{
            InitCommand=function(self)
                self:diffusealpha(0):xyz(strumXPosTable[i],0,strumZPosTable[(i-1)%7]):rotationx(90):rotationz(strumRotateTable[(i-1)%7]):zoom(.5)
            end,
            HoldingOnCommand=function(self) self:diffusealpha(0.8) end,
            HoldingOffCommand=function(self) self:stoptweening():diffusealpha(0) end,
            Def.Sprite {
                InitCommand=function(self)
                    local period = math.random(20,50) / 200
                    self:diffuse(color(FHColorTable[sButton])):y(-5)
                    self:pulse():effectclock("timer"):effectperiod(period):effectmagnitude(1,0.5,1)
                end,
                Texture='sprites/partstrum.png'
            }
        }
    end
else
    for i = 1,15 do
        HoldExplosion[#HoldExplosion+1] = Def.ActorFrame{
            InitCommand=function(self) self:diffusealpha(0):rotationx(90) end,
            HoldingOnCommand=function(self) self:diffusealpha(1) end,
            HoldingOffCommand=function(self) self:stoptweening():diffusealpha(0) end,
            Def.ActorFrame {
                InitCommand=function(self)
                    local period = math.random(20,50) / 200
                    local offset = math.random(-90,90)
                    self:rotationz(offset):zoom((2 * math.cos(math.rad(offset))) + 1):xyz(10 * math.sin(math.rad(offset)),(-16 * math.cos(math.rad(offset))) - 1,0)
                    self:pulse():effectclock("timer"):effectperiod(period):effectmagnitude(0.5,0.2,1)
                end,
                Def.Sprite {
                    Texture='sprites/spark 4x1.png',
                    InitCommand=function(self) self:SetAllStateDelays(0.0625) end,
                },
                Def.Sprite {
                    InitCommand=function(self) self:diffuse(1,.7,.2,.5):zoom(1.3):blend('BlendMode_Add'):SetAllStateDelays(0.0625) end,
                    Texture='sprites/spark 4x1.png'
                }
            }
        }
    end
end

return Def.ActorFrame {
    Def.Sprite {
        Texture='sprites/particle.png',
        InitCommand=function(self)
            self:diffusealpha(0):zoom(1.2):xyz(0,-3,0)
        end,
        HoldingOnCommand=function(self)
            if not string.find(sButton, "Strum") then
                self:diffusealpha(1):pulse():effectclock("timer"):effectmagnitude(0.8,1,0.8):effectperiod(0.2)
            end
        end,
        HoldingOffCommand=function(self)
            self:stoptweening():diffusealpha(0)
        end,
    },
    Def.ActorFrame {
        InitCommand=function(self)
            self:diffusealpha(0)
        end,
        Def.Sprite {
            Texture='sprites/feversprite1.png',
            InitCommand=function(self)
                if string.find(sButton, "Strum") then
                    self:diffuse(color(FHColorTable[sButton])):zoomy(5):xyz(0,16,0):rotationz(90):blend('BlendMode_Add')
                else
                    self:diffuse(1,.7,.2,1):zoom(1):xyz(0,16,0):rotationz(90):blend('BlendMode_Add')
                end
            end
        },
        Def.Sprite {
            Texture='sprites/feversprite1.png',
            InitCommand=function(self)
                if string.find(sButton, "Strum") then
                    self:diffuse(color(FHColorTable[sButton])):zoomy(5):xyz(0,-16,0):rotationz(-90):blend('BlendMode_Add')
                else
                    self:diffuse(1,.7,.2,1):zoom(1):xyz(0,-16,0):rotationz(-90):blend('BlendMode_Add')
                end
            end
        },
        HoldingOnCommand=function(self)
            self:diffusealpha(1):pulse():effectclock("timer"):effectmagnitude(0.8,1,0.8):effectperiod(0.2)
        end,
        HoldingOffCommand=function(self)
            self:stoptweening():diffusealpha(0)
        end,
    },
    HoldExplosion
}