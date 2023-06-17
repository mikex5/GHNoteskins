local sButton = Var "Button"
local sEffect = Var "Effect"
local sPlayer = Var "Player"
local sColor = Var "Color"
if sColor == "" then sColor = "4th" end

return Def.ActorFrame {
    Def.Model { --mine color
        InitCommand=function(self)
            if string.find(sButton, "Strum") then
                self:rotationx(90):diffuse(0.1,0.1,0.1,1):zoom(1.25)
            else
                self:rotationx(90):diffuse(color(RSQColorTable[sColor]))
            end
        end,
        Meshes=string.find(sButton, "Strum") and "models/tube.txt" or "models/bomb color.txt",
        Materials=(string.find(sButton, "Strum") and "models/materials/default mats.txt") or "models/bomb color.txt",
        Bones="models/bomb color.txt",
        FeverMessageCommand=function(self,params)
            if params.pn ~= sPlayer then return end
            if string.find(sButton, "Strum") then
                self:diffuse(0.1,0.1,0.1,1)
            elseif params.Active then
                self:diffuse(color(RSQColorTable["Fever"]))
            else
                self:diffuse(color(RSQColorTable[sColor]))
            end
        end
    },
    Def.Model { --regular mine
        Condition=(Var "Button" ~= "Strum Up"),
        InitCommand=function(self)
            self:rotationx(90)
        end,
        Meshes=string.find(sButton, "Strum") and "models/strum.txt" or "models/bomb.txt",
        Materials=(string.find(sButton, "Strum") and "models/materials/Strum mats.txt") or "models/bomb.txt",
        Bones="models/bomb.txt",
    },
    Def.Model { --strum end cap #1
        Condition=(Var "Button" == "Strum Up"),
        InitCommand=function(self)
            self:x(160):diffuse(1,1,1,1)
        end,
        Meshes="models/socket.txt",
        Materials="models/materials/Strum mats.txt",
        Bones="models/endcap.txt"
    },
    Def.Model { --strum end cap #2
        Condition=(Var "Button" == "Strum Up"),
        InitCommand=function(self)
            self:rotationy(180):x(-160):diffuse(1,1,1,1)
        end,
        Meshes="models/socket.txt",
        Materials="models/materials/Strum mats.txt",
        Bones="models/endcap.txt"
    }
}