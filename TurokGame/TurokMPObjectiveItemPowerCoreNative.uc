class TurokMPObjectiveItemPowerCoreNative extends TurokMPObjectiveItem
    abstract
    config(Game)
    hidecategories(Navigation);

var protected const class<Class> mPowerCorePickedUpMessage;

function AnnouncePickup(@NULL InstigatorPawn, optional class<Class> pickedUpFrom = none)
{
    super(Inventory).AnnouncePickup(InstigatorPawn);
    BroadcastLocalizedMessage(mPowerCorePickedUpMessage, int(InstigatorPawn.GetTeamNum()), InstigatorPawn.PlayerReplicationInfo, none, none);
    //return;    
}

defaultproperties
{
    DroppedPickupClass=Class'TurokDroppedPowerCorePickup'
    // Reference: SpriteComponent'Default__TurokMPObjectiveItemPowerCoreNative.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
}