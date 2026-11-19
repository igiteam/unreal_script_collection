/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoSlickifyArea extends Actor;

var	CylinderComponent CylinderComponent;


var protected transient NanoDecal MyNanoDecal;


simulated event PostBeginPlay()
{
	Super.PostBeginPlay();

	SpawnEffectDecal();

}

simulated function Destroyed()
{
	MyNanoDecal.DetachFromAny();
	Super.Destroyed();
}




simulated function SpawnEffectDecal()
{
	MyNanoDecal = NanoGRI(WorldInfo.GRI).LeaveADecalWorld( DecalTrace_StraightDown, DecalChoice_Default, DecalTimeVaryingParams_Default, Location );
}


protected simulated delegate DecalTrace_StraightDown( out vector out_TraceStart, out vector out_TraceDest, const float RandomOffsetRadius, optional vector ForceStartLocation )
{
	out_TraceStart = ForceStartLocation + ( Vect(0,0,15));
	out_TraceDest =  out_TraceStart - ( Vect(0,0,100));
}

/** This is the Delegate for the Decal Choice Policy for LeaveADecal **/
protected simulated delegate DecalChoice_Default( const out TraceHitInfo HitInfo, out float out_DecalRotation, out DecalData out_DecalData )
{
	local DecalData DD;

	DD.Width=128.0f;
	DD.Height=128.0f;

	DD.DecalMaterial = MaterialInstanceTimeVarying'Gear_Blood.Decals.MITV_BloodSmear_Var01_Spot_6';

	out_DecalData = DD;	
}

/** This is the Delegate for the MITV Params Policy for LeaveADecal **/
protected simulated delegate DecalTimeVaryingParams_Default( out MaterialInstance MI_Decal )
{

}




simulated event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
	if( NanoInterface_SlickifyAffect(Other) != none )
	{
		// here we want to notify the pawn that it is has touched a slicked area
		NanoInterface_SlickifyAffect(Other).OnSlickify();
	}
}



defaultproperties
{
	bCollideActors=TRUE
	bNoDelete=FALSE
	bMovable=TRUE
	bGameRelevant=TRUE

	RemoteRole=ROLE_SimulatedProxy


	Begin Object Class=SpriteComponent Name=Sprite
		Sprite=Texture2D'EditorResources.S_Actor'
		HiddenGame=FALSE
		AlwaysLoadOnClient=TRUE
		AlwaysLoadOnServer=TRUE
	End Object
	//Components.Add(Sprite)


	Begin Object Class=CylinderComponent Name=CollisionCylinder
		CollisionRadius=+0064.000000
		CollisionHeight=+0016.000000
		BlockZeroExtent=FALSE
		CollideActors=TRUE
		HiddenGame=FALSE
		AlwaysLoadOnClient=TRUE
		AlwaysLoadOnServer=TRUE
	End Object
	CollisionComponent=CollisionCylinder
	CylinderComponent=CollisionCylinder
	Components.Add(CollisionCylinder)


	Begin Object Class=NanoParticleSystemComponent Name=ParticleSystemComponent0
	    Template=ParticleSystem'COG_Mortar.Effects.P_Mortar_Plant'
		bAutoActivate=TRUE
	End Object
	//ParticleSystemComponent=ParticleSystemComponent0
	Components.Add(ParticleSystemComponent0)

	// for now just leave these around for 30 seconds
	LifeSpan=30.0f
}
