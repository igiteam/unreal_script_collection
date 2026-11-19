/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoCrowd_Pedestrian extends NanoCrowd_PedestrianBase
	abstract;

defaultproperties
{
	Begin Object Name=SkeletalMeshComponent0
		SkeletalMesh=SkeletalMesh'NPC_Civilian_LOD.SK_NPC_LOD_01'
		AnimTreeTemplate=AnimTree'NPC_CivilianProto.AT_NPC_Civilian_Proto'
		Scale=1.2

		AnimSets.Empty()
		AnimSets.Add(AnimSet'REB_AnyaProto.AS_REB_AnyaProto_Civilian')
		AnimSets.Add(AnimSet'MET_ShockTrooperProto.AS_MET_ShockTrooper_Proto')
		AnimSets.Add(AnimSet'REB_AnyaProto.AS_REB_Marcus_Civilian')
		AnimSets.Add(AnimSet'REB_AnyaProto.AS_REB_AnyaProto_No_Weapon')

		LineCheckBoundsScale=(X=0.3,Y=0.3,Z=0.5)
		Translation=(Z=-42.0)
	End Object
	
	RunAnimNames(0)="Run_Fwd"
	WalkAnimNames(0)="Walk_Fwd_RootMotion"
	WalkAnimNames(1)="Walk_Fwd_B_RootMotion"
	IdleAnimNames(0)="Standing_Idle"
	bUseRootMotionVelocity=TRUE
	
	// we have really large view distances in nano
	TickFrequencyDecreaseDistanceStart=12000
	TickFrequencyDecreaseDistanceEnd=16000
	TickFrequencyAtEndDistance=0.1

	PushReactionAnims(0)="Pushed_L"
	PushReactionAnims(1)="Pushed_R"
	PushReactionAnims(2)="Pushed_F"
	PushReactionAnims(3)="Pushed_B"

	GroupWaitingBehaviors(0)=(BehaviorArchetype=Nano_Proto_Crowd.Behaviors.WaitForGroup)

	bPreferVisibleDestination=TRUE

	bDoDodgeOnDamage=FALSE
}



