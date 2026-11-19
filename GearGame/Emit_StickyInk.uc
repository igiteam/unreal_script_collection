/**
 * Semi-persistent bits of fire stuck to the world.  Deposited by flamethrower, etc.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class Emit_StickyInk extends Emit_StickyFire
	config(Weapon);

var() protected const float DecalFadeInkOutTime;

simulated protected function ScorchDecalChoiceFunc_StickyFire( const out TraceHitInfo HitInfo, out float out_DecalRotation, out DecalData out_DecalData )
{
	out_DecalData = class'GearPhysicalMaterialProperty'.static.GetBloodDecalData( class'GearPhysicalMaterialProperty'.static.GetImpactPhysicalMaterialHitInfo( Hitinfo ), GDDT_StickyInk, WorldInfo );
	out_DecalData.ClipDecalsUsingFastPath = false;
	//`log("choicefunc called!"@out_DecalRotation@Hitinfo.PhysMaterial@out_DecalData.DecalMaterial);

	if (out_DecalData.bRandomizeRotation)
	{
		out_DecalRotation = FRand() * 360.0;
	}
}

simulated function Tick(float DeltaTime)
{
	local float InkFade;

	super.Tick(DeltaTime);

	if ( CurrentTime > RandomizedTotalBurnTime )
	{
		// fade to 50% over DecalFadeInkOutTime sec
		InkFade = (1.f - FMin((CurrentTime - RandomizedTotalBurnTime) / DecalFadeInkOutTime, 1.f));
		InkFade = InkFade * 0.5f + 0.5f;
		MIC_ScorchDecal.SetScalarParameterValue('Fade', InkFade);
	}
}

defaultproperties
{
	ParticleSystem=ParticleSystem'Weap_Ink_Grenade.Effects.P_Weap_Ink_Grenade_Ring_Ink'
	// ParticleSystem'Weap_Ink_Grenade.Effects.P_Weap_Ink_Grenade_Ring_Ink'  smaller inks

	ChanceToDrip=0.f

	DecalFadeInkOutTime=5.f
	DecalFadeCharInTime=0.25f

	Begin Object Name=CollisionCylinder0
		CollisionRadius=+0100.000000
		CollisionHeight=+0050.00000
	End Object

	Begin Object Name=ParticleSystemComponent0
		TranslucencySortPriority=1
	End Object

	DamageType=class'GDT_InkGrenade'

	bDrawDebug=0
}

