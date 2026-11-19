class OLEnemySurgeon extends OLEnemyGenericPatient
	native(AI)
	placeable; 

var AnimSet SurgeonSpecificAnimSet;

////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////

var SkeletalMeshComponent BoneShears;

cpptext
{
	virtual void OnPlayWeaponAnimNotify(UAnimNodeSequence* animNodeSeq);
}

simulated event BuildScriptAnimSetList()
{
	local array<AnimSet> AnimSets;

	Super.BuildScriptAnimSetList();

	AnimSets.AddItem(SurgeonSpecificAnimSet);
	AddAnimSets(AnimSets);
}

native function NativeOnAnimEnd(AnimNodeSequence seqNode, float playedTime, float excessTime);

////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////

defaultproperties 
{
	SubtitleName="Surgeon"
	
	bCanBeKnockedback=false
	bUseAIGroup=false
	bUseAvoidSystem=false

	SurgeonSpecificAnimSet=AnimSet'03_NPCMedium_Generic.NpcSurgeon-01_AS'		
	
	Begin Object Class=AnimNodeSequence Name=BoneShearsAnimSeq
		bCauseActorAnimEnd=true
	End Object

	Begin Object Class=SkeletalMeshComponent Name=BoneShearsComponent
		CastShadow=true
		bCastDynamicShadow=true
		BlockRigidBody=false
		BlockActors=false
		CollideActors=false
		HiddenGame=True
		bIgnoreControllersWhenNotRendered=true
		bUpdateKinematicBonesFromAnimation=false	
		Translation=(Z=0.0)
		LightEnvironment=MyLightEnvironment
		bOverrideAttachmentOwnerVisibility=true
		bAcceptsDynamicDecals=FALSE
		LightingChannels=(bInitialized=True,BSP=True,Static=True,Dynamic=True,CompositeDynamic=True,Skybox=True,Unnamed_1=True,Unnamed_2=True,Unnamed_3=True,Unnamed_4=True,Unnamed_5=True,Unnamed_6=True,Cinematic_1=True,Cinematic_2=True,Cinematic_3=True,Cinematic_4=True,Cinematic_5=True,Dynamic_1=True,Dynamic_2=True,Dynamic_3=True,Dynamic_4=True,Dynamic_5=True,Gameplay_1=True,Gameplay_2=True,Gameplay_3=True,Gameplay_4=True)
		bHasPhysicsAssetInstance=false
		TickGroup=TG_PreAsyncWork
		MinDistFactorForKinematicUpdate=0.2
		bChartDistanceFactor=true
		ShadowParent=WPawnSkeletalMeshComponent
		bPerBoneMotionBlur=false
		SkeletalMesh=SkeletalMesh'01_Animated_Props.SurgeonWeapon.SurgeonWeapon_GP'
		Rotation=(Pitch=0,Yaw=0,Roll=0)
		AnimSets(0)=AnimSet'01_Animated_Props.SurgeonWeapon.SurgeonWeapon_GP-AS'
		Animations=BoneShearsAnimSeq
	End Object
	BoneShears=BoneShearsComponent
}