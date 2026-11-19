class OLSoundEnvironmentVolume extends Volume
	native
	placeable;
	
var() bool bUseForOcclusion;
var() OLSoundEnvironment SoundEnvironment;
var() array<AkEvent> OnEnterEvents;
var() array<AkEvent> OnExitEvents;

/** Distance (in cm) for the reverb contribution to fade in or out */
var() float FadeDistance;

enum EVolumePriority
{
	EVP_VeryLow,
	EVP_Low,
	EVP_Normal,
	EVP_High,
	EVP_VeryHigh
};
var() EVolumePriority Priority;

var transient array<OLSoundConnectorComponent> Connections;

var transient bool bInitialized; // whether encompass checks have been made

event PostBeginPlay()
{
	Super.PostBeginPlay();
	bInitialized = false;	
}

cpptext
{
	virtual void PostEditChangeProperty(FPropertyChangedEvent& PropertyChangedEvent);
	void RegisterOnStaticEmitters(TArray<UOLSoundEmitter*>& sndSources);
}

defaultproperties
{	
	Priority=EVP_Normal

	Begin Object Name=BrushComponent0
		CollideActors=true
		BlockActors=false
		BlockZeroExtent=true
		BlockNonZeroExtent=true
		BlockRigidBody=false
	End Object

	FadeDistance=150.0

	bColored=true
	BrushColor=(R=0,G=200,B=200,A=255)

	bUseForOcclusion=true
	bProcessAllSkeletalMeshActors=true
}
