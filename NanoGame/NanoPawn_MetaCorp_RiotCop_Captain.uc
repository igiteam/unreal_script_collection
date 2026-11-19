/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoPawn_MetaCorp_RiotCop_Captain extends NanoPawn_MetaCorp_RiotCop;

/** The armor this guy is wearing **/
var SkeletalMeshComponent NanoPawnArmor;
var SkeletalMeshComponent NanoPawnArmorBlue;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

}

simulated function NanoCausingChaosValueDatum GetDeathChaosValue()
{
	return class'NanoCausingChaosValues'.default.RiotTrooperCaptainKilled;
}


function bool Died(Controller Killer, class<DamageType> DamageType, vector HitLocation)
{
	if( Super.Died(Killer,DamageType,HitLocation) == TRUE )
	{
		NanoPawnArmor.SetHidden( TRUE );
		if( NanoPawnArmorBlue != None )
		{
			NanoPawnArmorBlue.SetHidden( TRUE );
		}


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
		SkeletalMesh=SkeletalMesh'MET_ShockTrooper.SK_MET_ShockTrooper_Gore_Soft'	
		PhysicsAsset=PhysicsAsset'MET_ShockTrooper.SK_MET_ShockTrooper_Gore_Physics'
		Materials(0)=MaterialInstanceConstant'MET_ShockTrooper.M_ShieldTrooper_Body'
		Scale=1.1
	End Object

	Begin Object Class=SkeletalMeshComponent Name=NanoPawnArmorComp
	    SkeletalMesh=SkeletalMesh'MET_ShockTrooper.SK_MET_ShieldTrooper'
	    bAllowAmbientOcclusion=FALSE
		LightEnvironment=MyLightEnvironment
		ParentAnimComponent=NanoPawnMesh
		ShadowParent=NanoPawnMesh
		bUpdateSkelWhenNotRendered=TRUE
		bCastHiddenShadow=TRUE
		CastShadow=TRUE
		CollideActors=FALSE
	End Object
	NanoPawnArmor=NanoPawnArmorComp
	Components.Add(NanoPawnArmorComp)

	Begin Object Class=SkeletalMeshComponent Name=NanoPawnArmorCompBlue
		SkeletalMesh=SkeletalMesh'MET_ShockTrooper.SK_MET_ShockTrooper_Armor'
		bAllowAmbientOcclusion=FALSE
		LightEnvironment=MyLightEnvironment
		ParentAnimComponent=NanoPawnMesh
		ShadowParent=NanoPawnMesh
		bUpdateSkelWhenNotRendered=TRUE
		bCastHiddenShadow=TRUE
		CastShadow=TRUE
		CollideActors=FALSE
	End Object
	NanoPawnArmorBlue=NanoPawnArmorCompBlue
	Components.Add(NanoPawnArmorCompBlue)



	PreferredRangedWeaponClass=class'NanoWeap_AssaultRifle'
	BatonClass=class'NanoWeap_BatonOverCharged'

	MeleeEngagePriorityLevel=1


	// this is the DestFallZ distance for ~4 stories.
	Jump_DestZValueThatICanSurvive=3000
	Jump_HowHighICanJumpInStories=2

	DroppedOrbClasses.Add(class'NanoAbsorbOrb_Body_Captain')
}