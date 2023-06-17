local sButton = Var "Button"
local sPlayer = Var "Player"
if not GHReceptor then GHReceptor = {} end
if not GHReceptor[sPlayer] then GHReceptor[sPlayer] = {} end
if not GHReceptor[sPlayer][sButton] then GHReceptor[sPlayer][sButton] = {} end

-- Here's a map for what GHReceptor is since it's gotten so convoluted
-- First is per player, then per button (Fret 1, Fret 2,... Fret 5)
-- [0] = Nothing. Lua lists start at 1 for some cursed reason
-- [1] = The entire assembled receptor for a column
-- [2] = Whether the fret is being pressed down or not
-- [3] = Idle inner receptor (colored part)
-- [4] = Idle inner receptor (non-colored part)
-- [5] = Active inner receptor (colored part)
-- [6] = Active inner receptor (non-colored part)
-- [7] = Metal column under the inner receptor

local Buttons = {
    "Fret 1",
    "Fret 2",
    "Fret 3",
    "Fret 4",
    "Fret 5"
}

local offsetChart =
{
    ["Fret 1"] = -20,
    ["Fret 2"] = -10,
    ["Fret 3"] = 0,
    ["Fret 4"] = 10,
    ["Fret 5"] = 20,
    ["Fret 6"] = 30,
    ["Strum Up"] = 0
}

local feverActive = false

local feverExplosion = Def.ActorFrame{}
local comboSquares = Def.ActorFrame{}

for i = 1,16 do
    feverExplosion[#feverExplosion+1] = Def.ActorFrame{
        InitCommand=function(self)
            self:diffusealpha(0):zoom(.8):rotationx(90):x((25*i) - 212)
            self.startPos = (25*i) - 212
            self.prevAmount = 0
            self.feverActive = false
        end,
        FeverScoreMessageCommand=function(self,params)
            if params.Amount > self.prevAmount and not self.feverActive then
                self:stoptweening():x(self.startPos):z(8):diffuse(color(FHQColorTable["Fever"])):decelerate(math.random(30,100) / 100):z(math.random(60,90)):x(self.startPos+math.random(-100,100)):rotationz(math.random(-179,179)):diffusealpha(0)
                self.prevAmount = params.Amount
            end
        end,
        FeverMessageCommand=function(self,params)
            if params.Active then
                self.prevAmount = 0
            end
            self.feverActive = params.Active
        end,
        Def.Sprite {
            Texture='sprites/partfever.png'
        }
    }
end

for i = 1,10 do
    comboSquares[#comboSquares+1] = Def.Quad{
        OnCommand=function(self)
            self:zoomto(8,10):rotationx(-90):diffuse(1,1,1,0):z((i-5.5)*18 + 4):y(-2)
            self.isOn = false
        end,
        ComboChangedMessageCommand=function(self,params)
            if params.Player ~= sPlayer then return end
            local curCombo = params.PlayerStageStats:GetCurrentCombo()
            if params.PlayerStageStats:GetCurrentMissCombo() > 0 then
                if feverActive == false then
                    self:diffuse(1,1,1,0)
                end
                self.isOn = false
            elseif curCombo <= 30 then
                if curCombo % 10 == i  or (i == 10 and curCombo % 10 == 0 and curCombo > 0) then
                    self.isOn = true
                elseif curCombo % 10 == 1 and (i ~= 1) then
                    self.isOn = false
                end
            end
            if feverActive == false then
                if curCombo >= 30 then
                    self:diffuse(.8,.1,1,1)
                elseif curCombo >= 20 then
                    self:diffuse(.1,.8,.1,1)
                elseif curCombo >= 10 then
                    self:diffuse(1,.8,.1,1)
                end
            else
                self:diffuse(color(FHQColorTable["Fever"]))
            end
            if self.isOn == true then
                self:diffusealpha(1)
            else
                self:diffusealpha(0)
            end
        end
    }
end

