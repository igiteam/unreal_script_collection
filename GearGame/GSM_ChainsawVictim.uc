
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_ChainsawVictim extends GSM_InteractionPawnFollower_Base
	dependson(GSM_ChainsawAttack);

function InteractionStarted()
{
	Super.InteractionStarted();

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
	if (PCOwner != None)
	{
		PawnOwner.GearPawnFX.SpawnChainsawCameraBlood(PCOwner);
	}
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	Super.SpecialMoveEnded(PrevMove, NextMove);

	// If we're in god mode or have unlimited health, we're not going to die, so keep inventory.
	if( PawnOwner.bShouldChainsawAttackInstantKillMe && !PawnOwner.bUnlimitedHealth && !PawnOwner.InGodMode() )
	{
		if (PawnOwner.Weapon != None)
		{
			PawnOwner.TossInventory(PawnOwner.Weapon);
		}

		// safety kill, if somehow GSM_ChainsawAttack fails to kill the owner
		if( PawnOwner.WorldInfo.NetMode != NM_Client && PawnOwner.IsGameplayRelevant() )
		{
			`warn("victim special move forcing Died(), this shouldn't happen");
			ScriptTrace();
			if( Leader != None )
			{
				PawnOwner.Died(Leader.Controller, class'GDT_Chainsaw', PawnOwner.Location);
			}
			else
			{
				PawnOwner.Died(None, class'GDT_Chainsaw', PawnOwner.Location);
			}
		}
	}

	PawnOwner.ClearTimer(nameof(DropGrenade), self);
}

function bool SetChainsawAnims(GearPawn GP, out GSM_ChainsawAttack.HeightAnims Anims, float BlendTime, EChainsawAnimType AnimType)
{
	return true; // true indicates SetChainsawHeightAnims should be called for us on the attacking GSM
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
}
