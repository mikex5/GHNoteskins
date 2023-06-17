local sButton = Var "Button"
local sPlayer = Var "Player"

return Def.ActorFrame {
    InitCommand=function(self) self:SetHeight(16) end,
    Def.Sprite {
        Texture=string.find(sButton, "Strum") and 'sprites/StrumHoldCap.png' or 'sprites/TapHoldCap.png',
        InitCommand=function(self)
            if string.find(sButton, "Strum") then
                self:zoomy(0.5):diffuse(ColorDarkTone(color(FHColorTable[sButton]))):y(16)
            else
                self:zoom(0.5):diffuse(color(FHColorTable[sButton])):y(16)
            end
        end,
        FeverMessageCommand=function(self,params)
            if params.pn ~= sPlayer then return end
            if params.Active then
                self:diffuse(color(FHColorTable["Fret 6"]))
            else
                if string.find(sButton, "Strum") then
                    self:diffuse(ColorDarkTone(color(FHColorTable[sButton])))
                else
                    self:diffuse(color(FHColorTable[sButton]))
                end
            end
        end
    }
}
