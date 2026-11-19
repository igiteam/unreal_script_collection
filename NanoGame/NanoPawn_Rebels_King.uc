/**
 * King
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoPawn_Rebels_King extends NanoPawn_Rebels_QuestGiverBase
	config(Pawn);


simulated event PostBeginPlay()
{
	Super.PostBeginPlay();

	AimNodes.length = 0;
}


defaultproperties
{
	Begin Object Name=NanoPawnMesh
		SkeletalMesh=SkeletalMesh'COG_Gus.COG_Gus'
		PhysicsAsset=PhysicsAsset'COG_Gus.COG_Gus_Physics'
		AnimTreeTemplate=AnimTree'REB_Lyrik_AT.AT_Lyrik'
		AnimSets.Add(AnimSet'MET_Executive.AS_MET_Executive')
		Translation=(Z=-88.0)
	End Object

	Begin Object Name=CollisionCylinder
	    CollideActors=TRUE
		BlockZeroExtent=FALSE
	End Object

	bCollideActors=TRUE

	bKillDuringLevelTransition=FALSE
}
