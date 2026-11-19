class TurokMPInterpActor extends InterpActor
    native
    hidecategories(Navigation)
    autoexpandcategories(Multiplayer);

var(Multiplayer) private noclear export editinline @NULL mGameModeRestriction;

defaultproperties
{
    // Reference: TurokMPGameModeRestriction'Default__TurokMPInterpActor.GameModeRestriction0'
    begin object name=GameModeRestriction0 class=Class'TurokMPGameModeRestriction'
    end object
    mGameModeRestriction=GameModeRestriction0
    // Reference: StaticMeshComponent'Default__TurokMPInterpActor.StaticMeshComponent0'
    begin object name=StaticMeshComponent0
        LightEnvironment=DynamicLightEnvironmentComponent'Default__TurokMPInterpActor.MyLightEnvironment'
    end object
    StaticMeshComponent=StaticMeshComponent0
    // Reference: DynamicLightEnvironmentComponent'Default__TurokMPInterpActor.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    Components[0]=MyLightEnvironment
    Components[1]=StaticMeshComponent0
    CollisionComponent=StaticMeshComponent0
}