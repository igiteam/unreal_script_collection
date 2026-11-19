class TurokMPTeamSpawnTarget extends TurokMPSpawnTarget
    native
    nativereplication
    hidecategories(Navigation,Lighting,LightColor,Force)
    autoexpandcategories(Multiplayer);

enum SpawnTargetType
{
    SPAWNTARGETTYPE_Defensive,      // 0
    SPAWNTARGETTYPE_Offensive,      // 1
    SPAWNTARGETTYPE_Capture,        // 2
    SPAWNTARGETTYPE_Coop,           // 3
    SPAWNTARGETTYPE_MAX             // 4
};

var(Multiplayer) private noclear export editinline @NULL mGameModeRestriction;
var(Multiplayer) private int mTeamIndex;
var private int mInitialTeamIndex;

// Export UTurokMPTeamSpawnTarget::execGetTeamNum(FFrame&, void* const)
native simulated function byte GetTeamNum();

simulated event PostBeginPlay()
{
    super(Actor).PostBeginPlay();
    mInitialTeamIndex = mTeamIndex;
    //return;    
}

event PostSaveGameRestore()
{
    SetInitialState();
    //return;    
}

function Reset()
{
    mTeamIndex = mInitialTeamIndex;
    super(Actor).Reset();
    //return;    
}

function SwapTeams()
{
    // End:0x1C
    if(mTeamIndex == 0)
    {
        mTeamIndex = 1;
        mInitialTeamIndex = 1;        
    }
    else
    {
        // End:0x35
        if(mTeamIndex == 1)
        {
            mTeamIndex = 0;
            mInitialTeamIndex = 0;
        }
    }
    //return;    
}

function OnSetActiveSpawnTarget(@NULL Action)
{
    // End:0x5D
    if(TurokCoopGame(WorldInfo.Game) != none)
    {
        TurokTeamInfo(WorldInfo.Game.GameReplicationInfo.Teams[int(GetTeamNum())]).SetSpawnTarget(self);        
    }
    //return;    
}

defaultproperties
{
    // Reference: TurokMPGameModeRestriction'Default__TurokMPTeamSpawnTarget.GameModeRestriction0'
    begin object name=GameModeRestriction0 class=Class'TurokMPGameModeRestriction'
    end object
    mGameModeRestriction=GameModeRestriction0
    // Reference: CylinderComponent'Default__TurokMPTeamSpawnTarget.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__TurokMPTeamSpawnTarget.Sprite'
    begin object name=Sprite
    end object
    GoodSprite=Sprite
    // Reference: SpriteComponent'Default__TurokMPTeamSpawnTarget.Sprite2'
    begin object name=Sprite2
    end object
    BadSprite=Sprite2
    bAlwaysRelevant=true
    Components[0]=Sprite
    Components[1]=Sprite2
    // Reference: ArrowComponent'Default__TurokMPTeamSpawnTarget.Arrow'
    begin object name=Arrow
    end object
    Components[2]=Arrow
    Components[3]=CollisionCylinder
    // Reference: PathRenderingComponent'Default__TurokMPTeamSpawnTarget.PathRenderer'
    begin object name=PathRenderer
    end object
    Components[4]=PathRenderer
    CollisionComponent=CollisionCylinder
}