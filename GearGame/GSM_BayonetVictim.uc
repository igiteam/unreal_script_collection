
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_BayonetVictim extends GSM_InteractionPawnFollower_Base
	dependson(GSM_BayonetAttack);

function InteractionStarted()
{
	Super.InteractionStarted();

	if (PawnOwner.Role == ROLE_Authority && PawnOwner.IsCarryingShield())
	{
		PawnOwner.DropShield();
	}

	if (PCOwner != None && PCOwner.IsLocalPlayerController())
	{
		PawnOwner.SetTimer(0.4f,FALSE,nameof(SpawnBlood),self);

		if (PawnOwner.MyGearWeapon != None && PawnOwner.MyGearWeapon.CanMartyr())
		{
			PCOwner.MyGearHUD.SetActionInfo(AT_SuicideBomb, PCOwner.ActionSuicideBomb);
		}
	}
	else if (GearAI_TDM(AIOwner) != None && GearWeap_GrenadeBase(PawnOwner.Weapon) != None && FRand() < AIOwner.GrenadeMartyrChance)
	{
		`AILog_Ext("- Grenade martyr", '', AIOwner);
		PawnOwner.SetTimer(0.75 + FRand(), false, nameof(DropGrenade), self);
	}
}

function DropGrenade()
{
	PawnOwner.MyGearWeapon.DoMartyrFire();
}

function SpawnBlood()
{
	PCOwner.ClientSpawnCameraLensEffect( class'Emit_CameraBlood_Bayonet' );
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	Super.SpecialMoveEnded(PrevMove, NextMove);

	// safety kill, if somehow GSM_ChainsawAttack fails to kill the owner
	if( PawnOwner.WorldInfo.NetMode != NM_Client && PawnOwner.IsGameplayRelevant() )
	{
		`warn("victim special move forcing Died(), this shouldn't happen");
		ScriptTrace();
		if( PawnOwner.Health > 0 && PawnOwner.bShouldChainsawAttackInstantKillMe && !PawnOwner.bUnlimitedHealth && !PawnOwner.InGodMode() )
		{
			if( Leader != None )
			{
				PawnOwner.Died(Leader.Controller, class'GDT_BayonetGib', PawnOwner.Location);
			}
			else
			{
				PawnOwner.Died(None, class'GDT_BayonetGib', PawnOwner.Location);
			}
		}
	}

	PawnOwner.ClearTimer(nameof(DropGrenade), self);
}

function bool ButtonPress(name ButtonName)
{
	if (ButtonName == 'R2' && GearWeap_GrenadeBase(PawnOwner.MyGearWeapon) != None)
	{
		PawnOwner.MyGearWeapon.DoMartyrFire();
		return true;
	}
	else
	{
		return false;
	}
}

defaultproperties
{
	bUseUnsynchedServerMove = TRUE
}
