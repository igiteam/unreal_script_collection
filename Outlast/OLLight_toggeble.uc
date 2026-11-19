class OLLight_toggeble extends SpotLightToggleable
	ClassGroup(OL,Ingredient)
	placeable;
	
var() StaticMeshComponent LightMesh;
var() StaticMeshComponent FogMesh;
//var() SpotLightComponent SpotLight;


defaultproperties
{
	Begin Object Class=StaticMeshComponent Name=Mesh0
        StaticMesh=StaticMesh'Lights.Ceilling.Neon_light'
		Materials(0)=MaterialInstanceConstant'Lights.Ceilling.Neon_light_mat'
		bAllowApproximateOcclusion=TRUE
		bForceDirectLightMap=TRUE
		bUsePrecomputedShadows=TRUE
		Translation=(X=-10)
		Rotation=(Pitch=16384,Yaw=0,Roll=0)
	End Object
	LightMesh=Mesh0
	Components.Add(Mesh0)

	Begin Object Class=StaticMeshComponent Name=Mesh1
		BlockActors=false
		CollideActors=false
        CastShadow=False
		bAcceptsLights=False
		StaticMesh=StaticMesh'Asylum_effect.Fog.Light_fog'
		Translation=(X=-10)
		Rotation=(Pitch=16384,Yaw=0,Roll=0)
	End Object
	CollisionType=COLLIDE_NoCollision
	BlockRigidBody=False
	FogMesh=Mesh1
	Components.Add(Mesh1)
	
	// Visual things should be ticked in parallel with physics
	TickGroup=TG_DuringAsyncWork

	Begin Object Name=Sprite
		Sprite=none
	End Object

	// Light component.
	Begin Object Name=SpotLightComponent0
	    LightAffectsClassification=LAC_STATIC_AFFECTING
	    CastShadows=TRUE
	    CastStaticShadows=TRUE
	    CastDynamicShadows=FALSE
	    bForceDynamicLight=FALSE
	    UseDirectLightMap=FALSE
		LightingChannels=(BSP=TRUE,Static=TRUE,Dynamic=FALSE,bInitialized=TRUE)
            InnerConeAngle=40.000000
            OuterConeAngle=70.000000
		LightColor=(B=255,G=236,R=223,A=0)
        // By default indirect light from toggleable lights won't be put into lightmaps, since it can't be toggled in-game
        LightmassSettings=(IndirectLightingScale=0)
	End Object

    Rotation=(Pitch=-16384,Yaw=0,Roll=0)
	bMovable=FALSE
	bStatic=FALSE
	bHardAttach=TRUE
	bHidden=False

}
