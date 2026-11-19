/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearPawnFX_Lambent extends GearPawnFX;

/** curve for fading out chainsaw blood */
var InterpCurveFloat ChainsawBloodFadeCurve;

simulated function BloodDecalChoice_ChainsawSpray_Wall(const out TraceHitInfo HitInfo, out float out_DecalRotation, out DecalData out_DecalData)
{
	Super.BloodDecalChoice_ChainsawSpray_Wall(HitInfo, out_DecalRotation, out_DecalData);
	out_DecalData.DecalMaterial = DecalMaterial'War_Gameplay_Decals.Gears3.Blood.D_Lambent_Blood_Splat_Decal';
	out_DecalData.LifeSpan = 15.0;
}

simulated function BloodDecalChoice_ChainsawSpray_Ground(const out TraceHitInfo HitInfo, out float out_DecalRotation, out DecalData out_DecalData)
{
	Super.BloodDecalChoice_ChainsawSpray_Ground(HitInfo, out_DecalRotation, out_DecalData);
	out_DecalData.DecalMaterial = DecalMaterial'War_Gameplay_Decals.Gears3.Blood.D_Lambent_Blood_Splat_Decal';
	out_DecalData.LifeSpan = 15.0;
}

simulated function SetChainsawBloodParams(MaterialInstanceTimeVarying MI_Decal)
{
	MI_Decal.SetScalarCurveParameterValue('Fade', ChainsawBloodFadeCurve);
}

simulated function SpawnChainsawCameraBlood(PlayerController PC)
{
	if (SpecialMove == SM_ChainsawVictim)
	{
		PC.ClientSpawnCameraLensEffect(class'Emit_CameraBlood_Chainsaw_Lambent');
	}
}

simulated function SpawnBayonetCameraBlood(PlayerController PC)
{
	if (SpecialMove == SM_BayonetVictim)
	{
		PC.ClientSpawnCameraLensEffect(class'Emit_CameraBlood_Bayonet_Lambent');
	}
}

defaultproperties
{
	ChainsawBloodFadeCurve=(Points=((InVal=0.0,OutVal=1.0),(InVal=10.0,OutVal=1.0),(InVal=15.0,OutVal=0.0)))
}
