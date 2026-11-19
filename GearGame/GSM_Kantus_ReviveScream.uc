
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GSM_Kantus_ReviveScream extends GearSpecialMove
	config(Pawn);


/** animation to play **/
var GearPawn.BodyStance BS_Scream;

/** Revive Search radius */
var config float ReviveSearchRadius;
/** Revive Delay (after animation starts) **/
var config float ReviveDelay;
/** amount that damaged but not DBNO pawns in range are healed */
var config int HealAmount;
/** cooldown after the scream is used before it can be used again */
var config float Cooldown;

/** last time the scream was used (for cooldown tracking) */
var float LastScreamTime;

var array<GearPawn> PawnsToHeal;

/** Camera shake parameters */
var GearCameraShake ExploShake;
/** Radius to within which to play full-powered screenshake (will be scaled within radius) */
var float ExploShakeInnerRadius;
/** Between inner and outer radii, scale shake from full to zero */
var float ExploShakeOuterRadius;
/** Exponent for intensity falloff between inner and outer radii. */
var float ExploShakeFalloff;

protected function bool InternalCanDoSpecialMove()
{
	return (PawnOwner.WorldInfo.TimeSeconds - LastScreamTime >= Cooldown && !PawnOwner.IsDBNO() && GatherValidTargets());
}

simulated function bool GatherValidTargets()
{
	local GearPawn	FoundPawn;

	//`log(self@GetFuncName()@KnockdownRange@KnockdownFOV);
	PawnsToHeal.length = 0;
	foreach PawnOwner.WorldInfo.AllPawns(class'GearPawn', FoundPawn, PawnOwner.Location, ReviveSearchRadius)
	{
		//`log(self@GetFuncName()@"Potential victim:"@FoundPawn);
		if (PawnOwner != FoundPawn && PawnOwner.IsSameTeam(FoundPawn) && FoundPawn.bCanBeHealed && !FoundPawn.IsAHostage() && FoundPawn.Health < FoundPawn.DefaultHealth)
		{
			//`log(self@GetFuncName()@"Found victim:"$FoundPawn);
			PawnsToHeal.AddItem(FoundPawn);
		}
	}

	//`log(self@GetFuncName()@"found"@PawnsToHeal.length);
	return (PawnsToHeal.length > 0);

}

function ReviveCutShort()
{
	DoRevive();
	pawnOwner.ClearTimer('DoRevive',self);
	PawnOwner.BS_StopAll(0.3f);
	PawnOwner.EndSpecialMove();
}

function DoRevive()
{
	local int i, AdjustedHealAmount;

	if (PawnOwner.Role == ROLE_Authority)
	{
		// adjust heal by difficulty for humans so that the percentage for any given creature is the same regardless of difficulty
		AdjustedHealAmount = HealAmount;
		if (PawnOwner.IsHumanControlled())
		{
			AdjustedHealAmount *= GearPRI(PawnOwner.PlayerReplicationInfo).Difficulty.default.PlayerHealthMod;
		}
		for (i = 0; i < PawnsToHeal.length; i++)
		{
			if (PawnsToHeal[i] != None && !PawnsToHeal[i].IsPendingKill())
			{
				if (PawnsToHeal[i].IsDBNO(true) && PawnsToHeal[i].bCanRecoverFromDBNO)
				{
					GearGame(PawnOwner.WorldInfo.Game).TriggerGUDEvent(GUDEvent_Revived, PawnOwner, PawnsToHeal[i]);
					PawnsToHeal[i].DoRevival(PawnOwner, true);
				}
				else if (PawnsToHeal[i].Health > 0 && !PawnsToHeal[i].bTearOff)
				{
					PawnsToHeal[i].HealDamage(AdjustedHealAmount, PawnOwner.Controller, class'GearDamageType');
					PawnsToHeal[i].DesiredKantusFadeVal = 0.25;
					PawnsToHeal[i].SetTimer(0.75, false, nameof(PawnsToHeal[i].ClearKantusHealGlow));
				}
			}
		}
	}
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	Super.SpecialMoveStarted(bForced,PrevMove);

	if (PawnOwner.Role == ROLE_Authority)
	{
		PawnOwner.SetTimer(ReviveDelay, false, nameof(DoRevive), self);
	}

	// quit playing grenade anims
	PawnOwner.BS_StopAll(0.1f);

	// Play body stance animation.
	PawnOwner.BS_Play(BS_Scream, SpeedModifier, 0.2f/SpeedModifier, 0.2f/SpeedModifier, FALSE, TRUE );

	// Enable end of animation notification. This is going to call SpecialMoveEnded()
	PawnOwner.BS_SetAnimEndNotify(BS_Scream, TRUE);

	PawnOwner.DesiredKantusFadeVal = 1.0f;
	PawnOwner.KantusReviver = GearPawn_LocustKantusBase(Pawnowner);
	if (ExploShake != None)
	{
		class'GearPlayerCamera'.static.PlayWorldCameraShake(ExploShake, PawnOwner, PawnOwner.Location, ExploShakeInnerRadius, ExploShakeOuterRadius, ExploShakeFalloff, TRUE );
	}
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	Super.SpecialMoveEnded(PrevMove, NextMove);

	PawnOwner.BS_SetAnimEndNotify(BS_Scream, FALSE);
	PawnOwner.DesiredKantusFadeVal = 0.f;

	LastScreamTime = PawnOwner.WorldInfo.TimeSeconds;
}


defaultproperties
{
	bShouldAbortWeaponReload=TRUE
	bCanFireWeapon=FALSE
	bDisableMovement=TRUE

	BS_Scream=(Stance=((Slot=BS_FullBody,AnimName="kantus_chant")))

// 	Begin Object Class=GearCameraShake Name=ExploShake0
// 		OscillationDuration=4.f
// 		RotOscillation={(Pitch=(Amplitude=1000.f,Frequency=80.f),
// 						Yaw=(Amplitude=400.f,Frequency=40.f),
// 						Roll=(Amplitude=600.f,Frequency=50.f))}
// 	End Object
// 	ExploShake=ExploShake0
	ExploShakeInnerRadius=800
	ExploShakeOuterRadius=2048

	Action={(
			ActionName=ReviveTeammate,
			ActionIconDatas=(	(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=330,V=314,UL=45,VL=32))), // X Button
								(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=175,V=239,UL=136,VL=75)))	),
	)}
}
