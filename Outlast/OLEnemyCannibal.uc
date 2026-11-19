class OLEnemyCannibal extends OLEnemyGenericPatient
	native(AI)
	placeable; 

////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////

var AnimSet CannibalSpecificAnimSet;
var SkeletalMeshComponent CannibalDrill;

cpptext
{
	virtual void OnPlayWeaponAnimNotify(UAnimNodeSequence* animNodeSeq);
}

simulated event BuildScriptAnimSetList()
{
	local array<AnimSet> AnimSets;

	Super.BuildScriptAnimSetList();

	AnimSets.AddItem(CannibalSpecificAnimSet);
	AddAnimSets(AnimSets);
}

event HideWeapon()
{
	Super.HideWeapon();
	NativeHideWeapon();
}

native function NativeHideWeapon();
native function NativeOnAnimEnd(AnimNodeSequence seqNode, float playedTime, float excessTime);

////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////


defaultproperties 
{
	Begin Object Name=WPawnSkeletalMeshComponent
		SkeletalMesh=SkeletalMesh'02_Cannibal.Cannibal'
		AnimTreeTemplate=AnimTree'02_Behaviors.Enemy.Generic_AnimTree'
	End Object
	
	Begin Object Class=AnimNodeSequence Name=CannibalDrillAnimSeq
		bCauseActorAnimEnd=true
	End Object

	Begin Object Class=SkeletalMeshComponent Name=CannibalDrillComponent
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
		SkeletalMesh=SkeletalMesh'02_Cannibal.cannibal_drill'
		Rotation=(Pitch=0,Yaw=0,Roll=0)
		AnimSets(0)=AnimSet'03_Cannibal.Cannidrill-01_AS'
		Animations=CannibalDrillAnimSeq
	End Object
	CannibalDrill=CannibalDrillComponent
	
	FootStepSound_Walk=AkEvent'DLC_SFX_build1.Footsteps_Walk_Cannibal'
	FootStepSound_Run=AkEvent'DLC_SFX_build1.Footsteps_Run_Cannibal'

	CannibalSpecificAnimSet=AnimSet'03_Cannibal.Cannibal_AS'

	SubtitleName="Cannibal"

	bCanBeKnockedback=false
	bUseAIGroup=false
	bUseAvoidSystem=false	
}