//
// OptionalObject is an Inventory
//
class ZombieGameMessage extends ZombieMessage;

static event string GetString(
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
//	if ( class<Actor>(OptionalObject) != None )
//		return class<Actor>(OptionalObject).static.GetLocalString(Switch, RelatedPRI_1, RelatedPRI_2);
	return "Test Game Msg: " $ Rand(100);
}


// Decompiled with UE Explorer.
defaultproperties
{
    TextSize=12.0000000
    UseBasePos=true
    bFadeMessage=true
    Lifetime=10
    XPos=50.0000000
    YPos=76.0000000
}