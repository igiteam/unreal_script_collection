/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoPawn_MetaCorp_RiotCop_Grabber extends NanoPawn_MetaCorp_RiotCop;


simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
}


simulated function float SpawnNanoBaton()
{
	local float AnimTime;

	AnimTime = Super.SpawnNanoBaton();

	Weapon.Mesh.SetHidden( TRUE ); // hide our baton

	return AnimTime;
}


simulated function NanoCausingChaosValueDatum GetDeathChaosValue()
{
	return class'NanoCausingChaosValues'.default.RiotTrooperGrabberKilled;
}


function bool Died(Controller Killer, class<DamageType> DamageType, vector HitLocation)
{
	if( Super.Died(Killer,DamageType,HitLocation) == TRUE )
	{


		return TRUE;
	}

	return FALSE;
}


event HitWall( vector HitNormal, actor Wall, PrimitiveComponent WallComp)
{
	Super.HitWall(HitNormal, Wall, WallComp);

	// captains smash down walls!
	//`log( GetFuncName() @ self @ `showvar(Wall));
	if( NanoShieldWall(Wall) != None )
	{
		if( !NanoShieldWall(Wall).bBusted )
		{
			NanoShieldWall(Wall).bBusted = TRUE;
			NanoShieldWall(Wall).OnBust();
			PlayDenseBash();
		}
	}
}




defaultproperties
{
	Begin Object Name=NanoPawnMesh
		SkeletalMesh=SkeletalMesh'MET_ShockTrooper.SK_MET_ShockTrooper_Fat_Gore_Soft'
		PhysicsAsset=PhysicsAsset'MET_ShockTrooper.SK_MET_ShockTrooper_Gore_Physics'
		Scale=1.3
	End Object


	PreferredRangedWeaponClass=class'NanoWeap_AssaultRifle'
	BatonClass=class'NanoWeap_BatonGrabber'

	MeleeEngagePriorityLevel=1


	// this is the DestFallZ distance for ~4 stories.
	Jump_DestZValueThatICanSurvive=3000
	Jump_HowHighICanJumpInStories=2

	DroppedOrbClasses.Add(class'NanoAbsorbOrb_Body_Captain')
}