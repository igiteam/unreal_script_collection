
/**
 * Meat Shield: Hostage
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_Hostage extends GSM_InteractionPawnFollower_Base;

/** shake played on kidnapper when a living hostage resists by pressing the button */
var protectedwrite const GearCameraShake ResistShake;
/** rumble to go with the ResistShake */
var ForceFeedbackWaveform ResistFF;
/** last time we triggered ResistShake */
var float LastResistTime;
/** cooldown for ResistShake */
var config float ResistShakeCooldown;
/** damage caused by ResistShake */
var config float ResistDamage;
/** HUD icon for resist shake */
var ActionInfo ResistActionInfo;

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	local GearPRI GPRI;

	Super.SpecialMoveStarted(bForced,PrevMove);

	// Allow the pawn to handle any specific things when being taken hostage
	GearPawn_Infantry(PawnOwner).TakenHostageNotify();

	// set post async so that it does get updated after async is done
	PawnOwner.Mesh.SetTickGroup(TG_PostAsyncWork);
	PawnOwner.SetTickGroup(TG_PostAsyncWork);

	// Set his health to default value.
	PawnOwner.HostageHealth = PawnOwner.HostageDefaultHealth;

	// As a hostage, PawnOwner doesn't bleed out anymore.
	// Blargh - why do we have to manually toggle these. Need to refactor this to just check for a flag in the HUD code.
	// It would be much easier to maintain.
	if( PCOwner != None && PCOwner.MyGearHUD != None )
	{
		// stop pp effect for bleed out
		GPRI = GearPRI(PawnOwner.PlayerReplicationInfo);
		if (GPRI != None && GPRI.bIsLeader)
		{
			PCOwner.StopPostProcessOverride(eGPP_BleedOut);
		}
		PCOwner.MyGearHUD.ClearActionInfoByType(AT_StayingAlive);
		PCOwner.MyGearHUD.ClearActionInfoByType(AT_SuicideBomb);
	}

	// Set the time of death since he is technically dead
	if (PawnOwner.TimeOfDeath == 0.0f && PawnOwner.CanBeSpecialMeleeAttacked(PawnOwner.InteractionPawn))
	{
		PawnOwner.TimeOfDeath = PawnOwner.WorldInfo.TimeSeconds;
	}

	// if pawn is on fire or smoldering, put him out
	PawnOwner.ExtinguishPawn();

	PawnOwner.InteractionPawn.StartBloodTrail( 'SpawnABloodTrail_MeatBag' );

	// If we've been taken hostage from stumbling and not DBNO, then force pawn to go into
	// DBNO state. Consider this to be an execution. One code path for all!
	if( PawnOwner.WorldInfo.NetMode != NM_Client )
	{
		if( !PawnOwner.IsInState('Kidnapped') )
		{
			PawnOwner.GotoState('Kidnapped');
		}

		// if carrying a heavy weapon, drop it
		if( PawnOwner.IsCarryingAHeavyWeapon() )
		{
			PawnOwner.ThrowActiveWeapon();
		}

		// if carrying a shield, drop it
		if( PawnOwner.IsCarryingShield() )
		{
			PawnOwner.DropShield();
		}
	}

	if (PCOwner != None && !PCOwner.IsInState('Kidnapped'))
	{
		PCOwner.GotoState('Kidnapped');
	}

	PawnOwner.HolsterWeapon();

	if (PawnOwner.CanBeSpecialMeleeAttacked(PawnOwner.InteractionPawn))
	{
		// remove taccom mesh while a hostage
		GearPawn_Infantry(PawnOwner).RemoveTaccomMesh();
	}
	// if we are still controlled, we can do the camera shake to our attacker; display the HUD for that
	else if (PawnOwner.IsLocallyControlled() && PCOwner != None)
	{
		PCOwner.MyGearHUD.ClearActionInfoByType(AT_StayingAlive);
		PCOwner.MyGearHUD.ClearActionInfoByType(AT_SuicideBomb);
		ShowHUDDisplay();
	}

 	if (AIOwner != None)
	{
		PawnOwner.SetTimer(3.0, true, nameof(AIResistanceCheck), self);
	}

