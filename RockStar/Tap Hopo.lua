local sButton = Var "Button"
local sEffect = Var "Effect"
local sPlayer = Var "Player"

return Def.ActorFrame {
    Def.Model { --glass center
        InitCommand=function(self)
            self:rotationx(90):rotationz(angleChart[sButton]):z(offsetChart[sButton]):diffuse(color(RSColorTable[sButton]))
            if string.find(sButton, "Strum") then
                self:zoom(1.25)
            else
                self:zoomy(.65):zoomz(.65):zoomx(.63)
            end
            if tonumber(sEffect) > 0 then
                self:diffuse(.9,.9,.9,1)
            end
        end,
        Meshes=string.find(sButton, "Strum") and "models/tube.txt" or "models/glasstube.txt",
        Materials="models/materials/default mats.txt",
        Bones="models/glasstube.txt",
        FeverMissedMessageCommand=function(self,params)
            if params.pn ~= sPlayer then return end
            if tonumber(sEffect) > 0 then
                if params.Missed then
                    self:diffuse(color(RSColorTable[sButton]))
                else
                    self:diffuse(.9,.9,.9,1)
                end
            end
        end
    },
    Def.Model { --shiny glass
        InitCommand=function(self)
            self:rotationx(90):rotationz(angleChart[sButton]):z(offsetChart[sButton]):blend('BlendMode_Add')
            if string.find(sButton, "Strum") then
                self:zoomy(1.26):zoomz(1.26):zoomx(1.25)
            else
                self:zoomy(.66):zoomz(.66):zoomx(.63)
            end
        end,
        Meshes=string.find(sButton, "Strum") and "models/tube.txt" or "models/glasstube.txt",
        Materials=(string.find(sButton, "Strum") and "models/materials/Strum hopo mats.txt") or "models/materials/plasticshine mats.txt",
        Bones="models/glasstube.txt",
    },
    Def.Model { --glow effect
        InitCommand=function(self)
            self:rotationx(90):rotationz(angleChart[sButton]):z(offsetChart[sButton]):diffuse(color(RSColorTable[sButton])):blend('BlendMode_Add')
            if not string.find(sButton, "Strum") then
                self:zoomx(1.5):zoomy(1.2):zoomz(1.2):z(offsetChart[sButton] - 3)
            else
                self:zoomx(9):zoomy(1.5):zoomz(1.5):z(offsetChart[sButton] + 3):diffusealpha(0.9)
            end
            if tonumber(sEffect) > 0 then
                if string.find(sButton, "Strum") then
                    self:diffuse(color(RSColorTable["Fret 6"]))
                else
                    self:diffuse(1,1,1,1)
                end
            end
        end,
        Meshes="models/glasstube_inverted.txt",
        Materials="models/materials/glowup mats.txt",
        Bones="models/glasstube.txt",
        FeverMissedMessageCommand=function(self,params)
            if params.pn ~= sPlayer then return end
            if tonumber(sEffect) > 0 then
                if params.Missed then
                    self:diffuse(color(RSColorTable[sButton]))
                    if string.find(sButton, "Strum") then
                        self:diffusealpha(.9)
                    end
                else
                    if string.find(sButton, "Strum") then
                        self:diffuse(color(RSColorTable["Fret 6"]))
                    else
                        self:diffuse(1,1,1,1)
                    end
                end
            end
        end
    },
    Def.ActorFrame {
        InitCommand=function(self)
            self:rotationx(90):rotationz(angleChart[sButton]):z(offsetChart[sButton])
            if not string.find(sButton, "Strum") then
                self:zoomy(.67):zoomz(.67)
            end
        end,
        Def.Model { --end cap #1
            InitCommand=function(self)
                if string.find(sButton, "Strum") then
                    self:x(160)
                else
                    self:x(6.1)
                end
                if tonumber(sEffect) > 0 then
                    self:diffuse(color(RSColorTable["Fret 6"]))
                else
                    self:diffuse(1,1,1,1)
                end
            end,
            Meshes=string.find(sButton, "Strum") and "models/socket.txt" or "models/endcap.txt",
            Materials=(string.find(sButton, "Strum") and "models/materials/Strum mats.txt") or "models/materials/default mats.txt",
            Bones="models/endcap.txt",
            FeverMissedMessageCommand=function(self,params)
                if params.pn ~= sPlayer then return end
                if tonumber(sEffect) > 0 then
                    if params.Missed then
                        self:diffuse(1,1,1,1)
                    else
                        self:diffuse(color(RSColorTable["Fret 6"]))
                    end
                end
            end
        },
        Def.Model { --end cap #1, strum fever only
            Condition=(Var "Button" == "Strum Up" and tonumber(Var "Effect") > 0),
            InitCommand=function(self) self:x(160):diffuse(color(RSColorTable["Fret 6"])) end,
            Meshes="models/socket.txt",
            Materials="models/materials/Strum hopo mats.txt",
            Bones="models/endcap.txt",
            FeverMissedMessageCommand=function(self,params)
                if params.pn ~= sPlayer then return end
                if tonumber(sEffect) > 0 then
                    if params.Missed then
                        self:diffusealpha(0)
                    else
                        self:diffuse(color(RSColorTable["Fret 6"]))
                    end
                end
            end
        },
        Def.Model { --end cap #2
            InitCommand=function(self)
                if string.find(sButton, "Strum") then
                    self:x(-160):rotationy(180)
                else
                    self:x(-6.1):rotationy(180)
                end
                if tonumber(sEffect) > 0 then
                    self:diffuse(color(RSColorTable["Fret 6"]))
                else
                    self:diffuse(1,1,1,1)
                end
            end,
            Meshes=string.find(sButton, "Strum") and "models/socket.txt" or "models/endcap.txt",
            Materials=(string.find(sButton, "Strum") and "models/materials/Strum mats.txt") or "models/materials/default mats.txt",
            Bones="models/endcap.txt",
            FeverMissedMessageCommand=function(self,params)
                if params.pn ~= sPlayer then return end
                if tonumber(sEffect) > 0 then
                    if params.Missed then
                        self:diffuse(1,1,1,1)
                    else
                        self:diffuse(color(RSColorTable["Fret 6"]))
                    end
                end
            end
        },
        Def.Model { --end cap #2, strum fever only
            Condition=(Var "Button" == "Strum Up" and tonumber(Var "Effect") > 0),
            InitCommand=function(self) self:rotationy(180):x(-160):diffuse(color(RSColorTable["Fret 6"])) end,
            Meshes="models/socket.txt",
            Materials="models/materials/Strum hopo mats.txt",
            Bones="models/endcap.txt",
            FeverMissedMessageCommand=function(self,params)
                if params.pn ~= sPlayer then return end
                if tonumber(sEffect) > 0 then
                    if params.Missed then
                        self:diffusealpha(0)
                    else
                        self:diffuse(color(RSColorTable["Fret 6"]))
                    end
                end
            end
        }
    },
    Def.ActorFrame { --light rings
        Condition=(Var "Button" ~= "Strum Up"),
        InitCommand=function(self)
            self:rotationx(90):rotationz(angleChart[sButton]):z(offsetChart[sButton]):zoomy(.67):zoomz(.67)
        end,
        Def.Model {
            InitCommand=function(self)
                self:x(15)
            end,
            Meshes="models/lightring.txt",
            Materials="models/materials/default mats.txt",
            Bones="models/lightring.txt"
        },
        Def.Model {
            InitCommand=function(self)
                self:x(-15):rotationy(180)
            end,
            Meshes="models/lightring.txt",
            Materials="models/materials/default mats.txt",
            Bones="models/lightring.txt"
        }
    },
    Def.Model { --base thingy
        Condition=(Var "Button" ~= "Strum Up"),
        InitCommand=function(self)
            self:rotationx(90):rotationz(angleChart[sButton]):z(offsetChart[sButton]):backfacecull(false):zoomy(.67):zoomz(.67):zoomx(.8)
        if tonumber(sEffect) > 0 then
                self:diffuse(Alpha(color(RSColorTable["Fret 6"]),.9))
            else
                self:diffuse(1,1,1,.9)
            end
        end,
        Meshes="models/notebase.txt",
        Materials="models/materials/default mats.txt",
        Bones="models/notebase.txt",
        FeverMissedMessageCommand=function(self,params)
            if params.pn ~= sPlayer then return end
            if tonumber(sEffect) > 0 then
                if params.Missed then
                    self:diffuse(1,1,1,.9)
                else
                    self:diffuse(Alpha(color(RSColorTable["Fret 6"]),.9))
                end
            end
        end
    }
}