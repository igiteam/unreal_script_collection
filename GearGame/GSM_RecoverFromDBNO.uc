
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_RecoverFromDBNO extends GSM_StumbleGetUp;

var		bool				bRevivedByKantus;
var()	GearPawn.BodyStance	BS_GetUp, BS_KantusRevive;

function bool CanChainMove(ESpecialMove NextMove)
{
	// allow everything to chain from recovery
	return TRUE;
}

static function INT PackSpecialMoveFlags(bool inbRevivedByKantus)
{
	return INT(inbRevivedByKantus);
}

/** Unpack Special Move flags used for replication */
function UnpackSpecialMoveFlags()
{
	bRevivedByKantus = bool(PawnOwner.SpecialMoveFlags & 1);
}

function PlayGetUpAnimation()
{
	local float AnimStart;

	// if already finished, just end special move
	if ( PawnOwner.bFinishedSelfReviving )
	{
		PawnOwner.EndSpecialMove();
	}
	else
	{
		// if still playing
		if (PawnOwner.bPlayingSelfReviving)
		{
			if (PawnOwner.CurrentReviveStage == 1)
			{
				AnimStart = 0.6f;
			}
			else if (PawnOwner.CurrentReviveStage == 2)
			{
				AnimStart = 1.17f;
			}

			PawnOwner.ClearRecovery();

			Super.PlayGetUpAnimation();
			PawnOwner.BS_SetPosition(BS_Animation, AnimStart);
		}
		else
		{
			Super.PlayGetUpAnimation();
		}
	}
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	// clear the was DBNO flag since we didn't die
	PawnOwner.bWasDBNO = FALSE;

	UnpackSpecialMoveFlags();

	if (bRevivedByKantus)
	{
		PawnOwner.DesiredKantusFadeVal = 1.0f;
		PawnOwner.SetDesiredRotation(rotator(PawnOwner.KantusReviver.Location - PawnOwner.Location));
		PawnOwner.Controller.SetFocalPoint(vect(0,0,0));

	}
	BS_Animation = bRevivedByKantus ? BS_KantusRevive : BS_GetUp;

	Super.SpecialMoveStarted(bForced,PrevMove);

	// human controlled Pawns revived by Kantus are invulnerable until it's done
	bOnlyInteractionPawnCanDamageMe = (bRevivedByKantus && PawnOwner.IsHumanControlled());

	// note the time of revival
	PawnOwner.TimeOfRevival = PawnOwner.WorldInfo.TimeSeconds;

	// if alive and owning client
	if( PawnOwner.IsLocallyControlled() && PawnOwner.IsHumanControlled() )
	{
		if (PCOwner.CurrentPPType == eGPP_BleedOut)
		{
			PCOwner.StopPostProcessOverride(eGPP_BleedOut);
		}
		// then kick out the dbno exit cue
		PawnOwner.PlaySound(SoundCue'Interface_Audio.Interface.DeathModeExit01Cue', TRUE);
	}

	// put out any fire or smoke
	PawnOwner.ExtinguishPawn();

	PawnOwner.UnHolsterWeapon();

	// clear some extra flags jic
	PawnOwner.bWantsToMelee = FALSE;
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	Super.SpecialMoveEnded(PrevMove,NextMove);
	if(bRevivedByKantus)
	{
		PawnOwner.DesiredKantusFadeVal = 0.0f;
		if (bRevivedByKantus)
		{
			if(PawnOwner.HealthRechargeDelay > 0.f)
			{
				PawnOwner.EnableHealthRecharge();
			}
			else
			{
				// assumes we were put at 15% of health by dorevival, so add back up to 100%..
				// (means if we took some damage durnig the interim we will still maintain that damage)
				PawnOwner.Health += pawnOwner.DefaultHealth * 0.85f;
			}
		}
		PawnOwner.LockDesiredRotation(FALSE);
		//PawnOWner.Controller.bForceDesiredRotation = PawnOwner.Controller.Default.bForceDesiredRotation;

	}
	if (PCOwner != None && !PawnOwner.Weapon.HasAnyAmmo() && PCOwner.IsLocalPlayerController())
	{
		GearInventoryManager(PawnOwner.InvManager).AutoSwitchWeapon();;
	}
}

defaultproperties
{
	BS_GetUp=(Stance=((Slot=BS_FullBody,AnimName="AR_Injured_Getup")))
	BS_KantusRevive=(Stance=((Slot=BS_FullBody,AnimName="DBNO_Revive")))
}