// 	// For testing
// 	if( TRUE )
// 	{
// 		PawnOwner.SetTimer(2.0, true, nameof(PawnOwner.ServerDoHostageResistance));
// 	}
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	// restore tickgroup
	PawnOwner.Mesh.SetTickGroup(PawnOwner.default.Mesh.TickGroup);
	PawnOwner.SetTickGroup(PawnOwner.default.TickGroup);

	// reset the DBNO time
	PawnOwner.TimeOfDBNO = 0;

	if (NextMove == SM_ChainsawVictim && PawnOwner.Role == ROLE_Authority)
	{
		PawnOwner.InteractionPawn.SetTimer(0.1f,FALSE,'SavedByAMeatshieldCallback');
	}
	PawnOwner.InteractionPawn.StopBloodTrail( 'SpawnABloodTrail_MeatBag' );

	if (NextMove == SM_ChainsawVictim)
	{
		if (PawnOwner.WorldInfo.NetMode != NM_Client && PawnOwner.IsInState('Kidnapped'))
		{
			PawnOwner.GotoState('');
		}
	}
	// if we were released alive, then reattach our weapon
	// non-owning client only, since the server and owning client do the full weapon selection logic elsewhere
	else if (PawnOwner.WorldInfo.NetMode == NM_Client && !PawnOwner.bTearOff && !PawnOwner.IsLocallyControlled())
	{
		PawnOwner.UnHolsterWeapon();
	}

	PawnOwner.ClearTimer(nameof(ShowHUDDisplay), self);
	PawnOwner.ClearTimer(nameof(AIResistanceCheck), self);

	// On the owning client, SpecialMoves are done with RPCs so it will beat the base clearing variable replication.
	// Force the detach here.
	if (PawnOwner.Role < ROLE_Authority && PawnOwner.IsLocallyControlled())
	{
		class'GSM_InteractionPawnLeader_Base'.static.DetachPawnHelper(PawnOwner);
	}

	Super.SpecialMoveEnded(PrevMove, NextMove);

	// since this GSM has disabled physics, it will turn to fall when it's changing
	// when gore is on, if fall, it will really fall.  TTP 126021
	if ( NextMove == SM_ChainsawVictim && PawnOwner.bIsGore )
	{
		PawnOwner.SetPhysics(PHYS_None);
	}

	if (NextMove != SM_Kidnapper_Execution && !PawnOwner.bTearOff && GearPawn_Infantry(PawnOwner).TaccomMesh != None)
	{
		PawnOwner.AttachComponent(GearPawn_Infantry(PawnOwner).TaccomMesh);
	}
}

/** turns on the HUD display telling the player that they can press the button to shake the enemy camera */
function ShowHUDDisplay()
{
	PCOwner.MyGearHUD.SetActionInfo(AT_SpecialMove, ResistActionInfo);
}

function bool ButtonPress(Name ButtonName)
{
	// follower input is accepted only if you're attached already
	// TTP 148554 shows the animation gets interrupted before attached. (GSM_Kidnap)
	// so here only accept input if follower is attached to leader
	if ( PCOwner.MyGearPawn != None && PCOwner.MyGearPawn.Base == Leader &&
		!PCOwner.MyGearHUD.bShowScores && !PCOwner.MyGearHUD.bDrawOverheadMPMap && ButtonName == 'B' )
	{
		PawnOwner.ServerDoHostageResistance();
		// update client HUD
		if (PawnOwner.IsLocallyControlled() && PCOwner != None)
		{
			PCOwner.MyGearHUD.ClearActionInfoByType(AT_SpecialMove);
			PawnOwner.SetTimer(ResistShakeCooldown, false, nameof(ShowHUDDisplay), self);
		}
		return true;
	}
	else
	{
		return false;
	}
}

/** called when hostage is AI controlled to decide if it wants to do the resistance move */
function AIResistanceCheck()
{
	// whenever it's available while kidnapper is damaged
	if (PawnOwner.Controller != None && PawnOwner.InteractionPawn.Health < PawnOwner.InteractionPawn.HealthMax)
	{
		PawnOwner.ServerDoHostageResistance();
	}
}

defaultproperties
{
	DefaultAICommand=class'AICmd_Base_PushedBySpecialMove'

	Begin Object Class=GearCameraShake Name=ResistShake0
		Anim=CameraAnim'Effects_Camera.SpecialMoves.CA_Hostage_Jab'
		AnimBlendInTime=0.1f
	End Object
	ResistShake=ResistShake0

	Begin Object Class=ForceFeedbackWaveform Name=ForceFeedbackWaveform4
	    Samples(0)=(LeftAmplitude=100,RightAmplitude=100,LeftFunction=WF_LinearDecreasing,RightFunction=WF_LinearDecreasing,Duration=0.7)
	    Samples(1)=(LeftAmplitude=100,RightAmplitude=100,LeftFunction=WF_LinearDecreasing,RightFunction=WF_LinearDecreasing,Duration=0.7)
	End Object
	ResistFF=ForceFeedbackWaveform4

	// B Button
	ResistActionInfo={(
		ActionName=HostageResist,
		IconAnimationSpeed=0.1f,
		ActionIconDatas=(	(ActionIcons=((Texture=Texture2D'Warfare_HUD.HUD.HUD_ActionIcons2',U=83,V=0,UL=45,VL=32),
										  (Texture=Texture2D'Warfare_HUD.HUD.HUD_ActionIcons2',U=83,V=33,UL=45,VL=32))))
		)}

	bDisableLook=False
	bCameraFocusOnPawn=False

	BS_PistolReload=(Stance=((Slot=BS_Hostage_Upper,AnimName="Hostage_Pistol_reload")))
	BS_PistolReloadFail=(Stance=((Slot=BS_Hostage_Upper,AnimName="Hostage_Pistol_reload_fail")))
	BS_PistolMelee=(Stance=((Slot=BS_FullBody,AnimName="ADD_Hostage_MeleeA")))
}
