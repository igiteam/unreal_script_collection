class OLSoundConnector extends Actor
	native
	placeable;

var DrawSphereComponent SpherePreviewComp;
var DrawBoxComponent BoxPreviewComp;
var() OLSoundConnectorComponent SoundConnectorComp;
var() float OcclusionFactor;

cpptext
{
	virtual void SetVolumes(const TArray<class AVolume*>& Volumes);
	
#if WITH_EDITOR
	virtual void PostEditChangeProperty(FPropertyChangedEvent& PropertyChangedEvent);
	virtual void PostLoad();
	void UpdatePreviewShapes();
	virtual void CheckForErrors();
#endif
}

simulated function OnToggle(SeqAct_Toggle Action)
{
	// Turn ON
	if (Action.InputLinks[0].bHasImpulse)
	{
		SoundConnectorComp.bEnabled = true;
	}
	// Turn OFF
	else if (Action.InputLinks[1].bHasImpulse)
	{
		SoundConnectorComp.bEnabled = false;
	}
	// Toggle
	else if (Action.InputLinks[2].bHasImpulse)
	{
		SoundConnectorComp.bEnabled = !SoundConnectorComp.bEnabled;
	}
}

defaultproperties
{
	Begin Object Class=SpriteComponent Name=Sprite
		Sprite=Texture2D'EditorResources.AmbientSoundIcons.S_Ambient_Sound_Non_Loop'
		Scale=0.15
		SpriteCategoryName="OutlastSound"
		HiddenGame=true
		HiddenEditor=false
		AlwaysLoadOnClient=False
		AlwaysLoadOnServer=False		
	End Object
	Components.Add(Sprite)
	
	Begin Object Class=DrawSphereComponent Name=SphereComp
		CollideActors=False
		BlockActors=False
		BlockZeroExtent=False
		BlockNonZeroExtent=False
		BlockRigidBody=False
		SphereRadius=100.0
		Translation=(Z=100.0)
		AbsoluteScale=true
		HiddenGame=true
	End Object
	SpherePreviewComp=SphereComp
	Components.Add(SphereComp)

	Begin Object Class=DrawBoxComponent Name=BoxComp
		CollideActors=False
		BlockActors=False
		BlockZeroExtent=False
		BlockNonZeroExtent=False
		BlockRigidBody=False
		BoxExtent=(X=25.0, Z=50.0, Y=300.0)
		Translation=(Z=100.0)
		AbsoluteScale=true
		HiddenGame=true
		HiddenEditor=true
	End Object
	BoxPreviewComp=BoxComp
	Components.Add(BoxComp)

	Begin Object Class=OLSoundConnectorComponent Name=SoundConnectorComponent
	End Object
	SoundConnectorComp=SoundConnectorComponent
	Components.Add(SoundConnectorComponent)

	OcclusionFactor=0.0
}
