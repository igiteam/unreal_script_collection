class TurokAssaultSpawnSwapper extends TurokMPNavPoint
    hidecategories(Navigation,Lighting,LightColor,Force)
    autoexpandcategories(Multiplayer);

enum eAssaultSwapModes
{
    eAssaultSwapMode_FlagSpawn,     // 0
    eAssaultSwapMode_TeamSpawn,     // 1
    eAssaultSwapMode_MAX            // 2
};

var(Multiplayer) private byte mSwapMode;

exec function SetSwapMode(int mode)
{
    // End:0x16
    if(mode == 1)
    {
        mSwapMode = 1;        
    }
    else
    {
        mSwapMode = 0;
    }
    //return;    
}

function byte GetSwapMode()
{
    return mSwapMode;
    //return ReturnValue;    
}

function PerformSpawnSwap()
{
    local @NULL SpawnTarget, assaultBase;

    // End:0x72
    if(int(mSwapMode) == int(1))
    {
        // End:0x40
        foreach WorldInfo.AllNavigationPoints(Class'TurokMPTeamSpawnTarget', SpawnTarget)
        {
            SpawnTarget.SwapTeams();            
        }        
        // End:0x71
        foreach WorldInfo.AllNavigationPoints(Class'TurokAssaultBase', assaultBase)
        {
            assaultBase.SwapTeams();            
        }        
    }
    //return;    
}

defaultproperties
{
    // Reference: CylinderComponent'Default__TurokAssaultSpawnSwapper.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__TurokAssaultSpawnSwapper.Sprite'
    begin object name=Sprite
        Sprite=Texture2D'EngineResources.Flag1'
    end object
    GoodSprite=Sprite
    // Reference: SpriteComponent'Default__TurokAssaultSpawnSwapper.Sprite2'
    begin object name=Sprite2
    end object
    BadSprite=Sprite2
    bHidden=true
    Components[0]=Sprite
    Components[1]=Sprite2
    // Reference: ArrowComponent'Default__TurokAssaultSpawnSwapper.Arrow'
    begin object name=Arrow
    end object
    Components[2]=Arrow
    Components[3]=CollisionCylinder
    // Reference: PathRenderingComponent'Default__TurokAssaultSpawnSwapper.PathRenderer'
    begin object name=PathRenderer
    end object
    Components[4]=PathRenderer
    CollisionComponent=CollisionCylinder
}