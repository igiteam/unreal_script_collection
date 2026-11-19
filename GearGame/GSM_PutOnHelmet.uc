
/**
 * Putting on helmet. For theron Marcus & Dom.
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_PutOnHelmet extends GSM_BasePlaySingleAnim;

var class<Item_HelmetBase>	HelmetClass;

protected function bool InternalCanDoSpecialMove()
{
	local GearPawn_Infantry	InfantryPawn;

	// Needs to have a helmet to do this special move.
	InfantryPawn = GearPawn_Infantry(PawnOwner);
	if( InfantryPawn != None )
	{
		HelmetClass = GetHelmetClass(InfantryPawn);
		if( HelmetClass != None )
		{
			return TRUE;
		}
		else
		{
			`warn("tried to do GSM_PutOnHelmet on a pawn that is not wearing a helmet." @ PawnOwner @ HelmetClass);
			return FALSE;
		}
	}
	else
	{
		`warn("tried to do GSM_PutOnHelmet on a pawn that is a GearPawn_Infantry." @ PawnOwner);
		return FALSE;
	}
	return FALSE;
}

/** Try to figure out what helmet class this pawn should use */
function class<Item_HelmetBase> GetHelmetClass(GearPawn_Infantry InfantryPawn)
{
	local class<GearPawn_Infantry>	InfantryClass;

	if( InfantryPawn.AttachmentClasses[eATTACHTYPE_Helmet] != None )
	{
		return class<Item_HelmetBase>(InfantryPawn.AttachmentClasses[eATTACHTYPE_Helmet]);
	}
	if( InfantryPawn.default.AttachmentClasses[eATTACHTYPE_Helmet] != None )
	{
		return class<Item_HelmetBase>(InfantryPawn.default.AttachmentClasses[eATTACHTYPE_Helmet]);
	}
	InfantryClass = class<GearPawn_Infantry>(InfantryPawn.MutatedClass);
	if( InfantryClass != None && InfantryClass.default.AttachmentClasses[eATTACHTYPE_Helmet] != None )
	{
		return class<Item_HelmetBase>(InfantryClass.default.AttachmentClasses[eATTACHTYPE_Helmet]);
	}

	return None;
}

function PlayAnimation()
{
	if (PawnOwner.Role == ROLE_Authority && PawnOwner.IsCarryingAHeavyWeapon())
	{
		PawnOwner.ThrowActiveWeapon();
	}

	Super.PlayAnimation();

	PawnOwner.SetTimer(0.21f / SpeedModifier, FALSE, nameof(GrabHelmet), Self);
	PawnOwner.SetTimer(0.58f / SpeedModifier, FALSE, nameof(PutOnHelmet), Self);
}

function GrabHelmet()
{
	local GearPawn_Infantry	InfantryPawn;

	InfantryPawn = GearPawn_Infantry(PawnOwner);
	if( InfantryPawn != None )
	{
		InfantryPawn.AttachmentClasses[eATTACHTYPE_Helmet] = HelmetClass;
		if( InfantryPawn.AttachmentClasses[eATTACHTYPE_Helmet] != None )
		{
			InfantryPawn.SetupAttachment(eATTACHTYPE_Helmet);
			// Attach it to left hand first.
			InfantryPawn.Mesh.AttachComponent(InfantryPawn.AttachmentMeshes[eATTACHTYPE_Helmet], 'b_MF_Weapon_L_End');
		}
		else
		{
			`warn("GrabHelmet, Helmet class is none!");
		}
	}
}

function PutOnHelmet()
{
	local GearPawn_Infantry	InfantryPawn;

	InfantryPawn = GearPawn_Infantry(PawnOwner);
	if( InfantryPawn != None )
	{
		InfantryPawn.AttachmentClasses[eATTACHTYPE_Helmet] = HelmetClass;
		if( InfantryPawn.AttachmentClasses[eATTACHTYPE_Helmet] != None )
		{
			InfantryPawn.SetupAttachment(eATTACHTYPE_Helmet);
		}
		else
		{
			`warn("PutOnHelmet, Helmet class is none!");
		}
	}
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	// If we've been aborted early, cancel those timers.
	if( PawnOwner.IsTimerActive(nameof(GrabHelmet), Self) )
	{
		PawnOwner.ClearTimer(nameof(GrabHelmet), Self);
	}
	if( PawnOwner.IsTimerActive(nameof(PutOnHelmet), Self) )
	{
		PawnOwner.ClearTimer(nameof(PutOnHelmet), Self);
		PutOnHelmet();
	}

	Super.SpecialMoveEnded(PrevMove, NextMove);
}

defaultproperties
{
	BS_Animation=(Stance=((Slot=BS_FullBody,AnimName="AR_Put_On_Helmet")))

	BlendInTime=0.33f
	BlendOutTime=0.5f

	DefaultAICommand=class'AICmd_Base_PushedBySpecialMove'
	bBreakFromCover=TRUE
	bDisableTurnInPlace=TRUE
	bShouldAbortWeaponReload=TRUE
	bCanFireWeapon=FALSE
	bDisableMovement=TRUE
	bLockPawnRotation=TRUE
	bDisableAI=TRUE
}
