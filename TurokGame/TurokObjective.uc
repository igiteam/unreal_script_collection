class TurokObjective extends Objective
    native
    hidecategories(Navigation,Lighting,LightColor,Force);

var bool bFirstObjective;
var @NULL NextObjective;
var() float Value;

simulated function PostBeginPlay()
{
    local @NULL O, CurrentObjective;

    super(Actor).PostBeginPlay();
    // End:0x67
    if(bFirstObjective)
    {
        CurrentObjective = self;
        // End:0x66
        foreach AllActors(Class'TurokObjective', O)
        {
            // End:0x65
            if(O != CurrentObjective)
            {
                CurrentObjective.NextObjective = O;
                O.bFirstObjective = false;
                CurrentObjective = O;
            }            
        }        
    }
    //return;    
}

defaultproperties
{
    bFirstObjective=true
    Value=1.0000000
    // Reference: CylinderComponent'Default__TurokObjective.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__TurokObjective.Sprite'
    begin object name=Sprite
        Sprite=Texture2D'EngineResources.Flag1'
    end object
    GoodSprite=Sprite
    // Reference: SpriteComponent'Default__TurokObjective.Sprite2'
    begin object name=Sprite2
    end object
    BadSprite=Sprite2
    Components[0]=Sprite
    Components[1]=Sprite2
    // Reference: ArrowComponent'Default__TurokObjective.Arrow'
    begin object name=Arrow
    end object
    Components[2]=Arrow
    Components[3]=CollisionCylinder
    // Reference: PathRenderingComponent'Default__TurokObjective.PathRenderer'
    begin object name=PathRenderer
    end object
    Components[4]=PathRenderer
    CollisionComponent=CollisionCylinder
}