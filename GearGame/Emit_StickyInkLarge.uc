/** 
 * Semi-persistent bits of fire stuck to the world.  Deposited by flamethrower, etc.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class Emit_StickyInkLarge extends Emit_StickyInk
	config(Weapon);

simulated protected function ScorchDecalChoiceFunc_StickyFire( const out TraceHitInfo HitInfo, out float out_DecalRotation, out DecalData out_DecalData )
{
	out_DecalData = class'GearPhysicalMaterialProperty'.static.GetBloodDecalData( class'GearPhysicalMaterialProperty'.static.GetImpactPhysicalMaterialHitInfo( Hitinfo ), GDDT_StickyInkLarge, WorldInfo );
	out_DecalData.ClipDecalsUsingFastPath = false;
	//`log("choicefunc called!"@out_DecalRotation@Hitinfo.PhysMaterial@out_DecalData.DecalMaterial);

	if( out_DecalData.bRandomizeRotation == TRUE )
	{
		out_DecalRotation = FRand() * 360.0f;
	}
}

defaultproperties
{
//	Sound=None
	ParticleSystem=ParticleSystem'Weap_Ink_Grenade.Effects.P_Weap_Ink_Grenade_Core_Ink'
	// ParticleSystem'Weap_Ink_Grenade.Effects.P_Weap_Ink_Grenade_Ring_Ink'  smaller inks

// 
// 	LifeSpan=0.f
// 
// 	bDestroyOnSystemFinish=false
// 	bReplicateInstigator=TRUE	
// 	bNetTemporary=TRUE
// 	RemoteRole=ROLE_SimulatedProxy
// 
// 	bCollideActors=true
// 	Begin Object Class=CylinderComponent Name=CollisionCylinder0
// 		CollisionRadius=+0032.000000
// 		CollisionHeight=+0032.00000
// 		CollideActors=TRUE
// 	End Object
// 	CollisionComponent=CollisionCylinder0
// 	Components.Add(CollisionCylinder0)
// 
// 	RandomizedScaleRange=(X=0.5,Y=1.8)
// 
// 	DamageApplicationInterval=0.25f
// 
// 	DripParticleSystem=None
// 	ChanceToDrip=0.f
// 	DrippingZThreshold=-999.f       // no dripping
// 
// 	Begin Object Class=MaterialInstanceConstant Name=MIC_ScorchDecal0
// 	End Object
// 	MIC_ScorchDecal=MIC_ScorchDecal0
// 
// 	DecalFadeCharInTime=0.4f
// 	DecalFadeEmbersInTime=0.6f
// 	DecalFadeEmbersOutTime=1.f

	DamageType=class'GDT_InkGrenade'

	bDrawDebug=0
}

