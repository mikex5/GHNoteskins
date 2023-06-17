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

if sButton == "Strum Up" then
    return Def.ActorFrame{
        Def.Sprite{
            InitCommand=function(self) self:zoom(.5):x(-145) end,
            Texture="sprites/strum_bracket.png"
        },
        Def.Sprite{
            InitCommand=function(self) self:zoom(.5):x(145):rotationz(180) end,
            Texture="sprites/strum_bracket.png"
        },
        PressCommand=function(self) --Function to make the receptors bop
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
        end
    }
end

local Push = Def.ActorFrame{
    Def.Model {
        InitCommand=function(self)
            self:rotationx(90):diffuse(color(FHFColorTable[sButton]))
            GHReceptor[sPlayer][sButton][3] = self
        end,
        PressCommand=function(self) self:diffusealpha(0) end,
        LiftCommand=function(self) self:sleep(self:GetTweenTimeLeft()):diffusealpha(1) end,
        FeverMessageCommand=function(self,params)
            if params.pn ~= sPlayer then return end
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
            self:diffuse(color(FHFColorTable[sButton])):diffusealpha(0):rotationx(90):rotationy(120 + offsetChart[sButton]):zoom(1.01)
            GHReceptor[sPlayer][sButton][5] = self
        end,
        PressCommand=function(self) self:diffusealpha(1):decelerate(.1):z(-3) end,
        LiftCommand=function(self) self:sleep(self:GetTweenTimeLeft()):diffusealpha(0):z(0) end,
        FeverMessageCommand=function(self,params)
            if params.pn ~= sPlayer then return end
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
    Def.Sprite { --Secret sauce of this noteskin, the indicator rings
        Texture="sprites/indicator_ring.png",
        InitCommand=function(self)
            self:z(-1):zoom(.55):diffuse(Alpha(color(FHFColorTable["Fret 6"]),.5)):croptop(1)
            self.Amount=0
            self.feverActive = false
        end,
        FeverScoreMessageCommand=function(self,params)
            if params.pn ~= sPlayer then return end
            self.Amount = params.Amount;
            if not self.feverActive then
                if self.Amount < 50 then
                    self:stoptweening():diffuse(1,1,1,.5):linear(.2):diffuse(Alpha(color(FHFColorTable["Fret 6"]),.5)):croptop(1-(params.Amount /125))
                else
                    self:stoptweening():diffuse(1,1,1,1):linear(.2):diffuse(color(FHFColorTable["Fret 6"])):croptop(1-(params.Amount /125))
                end
            else
                self:stoptweening():diffusealpha(1):linear(.1):croptop(1-(params.Amount /125)):linear((self.Amount /125)*12.5):croptop(1)
            end
        end,
        FeverMessageCommand=function(self,params)
            if params.pn ~= sPlayer then return end
            self.feverActive = params.Active
            if params.Active then
                self:stoptweening():diffuse(1,1,1,1):croptop(0):linear(.1):croptop(1-(params.Amount /125)):diffuse(color(FHFColorTable["Fret 6"])):linear((self.Amount /125)*12.5):croptop(1)
            else
                self:stoptweening():diffusealpha(.3):croptop(1)
            end
        end,
    },
    Def.Sprite {
        Texture="sprites/indicator_ring.png",
        InitCommand=function(self)
            self:z(-1):zoom(.5):diffuse(1,1,1,1)
            self.countedMiss = false
        end,
        ComboChangedMessageCommand=function(self,params)
            if params.Player ~= sPlayer then return end
            local curCombo = params.PlayerStageStats:GetCurrentCombo()
            if params.PlayerStageStats:GetCurrentMissCombo() > 0  then
                if not self.countedMiss then
                    self:stoptweening():diffuse(1,0,0,1):linear(.1):diffuse(1,1,1,1)
                    self.countedMiss = true
                end
            else
                if curCombo >= 30 then
                    self:diffuse(.8,.1,1,1)
                elseif curCombo >= 20 then
                    self:diffuse(.1,.8,.1,1)
                elseif curCombo >= 10 then
                    self:diffuse(1,.8,.1,1)
                else
                    self:diffuse(1,1,1,1)
                end
                self.countedMiss = false
            end
        end,
    },
    Def.Quad {
        InitCommand=function(self)
            self:xy(0,-180):zoomto(2,320):diffuse(1,1,1,1):diffusetopedge(1,1,1,0)
        end
    },
    Def.Model {
        InitCommand=function(self) self:rotationx(90):diffuse(color(FHFColorTable[sButton])):zoom(0.99) end,
        Meshes="models/outer_receptor color.txt",
        Materials="models/outer_receptor color.txt",
        Bones="models/outer_receptor color.txt",
    },
    Def.Model {
        InitCommand=function(self) self:rotationx(90):zoom(.99) end,
        Meshes="models/outer_receptor.txt",
        Materials="models/outer_receptor.txt",
        Bones="models/outer_receptor.txt",
    },
    Push
}