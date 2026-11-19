class OLEnemyGenericPatient extends OLEnemyPawn
	native(AI)
	placeable; 

////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////


defaultproperties 
{
	Begin Object Name=WPawnSkeletalMeshComponent
		SkeletalMesh=SkeletalMesh'02_Generic_Patient.Pawn.Generic_Patient'
		AnimTreeTemplate=AnimTree'02_Behaviors.Enemy.Generic_AnimTree'
	End Object

	WeaponAnimSets(0)=AnimSet'03_NPCMedium_Generic.NpcMediumGenericWeapon-01_AS'

	SubtitleName="Patient"

	bCloseDoorInPatrol=true
	bUseAIGroup=true
	bCanVault=true
	bCanBeKnockedback=true
	bUsesDirectionalAttacks=true

	bUsesDoorBashLoop=true
	bUseAvoidSystem=true

	DoorOpenDistancePush=70.0
	DoorOpenDistancePull=100.0

	DoorBreakDistance=50.0
	DoorChasingBreakDistance=50.0

	NormalDropDownDistance=50.0
	NormalClimbUpDistance=50.0
	ChasingDropDownDistance=50.0
	ChasingClimbUpDistance=50.0

	WallBashDistance=160.0
	WallBashTime=0.5

	TableBashDistance=281.0
	
	DoorOpenEndOffsetPushLeft=(X=158.86,Y=10.202)
	DoorOpenEndOffsetPushRight=(X=165.85,Y=-2.674)
	DoorOpenEndOffsetPullLeft=(X=78.63,Y=3.01)
	DoorOpenEndOffsetPullRight=(X=105.49,Y=-2.55)
	DoorOpenEndOffsetPushLeftWithClose=(X=158.86,Y=10.202)
	DoorOpenEndOffsetPushRightWithClose=(X=165.85,Y=-2.674)
	DoorOpenEndOffsetPullLeftWithClose=(X=90.0,Y=1.259)
	DoorOpenEndOffsetPullRightWithClose=(X=90.0,Y=1.259)

	DoorBashEndOffset=(X=150.0,Y=4.147)

	LockerInvestigateOffset=(X=88.87,Y=0.0)
	LockerAttackOffset=(X=88.87,Y=0.0)

	BedInvestigateOffsetLeft=(X=-50.0,Y=-150)
	BedInvestigateOffsetRight=(X=-50.0,Y=150)
	BedAttackOffsetLeft=(X=-43.307,Y=-147.29)
	BedAttackOffsetRight=(X=6.693,Y=152.71)

	GrabTargetVelocity=20.0

	SqueezeAttackOffset=(X=75,Y=29.6,Z=0.0)
}