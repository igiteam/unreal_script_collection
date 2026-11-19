class OLLight extends Actor
	ClassGroup(OL,Ingredient)
	placeable;
	
var() StaticMeshComponent LightMesh;
var() StaticMeshComponent FogMesh;
var() SpotLightComponent SpotLight;
	
defaultproperties
{
	Begin Object Class=StaticMeshComponent Name=Mesh0
        StaticMesh=StaticMesh'Lights.Ceilling.Neon_light'
		Materials(0)=MaterialInstanceConstant'Lights.Ceilling.Neon_light_mat'
		bAllowApproximateOcclusion=TRUE
		bForceDirectLightMap=TRUE
		bUsePrecomputedShadows=TRUE
	End Object
	LightMesh=Mesh0
	Components.Add(Mesh0)

	Begin Object Class=StaticMeshComponent Name=Mesh1
		BlockActors=false
		CollideActors=false
        bAllowApproximateOcclusion=True
        bForceDirectLightMap=True
        bUsePrecomputedShadows=True
        LightingChannels=(bInitialized=True,Static=True)
		StaticMesh=StaticMesh'Asylum_effect.Fog.Light_fog'
	End Object
	CollisionType=COLLIDE_NoCollision
	BlockRigidBody=False
	FogMesh=Mesh1
	Components.Add(Mesh1)
	
	
	Begin Object Class=SpotLightComponent Name=CeilingLight
		LightAffectsClassification=LAC_STATIC_AFFECTING
	    CastShadows=TRUE
	    CastStaticShadows=TRUE
	    CastDynamicShadows=FALSE
	    bForceDynamicLight=FALSE
	    UseDirectLightMap=FALSE
		LightingChannels=(BSP=TRUE,Static=TRUE,Dynamic=FALSE,bInitialized=TRUE)
		OuterConeAngle=50.000000
		LightColor=(B=255,G=236,R=223,A=0)
		Rotation=(Pitch=-16384,Yaw=0,Roll=0)
		Translation=(Z=-10)
	End Object
    bMovable=FALSE
	bStatic=TRUE
	SpotLight=CeilingLight
	Components.Add(CeilingLight)
	
}