class TurokMPPlayerStart extends PlayerStart
    native
    hidecategories(Navigation,Lighting,LightColor,Force,Collision)
    autoexpandcategories(Multiplayer);

var(Multiplayer) private const @NULL mSpawnTarget;

// Export UTurokMPPlayerStart::execGetTeamNum(FFrame&, void* const)
native simulated function byte GetTeamNum();

simulated function @NULL GetSpawnTarget()
{
    return mSpawnTarget;
    //return ReturnValue;    
}

simulated function OnToggle(@NULL Action)
{
    //return;    
}

defaultproperties
{
    bPrimaryStart=false
    bNoAutoConnect=true
    bDestinationOnly=true
    bSourceOnly=true
    // Reference: CylinderComponent'Default__TurokMPPlayerStart.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__TurokMPPlayerStart.Sprite'
    begin object name=Sprite
        Sprite=Texture2D'TurokEditorResources.TurokPlayerStart'
    end object
    GoodSprite=Sprite
    // Reference: SpriteComponent'Default__TurokMPPlayerStart.Sprite2'
    begin object name=Sprite2
    end object
    BadSprite=Sprite2
    Components[0]=Sprite
    Components[1]=Sprite2
    // Reference: ArrowComponent'Default__TurokMPPlayerStart.Arrow'
    begin object name=Arrow
    end object
    Components[2]=Arrow
    Components[3]=CollisionCylinder
    // Reference: PathRenderingComponent'Default__TurokMPPlayerStart.PathRenderer'
    begin object name=PathRenderer
    end object
    Components[4]=PathRenderer
    CollisionComponent=CollisionCylinder
}