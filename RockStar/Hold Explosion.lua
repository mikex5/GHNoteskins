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
local HoldExplosion2 = Def.ActorFrame{}

for i = 1,15 do
    HoldExplosion[#HoldExplosion+1] = Def.ActorFrame{
        InitCommand=function(self) self:diffusealpha(0):rotationx(90) end,
        HoldingOnCommand=function(self) self:diffusealpha(1) end,
        HoldingOffCommand=function(self) self:stoptweening():diffusealpha(0) end,
        Def.ActorFrame {
            InitCommand=function(self)
                local period = math.random(20,50) / 200
                local offset = math.random(-90,90)
                self:rotationz(offset):zoom((1.5 * math.cos(math.rad(offset))) + 1):xyz(8 * math.sin(math.rad(offset)),(-12 * math.cos(math.rad(offset))) - 1,0)
                self:pulse():effectclock("timer"):effectperiod(period):effectmagnitude(0.4,0.15,1)
            end,
            Def.Sprite {
                Texture='sprites/spark 4x1.png',
                InitCommand=function(self) self:SetAllStateDelays(0.0625) end,
            },
            Def.Sprite {
                InitCommand=function(self)
                    self:diffuse(color(RSColorTable[sButton])):diffusealpha(0.5):zoom(1.3):blend('BlendMode_Add'):SetAllStateDelays(0.0625)
                end,
                Texture='sprites/spark 4x1.png'
            }
        }
    }
end

if string.find(sButton, "Strum") then
    for i = 1,15 do
        HoldExplosion2[#HoldExplosion2+1] = Def.ActorFrame{
            InitCommand=function(self) self:diffusealpha(0):rotationx(90) end,
            HoldingOnCommand=function(self) self:diffusealpha(1) end,
            HoldingOffCommand=function(self) self:stoptweening():diffusealpha(0) end,
            Def.ActorFrame {
                InitCommand=function(self)
                    local period = math.random(20,50) / 200
                    local offset = math.random(-90,90)
                    self:rotationz(offset):zoom((1.5 * math.cos(math.rad(offset))) + 1):xyz(8 * math.sin(math.rad(offset)),(-12 * math.cos(math.rad(offset))) - 1,0)
                    self:pulse():effectclock("timer"):effectperiod(period):effectmagnitude(0.4,0.15,1)
                end,
                Def.Sprite {
                    Texture='sprites/spark 4x1.png',
                    InitCommand=function(self) self:SetAllStateDelays(0.0625) end,
                },
                Def.Sprite {
                    InitCommand=function(self)
                        self:diffuse(color(RSColorTable[sButton])):diffusealpha(0.5):zoom(1.3):blend('BlendMode_Add'):SetAllStateDelays(0.0625)
                    end,
                    Texture='sprites/spark 4x1.png'
                }
            }
        }
    end
end

return Def.ActorFrame {
    Def.ActorFrame {
        InitCommand=function(self) if string.find(sButton, "Strum") then self:x(-160) end end,
        Def.Sprite {
            Texture='sprites/particle.png',
            InitCommand=function(self)
                self:diffusealpha(0):zoom(1):y(0):rotationz(angleChart[sButton]):z(offsetChart[sButton])
            end,
            HoldingOnCommand=function(self)
                self:diffusealpha(1):pulse():effectclock("timer"):effectmagnitude(0.6,1,0.6):effectperiod(0.2)
            end,
            HoldingOffCommand=function(self)
                self:stoptweening():diffusealpha(0)
            end,
        },
        Def.ActorFrame {
            InitCommand=function(self)
                self:diffusealpha(0):rotationz(angleChart[sButton]):z(offsetChart[sButton])
            end,
            Def.Sprite {
                Texture='sprites/feversprite2.png',
                InitCommand=function(self)
                    self:diffuse(color(RSColorTable[sButton])):zoom(0.8):blend('BlendMode_Add')
                end
            },
            HoldingOnCommand=function(self)
                self:diffusealpha(1):pulse():effectclock("timer"):effectmagnitude(0.6,1,0.6):effectperiod(0.2)
            end,
            HoldingOffCommand=function(self)
                self:stoptweening():diffusealpha(0)
            end,
        },
        HoldExplosion,
    },
    Def.ActorFrame {
        Condition=(Var "Button" == "Strum Up"),
        InitCommand=function(self) if string.find(sButton, "Strum") then self:x(160) end end,
        Def.Sprite {
            Texture='sprites/particle.png',
            InitCommand=function(self)
                self:diffusealpha(0):zoom(1):y(0):rotationz(angleChart[sButton]):z(offsetChart[sButton])
            end,
            HoldingOnCommand=function(self)
                self:diffusealpha(1):pulse():effectclock("timer"):effectmagnitude(0.6,1,0.6):effectperiod(0.2)
            end,
            HoldingOffCommand=function(self)
                self:stoptweening():diffusealpha(0)
            end,
        },
        Def.ActorFrame {
            InitCommand=function(self)
                self:diffusealpha(0):rotationz(angleChart[sButton]):z(offsetChart[sButton])
            end,
            Def.Sprite {
                Texture='sprites/feversprite2.png',
                InitCommand=function(self)
                    self:diffuse(color(RSColorTable[sButton])):zoom(0.8):blend('BlendMode_Add')
                end
            },
            HoldingOnCommand=function(self)
                self:diffusealpha(1):pulse():effectclock("timer"):effectmagnitude(0.6,1,0.6):effectperiod(0.2)
            end,
            HoldingOffCommand=function(self)
                self:stoptweening():diffusealpha(0)
            end,
        },
        HoldExplosion2
    }
}