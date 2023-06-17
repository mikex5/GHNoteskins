local sButton = Var "Button"
local sEffect = Var "Effect"
local sPlayer = Var "Player"
local iCurrentFrame = 0 -- Hungarian notation is ass but why no ints in lua??
local fTexOffset = 0
local fLastFrameSeconds = GetTimeSinceStart()
local fLastUpdateSeconds = fLastFrameSeconds
local animX1 =
{
    [0] = 0, -- arrays start at 0, and no language will tell me otherwise
    [1] = 0.125,
    [2] = 0.25,
    [3] = 0.375,
    [4] = 0.5,
    [5] = 0.625,
    [6] = 0.75,
    [7] = 0.875,
    [8] = 0.875,
    [9] = 0.75,
    [10] = 0.625,
    [11] = 0.5,
    [12] = 0.375,
    [13] = 0.25,
    [14] = 0.125,
    [15] = 0,
    [16] = 0.25,
    [17] = 0.375,
    [18] = 0.5,
    [19] = 0.625,
    [20] = 0.75,
    [21] = 0.875,
    [22] = 1,
    [23] = 1,
    [24] = 0.875,
    [25] = 0.75,
    [26] = 0.625,
    [27] = 0.5,
    [28] = 0.375,
    [29] = 0.25,
}
local animX2 =
{
    [0] = 0.125,
    [1] = 0.25,
    [2] = 0.375,
    [3] = 0.5,
    [4] = 0.625,
    [5] = 0.75,
    [6] = 0.875,
    [7] = 1,
    [8] = 1,
    [9] = 0.875,
    [10] = 0.75,
    [11] = 0.625,
    [12] = 0.5,
    [13] = 0.375,
    [14] = 0.25,
    [15] = 0.125,
    [16] = 0.125,
    [17] = 0.25,
    [18] = 0.375,
    [19] = 0.5,
    [20] = 0.625,
    [21] = 0.75,
    [22] = 0.875,
    [23] = 0.875,
    [24] = 0.75,
    [25] = 0.625,
    [26] = 0.5,
    [27] = 0.375,
    [28] = 0.25,
    [29] = 0.125,
}

return Def.ActorFrame {
    InitCommand=function(self) self:SetHeight(64) end,
    HoldUpdateCommand=function(self) -- Thanks Jous :)
        local fNow = GetTimeSinceStart()
        if fNow - fLastFrameSeconds >= 0.025 then
            iCurrentFrame = iCurrentFrame + (((fNow - fLastFrameSeconds) * 40) % 30)
            if iCurrentFrame >= 30 then iCurrentFrame = iCurrentFrame - 30 end
            fLastFrameSeconds = fNow
        end
        fTexOffset = fTexOffset - ((fNow -fLastUpdateSeconds) * 1.333333)
        if fTexOffset <= -1 then fTexOffset = 0 end
        fLastUpdateSeconds = fNow
        if string.find(sButton, "Strum") then
            self:GetChild("Helix1"):customtexturerect(animX1[math.floor(iCurrentFrame)], -(self:GetHoldLength()/(self:GetChild("Helix1"):GetHeight() * 2)), animX2[math.floor(iCurrentFrame)], 0):fadebottom(0.2)
            self:GetChild("Helix2"):customtexturerect(animX1[math.floor(iCurrentFrame)], -(self:GetHoldLength()/(self:GetChild("Helix2"):GetHeight() * 2)), animX2[math.floor(iCurrentFrame)], 0):fadebottom(0.2)
            self:GetChild("Helix3"):customtexturerect(animX1[math.floor(iCurrentFrame)], -(self:GetHoldLength()/(self:GetChild("Helix3"):GetHeight() * 2)), animX2[math.floor(iCurrentFrame)], 0):fadebottom(0.2)
            self:GetChild("Helix4"):customtexturerect(animX1[math.floor(iCurrentFrame)], -(self:GetHoldLength()/(self:GetChild("Helix4"):GetHeight() * 2)), animX2[math.floor(iCurrentFrame)], 0):fadebottom(0.2)
        else
            self:GetChild("Helix1"):customtexturerect(0.5, -(self:GetHoldLength()/(self:GetChild("Helix1"):GetHeight() * 2)) + fTexOffset, 0.625, fTexOffset):fadebottom(0.2)
            self:GetChild("Helix2"):customtexturerect(animX1[math.floor(iCurrentFrame)], -(self:GetHoldLength()/(self:GetChild("Helix2"):GetHeight() * 2)), animX2[math.floor(iCurrentFrame)], 0):fadebottom(0.2)
            self:GetChild("Helix3"):customtexturerect(0.5, -(self:GetHoldLength()/(self:GetChild("Helix3"):GetHeight() * 2)) + fTexOffset, 0.625, fTexOffset):fadebottom(0.2)
            self:GetChild("Helix4"):customtexturerect(animX1[math.floor(iCurrentFrame)], -(self:GetHoldLength()/(self:GetChild("Helix4"):GetHeight() * 2)), animX2[math.floor(iCurrentFrame)], 0):fadebottom(0.2)
        end
        --self:GetChild("debuge"):settext(tostring(iCurrentFrame))
    end,
    Def.Sprite {
        Name="Helix1",
        Texture='sprites/glinewave 8x1.png',
        InitCommand=function(self)
            self:diffuse(color(RSColorTable[sButton])):x(1):z(offsetChart[sButton]):animate(false)
            if string.find(sButton, "Strum") then
                self:x(160)
            end
            if tonumber(sEffect) > 0 then
                self:diffuse(color("1,1,1,1"))
            end
        end,
        FeverMissedMessageCommand=function(self,params)
            if params.pn ~= sPlayer then return end
            if tonumber(sEffect) > 0 then
                if params.Missed then
                    self:diffuse(color(RSColorTable[sButton]))
                else
                    self:diffuse(color("1,1,1,1"))
                end
            end
        end
    },
    Def.Sprite {
        Name="Helix2",
        Texture='sprites/glinewave 8x1.png',
        InitCommand=function(self)
            self:x(-1):z(offsetChart[sButton]):diffuse(color(RSColorTable[sButton])):animate(false)
            if string.find(sButton, "Strum") then
                self:x(-160)
            end
            if tonumber(sEffect) > 0 then
                self:diffuse(color("1,1,1,1"))
            end
        end,
        FeverMissedMessageCommand=function(self,params)
            if params.pn ~= sPlayer then return end
            if tonumber(sEffect) > 0 then
                if params.Missed then
                    self:diffuse(color(RSColorTable[sButton]))
                else
                    self:diffuse(color("1,1,1,1"))
                end
            end
        end
    },
    Def.Sprite {
        Name="Helix3",
        Texture='sprites/zinewave 8x1.png',
        InitCommand=function(self)
            self:diffuse(color("1,1,1,0.8")):x(1):z(offsetChart[sButton]):animate(false):blend('BlendMode_Add')
            if string.find(sButton, "Strum") then
                self:x(160)
            end
        end
    },
    Def.Sprite {
        Name="Helix4",
        Texture='sprites/zinewave 8x1.png',
        InitCommand=function(self)
            self:x(-1):z(offsetChart[sButton]):diffuse(color("1,1,1,0.8")):animate(false):blend('BlendMode_Add')
            if string.find(sButton, "Strum") then
                self:x(-160)
            end
        end
    --},
    --Def.BitmapText{
    --    Name="debuge",
    --    Text="",
    --    Font="Common Normal",
    --    InitCommand=function(self) self:diffuse(1,1,1,1):rotationx(180) end,
    }
}