if sButton == "Strum Up" then
    return Def.ActorFrame{
        Def.ActorFrame{ --Fever meter take 2
            OnCommand=function(self) self:rotationx(90):x(173):y(-128) end,
            Def.Model{ --Base
                InitCommand=function(self) self:zoomz(0.75):zoomx(2):zoomy(2) end,
                Meshes="models/meter.txt",
                Materials="models/bomb.txt",
                Bones="models/meter.txt"
            },
            Def.Model{ --Filling
                OnCommand=function(self)
                    self:diffuse(color(FHQColorTable["Fever"])):zoomx(2.04):zoomy(2.04):zoomz(0)
                    self.Active = false
                    self.Amount = 0
                end,
                Meshes="models/meter.txt",
                Materials="models/materials/meter anim mats.txt",
                Bones="models/meter.txt",
                FeverMessageCommand=function(self,params)
                    if params.pn ~= sPlayer then return end
                    if params.Active then
                        feverActive = true
                        self.Active = true
                        self:stoptweening():linear((self.Amount /125)*12.5):z(96):zoomz(0)
                    else
                        feverActive = false
                        self.Active = false
                        self.Amount = 0
                    end
                end,
                FeverScoreMessageCommand=function(self,params)
                    if params.pn ~= sPlayer then return end
                    self.Amount = params.Amount
                    if self.Active then
                        self:stoptweening():z(96-(params.Amount * 96 / 125)):zoomz(params.Amount / 166.667):linear((params.Amount /125)*12.5):z(96):zoomz(0)
                    else
                        self:stoptweening():linear(.1):z(96-(params.Amount * 96 / 125)):zoomz(params.Amount / 166.667)
                    end
                end,
            },
            Def.Sprite{ --Charged indicator
                Texture="sprites/charged 4x1.png",
                InitCommand=function(self)
                    self:diffusealpha(0):rotationx(-90):zoomy(0):z(90):SetAllStateDelays(0.08):y(-2)
                    self.Active = false
                    self.Amount = 0
                end,
                FeverMessageCommand=function(self,params)
                    if params.pn ~= sPlayer then return end
                    if params.Active then
                        self.Active = true
                        self:stoptweening():linear((self.Amount /125)*12.5):z(90):zoomy(0)
                    else
                        self:diffusealpha(0)
                        self.Active = false
                        self.Amount = 0
                    end
                end,
                FeverScoreMessageCommand=function(self,params)
                    if params.pn ~= sPlayer then return end
                    self.Amount = params.Amount
                    if params.Amount >= 50 then
                        self:diffusealpha(1)
                    end
                    if self.Active then
                        self:stoptweening():z(90-(params.Amount * 90 / 125)):zoomy(params.Amount / 45):linear((params.Amount /125)*12.5):z(90):zoomy(0)
                    else
                        self:stoptweening():linear(.1):z(90-(params.Amount * 90 / 125)):zoomy(params.Amount / 45)
                    end
                end,
            },
            Def.Model{ --Top Cap
                OnCommand=function(self) self:zoomz(0.01):zoomx(2.1):zoomy(2.1):z(-96):diffuse(.4,.4,.4,1) end,
                Meshes="models/meter.txt",
                Materials="models/meter.txt",
                Bones="models/meter.txt"
            },
            Def.Model{ --Mid band
                OnCommand=function(self) self:zoomz(0.008):zoomx(2.1):zoomy(2.1):diffuse(.7,.7,.7,1):z(20) end,
                Meshes="models/meter.txt",
                Materials="models/bomb.txt",
                Bones="models/meter.txt"
            },
            Def.Sprite{--low cap Sprite
                Texture='sprites/feversprite1.png',
                InitCommand=function(self)
                    self:blend('BlendMode_Add'):zoomy(.4):zoomx(.25):rotationz(-90):rotationx(-90):z(90):diffuse(Alpha(color(FHQColorTable["Fever"]),0)):diffusealpha(0):y(-3)
                    self.Active = false
                    self.Amount = 0
                end,
                FeverMessageCommand=function(self,params)
                    if params.pn ~= sPlayer then return end
                    if params.Active then
                        self.Active = true
                        self:stoptweening():sleep((self.Amount /125)*12.5):diffusealpha(0)
                    else
                        self.Active = false
                        self.Amount = 0
                    end
                end,
                FeverScoreMessageCommand=function(self,params)
                    if params.pn ~= sPlayer then return end
                    self.Amount = params.Amount
                    if self.Active then
                        self:stoptweening():sleep((self.Amount /125)*12.5):diffusealpha(0)
                    else
                        if self.Amount > 1 then
                            self:stoptweening():diffusealpha(1)
                        else
                            self:diffusealpha(0)
                        end
                    end
                end,
            },
            Def.Sprite{--Top cap Sprite
                Texture='sprites/feversprite1.png',
                InitCommand=function(self)
                    self:blend('BlendMode_Add'):zoomy(.4):zoomx(.25):rotationz(90):rotationx(-90):diffuse(Alpha(color(FHQColorTable["Fever"]),0)):diffusealpha(0):z(90)
                    self.Active = false
                    self.Amount = 0
                end,
                FeverMessageCommand=function(self,params)
                    if params.pn ~= sPlayer then return end
                    if params.Active then
                        self.Active = true
                        self:stoptweening():linear((self.Amount /125)*12.5):z(90):sleep(0.01):diffusealpha(0)
                    else
                        self.Active = false
                        self.Amount = 0
                    end
                end,
                FeverScoreMessageCommand=function(self,params)
                    if params.pn ~= sPlayer then return end
                    self.Amount = params.Amount
                    if self.Active then
                        self:stoptweening():diffusealpha(1):z(90-(params.Amount * 193 / 125)):linear((self.Amount /125)*12.5):z(90):sleep(0.01):diffusealpha(0)
                    else
                        if self.Amount > 1 then
                            self:stoptweening():diffusealpha(1):linear(.1):z(90-(params.Amount * 193 / 125))
                        else
                            self:diffusealpha(0)
                        end
                    end
                end,
            },
            Def.Model{ --Bot Cap
                OnCommand=function(self) self:zoomz(0.01):zoomx(2.1):zoomy(2.1):z(96):diffuse(.4,.4,.4,1) end,
                Meshes="models/meter.txt",
                Materials="models/meter.txt",
                Bones="models/meter.txt"
            },
        },
        Def.ActorFrame{ --Multiplier meter take 2
            OnCommand=function(self) self:rotationx(90):y(-128):x(-173):rotationy(180) end,
            Def.Model{ --Base
                OnCommand=function(self) self:diffuse(.4,.4,.4,1):zoomx(2):zoomy(2):zoomz(0.75) end,
                Meshes="models/meter.txt",
                Materials="models/bomb.txt",
                Bones="models/meter.txt"
            },
            Def.Model{ --Top Cap
                OnCommand=function(self) self:zoomz(0.01):zoomx(2.1):zoomy(2.1):z(-96):diffuse(.4,.4,.4,1) end,
                Meshes="models/meter.txt",
                Materials="models/meter.txt",
                Bones="models/meter.txt"
            },
            Def.Model{ --Bot Cap
                OnCommand=function(self) self:zoomz(0.01):zoomx(2.1):zoomy(2.1):z(96):diffuse(.4,.4,.4,1) end,
                Meshes="models/meter.txt",
                Materials="models/meter.txt",
                Bones="models/meter.txt"
            },
            comboSquares,
            Def.ActorFrame{
                InitCommand=function(self) self:rotationy(-188):rotationx(-15):rotationz(5):x(24):z(152):zoom(0.8) end,
                Def.Sprite {
                    InitCommand=function(self)
                        self:zoom(.5)
                    end,
                    Texture='sprites/combometerbg.png'
                },
                Def.Sprite {
                    Texture='sprites/comboring mask.png',
                    InitCommand=function(self)
                        self:z(0.5):y(0.5):zoom(0.51):MaskSource(true)
                    end
                },
                Def.Sprite { --FC indicator
                    Texture='sprites/fcshine 4x4.png',
                    InitCommand=function(self)
                        self:z(0.5):y(0.5):zoom(2.02):SetAllStateDelays(0.05):MaskDest()
                    end,
                    ComboChangedMessageCommand=function(self,params)
                        if params.Player ~= sPlayer then return end
                        local curCombo = params.PlayerStageStats:GetCurrentMissCombo()
                        if curCombo > 0 then
                            self:diffusealpha(0)
                        end
                    end
                },
                Def.BitmapText{ --Meter Text
                    Text="",
                    Font="Common Normal",
                    OnCommand=function(self) self:zoom(2) end,
                    ComboChangedMessageCommand=function(self,params)
                        if params.Player ~= sPlayer then return end
                        local curCombo = params.PlayerStageStats:GetCurrentCombo()
                        local percent = 1
                        self:diffuse(1,1,1,1)
                        if curCombo >= 30 then
                            percent = 4
                            self:diffuse(.8,.1,1,1)
                        elseif curCombo >= 20 then
                            percent = 3
                            self:diffuse(.1,.8,.1,1)
                        elseif curCombo >= 10 then
                            percent = 2
                            self:diffuse(1,.8,.1,1)
                        end
                        if feverActive then
                            percent = percent*2
                            self:diffuse(color(FHQColorTable["Fever"]))
                        end
                        if percent > 1 then
                            self:settext("x"..percent)
                        else
                            self:settext("")
                        end
                    end,
                    FeverMessageCommand=function(self,params)
                        if params.Player ~= sPlayer then return end
                        local curCombo = params.PlayerStageStats:GetCurrentCombo()
                        local percent = 1
                        self:diffuse(1,1,1,1)
                        if curCombo >= 30 then
                            percent = 4
                            self:diffuse(.8,.1,1,1)
                        elseif curCombo >= 20 then
                            percent = 3
                            self:diffuse(.1,.8,.1,1)
                        elseif curCombo >= 10 then
                            percent = 2
                            self:diffuse(1,.8,.1,1)
                        end
                        if params.Active then
                            percent = percent * 2
                            self:diffuse(color(FHQColorTable["Fever"]))
                        end
                        if percent > 1 then
                            self:settext("x"..percent)
                        else
                            self:settext("")
                        end
                    end
                },
            },
        },
        PressCommand=function(self) --Function to make the receptors bop? why here?
            local FretActive = false
            for _,v in ipairs(Buttons) do
                if GHReceptor[sPlayer][v][2] then
                    FretActive = true
                end
            end
            if not FretActive then
                for _,v in ipairs(Buttons) do
                    GHReceptor[sPlayer][v][3]:stoptweening():diffusealpha(1):z(6):sleep(.1):bounceend(.1):z(0):diffusealpha(1)
                    GHReceptor[sPlayer][v][4]:stoptweening():diffusealpha(1):z(6):sleep(.1):bounceend(.1):z(0):diffusealpha(1)
                    GHReceptor[sPlayer][v][5]:stoptweening():diffusealpha(0)
                    GHReceptor[sPlayer][v][6]:stoptweening():diffusealpha(0)
                    GHReceptor[sPlayer][v][7]:stoptweening():diffusealpha(0)
                end
            end
        end,
        Def.ActorFrame{ --Highway
            OnCommand=function(self) self:z(-8) end,
            Def.Quad{ --Highway edges
                InitCommand=function(self)
                    self:xy(-165,-200):zoomto(2,700):diffuse(1,1,1,1):diffusetopedge(1,1,1,0)
                end,
                FeverMessageCommand=function(self,params)
                    if params.pn ~= sPlayer then return end
                    if params.Active then
                        self:diffuse(color(FHQColorTable["Fever"])):diffusetopedge(Alpha(color(FHQColorTable["Fever"]),0))
                    else
                        self:diffuse(1,1,1,1):diffusetopedge(1,1,1,0)
                    end
                end,
            },
            Def.Quad{
                InitCommand=function(self)
                    self:xy(165,-200):zoomto(2,700):diffuse(1,1,1,1):diffusetopedge(1,1,1,0)
                end,
                FeverMessageCommand=function(self,params)
                    if params.pn ~= sPlayer then return end
                    if params.Active then
                        self:diffuse(color(FHQColorTable["Fever"])):diffusetopedge(Alpha(color(FHQColorTable["Fever"]),0))
                    else
                        self:diffuse(1,1,1,1):diffusetopedge(1,1,1,0)
                    end
                end,
            },
            Def.ActorFrame{ --Fever effects
                InitCommand=function(self)
                    self:y(-110):diffusealpha(0)
                end,
                Def.Sprite{
                    Texture="sprites/feversprite1.png",
                    InitCommand=function(self)
                        self:x(-102):diffuse(color(FHQColorTable["Fever"])):zoom(4)
                    end
                },
                Def.Sprite{
                    Texture="sprites/feversprite1.png",
                    InitCommand=function(self)
                        self:x(102):zoomx(-4):zoomy(4):diffuse(color(FHQColorTable["Fever"]))
                    end
                },
                FeverMessageCommand=function(self,params)
                    if params.pn ~= sPlayer then return end
                    if params.Active then
                        self:y(-70):diffusealpha(1):linear(0.5):y(-800):diffusealpha(0)
                    else
                        self:diffusealpha(0):y(-110)
                    end
                end,
            },
            Def.ActorFrame{ --More fever effects
                InitCommand=function(self)
                    self:y(-370):diffusealpha(0)
                end,
                Def.Quad{
                    InitCommand=function(self)
                        self:x(-150):zoomto(32,1100):diffuse(Alpha(color(FHQColorTable["Fever"]),0)):diffuselowerleft(color(FHQColorTable["Fever"]))
                    end
                },
                Def.Quad{
                    InitCommand=function(self)
                        self:x(150):zoomto(-32,1100):diffuse(Alpha(color(FHQColorTable["Fever"]),0)):diffuselowerleft(color(FHQColorTable["Fever"]))
                    end
                },
                FeverMessageCommand=function(self,params)
                    if params.pn ~= sPlayer then return end
                    if params.Active then
                        self:diffuseshift():diffusealpha(1):effectcolor1(1,1,1,1):effectcolor2(1,1,1,.5):effectperiod(1)
                    else
                        self:stopeffect():diffusealpha(0)
                    end
                end,
            }
        },
        feverExplosion
    }
