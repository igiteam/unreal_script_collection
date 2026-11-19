/**
 *
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */
/** this is used to handle auto objective announcements (what the game thinks the player should do next) */
class TMObjectiveAnnouncement extends TMObjectiveSpecificMessage
	dependson(TMPlayerController);

static function ObjectiveAnnouncementInfo GetObjectiveAnnouncement(byte MessageIndex, Object Objective, PlayerController PC)
{
	local TMGameObjective GameObj;
	local TMCarriedObject Flag;
	local ObjectiveAnnouncementInfo EmptyAnnouncement;
	local TMPickupFactory Pickup;
	local TMVehicle Vehicle;

	GameObj = TMGameObjective(Objective);
	if (GameObj != None)
	{
		return GameObj.WorldInfo.GRI.OnSameTeam(GameObj, PC) ? GameObj.DefendAnnouncement : GameObj.AttackAnnouncement;
	}
	else
	{
		Flag = TMCarriedObject(Objective);
		if (Flag != None )
		{
			if ( Flag.Team != None && Flag.Team.TeamIndex < Flag.NeedToPickUpAnnouncements.length)
			{
				return Flag.NeedToPickUpAnnouncements[Flag.Team.TeamIndex];
			}
		}
		else
		{
			Pickup = TMPickupFactory(Objective);
			if ( Pickup != None )
			{
				if ( class<TMWeapon>(Pickup.InventoryType) != None )
				{
					return class<TMWeapon>(Pickup.InventoryType).Default.NeedToPickupAnnouncement;
				}
			}
			else
			{
				Vehicle = TMVehicle(Objective);
				if ( Vehicle != None )
				{
					return Vehicle.NeedToPickupAnnouncement;
				}
			}
		}
	}

	return EmptyAnnouncement;
}

static function bool ShouldBeRemoved(TMQueuedAnnouncement MyAnnouncement, class<TMLocalMessage> NewAnnouncementClass, int NewMessageIndex)
{
	// don't ever allow two objective messages to be in the queue simultaneously
	return (default.Class == NewAnnouncementClass);
}

static simulated function SetHUDDisplay( PlayerController P, int Switch, string Text, PlayerReplicationInfo RelatedPRI_1,
					PlayerReplicationInfo RelatedPRI_2, Object OptionalObject )
{
	if (TMHUD(P.myHUD) != None)
	{
		TMHUD(P.myHUD).SetDisplayedOrders(Text);
	}
}

