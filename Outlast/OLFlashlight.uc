class OLFlashLight extends InterpActor
	placeable;
	
var() StaticMeshComponent FlashLightMesh;
var() StaticMeshComponent ConeMesh1a;
var() StaticMeshComponent ConeMesh1b;
var() StaticMeshComponent ConeMesh2a;
var() StaticMeshComponent ConeMesh2b;
var() LensFlareComponent LensFlareMesh;
var() SpotLightComponent LightSpotLight;

simulated function OnToggle(SeqAct_Toggle Action)
{
	// Turn ON
	if (Action.InputLinks[0].bHasImpulse)
	{
		ConeMesh1a.SetHidden(false);
		ConeMesh1b.SetHidden(false);
		ConeMesh2a.SetHidden(false);		
		ConeMesh2b.SetHidden(false);
		LensFlareMesh.SetHidden(false);
		LightSpotLight.SetEnabled(true);
	}
	// Turn OFF
	else if (Action.InputLinks[1].bHasImpulse)
	{
		ConeMesh1a.SetHidden(true);
		ConeMesh1b.SetHidden(true);
		ConeMesh2a.SetHidden(true);		
		ConeMesh2b.SetHidden(true);
		LensFlareMesh.SetHidden(true);
		LightSpotLight.SetEnabled(false);
	}
}