end

local Push = Def.ActorFrame{
    Def.Model {
        InitCommand=function(self)
            self:rotationx(90):diffuse(color(FHQColorTable["192nd"]))
            GHReceptor[sPlayer][sButton][3] = self
        end,
        PressCommand=function(self) self:diffusealpha(0) end,
        LiftCommand=function(self) self:sleep(self:GetTweenTimeLeft()):diffusealpha(1) end,
        FeverMessageCommand=function(self,params)
            if params.pn ~= sPlayer then return end
            if params.Active then
                self:diffuse(color(FHQColorTable["Fever"]))
            else
                self:diffuse(color(FHQColorTable["192nd"]))
            end
            if GHReceptor[sPlayer][sButton][2] then
                self:diffusealpha(0)
            end
        end,
        Meshes="models/inner_receptor_idle color.txt",
        Materials="models/inner_receptor_idle color.txt",
        Bones="models/inner_receptor_idle color.txt"
    },
    Def.Model {
        InitCommand=function(self)
            self:rotationx(90):rotationy(136 + offsetChart[sButton]):diffusealpha(1)
            GHReceptor[sPlayer][sButton][4] = self
        end,
        PressCommand=function(self) self:diffusealpha(0) end,
        LiftCommand=function(self) self:sleep(self:GetTweenTimeLeft()):diffusealpha(1) end,
        Meshes="models/inner_receptor_idle.txt",
        Materials="models/inner_receptor_idle.txt",
        Bones="models/inner_receptor_idle.txt"
    },
    Def.Model {
        InitCommand=function(self)
            self:diffuse(color(FHQColorTable["192nd"])):diffusealpha(0):rotationx(90):rotationy(120 + offsetChart[sButton]):zoom(1.01)
            GHReceptor[sPlayer][sButton][5] = self
        end,
        PressCommand=function(self) self:diffusealpha(1):decelerate(.1):z(-3) end,
        LiftCommand=function(self) self:sleep(self:GetTweenTimeLeft()):diffusealpha(0):z(0) end,
        FeverMessageCommand=function(self,params)
            if params.pn ~= sPlayer then return end
            if params.Active then
                self:diffuse(color(FHQColorTable["Fever"]))
            else
                self:diffuse(color(FHQColorTable["192nd"]))
            end
            if not GHReceptor[sPlayer][sButton][2] then
                self:diffusealpha(0)
            end
        end,
        Meshes="models/inner_receptor_active color.txt",
        Materials="models/inner_receptor_active color.txt",
        Bones="models/inner_receptor_active color.txt"
    },
    Def.Model {
        InitCommand=function(self)
            self:diffusealpha(0):rotationx(90):rotationy(136 + offsetChart[sButton])
            GHReceptor[sPlayer][sButton][6] = self
        end,
        PressCommand=function(self) self:diffusealpha(1):decelerate(.1):z(-3) end,
        LiftCommand=function(self) self:sleep(self:GetTweenTimeLeft()):diffusealpha(0):z(0) end,
        Meshes="models/inner_receptor_active.txt",
        Materials="models/inner_receptor_active.txt",
        Bones="models/inner_receptor_active.txt"
    },
    Def.Model {
        InitCommand=function(self)
            self:diffusealpha(0):rotationx(90)
            GHReceptor[sPlayer][sButton][7] = self
        end,
        PressCommand=function(self) self:diffusealpha(1):zoomy(0.5):z(-3) end,
        LiftCommand=function(self) self:sleep(self:GetTweenTimeLeft()):diffusealpha(0):zoomy(1):z(0) end,
        Meshes="models/metal.txt",
        Materials="models/metal.txt",
        Bones="models/metal.txt"
    }
}

