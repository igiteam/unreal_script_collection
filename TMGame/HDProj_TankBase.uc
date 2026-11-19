/**
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */
class HDProj_TankBase extends HDProjectile;

var array<ParticleSystem> subProjExplosionTemplates;
var ParticleSystem CurrsubProjExplosionTemplate;
var ParticleSystem DefaultProjExplosionTemplate;
simulated function PostBeginPlay()
{
	// force ambient sound if not vehicle game mode
	bImportantAmbientSound = !WorldInfo.bDropDetail;
	Super.PostBeginPlay();
}

simulated function SpawnExplosionEffects(vector HitLocation, vector HitNormal)
{
	local vector LightLoc, LightHitLocation, LightHitNormal;
	local vector Direction;
	local ParticleSystemComponent ProjExplosion;
	local Actor EffectAttachActor;
	local MaterialInstanceTimeVarying MITV_Decal;

	if (WorldInfo.NetMode != NM_DedicatedServer)
	{
		if (ProjectileLight != None)
		{
			DetachComponent(ProjectileLight);
			ProjectileLight = None;
		}
		if (ProjExplosionTemplate != None && EffectIsRelevant(Location, false, MaxEffectDistance))
		{
			EffectAttachActor = (bAttachExplosionToVehicles || (TMVehicle(ImpactedActor) == None)) ? ImpactedActor : None;
			if (!bAdvanceExplosionEffect)
			{
				ProjExplosion = WorldInfo.MyEmitterPool.SpawnEmitter(ProjExplosionTemplate, HitLocation, /*rot(-16384,0,0)+rotator(HitNormal)*/, EffectAttachActor);
				if(CurrsubProjExplosionTemplate != none)
				{
                    WorldInfo.MyEmitterPool.SpawnEmitter(CurrsubProjExplosionTemplate, HitLocation, /*rot(-16384,0,0)+rotator(HitNormal)*/, EffectAttachActor);
                }
			}
			else
			{
				Direction = normal(Velocity - 2.0 * HitNormal * (Velocity dot HitNormal)) * Vect(1,1,0);
				ProjExplosion = WorldInfo.MyEmitterPool.SpawnEmitter(ProjExplosionTemplate, HitLocation, /*rotator(Direction)*/, EffectAttachActor);
				if(CurrsubProjExplosionTemplate != none)
				{
                    WorldInfo.MyEmitterPool.SpawnEmitter(CurrsubProjExplosionTemplate, HitLocation, /*rotator(Direction)*/, EffectAttachActor);
                }
				ProjExplosion.SetVectorParameter('Velocity',Direction);
				ProjExplosion.SetVectorParameter('HitNormal',HitNormal);
			}
			SetExplosionEffectParameters(ProjExplosion);

			if ( !WorldInfo.bDropDetail && ((ExplosionLightClass != None) || (ExplosionDecal != none)) && ShouldSpawnExplosionLight(HitLocation, HitNormal) )
			{
				if ( ExplosionLightClass != None )
				{
					if (Trace(LightHitLocation, LightHitNormal, HitLocation + (0.25 * ExplosionLightClass.default.TimeShift[0].Radius * HitNormal), HitLocation, false) == None)
					{
						LightLoc = HitLocation + (0.25 * ExplosionLightClass.default.TimeShift[0].Radius * (vect(1,0,0) >> ProjExplosion.Rotation));
					}
					else
					{
						LightLoc = HitLocation + (0.5 * VSize(HitLocation - LightHitLocation) * (vect(1,0,0) >> ProjExplosion.Rotation));
					}

					TMEmitterPool(WorldInfo.MyEmitterPool).SpawnExplosionLight(ExplosionLightClass, LightLoc, EffectAttachActor);
				}

				// this code is mostly duplicated in:  TMGib, TMProjectile, TMVehicle, TMWeaponAttachment be aware when updating
				if (ExplosionDecal != None && Pawn(ImpactedActor) == None )
				{
					if( MaterialInstanceTimeVarying(ExplosionDecal) != none )
					{
						// hack, since they don't show up on terrain anyway
						if ( Terrain(ImpactedActor) == None )
						{
						MITV_Decal = new(self) class'MaterialInstanceTimeVarying';
						MITV_Decal.SetParent( ExplosionDecal );

						WorldInfo.MyDecalManager.SpawnDecal(MITV_Decal, HitLocation, rotator(-HitNormal), DecalWidth, DecalHeight, 10.0, FALSE );
						//here we need to see if we are an MITV and then set the burn out times to occur
						MITV_Decal.SetScalarStartTime( DecalDissolveParamName, DurationOfDecal );
					}
					}
					else
					{
						WorldInfo.MyDecalManager.SpawnDecal( ExplosionDecal, HitLocation, rotator(-HitNormal), DecalWidth, DecalHeight, 10.0, true );
					}
				}
			}
		}

		if (ExplosionSound != None && !bSuppressSounds)
		{
			PlaySound(ExplosionSound, true);
		}

		bSuppressExplosionFX = true; // so we don't get called again
	}
}

