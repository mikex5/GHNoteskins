local sButton = Var "Button"
local sPlayer = Var "Player"
if not RBReceptor then RBReceptor = {} end
if not RBReceptor[sPlayer] then RBReceptor[sPlayer] = {} end
if not RBReceptor[sPlayer][sButton] then RBReceptor[sPlayer][sButton] = {} end

-- Here's a map for what RBReceptor is since it's gotten so convoluted
-- First is per player, then per button (Fret 1, Fret 2,... Fret 5)
-- [0] = Nothing. Lua lists start at 1 for some cursed reason
-- [1] = The entire assembled receptor for a column
-- [2] = Whether the fret is being pressed down or not
-- [3] = The main part of the receptor you can see
-- [4] = The shine on top of that. It's its own model.
-- [5] = The light up portion when you hit a note. Again, its own model.

local Buttons = {
    "Fret 1",
    "Fret 2",
    "Fret 3",
    "Fret 4",
    "Fret 5"
}

local feverActive = false

if sButton == "Strum Up" then
    return Def.ActorFrame{
        Def.ActorFrame{ --Strum bracket
            OnCommand=function(self) self:rotationx(90) end,
            Def.Model {
                InitCommand=function(self)
                    self:x(157):diffuse(.5,.5,.5,1)
                end,
                Meshes="models/footplate.txt",
                Materials="models/materials/default mats.txt",
                Bones="models/footplate.txt"
            },
            Def.Model {
                InitCommand=function(self)
                    self:rotationy(180):x(-157):diffuse(.5,.5,.5,1)
                end,
                Meshes="models/footplate.txt",
                Materials="models/materials/default mats.txt",
                Bones="models/footplate.txt"
            },
            Def.Model {
                InitCommand=function(self)
                    self:x(157)
                end,
                Meshes="models/otherfootpart.txt",
                Materials="models/materials/default mats.txt",
                Bones="models/otherfootpart.txt"
            },
            Def.Model {
                InitCommand=function(self)
                    self:rotationy(180):x(-157):z(30.98)
                end,
                Meshes="models/otherfootpart.txt",
                Materials="models/materials/default mats.txt",
                Bones="models/otherfootpart.txt"
            },
            Def.Model {
                InitCommand=function(self)
                    self:x(157):diffuse(color(RSFColorTable["Fret 5"]))
                end,
                Meshes="models/hammer.txt",
                Materials="models/materials/strum mats.txt",
                Bones="models/hammer.txt",
                PressCommand=function(self)
                    local FretActive = false
                    for _,v in ipairs(Buttons) do
                        if RBReceptor[sPlayer][v][2] then
                            FretActive = true
                        end
                    end
                    if not FretActive then
                        self:rotationz(-15):x(147):accelerate(.15):rotationz(0):x(157)
                    end
                end
            },
            Def.Model {
                InitCommand=function(self)
                    self:rotationy(180):x(-157):diffuse(color(RSFColorTable["Fret 5"]))
                end,
                Meshes="models/hammer.txt",
                Materials="models/materials/strum mats.txt",
                Bones="models/hammer.txt",
                PressCommand=function(self)
                    local FretActive = false
                    for _,v in ipairs(Buttons) do
                        if RBReceptor[sPlayer][v][2] then
                            FretActive = true
                        end
                    end
                    if not FretActive then
                        self:rotationz(-15):x(-147):accelerate(.15):rotationz(0):x(-157)
                    end
                end
            }
        }
    }
end

local hitCommand = function(self)
    RBReceptor[sPlayer][sButton][3]:stoptweening():bounceend(.05):y(-2):accelerate(.1):y(0)
    RBReceptor[sPlayer][sButton][4]:stoptweening():bounceend(.05):y(-2.1):accelerate(.1):y(-0.1)
    RBReceptor[sPlayer][sButton][5]:stoptweening():diffusealpha(0.7):bounceend(.05):y(-2.1):accelerate(.1):y(-0.1):linear(0.01):diffusealpha(0)
end

