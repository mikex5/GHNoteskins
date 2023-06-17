local sButton = Var "Button"

local Explosion = Def.ActorFrame{}
local Shards = Def.ActorFrame{}

local ExploCom = function(self)
    local flameHeight = math.random(30,80)
    local travel = math.random(180,260)
    local rot = math.random(-179,179)
    self:stoptweening():diffusealpha(1):z(6):y(0):zoomx(math.random(1,5)/20):zoomz(math.random(5,10)/16):linear(.15):z(flameHeight * 0.9):y(travel * 0.8):rotationy(rot * 0.5):decelerate(.15):z(flameHeight):y(travel):rotationy(rot):diffusealpha(0)
end

local ExploFlash = function(self)
    self:stoptweening():z(12):diffuse(1,1,1,1):zoomx(2.5):zoomy(1):linear(.1):z(24):diffusealpha(.4):zoomy(2.5):zoomx(.5):decelerate(.12):diffusealpha(0):zoomy(3):zoomx(.1):z(40)
end

local ExploRise = function(self)
    local flameHeight = math.random(40,60)
    self:stoptweening():diffusealpha(1):z(20):zoomz(0.5):zoomx(0.1):linear(.1):zoomx(0.05):diffusealpha(0.6):z(flameHeight * 0.9):decelerate(.12):zoomx(0.01):z(flameHeight):diffusealpha(0)
end

local Explostrum = function(self)
    self:stoptweening():z(6):diffusealpha(1):zoom(1.22):accelerate(0.1):zoomy(5):z(7):decelerate(0.12):zoomy(12):z(8):diffusealpha(0)
end

local ExploMine = function(self)
    self:stoptweening():diffuse(1,1,1,1):zoom(5):xyz(0,0,5):decelerate(0.2):diffuse(1,0,0,0):zoom(0.2):xyz(math.random(-100,100),0,math.random(0,100))
end

for i = 1,5 do
    Shards[#Shards+1] = Def.ActorFrame{
        InitCommand=function(self)
            self:diffuse(color(RSColorTable[sButton])):diffusealpha(0):blend('BlendMode_Add'):xy(math.random(-30,30), 12)
            if i > 4 then
                self:diffuse(1,1,1,0)
            end
        end,
        W1Command=ExploCom,
        W2Command=ExploCom,
        W3Command=ExploCom,
        W4Command=ExploCom,
        W5Command=ExploCom,
        HitMineCommand=ExploMine,
        Def.Sprite {
            InitCommand=function(self) self:rotationx(90) end,
            Texture='sprites/particle.png',
            Frames=Sprite.LinearFrames( 1, 1 ),
        }
    }
end

for i = 1,8 do
    Explosion[#Explosion+1] = Def.ActorFrame{
        InitCommand=function(self)
            self:diffuse(1,1,1,0):blend('BlendMode_Add'):xy(math.random(-24,24), 12)
        end,
        W1Command=ExploRise,
        W2Command=ExploRise,
        W3Command=ExploRise,
        W4Command=ExploRise,
        W5Command=ExploRise,
        HitMineCommand=ExploMine,
        Def.Sprite {
            InitCommand=function(self) self:rotationx(90) end,
            Texture='sprites/particle.png',
            Frames=Sprite.LinearFrames( 1, 1 ),
        }
    }
end

return Def.ActorFrame {
    Def.ActorFrame {
        Condition=(Var "Button" ~= "Strum Up"),
        Def.Sprite {
            Texture='sprites/particle.png',
            InitCommand=function(self)
                self:diffuse(1,1,1,0):xyz(0,0,5):rotationx(90)
            end,
            W1Command=ExploFlash,
            W2Command=ExploFlash,
            W3Command=ExploFlash,
            W4Command=ExploFlash,
            W5Command=ExploFlash,
            HitMineCommand=ExploFlash,
        },
        Explosion,
        Shards
    },
    Def.ActorFrame {
        Condition=(Var "Button" == "Strum Up"),
        Def.Sprite {
            Texture='NoteField bars 1x4.png', --serving double purpose :)
            InitCommand=function(self)
                self:animate(false):diffuse(Alpha(color(RSColorTable[sButton]),0)):rotationx(90):z(12):blend('BlendMode_Add')
            end,
            W1Command=Explostrum,
            W2Command=Explostrum,
            W3Command=Explostrum,
            W4Command=Explostrum,
            W5Command=Explostrum,
            HitMineCommand=ExploMine,
        },
        Def.Sprite {
            Texture='NoteField bars 1x4.png', --serving double purpose :)
            InitCommand=function(self)
                self:animate(false):setstate(1):diffuse(1,1,1,1):diffusealpha(0):rotationx(90):z(12):y(1):blend('BlendMode_Add')
            end,
            W1Command=Explostrum,
            W2Command=Explostrum,
            W3Command=Explostrum,
            W4Command=Explostrum,
            W5Command=Explostrum,
            HitMineCommand=ExploMine,
        }
    }
}