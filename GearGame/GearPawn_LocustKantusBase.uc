
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearPawn_LocustKantusBase extends GearPawn_LocustBase
	abstract
	native(Pawn)
	config(Pawn);

var repnotify byte ThrowCount; // like flash count, but with more hax

/** e.g. "Boom", "Crush", etc. */
var protected const array<SoundCue>		KantusAttackTelegraphDialogue;

var ParticleSystem	ReviveParticleSystem;

var array< class<Gearpawn> > MinionClasses;

var config float MinTimeBetweenKnockDownScreams;
/** knockdown range to search for targets**/
var config float KnockdownRange;
var config float KnockdownFOV;
var config float KnockdownDelay;
var float LastSuccessfulKnockdownTime;
/** how long cringe from scream lasts */
var config float ScreamCringeDuration;

/** how much to modify the scream's screen shake by */
var config float ScreamShakeScale;

/** list of pawns to knock down in an impending scream (determined at start instead of end) */
var array<GearPawn> PawnsToKnockDown;

/** Pawn who instigated the Knock Down */
var transient Pawn KnockDownInstigator;
/** Last Time Kantus Stumbled due to Damage */
var transient float LastStumbleTime;

replication
{
	if (bNetDirty)
		ThrowCount;
}

simulated function DoKantusReviveEffects(GearPawn GP)
{
	GP.KantusRevivePSC = new(GP) class'ParticleSystemComponent';
	GP.KantusRevivePSC.SetTemplate(default.ReviveParticleSystem);
	GP.mesh.AttachComponent(GP.KantusRevivePSC, GP.MeleeDamageBoneName);
	GP.KantusRevivePSC.ActivateSystem();
	if (GP != self)
	{
		GP.SetDesiredRotation(rotator(Location - GP.Location));
		if (Role == ROLE_Authority)
		{
			GP.Controller.Focus = self;
		}
	}
}

simulated function TelegraphGrenadeThrow()
{
	local int RandIdx;

	// speak telegraph line
	if (KantusAttackTelegraphDialogue.length > 0)
	{
		RandIdx = Rand(KantusAttackTelegraphDialogue.length);
		// make addressee AI's target?
		SpeakLine(None, KantusAttackTelegraphDialogue[RandIdx], "", 0.f, Speech_GUDS,,,,,, TRUE);
	}
}

reliable server function ServerDoKnockdownScream()
{
	if (CanDoSpecialMove(GSM_Kantus_KnockdownScream) && CanDoKnockdown())
	{
		ServerDoSpecialMove(GSM_Kantus_KnockdownScream);
	}
}

function ThrowingInkGrenade(float Delay)
{
	local GearAI_Kantus KAI;
	ThrowCount++;

	KAI = GearAI_Kantus(Controller);
	if(KAI != none)
	{
		// let the controller do whatever it needs to when we throw this thing
		KAI.ThrowingInkGrenade(Delay);
	}
}

function bool CanDoKnockdown()
{
	local GearPawn	FoundPawn;
	local vector RotDir;
	local vector MeToVictimNormal;

	if (WorldInfo.TimeSeconds - LastSuccessfulKnockdownTime < MinTimeBetweenKnockDownScreams || IsDBNO())
	{
		return false;
	}

	PawnsToKnockDown.length = 0;
	RotDir = vector(Rotation);
	foreach VisibleCollidingActors(class'GearPawn', FoundPawn, KnockdownRange, Location, true)
	{
		if (FoundPawn != self && !IsSameTeam(FoundPawn) && !FoundPawn.IsAHostage() && FoundPawn.bRespondToExplosions)
		{
			MeToVictimNormal = Normal(FoundPawn.Location - Location);

			// check to see if he's within our specified FOV
			if ((MeToVictimNormal dot RotDir) >= KnockdownFOV)
			{
				// Add Pawn we found on the server.
				PawnsToKnockDown.AddItem(FoundPawn);
			}
		}
	}

	return (PawnsToKnockDown.length > 0);

}