simulated function bool ProjectileHurtRadius2( float DamageAmount, float InDamageRadius, class<DamageType> DamageType, float Momentum,
						vector HurtOrigin, vector HitNormal, optional class<DamageType> ImpactedActorDamageType )
{
	local bool bCausedDamage, bInitializedAltOrigin, bFailedAltOrigin;
	local Actor	Victim;
	local vector AltOrigin;

    local vector AltOrigin2, TraceHitLocation, TraceHitNormal;
	local Actor TraceHitActor;
    local TraceHitInfo HitInfo;
    local name PhyMatTypeName;
    local Box BBox;
    local vector /*AltOrigin,*/ BBoxCenter;
	// Prevent HurtRadius() from being reentrant.
	if ( bHurtEntry || bShuttingDown )
		return false;

	bHurtEntry = true;
	bCausedDamage = false;

	// if ImpactedActor is set, we actually want to give it full damage, and then let him be ignored by super.HurtRadius()
	if ( (ImpactedActor != None) && (ImpactedActor != self)  )
	{
		ImpactedActor.TakeRadiusDamage( InstigatorController, DamageAmount, InDamageRadius,
						(ImpactedActorDamageType != None) ? ImpactedActorDamageType : DamageType,
						Momentum, HurtOrigin, true, self );
		// need to check again in case TakeRadiusDamage() did something that went through our explosion path a second time
		if (ImpactedActor != None)
		{
			bCausedDamage = ImpactedActor.bProjTarget;
		}
	}

	foreach OverlappingActors( class'Actor', Victim, DamageRadius, HurtOrigin, false )
	{
		if ( !Victim.bWorldGeometry && (Victim != self) && (Victim != ImpactedActor) && (Victim.bProjTarget || (NavigationPoint(Victim) == None)) )
		{
		   ;
    	    Victim.GetComponentsBoundingBox(BBox);
			BBoxCenter = (BBox.Min + BBox.Max) * 0.5f;
			if ( !FastTrace(HurtOrigin, BBoxCenter,, TRUE) )
			{
				// try out from wall, in case trace start was embedded
				if ( !bInitializedAltOrigin )
				{
					// initialize alternate trace start
					bInitializedAltOrigin = true;
					AltOrigin = HurtOrigin + class'TMPawn'.Default.MaxStepHeight * HitNormal;
					if ( !FastTrace(HurtOrigin, AltOrigin,, TRUE) )
					{
						if ( Velocity == vect(0,0,0) )
						{
							bFailedAltOrigin = true;
						}
						else
						{
							AltOrigin = HurtOrigin - class'TMPawn'.Default.MaxStepHeight * normal(Velocity);
							bFailedAltOrigin = !FastTrace(HurtOrigin, AltOrigin,, TRUE);
						}
					}
				}
				if ( bFailedAltOrigin || !FastTrace(AltOrigin, BBoxCenter,, TRUE) )
				{
					continue;
				}
			}
			Victim.TakeRadiusDamage(InstigatorController, DamageAmount, DamageRadius, DamageType, Momentum, HurtOrigin, false, self);
			bCausedDamage = bCausedDamage || Victim.bProjTarget;
		}
	}
	bHurtEntry = false;
    AltOrigin2 = HurtOrigin + 10 * HitNormal;
    HurtOrigin = HurtOrigin + 10 * (-HitNormal);
    TraceHitActor = Trace(TraceHitLocation, TraceHitNormal, HurtOrigin, AltOrigin2,false,,HitInfo,TRACEFLAG_Bullet);
    ProjExplosionTemplate = DefaultProjExplosionTemplate;
    if(TraceHitActor != none)
    {
       PhyMatTypeName = TMPhysicalMaterialProperty(HitInfo.PhysMaterial.GetPhysicalMaterialProperty(class'TMPhysicalMaterialProperty')).MaterialType;
       if(PhyMatTypeName == 'Grass')
       {
         CurrsubProjExplosionTemplate = subProjExplosionTemplates[0];
       }
       else if(PhyMatTypeName == 'Foliage')
       {
         CurrsubProjExplosionTemplate = subProjExplosionTemplates[1];
       }
       else if(PhyMatTypeName == 'Metal')
       {
         CurrsubProjExplosionTemplate = subProjExplosionTemplates[2];
       }
       else if(PhyMatTypeName == 'Stone')
       {
         CurrsubProjExplosionTemplate = subProjExplosionTemplates[3];
       }
       else if(PhyMatTypeName == 'Wood')
       {
         CurrsubProjExplosionTemplate = subProjExplosionTemplates[4];
       }
       else if(PhyMatTypeName == 'Water')
       {
          ProjExplosionTemplate = subProjExplosionTemplates[5];
          CurrsubProjExplosionTemplate = none;
       }
       else
       {
         CurrsubProjExplosionTemplate = none;
       }
    }
	return bCausedDamage;
}

//simulated function MaterialImpactEffect GetImpactEffect(PhysicalMaterial HitMaterial)
//{
//	local int i;
//	local TMPhysicalMaterialProperty PhysicalProperty;
//
//	if (HitMaterial != None)
//	{
//		PhysicalProperty = TMPhysicalMaterialProperty(HitMaterial.GetPhysicalMaterialProperty(class'TMPhysicalMaterialProperty'));
//	}
//	if (TMPawn(Owner).FiringMode > 0)
//	{
//		if (PhysicalProperty != None && PhysicalProperty.MaterialType != 'None')
//		{
//			i = AltImpactEffects.Find('MaterialType', PhysicalProperty.MaterialType);
//			if (i != -1)
//			{
//				return AltImpactEffects[i];
//			}
//		}
//		return DefaultAltImpactEffect;
//	}
//	else
//	{
//		if (PhysicalProperty != None && PhysicalProperty.MaterialType != 'None')
//		{
//			i = ImpactEffects.Find('MaterialType', PhysicalProperty.MaterialType);
//			if (i != -1)
//			{
//				return ImpactEffects[i];
//			}
//		}
//		return DefaultImpactEffect;
//	}
//}

