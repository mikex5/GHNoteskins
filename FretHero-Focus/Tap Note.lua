local sButton = Var "Button"
local sEffect = Var "Effect"
local sPlayer = Var "Player"

return Def.ActorFrame {
    Def.Model { --fever note color
        --If this is not a fever note from the get-go, don't even bother loading the real model
        Condition=(tonumber(Var "Effect") > 0),
        InitCommand=function(self)
            self:rotationx(90):diffuse(color(FHFColorTable[sButton]))
            self.isHidden = false
        end,
        Meshes=(string.find(sButton, "Strum") and "models/strum color.txt") or "models/star color.txt",
        Materials=(string.find(sButton, "Strum") and "models/materials/Strum mats.txt") or "models/materials/Fret mats.txt",
        Bones="models/star color.txt",
        FeverMessageCommand=function(self,params)
            if params.pn ~= sPlayer then return end
            if self.isHidden then
                self:diffusealpha(0)
            end
        end,
        FeverMissedMessageCommand=function(self,params)
            if params.pn ~= sPlayer then return end
            if tonumber(sEffect) > 0 then
                if params.Missed then
                    self:diffusealpha(0)
                    self.isHidden = true
                else
                    self:diffusealpha(1)
                    self.isHidden = false
                end
            end
        end
    },
    Def.Model { --fever note glow
        --If this is not a fever note from the get-go, don't even bother loading the real model
        Condition=(tonumber(Var "Effect") > 0),
        InitCommand=function(self)
            self:rotationx(90):diffuse(color(FHFColorTable["Fret 6"]))
            self.isHidden = false
        end,
        Meshes=(string.find(sButton, "Strum") and "models/strum.txt") or "models/star glow.txt",
        Materials=(string.find(sButton, "Strum") and "models/materials/Strum fever mats.txt") or "models/materials/Fret mats.txt",
        Bones="models/star glow.txt",
        FeverMessageCommand=function(self,params)
            if params.pn ~= sPlayer then return end
            if self.isHidden then
                self:diffusealpha(0)
            end
        end,
        FeverMissedMessageCommand=function(self,params)
            if params.pn ~= sPlayer then return end
            if params.Missed then
                self:diffusealpha(0)
                self.isHidden = true
            else
                self:diffusealpha(1)
                self.isHidden = false
            end
        end
    },
    Def.Model { --fever note
        --If this is not a fever note from the get-go, don't even bother loading the real model
        Condition=(Var "Button" ~= "Strum Up" and tonumber(Var "Effect") > 0),
        InitCommand=function(self)
            self:rotationx(90)
            self.isHidden = false
        end,
        Meshes="models/star.txt",
        Materials="models/materials/Fret mats.txt",
        Bones="models/star.txt",
        FeverMissedMessageCommand=function(self,params)
            if params.pn ~= sPlayer then return end
            if params.Missed then
                self:diffusealpha(0)
                self.isHidden = true
            else
                self:diffusealpha(1)
                self.isHidden = false
            end
        end
    },
    Def.Model { --regular note color
        InitCommand=function(self)
            self:rotationx(90):diffuse(color(FHFColorTable[sButton]))
            if tonumber(sEffect) > 0 then
                self:diffusealpha(0)
                self.isHidden = true
            else
                self.isHidden = false
            end
        end,
        Meshes=string.find(sButton, "Strum") and "models/strum color.txt" or "models/gem color.txt",
        Materials=(string.find(sButton, "Strum") and "models/materials/Strum mats.txt") or "models/materials/Fret mats.txt",
        Bones="models/gem color.txt",
        FeverMessageCommand=function(self,params)
            if params.pn ~= sPlayer then return end
            if self.isHidden then
                self:diffusealpha(0)
            end
        end,
        FeverMissedMessageCommand=function(self,params)
            if params.pn ~= sPlayer then return end
            if tonumber(sEffect) > 0 then
                if params.Missed then
                    self:diffusealpha(1)
                    self.isHidden = false
                else
                    self:diffusealpha(0)
                    self.isHidden = true
                end
            end
        end
    },
    Def.Model { --regular note
        InitCommand=function(self)
            self:rotationx(90)
            if tonumber(sEffect) > 0 then
                self:diffusealpha(0)
                self.isHidden = true
            else
                self.isHidden = false
            end
        end,
        Meshes=string.find(sButton, "Strum") and "models/strum.txt" or "models/gem.txt",
        Materials=(string.find(sButton, "Strum") and "models/materials/Strum mats.txt") or "models/materials/Fret mats.txt",
        Bones="models/gem.txt",
        FeverMissedMessageCommand=function(self,params)
            if params.pn ~= sPlayer then return end
            if tonumber(sEffect) > 0 then
                if params.Missed then
                    self:diffusealpha(1)
                    self.isHidden = false
                else
                    self:diffusealpha(0)
                    self.isHidden = true
                end
            end
        end
    }
}