defaultproperties
{
	Begin Object Class=DynamicLightEnvironmentComponent Name=MyFLMeshLightEnvironment		
	End Object
	Components.Add(MyFLMeshLightEnvironment)

	Begin Object Class=StaticMeshComponent Name=FlashLightMeshComponent
		StaticMesh=StaticMesh'Lights.FlashLight-01'
		ReplacementPrimitive=None
		CollideActors=False
		BlockRigidBody=False
		LightEnvironment=MyFLMeshLightEnvironment
		LightingChannels=(bInitialized=True,Dynamic=True)
		RBCollideWithChannels=(Default=True,BlockingVolume=True)
	End Object
	FlashLightMesh=FlashLightMeshComponent
	Components.Add(FlashLightMeshComponent)

	Begin Object Class=StaticMeshComponent Name=ConeMesh1aComponent 
		StaticMesh=StaticMesh'Asylum_effect.LightCone-01'
		WireframeColor=(B=255,G=0,R=255,A=255)
		ReplacementPrimitive=None
		LightEnvironment=MyFLMeshLightEnvironment
		CastShadow=False
		CollideActors=False
		BlockRigidBody=False
		Translation=(X=-30.101883,Y=-0.458069,Z=-0.185303)
		Scale3D=(X=3.000000,Y=2.750000,Z=2.750000)
		LightingChannels=(bInitialized=True,Dynamic=True)
		RBCollideWithChannels=(Default=True,BlockingVolume=True)
	End Object
	ConeMesh1a=ConeMesh1aComponent
	Components.Add(ConeMesh1aComponent)

	Begin Object Class=StaticMeshComponent Name=ConeMesh1bComponent 
		StaticMesh=StaticMesh'Asylum_effect.LightCone-02'
		WireframeColor=(B=255,G=0,R=255,A=255)
		ReplacementPrimitive=None
		LightEnvironment=MyFLMeshLightEnvironment
		CastShadow=False
		CollideActors=False
		BlockRigidBody=False
		Translation=(X=-30.101883,Y=-0.458069,Z=-0.185303)
		Scale3D=(X=3.000000,Y=3.250000,Z=3.250000)
		LightingChannels=(bInitialized=True,Dynamic=True)
		RBCollideWithChannels=(Default=True,BlockingVolume=True)
	End Object
	ConeMesh1b=ConeMesh1bComponent
	Components.Add(ConeMesh1bComponent)

	Begin Object Class=StaticMeshComponent Name=ConeMesh2aComponent 
            	StaticMesh=StaticMesh'Asylum_effect.LightCone-03'
		WireframeColor=(B=255,G=0,R=255,A=255)
		ReplacementPrimitive=None
		LightEnvironment=MyFLMeshLightEnvironment
		CastShadow=False
		CollideActors=False
		BlockRigidBody=False
		Translation=(X=-30.101883,Y=-0.458069,Z=-0.185303)
		Scale3D=(X=3.000000,Y=2.000000,Z=2.000000)
		LightingChannels=(bInitialized=True,Dynamic=True)
		RBCollideWithChannels=(Default=True,BlockingVolume=True)
	End Object
	ConeMesh2a=ConeMesh2aComponent
	Components.Add(ConeMesh2aComponent)

	Begin Object Class=StaticMeshComponent Name=ConeMesh2bComponent 
		StaticMesh=StaticMesh'Asylum_effect.LightCone-04'
		WireframeColor=(B=255,G=0,R=255,A=255)
		ReplacementPrimitive=None
		LightEnvironment=MyFLMeshLightEnvironment
		CastShadow=False
		CollideActors=False
		BlockRigidBody=False
		Translation=(X=-30.101883,Y=-0.458069,Z=-0.185303)
		Scale3D=(X=3.000000,Y=2.000000,Z=2.000000)
		LightingChannels=(bInitialized=True,Dynamic=True)
		RBCollideWithChannels=(Default=True,BlockingVolume=True)
	End Object
	ConeMesh2b=ConeMesh2bComponent
	Components.Add(ConeMesh2bComponent)

	Begin Object Class=LensFlareComponent Name=LensFlareMeshComponent
		Template=LensFlare'VFX_LensFlare.flares.FlashLight-01'
		NextTraceTime=-0.901944
		ReplacementPrimitive=None
		MaxDrawDistance=50000.000000
		CachedMaxDrawDistance=50000.000000
		DepthPriorityGroup=SDPG_Foreground
		LightingChannels=(bInitialized=True,Dynamic=True)
		Translation=(X=-36.518829,Y=0,Z=0)
		Rotation=(Pitch=0,Yaw=32768,Roll=0)
	End Object
	LensFlareMesh=LensFlareMeshComponent
	Components.Add(LensFlareMeshComponent)

	Begin Object Class=SpotLightComponent Name=LightSpotLightComponent
            	Begin Object Class=LightFunction Name=LightFunction_0
               		SourceMaterial=MaterialInstanceConstant'Asylum_effect.Light.FlashLight_function_INST'
               		Scale=(X=128.000000,Y=128.000000,Z=128.000000)
               		Name="LightFunction_0"
               		ObjectArchetype=LightFunction'Engine.Default__LightFunction'
           	End Object
		OuterConeAngle=15.000000
		LightShaftConeAngle=50.000000
		CachedParentToWorld=(XPlane=(W=0.000000,X=-0.999882,Y=-0.000000,Z=-0.015339),YPlane=(W=0.000000,X=-0.000000,Y=1.000000,Z=0.000000),ZPlane=(W=0.000000,X=0.015339,Y=0.000000,Z=-0.999882),WPlane=(W=1.000000,X=-32.509068,Y=0.024841,Z=-1.156738))
		LightmassSettings=(LightSourceRadius=32.000000)
		LightGuid=(A=-1469459632,B=1157639902,C=-1920017986,D=-1318663716)
		LightmapGuid=(A=1022433191,B=1302926668,C=-47744875,D=28197039)
            	Brightness=5.000000
            	LightColor=(B=255,G=227,R=205,A=0)
		bPrecomputedLightingIsValid=False
		LightingChannels=(Unnamed_1=True,Unnamed_2=True,Unnamed_3=True,Unnamed_4=True,Unnamed_5=True,Unnamed_6=True)
		LightAffectsClassification=LAC_DYNAMIC_AND_STATIC_AFFECTING
		OcclusionDepthRange=200.000000
		BloomScale=6.000000
		OcclusionMaskDarkness=0.000000
		Translation=(X=-32.509068,Y=0.024841,Z=-1.156738)
		Rotation=(Pitch=0,Yaw=32768,Roll=0)
            	Function=LightFunction'LightFunction_0'
	End Object
	LightSpotLight=LightSpotLightComponent
	Components.Add(LightSpotLightComponent)

	bNoDelete=false
}