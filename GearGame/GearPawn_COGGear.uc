/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 *
 *  Base Gear COG Gear Character class
 */
class GearPawn_COGGear extends GearPawn_Infantry
	config(Pawn)
	native(Pawn);

simulated function OnDestroy(SeqAct_Destroy Action)
{
	if (PlayerController(Controller) != None &&
		WorldInfo.NetMode != NM_Standalone)
	{
		`Warn("Not destroying"@self);
	}
	else
	{
		Super.OnDestroy(Action);
	}
}

simulated function bool CanBeSpecialMeleeAttacked(GearPawn Attacker)
{
	// don't allow friendly AI COGs to be executed unless playing on a high difficulty
	// and the AI has been left DBNO for a while
	if (!Super.CanBeSpecialMeleeAttacked(Attacker))
	{
		return false;
	}
	else if (GearGameSP_Base(WorldInfo.Game) == None)
	{
		return true;
	}
	else if (!IsDBNO())
	{
		// don't allow friendly AI in Campaign to be instagibbed by anything, must go down first
		return IsHumanControlled();
	}
	else if (WorldInfo.TimeSeconds - TimeStampEnteredRevivingState < 10.0)
	{
		return false;
	}
	else if (IsHumanControlled())
	{
		return GearPRI(PlayerReplicationInfo).Difficulty.default.bHumanCOGCanBeExecuted;
	}
	else
	{
		// in Arcade never let squadmates die since humans will respawn
		return (class'DifficultySettings'.static.GetLowestPlayerDifficultyLevel(WorldInfo).default.bAllowAICOGDeathWhenDBNO && GearGameSP_Arcade(WorldInfo.Game) == None);
	}
}


simulated function byte GetMPWeaponColorBasedOnClass()
{
	return 0;
}

/** called to make the character yell to announce his/her shot */
function AnnounceShot();
/** AI hook to play a line when the character is (or thinks he/she is) under heavy fire */
function PlayDefiantYell();

/**
 * Function allowing the Pawn to override a weapon reload animation with his own version.
 * By default the weapon provides the animation to play.
 * @param   GearWeap        Weapon being reloaded.
 * @param	BS_Animation	BodyStance to play.
 * @return					TRUE to override, FALSE to let weapon play default animations.
 */
simulated function bool OverrideReloadAnimation(GearWeapon GearWeap, out BodyStance BS_Animation)
{
	if (SpecialMove == SM_ZiplineIdle)
	{
		// skip if zipline
		return TRUE;
	}

	return Super.OverrideReloadAnimation(GearWeap, BS_Animation);
}

simulated function bool OverrideHolsterAnimation(GearWeapon WP)
{
	if (SpecialMove == SM_ZiplineIdle)
	{
		// skip if zipline
		return TRUE;
	}

	return Super.OverrideHolsterAnimation(WP);
}

simulated function bool OverrideEquipAnimation(GearWeapon WP, float BlendInTime)
{
	if (SpecialMove == SM_ZiplineIdle)
	{
		// skip if zipline
		return TRUE;
	}

	return Super.OverrideEquipAnimation(WP, BlendInTime);
}

defaultproperties
{
	DefaultInventory[0]=class'GearWeap_AssaultRifle'
	DefaultInventory[1]=class'GearWeap_COGPistol'
	DefaultInventory[2]=class'GearWeap_Shotgun'

	// HeadShot neck attachment
	Begin Object Class=StaticMeshComponent Name=GearHeadShotMesh1
	    StaticMesh=StaticMesh'COG_Gore.COG_Headshot_Gore'
		CollideActors=FALSE
		LightEnvironment=MyLightEnvironment
	End Object
	HeadShotNeckGoreAttachment=GearHeadShotMesh1
	bCanPlayHeadShotDeath=TRUE

	Begin Object Name=GearPawnMesh
		// this is only cog related animset
		AnimSets.Add(AnimSet'COG_MarcusFenix_Execution.Animations.AnimSetMarcus_CamSkel_ArmRip')
	End Object

	Begin Object Name=CollisionCylinder
		CollisionRadius=+0034.000000
		CollisionHeight=+0072.000000
	End Object

	CrouchHeight=+45.0
	CrouchRadius=+34.0

	SpecialMoveClasses(SM_MidLvlJumpOver)	=class'GSM_MantleOverGears'

	SpecialMoveClasses(SM_ShareAmmo)				=class'GSM_ShareAmmo'
	SpecialMoveClasses(SM_GiveMoney)                =class'GSM_GiveMoney'
	SpecialMoveClasses(SM_TradeWeapons)             =class'GSM_TradeWeapons'
	SpecialMoveClasses(SM_TradeWeapons_Leader)      =class'GSM_TradeWeapons_Leader'
	SpecialMoveClasses(SM_TradeWeapons_Follower)    =class'GSM_TradeWeapons_Follower'
	SpecialMoveClasses(SM_TradeWeaponsSecondaryAI)  =class'GSM_TradeWeaponsSecondaryAI'

	DeadBodyImpactSound=SoundCue'Foley_BodyMoves.BodyMoves.BodyFall_CogCue'

	bCanRechargeHealth=true

	bCanMeleeKick=TRUE
}
