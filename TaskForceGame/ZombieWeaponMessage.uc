//
//	OptionalObject is a Weapon Pickup
//	This is the message that tells you to press a button to switch weapons
//
class ZombieWeaponMessage extends ZombieMessage;



static event string GetString(
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
	if (ZombieUseTrigger(OptionalObject) != None )
	{
		return ZombieUseTrigger(OptionalObject).Message;
	}
	else if (SearchAbleActor(OptionalObject) != None)
	{
		If(Switch==0)
			return SearchAbleActor(OptionalObject).Message;
		Else If(Switch==1)
			
			return SearchAbleActor(OptionalObject).FinishMessage;
	}
	
	else if (SearchAbleActorInteraction(OptionalObject) != None)
	{
		return SearchAbleActorInteraction(OptionalObject).Message;
	}
	else if (ZombieDoorTrigger(OptionalObject) != None)
	{
		return ZombieDoorTrigger(OptionalObject).Message;
	}
	else if (ACTION_TutorialMessage(OptionalObject) != None )
	{
		return ACTION_TutorialMessage(OptionalObject).Message;
	}
	else if ( class<Actor>(OptionalObject) != None )
	{
		return class<Actor>(OptionalObject).static.GetLocalString(Switch, RelatedPRI_1, RelatedPRI_2);
	}

	//return "Press <action=use> to open door";
	return "Weapon message with invalid object: " $ OptionalObject;
}

static event string GetStringPC(
	PlayerController pc,
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{

	if (class<SFRMPickup>(OptionalObject) != None)
	{
		if (ZombiePlayerPawn(pc.Pawn) != none)
		{
			if (ZombiePlayerPawn(pc.Pawn).Weapons[3] != none)
			{
				return "<action=use>: swap " $ ZombiePlayerPawn(pc.Pawn).Weapons[3].ItemName $ " for " $ class<SFRMPickup>(OptionalObject).default.PickupName;	
			}
			else
			{
			//	return "<action=use>: pickup " $ class<SFRMPickup>(OptionalObject).default.PickupName;	
				return "Picked up "$class<SFRMPickup>(OptionalObject).default.PickupName;	
			}
		}
	}
	
	return GetString(Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
}

static function float GetZLifetime(int switch, Object optionalObject)
{
	if(ACTION_TutorialMessage(OptionalObject) != None)
	{
		return ACTION_TutorialMessage(OptionalObject).MessageTime;
	}
	
	//super.GetZLifetime(switch, optionalObject);*/

	if (SearchAbleActor(OptionalObject) != None)
	{
		If(Switch==0)
			return  0.2;

		else if(Switch==1)
			return 2.0;
	}
	else if (SearchAbleActorInteraction(OptionalObject) != None)
	{
		return 0.2;
	}
	return default.Lifetime;
}


// Decompiled with UE Explorer.
defaultproperties
{
    TextSize=18.0000000
    hJust=1
    bHasMarkup=true
    UseBasePos=true
    XPos=320.0000000
    YPos=136.0000000
}