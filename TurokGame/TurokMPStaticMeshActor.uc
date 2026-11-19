class TurokMPStaticMeshActor extends StaticMeshActor
    native
    hidecategories(Navigation)
    autoexpandcategories(Multiplayer);

var(Multiplayer) private noclear export editinline @NULL mGameModeRestriction;

defaultproperties
{
    // Reference: TurokMPGameModeRestriction'Default__TurokMPStaticMeshActor.GameModeRestriction0'
    begin object name=GameModeRestriction0 class=Class'TurokMPGameModeRestriction'
    end object
    mGameModeRestriction=GameModeRestriction0
    // Reference: StaticMeshComponent'Default__TurokMPStaticMeshActor.StaticMeshComponent0'
    begin object name=StaticMeshComponent0
        CastShadow=false
    end object
    StaticMeshComponent=StaticMeshComponent0
    bNoDelete=true
    bMovable=false
    Components[0]=StaticMeshComponent0
    CollisionComponent=StaticMeshComponent0
}