/** @note: nowadays we do cringes instead of knockdowns */
function DoKnockDown()
{
	local GearPawn FoundPawn;
	local vector MeToVictimNormal;
	local float DistFromMe;
	local int i;

	if (Role == ROLE_Authority)
	{
		for(i = 0; i < PawnsToKnockDown.length; i++)
		{
			FoundPawn = PawnsToKnockDown[i];
			MeToVictimNormal = FoundPawn.Location - Location;
			DistFromMe = VSize(MeToVictimNormal);
			// normalize, making use of previous sqrt
			MeToVictimNormal /= DistFromMe;

			if ( FastTrace(FoundPawn.Location,Location) &&
				!FoundPawn.IsProtectedByShield(MeToVictimNormal, false, Location) &&
				(FoundPawn.DrivenVehicle == None || !FoundPawn.DrivenVehicle.IsA('Turret_TroikaCabal')) && // need to check this otherwise you end up in lala land with camera all crazy and knocked down guy shooting troika
				(FoundPawn.Base == None || !FoundPawn.Base.IsA('GearPawn_SilverbackBase')) ) // Silverback drivers are immune
			{
				if (FoundPawn.CurrentLink != none)
				{
					FoundPawn.Controller.NotifyCoverDisabled(FoundPawn.CurrentLink, FoundPawn.CurrentSlotIdx);
				}

				FoundPawn.Cringe(ScreamCringeDuration);
				LastSuccessfulKnockdownTime = WorldInfo.TimeSeconds;
			}
		}
		PawnsToKnockDown.length = 0;
	}
}

simulated function bool CanBeAHostage()
{
	return FALSE;
}


simulated native final function bool IsThrowingOffHandGrenade();
native simulated function bool CanFireWeapon(optional bool bTestingForTargeting);

/**
 * The scream morphs don't work well with the generic headshot logic, just check that the hit bone matches the head if screaming
 *
 * @param BoneName - the bone hit
 *
 * @param HitLocation - location the damage occurred
 *
 * @param Momentum - the direction of the damage
 *
 * @param out_bHasHelmet - whether the enemy is wearing a helmet
 *
 * @return TRUE if this hit corresponds to a head shot.
 */
simulated event bool TookHeadShot(Name BoneName, vector HitLocation, vector Momentum, optional out byte out_bHasHelmet)
{
	if (IsScreaming() && BoneName == HeadBoneNames[0])
	{
		return TRUE;
	}

	return Super.TookHeadShot(BoneName, HitLocation, Momentum, out_bHasHelmet);
}

/**
 * Whether we are screaming
 *
 * @return TRUE if we are doing one of the special move screams
 */
simulated function bool IsScreaming()
{
	return IsDoingSpecialMove(GSM_Kantus_KnockDownScream) || IsDoingSpecialMove(GSM_Kantus_ReviveScream) || IsDoingSpecialMove(GSM_Kantus_SummoningScream) || IsDoingSpecialMove(GSM_Kantus_FrustratedScream);
}

/**
 * Martyr the ink grenade if possible
 *
 * @param DamageType - the damage type that killed us
 *
 * @param HitLoc - where the damage that killed us was
 */
simulated function PlayDying(class<DamageType> DamageType, vector HitLoc)
{
	local GearWeapon GW;

	Super.PlayDying(DamageType, HitLoc);

	if (!bIsGore && Role == ROLE_Authority)
	{
		foreach InvManager.InventoryActors(class'GearWeapon', GW)
		{
			if (GW.CanMartyr())
			{
				GW.DoMartyrFire();
			}
		}
	}
}

simulated function bool CanBeSpecialMeleeAttacked(GearPawn Attacker)
{
	// special case disallow retro lancer charge
	if (!IsDBNO() && Attacker != None && Attacker.Weapon != None && Attacker.Weapon.IsA('GearWeap_RetroLancer'))
	{
		return false;
	}
	else
	{
		return Super.CanBeSpecialMeleeAttacked(Attacker);
	}
}

defaultproperties
{
	NoticedGUDSPriority=150
	NoticedGUDSEvent=GUDEvent_NoticedKantus
	bCanDBNO=false
	bCanUseCover=false
	bCanBeHealed=false
	bSeesTaccomMeshForInjuredAllies=true
	SpecialMoveClasses(SM_WeaponPickup)=None
	SpecialMoveClasses(SM_CQCMove_PunchFace)=None
	ActionSpecialMoves.Add(SM_MidLvlJumpOver)

	BaseEyeHeight=100
	EyeHeight=100
	SiegeTutorialType=GEARTUT_SIEGE_Kantus

	CharacterFootStepType=CFST_Locust_Kantus
}
