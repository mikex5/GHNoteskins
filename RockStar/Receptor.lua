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

local shadows = Def.ActorFrame{}

for k,v in ipairs(Buttons) do
    shadows[#shadows+1] = Def.ActorFrame{
        Def.Quad {
            InitCommand=function(self)
                self:zoomto(64, 13):y(10):diffuse(0,0,0,1):rotationz(angleChart[v]):z(offsetChart[v]-2):x((k-3)*64)
            end
        },
        Def.Quad {
            InitCommand=function(self)
                self:zoomto(64, 13):y(-3):diffuse(0,0,0,1):diffusetopedge(0.3,0.3,0.3,1):rotationz(angleChart[v]):z(offsetChart[v]-2):x((k-3)*64)
            end
        },
        Def.Quad {
            InitCommand=function(self)
                self:zoomto(64, 13):y(-16):diffuse(0.3,0.3,0.3,1):diffusetopedge(0,0,0,1):rotationz(angleChart[v]):z(offsetChart[v]-2):x((k-3)*64)
            end
        }
    }
end

if sButton == "Strum Up" then
    return Def.ActorFrame{
        shadows,
        Def.ActorFrame{ --Highway
            OnCommand=function(self) self:z(-8) end,
            Def.Quad{ --Highway edges
                InitCommand=function(self)
                    self:xy(-170,-400):zoomto(10,1100):diffuse(Alpha(color(RSColorTable["Fret 6"]),0)):fadetop(0.3):blend('BlendMode_Add')
                    self.prevAmount = 0
                    self.feverActive = false
                end,
                FeverMessageCommand=function(self,params)
                    if params.pn ~= sPlayer then return end
                    self.feverActive = params.Active
                    if params.Active then
                        self:stoptweening():linear(.2):diffusealpha(1):linear(.3):diffusealpha(.5):fadetop(0.3)
                        self.prevAmount = 0
                    else
                        self:stoptweening():linear(.5):diffusealpha(0):fadetop(0.3)
                    end
                end,
                FeverScoreMessageCommand=function(self,params)
                    if params.pn ~= sPlayer then return end
                    self.Amount = params.Amount;
                    if params.Amount > self.prevAmount then
                        if self.feverActive then
                            self:stoptweening():linear(.3):diffusealpha(1):linear(.3):diffusealpha(.5):fadetop(0.3)
                        else
                            self:stoptweening():linear(.3):diffusealpha(1):linear(.3):diffusealpha(0):fadetop(0.3)
                        end
                        self.prevAmount = params.Amount
                    end
                end
            },
            Def.Quad{
                InitCommand=function(self)
                    self:xy(170,-400):zoomto(10,1100):diffuse(Alpha(color(RSColorTable["Fret 6"]),0)):fadetop(0.3):blend('BlendMode_Add')
                    self.prevAmount = 0
                    self.feverActive = false
                end,
                FeverMessageCommand=function(self,params)
                    if params.pn ~= sPlayer then return end
                    self.feverActive = params.Active
                    if params.Active then
                        self:stoptweening():linear(.2):diffusealpha(1):linear(.3):diffusealpha(.5):fadetop(0.3)
                        self.prevAmount = 0
                    else
                        self:stoptweening():linear(.5):diffusealpha(0):fadetop(0.3)
                    end
                end,
                FeverScoreMessageCommand=function(self,params)
                    if params.pn ~= sPlayer then return end
                    if params.Amount > self.prevAmount then
                        if self.feverActive then
                            self:stoptweening():linear(.3):diffusealpha(1):linear(.3):diffusealpha(.5):fadetop(0.3)
                        else
                            self:stoptweening():linear(.3):diffusealpha(1):linear(.3):diffusealpha(0):fadetop(0.3)
                        end
                        self.prevAmount = params.Amount
                    end
                end
            },
            Def.ActorFrame{ --Fever effects
                InitCommand=function(self)
                    self:y(-110):diffusealpha(0)
                    self.prevAmount = 0
                    self.feverActive = false
                end,
                Def.Sprite{
                    Texture="sprites/feversprite1.png",
                    InitCommand=function(self)
                        self:x(-134):diffuse(color(RSColorTable["Fret 6"])):zoomx(2):zoomy(4)
                    end
                },
                Def.Sprite{
                    Texture="sprites/feversprite1.png",
                    InitCommand=function(self)
                        self:x(134):zoomx(-2):zoomy(4):diffuse(color(RSColorTable["Fret 6"]))
                    end
                },
                FeverMessageCommand=function(self,params)
                    if params.pn ~= sPlayer then return end
                    if params.Active then
                        self:stoptweening():y(100):diffusealpha(1):linear(0.5):y(-700):diffusealpha(0)
                        self.prevAmount = 0
                    else
                        self:stoptweening():diffusealpha(0):y(0)
                    end
                    self.feverActive = params.Active
                end,
                FeverScoreMessageCommand=function(self,params)
                    if params.pn ~= sPlayer then return end
                    if params.Amount > self.prevAmount then
                        if not self.feverActive then
                            self:stoptweening():y(0):diffusealpha(1):linear(.5):y(-800):diffusealpha(0)
                        end
                        self.prevAmount = params.Amount
                    end
                end
            },
            Def.ActorFrame{ --More fever effects
                InitCommand=function(self)
                    self:y(-370):diffusealpha(0)
                end,
                Def.Quad{
                    InitCommand=function(self)
                        self:x(-150):zoomto(32,1100):diffuse(Alpha(color(RSColorTable["Fret 6"]),0)):diffuselowerleft(color(RSColorTable["Fret 6"]))
                    end
                },
                Def.Quad{
                    InitCommand=function(self)
                        self:x(150):zoomto(-32,1100):diffuse(Alpha(color(RSColorTable["Fret 6"]),0)):diffuselowerleft(color(RSColorTable["Fret 6"]))
                    end
                },
                FeverMessageCommand=function(self,params)
                    if params.pn ~= sPlayer then return end
                    if params.Active then
                        self:stoptweening():diffusealpha(0):linear(.3):diffusealpha(1)
                        self:diffuseshift():diffusealpha(1):effectcolor1(1,1,1,1):effectcolor2(1,1,1,.5):effectperiod(1)
                    else
                        self:stopeffect():linear(.5):diffusealpha(0)
                    end
                end,
            },
            Def.Sprite{ --Even MORE
                InitCommand=function(self)
                    self:y(0):zoomx(10):zoomy(4):diffuse(Alpha(color(RSColorTable["Fret 6"]),0))
                end,
                Texture="sprites/partstrum.png",
                FeverMessageCommand=function(self,params)
                    if params.pn ~= sPlayer then return end
                    if params.Active then
                        self:stoptweening():diffusealpha(1):linear(.5):y(-900):diffusealpha(0):zoomy(24)
                    else
                        self:stoptweening():diffusealpha(0):y(0):zoomx(10):zoomy(4)
                    end
                end,
            }
        },
        Def.ActorFrame{ --Meters
            OnCommand=function(self) self:rotationx(90) end,
            Def.ActorFrame {
                OnCommand=function(self) self:rotationx(-90):z(-5):y(48):spin():effectmagnitude(0,0,-25) end,
                Def.Sprite {
                    Texture='sprites/comboshine.png',
                    InitCommand=function(self)
                        self:zoom(.25):z(-1):blend('BlendMode_Add')
                        self.maxCombo = false
                        self.lastProcessed = 0
                        self.alreadymissed = false
                    end,
                    ComboChangedMessageCommand=function(self,params)
                        if params.Player ~= sPlayer then return end
                        local curCombo = params.PlayerStageStats:GetCurrentCombo()
                        local misCombo = params.PlayerStageStats:GetCurrentMissCombo()
                        if curCombo == self.lastProcessed then return end
                        if curCombo > misCombo then
                            self.alreadymissed = false
                        end
                        self.lastProcessed = curCombo
                        if curCombo == 30 then
                            self:stoptweening():diffuse(.4,.8,1,1):zoom(1.5):linear(0.5):zoom(1.25):diffuse(.2,.4,1,1)
                            self.maxCombo = true
                        elseif curCombo ~= 0 and curCombo % 10 == 0 and not self.maxCombo then
                            self:stoptweening():diffuse(1,1,1,1):zoom(1):linear(0.5):zoom(.25):diffusealpha(0)
                        end
                        if misCombo > 0 and not self.alreadymissed then
                            self:stoptweening():diffuse(1,0,0,1):zoom(.8):linear(0.3):zoom(.25):diffusealpha(0)
                            self.maxCombo = false
                            self.alreadymissed = true
                        end
                    end,
                    FeverMessageCommand=function(self,params)
                        if params.pn ~= sPlayer then return end
                        feverActive = params.Active
                        if params.Active then
                            self:stoptweening():diffuse(1,1,1,1):zoom(1.5):linear(0.5):zoom(1.25):diffuse(color(RSColorTable["Fret 6"]))
                        else
                            if self.maxCombo then
                                self:stoptweening():zoom(1.25):diffuse(.2,.4,1,1)
                            else
                                self:stoptweening():diffuse(1,1,1,1):linear(0.5):zoom(.25):diffusealpha(0)
                            end
                        end
                    end,
                },
                Def.Sprite {
                    Texture='sprites/particle.png',
                    InitCommand=function(self)
                        self:zoom(2):z(-0.9):diffusealpha(0):blend('BlendMode_Add')
                        self.maxCombo = false
                        self.lastProcessed = 0
                        self.alreadymissed = false
                    end,
                    ComboChangedMessageCommand=function(self,params)
                        if params.Player ~= sPlayer then return end
                        local curCombo = params.PlayerStageStats:GetCurrentCombo()
                        local misCombo = params.PlayerStageStats:GetCurrentMissCombo()
                        if curCombo == self.lastProcessed then return end
                        if curCombo > misCombo then
                            self.alreadymissed = false
                        end
                        self.lastProcessed = curCombo
                        if curCombo == 30 then
                            self:stoptweening():diffuse(.5,.8,1,1)
                            self.maxCombo = true
                        elseif curCombo ~= 0 and curCombo % 10 == 0 and not self.maxCombo then
                            self:stoptweening():diffuse(1,1,1,1):linear(0.5):diffusealpha(0)
                        end
                        if misCombo > 0 and not self.alreadymissed then
                            self:stoptweening():diffuse(1,.2,.2,1):linear(0.3):diffusealpha(0)
                            self.maxCombo = false
                            self.alreadymissed = true
                        end
                    end,
                    FeverMessageCommand=function(self,params)
                        if params.pn ~= sPlayer then return end
                        feverActive = params.Active
                        if params.Active then
                            self:stoptweening():diffuse(1,1,1,1):linear(0.5)
                        else
                            if self.maxCombo then
                                self:stoptweening():diffuse(.5,.8,1,1)
                            else
                                self:stoptweening():diffuse(1,1,1,1):linear(0.5):diffusealpha(0)
                            end
                        end
                    end,
                }
            },
            Def.Model {
                Meshes="models/fevermeterbar.txt",
                Materials="models/materials/default mats.txt",
                Bones="models/fevermeterbar.txt"
            },
            Def.Model {
                Meshes="models/combometer.txt",
                Materials="models/materials/default mats.txt",
                Bones="models/combometer.txt"
            },
            Def.Model {
                Meshes="models/meterholder.txt",
                Materials="models/materials/default mats.txt",
                Bones="models/meterholder.txt"
            },
            Def.Model {
                InitCommand=function(self)
                    self.Amount=0
                    self.Active=false
                end,
                FeverMessageCommand=function(self,params)
                    if params.pn ~= sPlayer then return end
                    if params.Active then
                        self.Active = true
                        self:stoptweening():linear((self.Amount /125)*12.5):texturetranslate(0,0) --texturetranslate not tweenable? :(
                    else
                        self.Active = false
                        self.Amount = 0
                    end
                end,
                FeverScoreMessageCommand=function(self,params)
                    if params.pn ~= sPlayer then return end
                    self.Amount = params.Amount
                    if self.Active then
                        self:stoptweening():texturetranslate(0,(params.Amount / 244)):linear((params.Amount /125)*12.5):texturetranslate(0,0)
                    else
                        self:stoptweening():linear(.1):texturetranslate(0,(params.Amount / 244))
                    end
                end,
                Meshes="models/fevermetertube.txt",
                Materials="models/fevermetertube.txt",
                Bones="models/fevermetertube.txt"
            },
            Def.Model { --All this for some shininess
                InitCommand=function(self)
                    self:zoom(1.005):blend('BlendMode_Add'):y(-0.1)
                end,
                Meshes="models/fevermetertube.txt",
                Materials="models/materials/plasticshine mats.txt",
                Bones="models/fevermetertube.txt"
            },
            Def.Sprite{ --Because the texturetranslate can't tween
                Texture="models/materials/shine.png",
                InitCommand=function(self)
                    self:blend('BlendMode_Add'):xyz(-177.6,3,16):zoomx(0):zoomy(0.4):diffuse(color(RSColorTable["Fret 6"])):diffusealpha(0):rotationx(-25)
                    self.Amount = 0
                    self.Active = false
                end,
                FeverScoreMessageCommand=function(self,params)
                    if params.pn ~= sPlayer then return end
                    self.Amount = params.Amount
                    if self.Active then
                        self:stoptweening():diffusealpha(1):linear(.1):zoomx(params.Amount * 5.45 / 125):x((params.Amount * 174.4/125)-177.6):linear((params.Amount /125)*12.5):x(-177.6):zoomx(0)
                    elseif params.Amount >= 50 then
                        self:stoptweening():diffusealpha(1):linear(.2):diffusealpha(.3):zoomx(params.Amount * 5.45 / 125):x((params.Amount * 174.4/125)-177.6)
                    end
                end,
                FeverMessageCommand=function(self,params)
                    if params.pn ~= sPlayer then return end
                    if params.Active then
                        self.Active = true
                        self:stoptweening():diffusealpha(1):linear((self.Amount /125)*12.5):x(-177.6):zoomx(0)
                    else
                        self:diffusealpha(0)
                        self.Amount = 0
                        self.Active = false
                    end
                end,
            },
            Def.Sprite{ --Because shine.png isn't smooth on the end
                Texture="sprites/feversprite1",
                InitCommand=function(self)
                    self:blend('BlendMode_Add'):xyz(-174,3,16):zoom(0.25):diffuse(color(RSColorTable["Fret 6"])):diffusealpha(0):rotationx(-25)
                    self.Amount = 0
                    self.Active = false
                end,
                FeverScoreMessageCommand=function(self,params)
                    if params.pn ~= sPlayer then return end
                    self.Amount = params.Amount
                    if self.Active then
                        self:stoptweening():diffusealpha(1):linear(.1):x((params.Amount * 348.8/125) - 173.6):linear((self.Amount /125)*12.5):x(-173.6)
                    elseif params.Amount >= 50 then
                        self:stoptweening():diffusealpha(1):linear(.2):diffusealpha(.3):x((params.Amount * 348.8/125) - 173.6)
                    end
                end,
                FeverMessageCommand=function(self,params)
                    if params.pn ~= sPlayer then return end
                    if params.Active then
                        self.Active = true
                        self:stoptweening():diffusealpha(1):linear((self.Amount /125)*12.5):x(-173.6)
                    else
                        self:diffusealpha(0)
                        self.Active = false
                        self.Amount = 0
                    end
                end,
            },
            Def.ActorFrame { --Combometer
                OnCommand=function(self) self:rotationx(-85):xyz(0,24,18):zoom(.84) end,
                Def.Sprite {
                    InitCommand=function(self)
                        self:zoom(.87):y(-1)
                    end,
                    Texture='sprites/combometerbg.png'
                },
                Def.Sprite {
                    Texture='sprites/combometer 10x1.png',
                    InitCommand=function(self)
                        self:zoom(.87):xyz(0,-1,0.2):diffusealpha(0):animate(false):setstate(0)
                    end,
                    ComboChangedMessageCommand=function(self,params)
                        if params.Player ~= sPlayer then return end
                        local curCombo = params.PlayerStageStats:GetCurrentCombo()
                        
                        if curCombo <= 0 then
                            self:diffusealpha(0)
                        elseif curCombo <= 30 then
                            self:diffusealpha(1):setstate(curCombo % 10)
                        else
                            self:diffusealpha(1):setstate(0)
                        end
                    end
                },
                Def.Sprite {
                    Texture='sprites/comboring.png',
                    InitCommand=function(self)
                        self:z(0.4):zoom(0.5)
                    end
                },
                Def.Sprite {
                    Texture='sprites/comboring mask.png',
                    InitCommand=function(self)
                        self:z(0.5):y(0.5):zoom(0.505):MaskSource(true)
                    end
                },
                Def.Sprite {
                    Texture='sprites/fcshine 4x4.png',
                    InitCommand=function(self)
                        self:z(0.5):zoom(2.02):SetAllStateDelays(0.05):MaskDest()
                    end,
                    ComboChangedMessageCommand=function(self,params)
                        if params.Player ~= sPlayer then return end
                        local curCombo = params.PlayerStageStats:GetCurrentMissCombo()
                        if curCombo > 0 then
                            self:diffusealpha(0)
                        end
                    end
                },
                Def.BitmapText{
                    Text="",
                    Font="Common Normal",
                    OnCommand=function(self) self:zoom(2):z(0.4):diffuse(1,1,1,1) end,
                    ComboChangedMessageCommand=function(self,params)
                        if params.Player ~= sPlayer then return end
                        local curCombo = params.PlayerStageStats:GetCurrentCombo()
                        local percent = 1
                        if curCombo >= 30 then
                            percent = 4
                        elseif curCombo >= 20 then
                            percent = 3
                        elseif curCombo >= 10 then
                            percent = 2
                        end
                        if feverActive then
                            percent = percent*2
                        end
                        if percent > 1 then
                            self:settext(percent.."x")
                        else
                            self:settext("")
                        end
                    end
                }
            }
        },
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
                    self:x(157):diffuse(color(RSColorTable["Fret 5"]))
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
                    self:rotationy(180):x(-157):diffuse(color(RSColorTable["Fret 5"]))
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
            },
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
        self:rotationx(90):rotationz(angleChart[sButton]):z(offsetChart[sButton])
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
    Def.Model {
        InitCommand=function(self)
            self:diffuse(color(RSColorTable[sButton]))
            RBReceptor[sPlayer][sButton][3] = self
        end,
        PressCommand=function(self) self:glow(Alpha(color(RSColorTable[sButton]), 0.2)) end,
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
            self:diffuse(ColorDarkTone(color(RSColorTable[sButton]))):blend('BlendMode_Add'):rotationx(-90):z(3):zoom(1.6):diffusealpha(0)
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