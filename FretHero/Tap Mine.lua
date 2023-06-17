local sButton = Var "Button"
local sEffect = Var "Effect"
local sPlayer = Var "Player"

return Def.ActorFrame {
    Def.Model { --mine color
        InitCommand=function(self)
            if string.find(sButton, "Strum") then
                self:rotationx(90):diffuse(0.1,0.1,0.1,1)
            else
                self:rotationx(90):diffuse(color(FHColorTable[sButton]))
            end
        end,
        Meshes=string.find(sButton, "Strum") and "models/strum color.txt" or "models/bomb color.txt",
        Materials=(string.find(sButton, "Strum") and "models/materials/Strum mats.txt") or "models/bomb color.txt",
        Bones="models/bomb color.txt",
        FeverMessageCommand=function(self,params)
            if params.pn ~= sPlayer then return end
            if string.find(sButton, "Strum") then
                self:diffuse(0.1,0.1,0.1,1)
            elseif params.Active then
                self:diffuse(color(FHColorTable["Fret 6"]))
            else
                self:diffuse(color(FHColorTable[sButton]))
            end
        end
    },
    Def.Model { --regular mine
        InitCommand=function(self)
            self:rotationx(90)
        end,
        Meshes=string.find(sButton, "Strum") and "models/strum.txt" or "models/bomb.txt",
        Materials=(string.find(sButton, "Strum") and "models/materials/Strum mats.txt") or "models/bomb.txt",
        Bones="models/bomb.txt",
    }
}