/**
 * Base class for  breakable glass actor
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GlassActorBase extends GearDestructibleObject
	abstract;

/** If true, effect should be rotated depending on the direction the glass was shot from */
var() bool bDirectionDependentEffect;
/** Replicated bool to notify clients which direction the effect should play */
var bool bReverseEffectDirection;

replication
{
	if (Role == ROLE_Authority)
		bReverseEffectDirection;
}

simulated event ReplicatedEvent(name VarName)
{	
	if (bDirectionDependentEffect && VarName == nameof(ReplicatedDamageMods))
	{
		//Negate yaw
		if (bReverseEffectDirection)
		{
			SubObjects[0].DamageMods[0].DestroyedEffects[0].RelativeRotation.Yaw = -default.SubObjects[0].DamageMods[0].DestroyedEffects[0].RelativeRotation.Yaw;
		}
		else
		{
			SubObjects[0].DamageMods[0].DestroyedEffects[0].RelativeRotation = default.SubObjects[0].DamageMods[0].DestroyedEffects[0].RelativeRotation;
		}
	}
	Super.ReplicatedEvent(VarName);
}

function TakeDamage(int DamageAmount, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	local vector X,Y,Z;

	if (bDirectionDependentEffect)
	{
		//Determine if we are breaking the default way or the reverse.
		GetAxes(Rotation, X,Y,Z);
		if (Momentum dot Y < 0)
		{
			bReverseEffectDirection = true;
			SubObjects[0].DamageMods[0].DestroyedEffects[0].RelativeRotation.Yaw = -default.SubObjects[0].DamageMods[0].DestroyedEffects[0].RelativeRotation.Yaw;
		}
		else //reset to default
		{
			bReverseEffectDirection = false;
			SubObjects[0].DamageMods[0].DestroyedEffects[0].RelativeRotation = default.SubObjects[0].DamageMods[0].DestroyedEffects[0].RelativeRotation;
		}
	}
	
	Super.TakeDamage(DamageAmount, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
}


DefaultProperties
{
	bDirectionDependentEffect=true

	Begin Object Class=StaticMeshComponent Name=GlassMesh0
		// Set required lighting properties to use lightmaps
		bForceDirectLightMap=TRUE
		bUsePrecomputedShadows=TRUE
		bAllowApproximateOcclusion=TRUE
		LightingChannels=(bInitialized=True,BSP=FALSE,Static=TRUE,Dynamic=FALSE,CompositeDynamic=TRUE)
		LightEnvironment=MyLightEnvironment
		Name="GlassMesh0"
	End Object
	Components.Add(GlassMesh0)
}
