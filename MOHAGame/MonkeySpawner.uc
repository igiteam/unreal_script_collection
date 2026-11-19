class MonkeySpawner extends Actor
    notplaceable
    hidecategories(Navigation);

var class<MOHAAIPawn> SpawnClass;
var export editinline SpriteComponent Sprite;
var string TeamName;
var float PulseScaleMax;
var float PulseScaleMin;
var float PulseScaleRate;

function SpawnMyGuy()
{
    __NFUN_278__(SpawnClass, self);
    GotoState('Pulse',, true);
    //return;    
}

state Pulse
{
    event BeginState(name prev)
    {
        Sprite.SetScale(PulseScaleMax);
        //return;        
    }

    event Tick(float dt)
    {
        Sprite.SetScale(Sprite.Scale - (PulseScaleRate * dt));
        // End:0x6D
        if(Sprite.Scale < PulseScaleMin)
        {
            Sprite.SetScale(PulseScaleMin);
            GotoState('None');
        }
        //return;        
    }
    stop;    
}

defaultproperties
{
    SpawnClass=Class'MOHAAIPawn'
    // Reference: SpriteComponent'Default__MonkeySpawner.Sprite'
    begin object name=Sprite class=Class'Engine.SpriteComponent'
        Sprite=Texture2D'EditorMonkeySpawner.nazimonkey'
        AlwaysLoadOnClient=false
        AlwaysLoadOnServer=false
        Scale=0.1000000
    end object
    Sprite=Sprite
    TeamName="Axis"
    PulseScaleMax=0.7500000
    PulseScaleMin=0.1000000
    PulseScaleRate=3.0000000
    Components[0]=Sprite
    // Reference: CylinderComponent'Default__MonkeySpawner.CollisionCylinder'
    begin object name=CollisionCylinder class=Class'Engine.CylinderComponent'
        CollisionHeight=96.0000000
        CollisionRadius=0.0000000
    end object
    Components[1]=CollisionCylinder
    Physics=2
    RemoteRole=1
    bGameRelevant=true
    bCollideActors=true
    bCollideWorld=true
    CollisionComponent=CollisionCylinder
    CollisionType=0
}