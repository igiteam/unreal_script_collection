class OLEnemySoldier extends OLEnemyPawn
	native(AI)
	placeable; 

var AkEvent SoundLanded;

////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////

function PlayLanded(float impactVel)
{
	Super.PlayLanded(impactVel);

	PlayAkEvent(SoundLanded);
}

////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////


defaultproperties 
{
	Begin Object Name=WPawnSkeletalMeshComponent
		SkeletalMesh=SkeletalMesh'02_Soldier.Pawn.Soldier-03'
		AnimSets.Empty
		AnimSets(0)=AnimSet'03_Soldier.Soldier_V2'
		PhysicsAsset=PhysicsAsset'02_Soldier.Pawn.Soldier-v2_Physics'
	End Object

	BehaviorTree=OLBTBehaviorTree'02_AI_Behaviors.Soldier_BT'

	SubtitleName="Soldier"

	bUseForMusic=true
	bMusicInPatrol=true

	bCanVault=true
	bCanThrow=true
	bUsesDirectionalAttacks=true
	bUseFirstInvestigationInFront=true

	VisionBone=NPCLarge-Head
	HeadBoneName=NPCLarge-Head
	HipBone=NPCLarge

	DoorOpenDistancePush=50.0
	DoorOpenDistancePull=100.0

	DoorBreakDistance=75.0
	DoorChasingBreakDistance=75.0

	WallBashDistance=75.0
	WallBashTime=0.2

	DoorOpenEndOffsetPushLeft=(X=82.29,Y=0.0)
	DoorOpenEndOffsetPushRight=(X=82.29,Y=0.0)
	DoorOpenEndOffsetPullLeft=(X=75.0,Y=0.0)
	DoorOpenEndOffsetPullRight=(X=82.3,Y=0.0)
	DoorOpenEndOffsetPushLeftWithClose=(X=50.0,Y=0.0)
	DoorOpenEndOffsetPushRightWithClose=(X=50.0,Y=0.0)
	DoorOpenEndOffsetPullLeftWithClose=(X=50.0,Y=0.0)
	DoorOpenEndOffsetPullRightWithClose=(X=50.0,Y=0.0)

	DoorBashEndOffset=(X=139.37,Y=0.0)

	LockerInvestigateOffset=(X=93.9,Y=0.0)
	LockerAttackOffset=(X=93.9,Y=0.0)

	BedInvestigateOffsetLeft=(X=-70.0,Y=-103.7)
	BedInvestigateOffsetRight=(X=-70.0,Y=103.7)

	BedAttackOffsetLeft=(X=20.9,Y=-101)
	BedAttackOffsetRight=(X=-43.3,Y=106.4)
		
	FootStepSound_Walk=AkEvent'Soldier_Snd.Footsteps_Walk_Soldier'
	FootStepSound_Run=AkEvent'Soldier_Snd.Footsteps_Run_Soldier'
	SoundLanded=AkEvent'Soldier_Snd.Footsteps_Landing_Soldier'

	SoundEventAmbientStart=AkEvent'Soldier_Snd.Swarm_Possession_Soldier_Play'
	SoundEventAmbientStop=AkEvent'Soldier_Snd.Swarm_Possession_Soldier_Stop'

	SoundEventIdleStart=AkEvent'VO_Soldier.AI_PLAY_SOL_BREATH_IDLE'
	SoundEventIdleStop=AkEvent'VO_Soldier.AI_STOP_SOL_BREATH_IDLE'

	InstantKillDmgType=class'OLDmgType_SoldierDecapitate'
	AttackNormalDmgType=class'OLDmgType_SoldierPunch'
	AttackThrowDmgType=class'OLDmgType_SoldierThrow'	
}