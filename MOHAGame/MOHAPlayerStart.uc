class MOHAPlayerStart extends PlayerStart
    native
    hidecategories(Navigation,Lighting,LightColor,Force,Collision,Collision);

// Export UMOHAPlayerStart::execAddKynapseSeedPoint(FFrame&, void* const)
native function AddKynapseSeedPoint();

function PreBeginPlay()
{
    super(Actor).PreBeginPlay();
    AddKynapseSeedPoint();
    //return;    
}

defaultproperties
{
    // Reference: CylinderComponent'Default__MOHAPlayerStart.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__MOHAPlayerStart.Sprite'
    begin object name=Sprite
    end object
    GoodSprite=Sprite
    // Reference: SpriteComponent'Default__MOHAPlayerStart.Sprite2'
    begin object name=Sprite2
    end object
    BadSprite=Sprite2
    Components[0]=Sprite
    Components[1]=Sprite2
    // Reference: ArrowComponent'Default__MOHAPlayerStart.Arrow'
    begin object name=Arrow
    end object
    Components[2]=Arrow
    Components[3]=CollisionCylinder
    // Reference: PathRenderingComponent'Default__MOHAPlayerStart.PathRenderer'
    begin object name=PathRenderer
    end object
    Components[4]=PathRenderer
    CollisionComponent=CollisionCylinder
}