class OLEnemyGroom extends OLEnemySoldier
	native(AI)
	placeable; 

////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////

function PlayLanded(float impactVel)
{
	Super.PlayLanded(impactVel);

	if (WorldInfo.TimeSeconds < SpawnTime + 2.0f)
	{
		// no sound if just spawned
		return;
	}

	if (SoundLanded != None)
	{
		PlayAkEvent(SoundLanded);
	}
}


defaultproperties 
{
	Begin Object Name=WPawnSkeletalMeshComponent
		SkeletalMesh=SkeletalMesh'02_Groom.Groom_Pre_mutation_1'
		AnimTreeTemplate=AnimTree'02_Behaviors.Enemy.Groom_AnimTree'
		AnimSets(0)=AnimSet'03_NPCLarge_Generic.NpcLargeGeneric-01_AS'
		AnimSets(1)=AnimSet'03_Groom.Groom_AS'
		PhysicsAsset=PhysicsAsset'02_Soldier.Pawn.Soldier-v2_Physics'
	End Object
		
	SubtitleName="Groom"

	FootStepSound_Walk=AkEvent'NPCs_Sounds.Footsteps_Walk_NPC'
	FootStepSound_Run=AkEvent'NPCs_Sounds.Footsteps_Run_NPC'
	
	SoundLanded=None
	SoundEventAmbientStart=None
	SoundEventAmbientStop=None
	SoundEventIdleStart=None
	SoundEventIdleStop=None

	bCanBeKnockedback=false
	bUseAIGroup=false
	bUseAvoidSystem=false	
}