/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoPawn_MetaCorp_Messenger extends NanoPawn_MetaCorp_NanoInfantry;



defaultproperties
{

	ControllerClass=class'NanoGameContent.NanoAI_MetaCorp_Messenger'

	Begin Object Name=NanoPawnMesh
		SkeletalMesh=SkeletalMesh'MET_Executive.SK_MET_Executive'
		PhysicsAsset=PhysicsAsset'REB_AnyaProto.SK_REB_AnyaProto_Physics'
		Translation=(Z=-88.0)
	End Object

	Begin Object Class=NanoParticleSystemComponent Name=FollowMeComp
	    Template=ParticleSystem'Effects_Gameplay.Fire.P_Propane_Tank_Flame'
		bAutoActivate=TRUE
		Scale3D=(X=2,Y=2,Z=2)
	End Object
	Components.Add(FollowMeComp)


}