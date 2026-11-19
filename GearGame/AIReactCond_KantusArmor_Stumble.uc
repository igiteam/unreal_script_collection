/**
 * Kantus Armor should stumble when hit with explosives
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class AIReactCond_KantusArmor_Stumble extends AIReactCond_Stumble
	within GearAI_KantusArmor;

/**
 * Stumble when hit with explosives
 * 
 * @param EventInstigator - the Actor that caused the damage
 * 
 * @param OriginatingChannel - the damage channel
 */
event bool ShouldActivate(Actor EventInstigator, AIReactChannel OriginatingChannel)
{
	local AIReactChan_Damage DmgChan;
	local GearPawn_LocustKantusBase Kantus;
	
	DmgChan = AIReactChan_Damage(OriginatingChannel);
	
	ActionToPush = SM_None;

	if (MyGearPawn == none || MyGearPawn.IsInCover())
	{
		return FALSE;
	}

	Kantus = GearPawn_LocustKantusBase(MyGearPawn);
	if( Kantus != None && `TimeSince(Kantus.LastStumbleTime) < Kantus.MinTimeBetweenKnockDownScreams )
	{
		return FALSE;
	}   

	if( MyGearPawn.IsDoingASpecialMove() && !MyGearPawn.SpecialMoves[MyGearPawn.SpecialMove].CanOverrideMoveWith(SM_StumbleGoDown) )
	{
		return FALSE;
	}

	if( ClassIsChildOf(DmgChan.damageType, class'GDT_Explosive') || ClassIsChildOf(DmgChan.damageType, class'GDT_Fire') || ClassIsChildOf(DmgChan.damageType, class'GDT_IncendiaryGrenade') )
	{
		if( DmgChan.DamageInstigator != None )
		{
			if( Kantus != None )
			{
				Kantus.LastStumbleTime = WorldInfo.TimeSeconds;
				Kantus.KnockDownInstigator = DmgChan.DamageInstigator;
			}
			Focus = DmgChan.DamageInstigator;
			SetEnemy(DmgChan.DamageInstigator); // Set as enemy, so he will face him when doing the scream.
			ActionToPush = SM_StumbleGoDown;
		}
	}

	if (ActionToPush != SM_None)
	{
		return TRUE;
	}

	return FALSE;
}

defaultproperties
{
	bAlwaysNotify=TRUE
}