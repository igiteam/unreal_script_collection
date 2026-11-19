/**
 * MetaCorp RiotCop
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoPawn_MetaCorp_RiotCop_Shield extends NanoPawn_MetaCorp_RiotCop;


/** The armor this guy is wearing **/
var SkeletalMeshComponent NanoPawnArmor;


function bool Died(Controller Killer, class<DamageType> DamageType, vector HitLocation)
{
	if( Super.Died(Killer,DamageType,HitLocation) == TRUE )
	{
		NanoPawnArmor.SetHidden( TRUE );

		return TRUE;
	}

	return FALSE;
}




defaultproperties
{
	bEquipShield=TRUE

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
}
