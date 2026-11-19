class TurokAssaultBase extends TurokMPTeamFlagBase
    abstract
    native
    hidecategories(Navigation,Lighting,LightColor,Force)
    autoexpandcategories(Multiplayer);

var protected const @NULL mFlagTranslationForTeam0;
var protected const @NULL mFlagTranslationForTeam1;
var protected const @NULL mFlagRotationForTeam0;
var protected const @NULL mFlagRotationForTeam1;

simulated event SetInitialState()
{
    local @NULL Game;

    // End:0x6A
    if(int(Role) == int(ROLE_Authority))
    {
        Game = TurokAssaultGame(WorldInfo.Game);
        // End:0x6A
        if(Game != none)
        {
            // End:0x4F
            if(mTeamIndex == 0)
            {
                Game.SetFlagBaseTeam0(self);
            }
            // End:0x6A
            if(mTeamIndex == 1)
            {
                Game.SetFlagBaseTeam1(self);
            }
        }
    }
    super.SetInitialState();
    //return;    
}

protected simulated function class<Class> GetFlagType(byte TeamIndex)
{
    local @NULL AG;

    AG = TurokAssaultGame(WorldInfo.Game);
    // End:0x3C
    if(int(AG.GetDefendingTeam()) != int(TeamIndex))
    {
        return none;
    }
    return super.GetFlagType(TeamIndex);
    //return ReturnValue;    
}

protected simulated function ManageFlagTranslationRotation(class<Class> InFlagClass)
{
    local byte TeamIndex;

    TeamIndex = InFlagClass.default.mTeamIndex;
    // End:0x3A
    if(int(TeamIndex) == 0)
    {
        mFlagTranslation = mFlagTranslationForTeam0;
        mFlagRotation = mFlagRotationForTeam0;        
    }
    else
    {
        mFlagTranslation = mFlagTranslationForTeam1;
        mFlagRotation = mFlagRotationForTeam1;
    }
    //return;    
}

function SwapTeams()
{
    mTeamIndex = ((mTeamIndex == 0) ? 1 : 0);
    //return;    
}

defaultproperties
{
    // Reference: StaticMeshComponent'Default__TurokAssaultBase.BaseMesh'
    begin object name=BaseMesh
    end object
    mBaseMeshComponent=BaseMesh
    // Reference: TurokMPGameModeRestriction'Default__TurokAssaultBase.GameModeRestriction0'
    begin object name=GameModeRestriction0
    end object
    mGameModeRestriction=GameModeRestriction0
    // Reference: DynamicLightEnvironmentComponent'Default__TurokAssaultBase.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: CylinderComponent'Default__TurokAssaultBase.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__TurokAssaultBase.Sprite'
    begin object name=Sprite
    end object
    GoodSprite=Sprite
    // Reference: SpriteComponent'Default__TurokAssaultBase.Sprite2'
    begin object name=Sprite2
    end object
    BadSprite=Sprite2
    Components[0]=Sprite2
    // Reference: ArrowComponent'Default__TurokAssaultBase.Arrow'
    begin object name=Arrow
    end object
    Components[1]=Arrow
    Components[2]=CollisionCylinder
    // Reference: PathRenderingComponent'Default__TurokAssaultBase.PathRenderer'
    begin object name=PathRenderer
    end object
    Components[3]=PathRenderer
    Components[4]=MyLightEnvironment
    Components[5]=BaseMesh
    CollisionComponent=CollisionCylinder
}