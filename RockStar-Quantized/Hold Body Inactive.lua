local sButton = Var "Button"
local sEffect = Var "Effect"
local sPlayer = Var "Player"
local sColor = Var "Color"
if sColor == "" then sColor = "4th" end

return Def.ActorFrame {
    InitCommand=function(self) self:SetHeight(32) end,
    Def.Sprite {
        Texture='sprites/glinewave 8x1.png',
        InitCommand=function(self)
            self:zoomx(2):zoomy(.5):z(offsetChart[sButton]):animate(false):diffuse(color(RSQColorTable[sColor])):setstate(0):fadebottom(0.2)
            if string.find(sButton, "Strum") then
                self:x(160)
            end
            if tonumber(sEffect) > 0 then
                self:diffuse(1,1,1,1)
            end
        end,
        FeverMissedMessageCommand=function(self,params)
            if params.pn ~= sPlayer then return end
            if tonumber(sEffect) > 0 then
                if params.Missed then
                    self:diffuse(color(RSQColorTable[sColor]))
                else
                    self:diffuse(1,1,1,1)
                end
            end
        end
    },
    Def.Sprite {
        Condition=(Var "Button" == "Strum Up"),
        Texture='sprites/glinewave 8x1.png',
        InitCommand=function(self)
            self:zoomx(2):zoomy(.5):z(offsetChart[sButton]):animate(false):diffuse(color(RSQColorTable[sColor])):setstate(0):fadebottom(0.2):x(-160)
            if tonumber(sEffect) > 0 then
                self:diffuse(1,1,1,1)
            end
        end,
        FeverMissedMessageCommand=function(self,params)
            if params.pn ~= sPlayer then return end
            if tonumber(sEffect) > 0 then
                if params.Missed then
                    self:diffuse(color(RSQColorTable[sColor]))
                else
                    self:diffuse(1,1,1,1)
                end
            end
        end
    }
}
