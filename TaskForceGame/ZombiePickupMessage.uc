//
// OptionalObject is an Inventory
//
class ZombiePickupMessage extends ZombieMessage;

static event string GetString(
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
	if (SearchAbleActor(OptionalObject) != None)
	{
		If(Switch==0)
			return SearchAbleActor(OptionalObject).Message;
		Else If(Switch==1)
			return SearchAbleActor(OptionalObject).FinishMessage;
	}
	
	else if (SearchAbleActorInteraction(OptionalObject) != None)
	{
		if(Switch==0)
		return SearchAbleActorInteraction(OptionalObject).Message;

		Else If(Switch==1)
			return SearchAbleActorInteraction(OptionalObject).NoAmmoFoundMsg;

	}

	
    
	else if ( class<Actor>(OptionalObject) != None )
	{
		return class<Actor>(OptionalObject).static.GetLocalString(Switch, RelatedPRI_1, RelatedPRI_2);
	}
	//else if ( class<SFRMWeaponMode>(OptionalObject) != None )
	//{
	//	return class<SFRMWeaponMode>(OptionalObject).static.GetLocalString(Switch, RelatedPRI_1, RelatedPRI_2);
	//}

	return "";

//	return "Test Msg: " $ Rand(1000);
}


// Decompiled with UE Explorer.
defaultproperties
{
    TextSize=12.0000000
    Kern=1.0000000
    bHasMarkup=true
    bFadeMessage=true
    Lifetime=10
    DrawColor=(R=0,G=91,B=143,A=255)
    XPos=48.0000000
    YPos=36.0000000
}