class TurokCTFBase extends TurokMPTeamFlagBase
    abstract
    native
    hidecategories(Navigation,Lighting,LightColor,Force)
    autoexpandcategories(Multiplayer);

simulated event SetInitialState()
{
    local @NULL Game;

    // End:0x6A
    if(int(Role) == int(ROLE_Authority))
    {
        Game = TurokCTFGame(WorldInfo.Game);
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

defaultproperties
{
    // Reference: StaticMeshComponent'Default__TurokCTFBase.BaseMesh'
    begin object name=BaseMesh
    end object
    mBaseMeshComponent=BaseMesh
    // Reference: TurokMPGameModeRestriction'Default__TurokCTFBase.GameModeRestriction0'
    begin object name=GameModeRestriction0
    end object
    mGameModeRestriction=GameModeRestriction0
    // Reference: DynamicLightEnvironmentComponent'Default__TurokCTFBase.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: CylinderComponent'Default__TurokCTFBase.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__TurokCTFBase.Sprite'
    begin object name=Sprite
    end object
    GoodSprite=Sprite
    // Reference: SpriteComponent'Default__TurokCTFBase.Sprite2'
    begin object name=Sprite2
    end object
    BadSprite=Sprite2
    Components[0]=Sprite2
    // Reference: ArrowComponent'Default__TurokCTFBase.Arrow'
    begin object name=Arrow
    end object
    Components[1]=Arrow
    Components[2]=CollisionCylinder
    // Reference: PathRenderingComponent'Default__TurokCTFBase.PathRenderer'
    begin object name=PathRenderer
    end object
    Components[3]=PathRenderer
    Components[4]=MyLightEnvironment
    Components[5]=BaseMesh
    CollisionComponent=CollisionCylinder
}