local hitCommand = function(self)
    GHReceptor[sPlayer][sButton][3]:stoptweening():diffusealpha(0):bounceend(.05):z(12):accelerate(.1):z(0)
    GHReceptor[sPlayer][sButton][4]:stoptweening():diffusealpha(0):bounceend(.05):z(12):accelerate(.1):z(0)
    GHReceptor[sPlayer][sButton][5]:stoptweening():diffusealpha(1):bounceend(.05):z(12):accelerate(.1):z(-3)
    GHReceptor[sPlayer][sButton][6]:stoptweening():diffusealpha(1):bounceend(.05):z(12):accelerate(.1):z(-3)
    GHReceptor[sPlayer][sButton][7]:stoptweening():diffusealpha(1):bounceend(.05):z(14):zoomy(3.5):accelerate(.1):z(-3):zoomy(.5)
end

return Def.ActorFrame {
    InitCommand=function(self)
        GHReceptor[sPlayer][sButton][1] = self
        GHReceptor[sPlayer][sButton][2] = false
    end,
    PressCommand=function(self)
        GHReceptor[sPlayer][sButton][2] = true
    end,
    LiftCommand=function(self)
        GHReceptor[sPlayer][sButton][2] = false
    end,
    W1Command=hitCommand,
    W2Command=hitCommand,
    W3Command=hitCommand,
    W4Command=hitCommand,
    W5Command=hitCommand,
    Def.Quad {
        InitCommand=function(self)
            self:xy(0,-180):zoomto(2,320):diffuse(1,1,1,1):diffusetopedge(1,1,1,0)
        end
    },
    Def.Model {
        InitCommand=function(self) self:rotationx(90):diffuse(color(FHQColorTable["192nd"])):zoom(0.99) end,
        Meshes="models/outer_receptor color.txt",
        Materials="models/outer_receptor color.txt",
        Bones="models/outer_receptor color.txt",
        FeverMessageCommand=function(self,params)
            if params.pn ~= sPlayer then return end
            if params.Active then
                self:diffuse(color(FHQColorTable["Fever"]))
            else
                self:diffuse(color(FHQColorTable["192nd"]))
            end
        end
    },
    Def.Model {
        InitCommand=function(self) self:rotationx(90):zoom(.99) end,
        Meshes="models/outer_receptor.txt",
        Materials="models/outer_receptor.txt",
        Bones="models/outer_receptor.txt",
    },
    Push
}