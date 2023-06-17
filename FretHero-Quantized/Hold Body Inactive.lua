local sButton = Var "Button"
local sPlayer = Var "Player"
local sColor = Var "Color"
if sColor == "" then sColor = "4th" end

return Def.ActorFrame {
    InitCommand=function(self) self:SetHeight(16) end,
    Def.Sprite {
        Texture=string.find(sButton, "Strum") and 'sprites/StrumHold.png' or 'sprites/TapHold.png',
        InitCommand=function(self)
            if string.find(sButton, "Strum") then
                self:zoomy(0.5):diffuse(ColorDarkTone(color(FHQColorTable[sColor])))
            else
                self:zoom(0.5):diffuse(color(FHQColorTable[sColor]))
            end
        end,
        FeverMessageCommand=function(self,params)
            if params.pn ~= sPlayer then return end
            if params.Active then
                self:diffuse(color(FHQColorTable["Fever"]))
            else
                if string.find(sButton, "Strum") then
                    self:diffuse(ColorDarkTone(color(FHQColorTable[sColor])))
                else
                    self:diffuse(color(FHQColorTable[sColor]))
                end
            end
        end
    }
}
