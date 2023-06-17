local sButton = Var "Button"

local Explosion = Def.ActorFrame{}

local ExploCom = function(self)
    if string.find(sButton, "Strum") then
        self:stoptweening():z(5):diffuse(FHQstrumcolor):zoom(1):linear(.1):z(50):zoom(.5):decelerate(.04):z(70):diffusealpha(0):zoom(.3)
    else
        local flameHeight = math.random(22,80)
        self:stoptweening():z(20):diffuse(1,.9,.6,.4):zoomx(1):zoomz(2):linear(.08):z(flameHeight * 0.95):diffuse(1,.7,.2,.3):zoomx(.5):zoomz(1):decelerate(.06):z(flameHeight):diffuse(.5,.1,0,0):zoomx(.2):zoomz(0.8)
    end
end

local ExploFlash = function(self)
    if string.find(sButton, "Strum") then
        self:stoptweening():diffuse(FHQstrumcolor):zoomy(2):zoomx(10):linear(.1):diffusealpha(.7):zoomy(2.5):zoomx(13):decelerate(.04):diffusealpha(0):zoomy(3):zoomx(15)
    else
        self:stoptweening():diffuse(1,1,1,.5):zoom(2.5):linear(.08):diffuse(1,.5,0,.4):zoom(3.2):decelerate(.06):diffuse(.5,.1,0,0):zoom(4)
    end
end

local ExploMine = function(self)
    self:stoptweening():diffuse(1,1,1,1):zoom(5):xyz(0,0,5):decelerate(0.2):diffuse(1,0,0,0):zoom(0.2):xyz(math.random(-100,100),0,math.random(0,100))
end

for i = 1,12 do
    Explosion[#Explosion+1] = Def.ActorFrame{
        InitCommand=function(self)
            self:diffusealpha(0):blend('BlendMode_Add')
            if string.find(sButton, "Strum") then
                self:xy((25*i) - 175, 15)
            else
                self:xy((3*i) - 19.5, 15)
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
            Texture=string.find(sButton, "Strum") and 'sprites/partstrum.png' or 'sprites/particle.png',
            Frames=Sprite.LinearFrames( 1, 1 ),
        }
    }
end

return Def.ActorFrame {
    Def.Sprite {
        Texture='sprites/particle.png',
        InitCommand=function(self)
            self:diffuse(1,1,1,0):xyz(0,0,5)
        end,
        W1Command=ExploFlash,
        W2Command=ExploFlash,
        W3Command=ExploFlash,
        W4Command=ExploFlash,
        W5Command=ExploFlash,
        HitMineCommand=ExploFlash,
    },
    Explosion
}