return Def.ActorFrame {
    InitCommand=function(self)
        RBReceptor[sPlayer][sButton][1] = self
        RBReceptor[sPlayer][sButton][2] = false
    end,
    PressCommand=function(self)
        RBReceptor[sPlayer][sButton][2] = true
    end,
    LiftCommand=function(self)
        RBReceptor[sPlayer][sButton][2] = false
    end,
    W1Command=hitCommand,
    W2Command=hitCommand,
    W3Command=hitCommand,
    W4Command=hitCommand,
    W5Command=hitCommand,
    Def.ActorFrame { --These things need to be skewed but not rotated
        InitCommand=function(self)
            self:z(-2)
        end,
        Def.Quad { --Quad that gives nifty status info going around the edge of the receptor. One for combos one for fever
            InitCommand=function(self)
                self:zoomto(64, 20):y(-25):z(-0.2):diffuse(1,1,1,0):blend('BlendMode_Add')
                self.missCounted = false
                self.maxCombo = false
                self.lastProcessed = 0
            end,
            ComboChangedMessageCommand=function(self,params)
                if params.Player ~= sPlayer then return end
                local curCombo = params.PlayerStageStats:GetCurrentCombo()
                local misCombo = params.PlayerStageStats:GetCurrentMissCombo()
                if self.lastProcessed == curCombo then return end
                self.lastProcessed = curCombo
                if curCombo >= 30 and not self.maxCombo then
                    self:stoptweening():diffuse(1,1,1,1):linear(0.2):diffuse(.4,.8,1,1):diffusetopedge(.4,.8,1,0)
                    self.maxCombo = true
                elseif curCombo ~= 0 and curCombo % 10 == 0 and not self.maxCombo then
                    self:stoptweening():diffuse(1,1,1,1):diffusetopedge(1,1,1,.2):linear(0.5):diffuse(1,1,1,0)
                end
                if misCombo > 0 then
                    self:stoptweening():diffuse(1,0,0,1):diffusetopedge(1,0,0,.2):linear(0.3):diffuse(1,0,0,0)
                    self.maxCombo = false
                end
            end,
        },
        Def.Quad {
            InitCommand=function(self)
                self:zoomto(64, 20):y(19):z(-0.2):diffuse(1,1,1,0):blend('BlendMode_Add')
                self.feverActive = false
            end,
            FeverMessageCommand=function(self,params)
                if params.pn ~= sPlayer then return end
                self.feverActive = params.Active
                if params.Active then
                    self:stoptweening():linear(.1):diffuse(color(RSFColorTable["Fret 6"])):linear(.2):diffusebottomedge(Alpha(color(RSFColorTable["Fret 6"]),.3))
                else
                    self:stoptweening():linear(.2):diffuse(Alpha(color(RSFColorTable["Fret 6"]),0))
                    self.prevAmount = 0
                end
            end,
            FeverScoreMessageCommand=function(self,params)
                if params.pn ~= sPlayer then return end
                local percent = 0
                if params.Amount >= 50 then percent = 0.5 end
                if params.Amount > self.prevAmount then
                    self.prevAmount = params.Amount
                    if self.feverActive then
                        self:stoptweening():linear(.1):diffuse(1,1,1,1):linear(.1):diffuse(color(RSFColorTable["Fret 6"])):diffusebottomedge(Alpha(color(RSFColorTable["Fret 6"]),.3))
                    elseif params.Amount >= 50 then
                        self:stoptweening():linear(.1):diffuse(1,1,1,1):linear(.1):diffuse(color(RSFColorTable["Fret 6"])):diffusebottomedge(Alpha(color(RSFColorTable["Fret 6"]),0))
                    else
                        self:stoptweening():linear(.1):diffuse(1,1,1,1):linear(.1):diffuse(Alpha(color(RSFColorTable["Fret 6"]),0))
                    end
                end
            end,
        },
        Def.Quad { --Quads for the black border under the receptor
            InitCommand=function(self)
                self:zoomto(64, 13):y(10):diffuse(0,0,0,1)
            end
        },
        Def.Quad {
            InitCommand=function(self)
                self:zoomto(64, 13):y(-3):diffuse(0,0,0,1):diffusetopedge(0.3,0.3,0.3,1)
            end
        },
        Def.Quad {
            InitCommand=function(self)
                self:zoomto(64, 13):y(-16):diffuse(0.3,0.3,0.3,1):diffusetopedge(0,0,0,1)
            end
        },
    },
    Def.ActorFrame { --These things need to be skewed and rotated
        InitCommand=function(self)
            self:rotationx(90)
        end,
        Def.Model {
            InitCommand=function(self)
                self:diffuse(color(RSFColorTable[sButton]))
                RBReceptor[sPlayer][sButton][3] = self
            end,
            PressCommand=function(self) self:glow(Alpha(color(RSFColorTable[sButton]), 0.2)) end,
            LiftCommand=function(self) self:glow(1,1,1,0) end,
            Meshes="models/receptor.txt",
            Materials="models/materials/default mats.txt",
            Bones="models/receptor.txt"
        },
        Def.Model {
            InitCommand=function(self)
                self:blend('BlendMode_Add'):zoom(1.01):y(-0.1)
                RBReceptor[sPlayer][sButton][4] = self
            end,
            Meshes="models/receptor.txt",
            Materials="models/materials/plasticshine mats.txt",
            Bones="models/receptor.txt"
        },
        Def.Model {
            InitCommand=function(self)
                self:x(28)
            end,
            Meshes="models/bezel.txt",
            Materials="models/bezel.txt",
            Bones="models/bezel.txt"
        },
        Def.Model {
            InitCommand=function(self)
                self:x(-28)
            end,
            Meshes="models/bezel.txt",
            Materials="models/bezel.txt",
            Bones="models/bezel.txt"
        },
        Def.Sprite { --On press light effect
            Texture='sprites/feversprite2.png',
            InitCommand=function(self)
                self:diffuse(ColorDarkTone(color(RSFColorTable[sButton]))):blend('BlendMode_Add'):rotationx(-90):z(3):zoom(1.6):diffusealpha(0)
            end,
            PressCommand=function(self) self:diffusealpha(0.8) end,
            LiftCommand=function(self) self:diffusealpha(0) end,
        },
        Def.Model {
            InitCommand=function(self)
                self:blend('BlendMode_Add'):zoom(1.01):y(-0.1):diffusealpha(0)
                RBReceptor[sPlayer][sButton][5] = self
            end,
            Meshes="models/receptor.txt",
            Materials="models/materials/receptoractive mats.txt",
            Bones="models/receptor.txt"
        }
    }
}