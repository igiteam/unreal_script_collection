/**
 * AssassinationTarget
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoPawn_MetaCorp_AssassinationTarget extends NanoPawn_MetaCorp_NanoInfantry
	config(Pawn);


simulated event PostBeginPlay()
{
	Super.PostBeginPlay();
}

simulated function CacheAnimNodes()
{
	Super.CacheAnimNodes();

	AimNodes[AimNodes.length] = NanoAnim_AimOffset(Mesh.FindAnimNode('GunAimNode'));
	AimNodes[AimNodes.length] = NanoAnim_AimOffset(Mesh.FindAnimNode('CamAimNode'));	
	AimNodes[AimNodes.length] = NanoAnim_AimOffset(Mesh.FindAnimNode('SwordAimNode'));	

	PhysBlend = NanoAnimBlendByPhysics(Mesh.FindAnimNode('PhysBlend'));

	TopHalfSlot = NanoAnimNodeSlot(Mesh.FindAnimNode('TopHalfSlot'));
	FullBodySlot = NanoAnimNodeSlot(Mesh.FindAnimNode('FullBodySlot'));
	RunningFullBodySlot = NanoAnimNodeSlot(Mesh.FindAnimNode('RunningFullBodySlot'));
	RunningTopHalfSlot = NanoAnimNodeSlot(Mesh.FindAnimNode('RunningTopHalfSlot'));
	FallingFullBodySlot = NanoAnimNodeSlot(Mesh.FindAnimNode('FallingFullBodySlot'));

	TackleRunSeqNode = NanoAnimNodeSequence(Mesh.FindAnimNode('TackleRun'));

	HeadTrackSkelControl = SkelControlLookAt(Mesh.FindSkelControl('HeadLook'));
}

simulated function ClearAnimNodes()
{
	AimNodes.Length = 0;

	PhysBlend = None;

	TopHalfSlot = None;
	FullBodySlot = None;
	RunningFullBodySlot = None;
	RunningTopHalfSlot = None;
	FallingFullBodySlot = None;

	TackleRunSeqNode = None;

	HeadTrackSkelControl = None;
}



simulated function Tick(float DeltaTime)
{
	Super.Tick(DeltaTime);

	if( IsHeadTrackingEnabled() )
	{
		HeadTrackSkelControl.DesiredTargetLocation = GetHeadLookTargetLocation();
		//`log( "setting" @ `showvar(HeadTrackSkelControl.DesiredTargetLocation) @ `showvar(HeadTrackSkelControl.ControlStrength));
	}
}




/** Return location of objective, used by radar */
simulated function vector GetObjectiveLocation()
{
	return Location;
}

/** This will return the struct that holds all of the values for this specific pawn **/
simulated function NanoCausingChaosValueDatum GetDeathChaosValue()
{
	return class'NanoCausingChaosValues'.default.MetaCorpExecKilled;
}


state Dying
{
	event BeginState(Name PrevStateName)
	{
		Super.BeginState( PrevStateName );

		NanoGRI(WorldInfo.GRI).ModifyChaosLevel( GetChaosZone(), none, class'NanoCausingChaosValues'.default.AssassinationTargetDied );
	}

}




defaultproperties
{
	ControllerClass=class'NanoAI_AssassinationTarget'

	Begin Object Name=NanoPawnMesh
		SkeletalMesh=SkeletalMesh'MET_Executive.SK_MET_Executive'
		PhysicsAsset=PhysicsAsset'REB_AnyaProto.SK_REB_AnyaProto_Physics'

		AnimTreeTemplate=AnimTree'MET_ShockTrooperProto_AT.AT_ShockTrooperProto'
		AnimSets.Add(AnimSet'MET_ShockTrooperProto.AS_MET_ShockTrooper_Proto')
		AnimSets.Add(AnimSet'MET_ShockTrooperProto.AS_MET_ShockT_Hit_React')
		AnimSets.Add(AnimSet'MET_ShockTrooperProto.AS_MET_ST_Combat_Idle')
		AnimSets.Add(AnimSet'MET_ShockTrooperProto.AS_MET_ST_Combat_Loc')
		AnimSets.Add(AnimSet'REB_AnyaProto.AS_REB_AnyaProto_Civilian')
		AnimSets.Add(AnimSet'MET_ShockTrooper.AS_MET_Shocktrooper_Gore_Deaths')		


		Translation=(Z=-88.0)
	End Object

    // prob wrong anims for this guy
	KnockdownAnimName="Shield_Knockdown"

	bKillDuringLevelTransition=TRUE

	PS_IRIS_FirstEncounter=ParticleSystem'Nano_Iris_Proto.Effects.P_IrisTargeting_Initiate'


	AimAttractors(0)=(OuterRadius=64.f,InnerRadius=4.f,BoneName="b_MF_Spine_02")
	AimAttractors(1)=(OuterRadius=32.f,InnerRadius=10.f,BoneName="b_MF_Head")
	AimAttractors(2)=(OuterRadius=32.f,InnerRadius=10.f,BoneName="b_MF_Calf_L")
	AimAttractors(3)=(OuterRadius=32.f,InnerRadius=10.f,BoneName="b_MF_Calf_R")


}
