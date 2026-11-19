class TurokBombNative extends TurokMPObjectiveItem
    abstract
    native
    config(Game)
    hidecategories(Navigation);

var const export editinline @NULL mBombMesh;
var const class<Class> mBombDamageType;
var const @NULL mSetBombGraphSet;
var const @NULL mDefuseBombGraphSet;
var const @NULL mCountdownSoundCue;
var const @NULL mExplosionSoundCue;
var const @NULL mExplosionTemplate;
var protected const class<Class> mBombPlantedMessage;
var protected const class<Class> mBombDefusedMessage;

// Export UTurokBombNative::execGetTeamNum(FFrame&, void* const)
native simulated function byte GetTeamNum();

simulated event Destroyed()
{
    local @NULL dispenser;

    // End:0x5D
    if(int(Role) == int(ROLE_Authority))
    {
        dispenser = TurokMPPickupFactoryBombsNative(mMPPickupFactory);
        // End:0x5D
        if((dispenser != none) && !WorldInfo.Game.bGameEnded)
        {
            dispenser.AddBombToPool();
        }
    }
    super.Destroyed();
    //return;    
}

event Plant(@NULL tph)
{
    local @NULL dispenser;

    dispenser = TurokMPPickupFactoryBombsNative(mMPPickupFactory);
    // DebugMode: 0
    assert(dispenser != none);
    dispenser.SetTeamNum(tph.GetTeamNum());
    // End:0x8C
    if(TurokMPGame(WorldInfo.Game) != none)
    {
        TurokMPGame(WorldInfo.Game).ScoreObjectivePoints(tph.Controller, 2);
    }
    BroadcastLocalizedMessage(mBombPlantedMessage, int(tph.GetTeamNum()), tph.PlayerReplicationInfo);
    //return;    
}

event Defuse(@NULL tph)
{
    // End:0x4A
    if(TurokMPGame(WorldInfo.Game) != none)
    {
        TurokMPGame(WorldInfo.Game).ScoreObjectivePoints(tph.Controller, 3);
    }
    BroadcastLocalizedMessage(mBombDefusedMessage, int(tph.GetTeamNum()), tph.PlayerReplicationInfo);
    Destroy();
    //return;    
}

defaultproperties
{
    mBombDamageType=Class'TurokDamageTypeBomb'
    bDropOnDeath=false
    DroppedPickupClass=none
    // Reference: SpriteComponent'Default__TurokBombNative.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
}