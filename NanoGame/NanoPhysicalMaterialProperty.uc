/**
 * This is out game specific PhysicalMaterial property holder.  It holds all of the
 * data / references to objects that a single PhysicalMaterial type needs.
 *
 * e.g. For the Wood PhysicalMaterial we need to have ImpactEffects, ImpactSounds
 * Footsteps, and eventually decals.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoPhysicalMaterialProperty extends PhysicalMaterialPropertyBase
	native
	collapsecategories
	editinlinenew
	hidecategories(Object)
	dependson(NanoTypes);


// this should be promoted to GameFramework


/** This is the version for the phys material.  This is primary used to have nice ordered effects as they are indexed by enum value **/
var int Version;


struct native ImpactFXBase
{
	/** Information on the impact decal */
	var() editinline array<DecalData> DecalData;
	/** Information on the impact decal when active reload is active */
	var() editinline array<DecalData> DecalData_AR;
	/** Information on the impact decal for no gore setting */
	var() editinline array<DecalData> DecalData_NoGore;
	/** Information on the impact decal for no gore setting with AR */
	var() editinline array<DecalData> DecalData_NoGore_AR;

	/** Sound cue to play when impacting this surface */
	var() SoundCue ImpactCue;

	/** Particle system to use for impacts */
	var() ParticleSystem ImpactPS;
	/** Particle system to use for impacts when perf is low*/
	var() ParticleSystem ImpactPS_ForSlowPerf;

	/** Particle system to use for Active Reload impacts */
	var() ParticleSystem ImpactPS_AR;
	/** Particle system to use for Active Reload impacts when perf is low */
	var() ParticleSystem ImpactPS_AR_ForSlowPerf;

	/** Particle system to use for impacts for no gore setting */
	var() ParticleSystem ImpactPS_NoGore;
	/** Particle system to use for impacts for no gore setting when perf is low */
	var() ParticleSystem ImpactPS_NoGore_ForSlowPerf;

	/** Particle system to use for impacts for no gore setting with AR */
	var() ParticleSystem ImpactPS_NoGore_AR;
	/** Particle system to use for impacts for no gore setting when perf is low with AR */
	var() ParticleSystem ImpactPS_NoGore_ForSlowPerf_AR;

	/** Play this CameraEffect when ever damage of this type is given.  This will primarily be used by explosions.  But could be used for other impacts too! **/
	var() class<Emit_NanoCameraLensEffectBase> CameraEffect;

	/** This is the radius to play the camera effect on **/
	var() float CameraEffectRadius;

	structdefaultproperties
	{
		CameraEffectRadius=800
	}
};



/** All the information needed by weapons per material type */
struct native ImpactFXBallistic extends ImpactFXBase
{
	/** This is for the sake of editing, knowing which entry is which weapon.  It is filled in by PostLoad(). */
	var() const editconst EImpactTypeBallistic Type;

	/** This is the particle system to use for exit wound spray.  If this not not set then no exit wound particle system **/
	var() ParticleSystem ExitWoundPS;
	/** This is the particle system to use for exit wound spray.  If this not not set then no exit wound particle system when perf is low **/
	var() ParticleSystem ExitWoundPS_ForSlowPerf;
};


/** All the information needed by weapons per material type */
struct native ImpactFXExplosion extends ImpactFXBase
{
	/** This is for the sake of editing, knowing which entry is which weapon.  It is filled in by PostLoad(). */
	var() const editconst EImpactTypeExplosion Type;

	/** This is the fog volume archetype which should be spawned.  This will primarily be used by explosions.  But could be used for other impacts too! **/
	var() Object FogVolumeArchetype;

	/** This is the fog volume archetype which should be spawned for slow perf situations.  This will primarily be used by explosions.  But could be used for other impacts too! **/
	var() Object FogVolumeArchetype_ForSlowPerf;
};



/**
 * This is a nice way to set the same FXInfo for the explosion type impacts.  (e.g. wood probably all uses the same effects.)
 * Or if there are differences there are a few only.  Saves on setting the same thing over and over and on maint
 **/
var() editinline ImpactFXBallistic DefaultFXInfoBallistic;

/**
 * This is a nice way to set the same FXInfo for the explosion type impacts.  (e.g. wood probably all uses the same effects.)
 * Or if there are differences there are a few only.  Saves on setting the same thing over and over and on maint
 **/
var() editinline ImpactFXExplosion DefaultFXInfoExplosion;


/** All of the specific types of impacts and their effects info **/
var() editinline array<ImpactFXBallistic> FXInfoBallistic;
/** All of the specific types of impacts and their effects info **/
var() editinline array<ImpactFXExplosion> FXInfoExplosion;

struct native FootStepsDatum
{
	/** This is for the sake of editing, knowing which entry is which weapon.  It is filled in by PostLoad(). */
	var() editconst ECharacterFootStepType Type;

	var() SoundCue FootStep;
	var() SoundCue FootStepRunning;
	var() SoundCue Landing;
	var() SoundCue Leaping;
	var() SoundCue Sliding;

	/** The Particle system to play when on this material **/
	var() ParticleSystem FootstepEffectPS;
};

var(FootSteps) editinline array<FootStepsDatum> FootStepInfo;

/** for all characters we are just going to play one ParticleSystem for walking **/
var(FootSteps) ParticleSystem FootstepEffectWalk;
/** for all characters we are just going to play one ParticleSystem for running **/
var(FootSteps) ParticleSystem FootstepEffectRun;

/** For all characters we are just going to use one roadie run effect per material **/
var(Dust) ParticleSystem RoadieRun;

/** For all characters we are just going to use one evade dust effect per material **/
var(Dust) ParticleSystem EvadeEffect;
/** This will play on the camera when you enter cover **/
var() class<Emit_NanoCameraLensEffectBase> EvadeCameraLensEffect;


/** For all characters we are just going to use one slide into cover dust effect per material **/
var(Dust) ParticleSystem SlideIntoCoverEffect;

/** For all characters we are just going to use one slide into cover dust effect per material **/
var(Dust) ParticleSystem SlideIntoCoverNonPlayerEffect;

/** This will play on the camera when you enter cover **/
var() class<Emit_NanoCameraLensEffectBase> SlideIntoCoverCameraLensEffect;

/** This holds all of the decal data for this physical material **/
var(Decals) editinline NanoDecalInfo DecalInfo;


// add in vehicle stuff when we actually get vehicles
// sounds: tire, squeeling, skidding
// particles:  skidding, driving, starting




cpptext
{
protected:
	void RefreshTypeData();

private:
	/**
	* Make sure all decal struct defaults have valid values
	*
	* @param DecalDataEntries - decal data struct array of entries to fixup
	**/
	void FixupDecalDataStructDefaults( TArray<FDecalData>& DecalDataEntries );

public:
	virtual void PostLoad();
	virtual void PostEditChangeChainProperty(FPropertyChangedChainEvent& PropertyChangedEvent);
}


/**
 * Attempts to grab the physical material from an ImpactInfo, returns default if no other is found.
 */
final simulated static function PhysicalMaterial GetImpactPhysicalMaterial(const out ImpactInfo Impact)
{
	local PhysicalMaterial PhysMaterial;

	// check for the simplest case first
	if (Impact.HitInfo.PhysMaterial != None)
	{
		PhysMaterial = Impact.HitInfo.PhysMaterial;
	}
	else
	// check to see if the material was specified but not the physical material
	if (Impact.HitInfo.Material != None)
	{
		PhysMaterial = Impact.HitInfo.Material.PhysMaterial;
	}

	// always guarantee a default
	if (PhysMaterial == None)
	{
		PhysMaterial = Physicalmaterial'NanoPhysMats.DefaultPhysMat';
	}

	return PhysMaterial;
}


/**
 * Attempts to grab the physical material from an ImpactInfo, returns default if no other is found.
 */
final simulated static function PhysicalMaterial GetImpactPhysicalMaterialHitInfo(const out TraceHitInfo HitInfo )
{
	local PhysicalMaterial PhysMaterial;

	// check for the simplest case first
	if( HitInfo.PhysMaterial != None )
	{
		PhysMaterial = HitInfo.PhysMaterial;
	}
	// check to see if the material was specified but not the physical material
	else if( HitInfo.Material != None )
	{
		PhysMaterial = HitInfo.Material.PhysMaterial;
	}

	// always guarantee a default
	if( PhysMaterial == None )
	{
		PhysMaterial = Physicalmaterial'NanoPhysMats.DefaultPhysMat';
	}

	return PhysMaterial;
}


final simulated static function DecalData DetermineImpactDecalData( PhysicalMaterial PhysMaterial, const class<NanoDamageType> NanoDmgType, bool bActiveReloadBonusActive, const out WorldInfo WorldInfo, const Pawn Instigator )
{
	local DecalData DecalData;
	local NanoPhysicalMaterialProperty PhysMatProp;
	local bool bShouldShowGore;

	if( NanoGRI(WorldInfo.GRI).ShouldDisableEffectsDueToFramerate(Instigator) )
	{
		return DecalData;
	}

	// we get touch evens from projectiles and other crazy things which end up sending  the DefaultPhysMaterial in and a NanoDamageType
	// which results in the going up the hierarchy code finding the default base effects (e.g. explosive == frag grenade) which looks silly
	// so just return here
	if( NanoDmgType.default.ImpactTypeBallisticID == ITB_None && NanoDmgType.default.ImpactTypeExplosionID == ITE_None )
	{
		return DecalData;
	}

	bShouldShowGore = WorldInfo.GRI.ShouldShowGore();

	// keep looking until we find a decal source data or run out of materials
	while( !DecalData.bIsValid && PhysMaterial != None )
	{
		PhysMatProp = NanoPhysicalMaterialProperty(PhysMaterial.PhysicalMaterialProperty);
		if( PhysMatProp != None )
		{
			// usually show gore and usually do non AR effects
			//@todo:  when the LOD/Perf code is centralized hook this stuff up
			if( bShouldShowGore == TRUE )
			{
				if( bActiveReloadBonusActive == FALSE )
				{
					DecalData = class'NanoDecal'.static.GetRandomDecalMaterial( NanoDmgType.default.ImpactTypeBallisticID != ITB_None ? PhysMatProp.FXInfoBallistic[NanoDmgType.default.ImpactTypeBallisticID].DecalData : PhysMatProp.FXInfoExplosion[NanoDmgType.default.ImpactTypeExplosionID].DecalData );
					// so now we need to check to see if we should use the Default For this PhysMaterial as we didn't find specific data
					if( DecalData.DecalMaterial == None )
					{
						DecalData = class'NanoDecal'.static.GetRandomDecalMaterial( NanoDmgType.default.ImpactTypeBallisticID != ITB_None ? PhysMatProp.DefaultFXInfoBallistic.DecalData : PhysMatProp.DefaultFXInfoExplosion.DecalData );
					}
				}
				else
				{
					DecalData = class'NanoDecal'.static.GetRandomDecalMaterial( NanoDmgType.default.ImpactTypeBallisticID != ITB_None ? PhysMatProp.FXInfoBallistic[NanoDmgType.default.ImpactTypeBallisticID].DecalData_AR : PhysMatProp.FXInfoExplosion[NanoDmgType.default.ImpactTypeExplosionID].DecalData_AR  );
					// so now we need to check to see if we should use the Default For this PhysMaterial as we didn't find specific data
					if( DecalData.DecalMaterial == None )
					{
						DecalData = class'NanoDecal'.static.GetRandomDecalMaterial( NanoDmgType.default.ImpactTypeBallisticID != ITB_None ? PhysMatProp.DefaultFXInfoBallistic.DecalData_AR : PhysMatProp.DefaultFXInfoExplosion.DecalData_AR );
					}
				}
			}
			else
			{
				DecalData = class'NanoDecal'.static.GetRandomDecalMaterial( NanoDmgType.default.ImpactTypeBallisticID != ITB_None ? PhysMatProp.FXInfoBallistic[NanoDmgType.default.ImpactTypeBallisticID].DecalData : PhysMatProp.FXInfoExplosion[NanoDmgType.default.ImpactTypeExplosionID].DecalData_NoGore  );
				// so now we need to check to see if we should use the Default For this PhysMaterial as we didn't find specific data
				if( DecalData.DecalMaterial == None )
				{
					DecalData = class'NanoDecal'.static.GetRandomDecalMaterial( NanoDmgType.default.ImpactTypeBallisticID != ITB_None ? PhysMatProp.DefaultFXInfoBallistic.DecalData_NoGore : PhysMatProp.DefaultFXInfoExplosion.DecalData_NoGore );
				}
			}

			/** @TODO - find some better way to handle this case? */
			DecalData.bIsValid = (DecalData.DecalMaterial != None);
		}
		PhysMaterial = PhysMaterial.Parent;
	}

	return DecalData;
}


final simulated static function SoundCue DetermineImpactSound( PhysicalMaterial PhysMaterial, const class<NanoDamageType> NanoDmgType, bool bActiveReloadBonusActive, const out WorldInfo WorldInfo )
{
	local SoundCue ImpactCue;
	local NanoPhysicalMaterialProperty PhysMatProp;

	// we get touch evens from projectiles and other crazy things which end up sending  the DefaultPhysMaterial in and a NanoDamageType
	// which results in the going up the hierarchy code finding the default base effects (e.g. explosive == frag grenade) which looks silly
	// so just return here
	if( NanoDmgType.default.ImpactTypeBallisticID == ITB_None && NanoDmgType.default.ImpactTypeExplosionID == ITE_None )
	{
		return None;
	}

	// keep looking until we find a source data or run out of materials
	while( ImpactCue == None && PhysMaterial != None )
	{
		PhysMatProp = NanoPhysicalMaterialProperty(PhysMaterial.PhysicalMaterialProperty);
		if( PhysMatProp != None )
		{
			ImpactCue = NanoDmgType.default.ImpactTypeBallisticID != ITB_None ? PhysMatProp.FXInfoBallistic[NanoDmgType.default.ImpactTypeBallisticID].ImpactCue : PhysMatProp.FXInfoExplosion[NanoDmgType.default.ImpactTypeExplosionID].ImpactCue;
			// so now we need to check to see if we should use the Default For this PhysMaterial as we didn't find specific data
			if( ImpactCue == None )
			{
				ImpactCue = NanoDmgType.default.ImpactTypeBallisticID != ITB_None ? PhysMatProp.DefaultFXInfoBallistic.ImpactCue : PhysMatProp.DefaultFXInfoExplosion.ImpactCue;
			}
		}
		PhysMaterial = PhysMaterial.Parent;
	}

	return ImpactCue;
}


final simulated static function ParticleSystem DetermineEvadeParticleEffect( PhysicalMaterial PhysMaterial, const out WorldInfo WorldInfo )
{
	local ParticleSystem Retval;
	local NanoPhysicalMaterialProperty PhysMatProp;

	// keep looking until we find a source data or run out of materials
	while( Retval == None && PhysMaterial != None )
	{
		PhysMatProp = NanoPhysicalMaterialProperty(PhysMaterial.PhysicalMaterialProperty);
		if( PhysMatProp != None )
		{
			Retval = PhysMatProp.EvadeEffect;
		}
		PhysMaterial = PhysMaterial.Parent;
	}

	return Retval;
}

final simulated static function FogVolumeSphericalDensityInfo DetermineFogVolumeArchetype( PhysicalMaterial PhysMaterial, const class<NanoDamageType> NanoDmgType, bool bActiveReloadBonusActive, const out WorldInfo WorldInfo )
{
	local FogVolumeSphericalDensityInfo Retval;
	local NanoPhysicalMaterialProperty PhysMatProp;

	// keep looking until we find a source data or run out of materials
	while( Retval == None && PhysMaterial != None )
	{
		PhysMatProp = NanoPhysicalMaterialProperty(PhysMaterial.PhysicalMaterialProperty);
		if( PhysMatProp != None )
		{
			Retval = FogVolumeSphericalDensityInfo(PhysMatProp.FXInfoExplosion[NanoDmgType.default.ImpactTypeExplosionID].FogVolumeArchetype);
			// so now we need to check to see if we should use the Default For this PhysMaterial as we didn't find specific data
			if( Retval == None )
			{
				Retval = FogVolumeSphericalDensityInfo(PhysMatProp.DefaultFXInfoExplosion.FogVolumeArchetype);
			}
		}
		PhysMaterial = PhysMaterial.Parent;
	}

	return Retval;
}


final simulated static function ParticleSystem DetermineSlideIntoCoverEffect( PhysicalMaterial PhysMaterial, const out WorldInfo WorldInfo )
{
	local ParticleSystem Retval;
	local NanoPhysicalMaterialProperty PhysMatProp;

	//`log( "DetermineSlideIntoCoverEffect" @ PhysMaterial );

	// keep looking until we find a source data or run out of materials
	while( Retval == None && PhysMaterial != None )
	{
		PhysMatProp = NanoPhysicalMaterialProperty(PhysMaterial.PhysicalMaterialProperty);
		if( PhysMatProp != None )
		{
			Retval = PhysMatProp.SlideIntoCoverEffect;
		}
		PhysMaterial = PhysMaterial.Parent;
	}

	return Retval;
}


final simulated static function ParticleSystem DetermineSlideIntoCoverNonPlayerEffect( PhysicalMaterial PhysMaterial, const out WorldInfo WorldInfo )
{
	local ParticleSystem Retval;
	local NanoPhysicalMaterialProperty PhysMatProp;

	// keep looking until we find a source data or run out of materials
	while( Retval == None && PhysMaterial != None )
	{
		PhysMatProp = NanoPhysicalMaterialProperty(PhysMaterial.PhysicalMaterialProperty);
		if( PhysMatProp != None )
		{
			Retval = PhysMatProp.SlideIntoCoverNonPlayerEffect;
		}
		PhysMaterial = PhysMaterial.Parent;
	}

	// temp hack until build can be promoted and then content updated
	if( Retval == none )
	{
		//Retval = ParticleSystem'Effects_Gameplay.Player_Movement.P_Player_Cover_Hit';
	}


	return Retval;
}





final simulated static function class<Emit_NanoCameraLensEffectBase> DetermineImpactCameraEffect( PhysicalMaterial PhysMaterial, const class<NanoDamageType> NanoDmgType, bool bActiveReloadBonusActive, const out WorldInfo WorldInfo, out float Radius )
{
	local class<Emit_NanoCameraLensEffectBase> Retval;
	local NanoPhysicalMaterialProperty PhysMatProp;

	// we get touch evens from projectiles and other crazy things which end up sending  the DefaultPhysMaterial in and a NanoDamageType
	// which results in the going up the hierarchy code finding the default base effects (e.g. explosive == frag grenade) which looks silly
	// so just return here
	if( NanoDmgType.default.ImpactTypeBallisticID == ITB_None && NanoDmgType.default.ImpactTypeExplosionID == ITE_None )
	{
		return Retval;
	}

	// keep looking until we find a source data or run out of materials
	while( Retval == None && PhysMaterial != None )
	{
		PhysMatProp = NanoPhysicalMaterialProperty(PhysMaterial.PhysicalMaterialProperty);
		if( PhysMatProp != None )
		{
			Retval = NanoDmgType.default.ImpactTypeBallisticID != ITB_None ? PhysMatProp.FXInfoBallistic[NanoDmgType.default.ImpactTypeBallisticID].CameraEffect : PhysMatProp.FXInfoExplosion[NanoDmgType.default.ImpactTypeExplosionID].CameraEffect;
			Radius = NanoDmgType.default.ImpactTypeBallisticID != ITB_None ? PhysMatProp.FXInfoBallistic[NanoDmgType.default.ImpactTypeBallisticID].CameraEffectRadius : PhysMatProp.FXInfoExplosion[NanoDmgType.default.ImpactTypeExplosionID].CameraEffectRadius;
			// so now we need to check to see if we should use the Default For this PhysMaterial as we didn't find specific data
			if( Retval == None )
			{
				Retval = NanoDmgType.default.ImpactTypeBallisticID != ITB_None ? PhysMatProp.DefaultFXInfoBallistic.CameraEffect : PhysMatProp.DefaultFXInfoExplosion.CameraEffect;
				Radius = NanoDmgType.default.ImpactTypeBallisticID != ITB_None ? PhysMatProp.DefaultFXInfoBallistic.CameraEffectRadius : PhysMatProp.DefaultFXInfoExplosion.CameraEffectRadius;
			}
		}
		PhysMaterial = PhysMaterial.Parent;
	}

	return Retval;
}



final simulated static function class<Emit_NanoCameraLensEffectBase> DetermineSlideIntoCoverCameraLensEffect( PhysicalMaterial PhysMaterial, const out WorldInfo WorldInfo )
{
	local class<Emit_NanoCameraLensEffectBase> Retval;
	local NanoPhysicalMaterialProperty PhysMatProp;

	// keep looking until we find a source data or run out of materials
	while( Retval == None && PhysMaterial != None )
	{
		PhysMatProp = NanoPhysicalMaterialProperty(PhysMaterial.PhysicalMaterialProperty);
		if( PhysMatProp != None )
		{
			Retval = PhysMatProp.SlideIntoCoverCameraLensEffect;
		}
		PhysMaterial = PhysMaterial.Parent;
	}

	return Retval;
}


final simulated static function class<Emit_NanoCameraLensEffectBase> DetermineEvadeCameraLensEffect( PhysicalMaterial PhysMaterial, const out WorldInfo WorldInfo )
{
	local class<Emit_NanoCameraLensEffectBase> Retval;
	local NanoPhysicalMaterialProperty PhysMatProp;

	// keep looking until we find a source data or run out of materials
	while( Retval == None && PhysMaterial != None )
	{
		PhysMatProp = NanoPhysicalMaterialProperty(PhysMaterial.PhysicalMaterialProperty);
		if( PhysMatProp != None )
		{
			Retval = PhysMatProp.EvadeCameraLensEffect;
		}
		PhysMaterial = PhysMaterial.Parent;
	}

	return Retval;
}


final simulated static function ParticleSystem DetermineRoadieRunParticleEffect( PhysicalMaterial PhysMaterial, const out WorldInfo WorldInfo )
{
	local ParticleSystem Retval;
	local NanoPhysicalMaterialProperty PhysMatProp;

	// keep looking until we find a source data or run out of materials
	while( Retval == None && PhysMaterial != None )
	{
		PhysMatProp = NanoPhysicalMaterialProperty(PhysMaterial.PhysicalMaterialProperty);
		if( PhysMatProp != None )
		{
			Retval = PhysMatProp.RoadieRun;
		}
		PhysMaterial = PhysMaterial.Parent;
	}

	return Retval;
}


final simulated static function ParticleSystem DetermineImpactParticleSystem( PhysicalMaterial PhysMaterial, const class<NanoDamageType> NanoDmgType, bool bActiveReloadBonusActive, const out WorldInfo WorldInfo, const Pawn Instigator, optional bool bSkipDefaults )
{
	local NanoPhysicalMaterialProperty PhysMatProp;
	local ParticleSystem ImpactPS;
	local bool bShouldShowGore;
	local bool bShouldDisableEffectDueToFramerate;

	if( NanoDmgType == none )
	{
		`warn( "DetermineImpactParticleSystem was none" @ "PhysMat" @ PhysMaterial );
		ScriptTrace();
		return none;
	}

	// we get touch evens from projectiles and other crazy things which end up sending  the DefaultPhysMaterial in and a NanoDamageType
	// which results in the going up the hierarchy code finding the default base effects (e.g. explosive == frag grenade) which looks silly
	// so just return here
	if( NanoDmgType.default.ImpactTypeBallisticID == ITB_None && NanoDmgType.default.ImpactTypeExplosionID == ITE_None )
	{
		//`warn( "ImpactTypeBallisticID == ITB_None && ImpactTypeExplosionID == ITE_None" );
		return None;
	}

	//`log( "DetermineImpactParticleSystem: " @ PhysMaterial @ NanoDmgType @ bActiveReloadBonusActive );

	bShouldShowGore = WorldInfo.GRI.ShouldShowGore();
	// this is really asking if we should switch to the _ForSlowPerf PS
	bShouldDisableEffectDueToFramerate = NanoGRI(WorldInfo.GRI).ShouldDisableEffectsDueToFramerate(Instigator) || class'Engine'.static.IsSplitScreen();
	// until we find a particle system or run out of stuff to look in
	while( ImpactPS == None && PhysMaterial != None )
	{
		PhysMatProp = NanoPhysicalMaterialProperty(PhysMaterial.PhysicalMaterialProperty);
		if( PhysMatProp != None )
		{
			if( bShouldShowGore == TRUE )
			{
				if( bShouldDisableEffectDueToFramerate == TRUE )
				{
					if( bActiveReloadBonusActive == TRUE )
					{
						ImpactPS = NanoDmgType.default.ImpactTypeBallisticID != ITB_None ? PhysMatProp.FXInfoBallistic[NanoDmgType.default.ImpactTypeBallisticID].ImpactPS_AR_ForSlowPerf : PhysMatProp.FXInfoExplosion[NanoDmgType.default.ImpactTypeExplosionID].ImpactPS_AR_ForSlowPerf;
						// so now we need to check to see if we should use the Default For this PhysMaterial as we didn't find specific data
						if( ImpactPS == None && !bSkipDefaults )
						{
							ImpactPS = NanoDmgType.default.ImpactTypeBallisticID != ITB_None ? PhysMatProp.DefaultFXInfoBallistic.ImpactPS_AR_ForSlowPerf : PhysMatProp.DefaultFXInfoExplosion.ImpactPS_AR_ForSlowPerf;
						}
					}

					if( ImpactPS == None )
					{
						ImpactPS = NanoDmgType.default.ImpactTypeBallisticID != ITB_None ? PhysMatProp.FXInfoBallistic[NanoDmgType.default.ImpactTypeBallisticID].ImpactPS_ForSlowPerf : PhysMatProp.FXInfoExplosion[NanoDmgType.default.ImpactTypeExplosionID].ImpactPS_ForSlowPerf;
						// so now we need to check to see if we should use the Default For this PhysMaterial as we didn't find specific data
						if( ImpactPS == None && !bSkipDefaults )
						{
							ImpactPS = NanoDmgType.default.ImpactTypeBallisticID != ITB_None ? PhysMatProp.DefaultFXInfoBallistic.ImpactPS_ForSlowPerf : PhysMatProp.DefaultFXInfoExplosion.ImpactPS_ForSlowPerf;
						}
					}

				}

				// so now we check to see if we still don't have an impact (as there were no ForSlowPerf set)
				if( ImpactPS == None )
				{
					if( bActiveReloadBonusActive == TRUE )
					{
						ImpactPS = NanoDmgType.default.ImpactTypeBallisticID != ITB_None ? PhysMatProp.FXInfoBallistic[NanoDmgType.default.ImpactTypeBallisticID].ImpactPS_AR : PhysMatProp.FXInfoExplosion[NanoDmgType.default.ImpactTypeExplosionID].ImpactPS_AR;
						// so now we need to check to see if we should use the Default For this PhysMaterial as we didn't find specific data
						if( ImpactPS == None && !bSkipDefaults )
						{
							ImpactPS = NanoDmgType.default.ImpactTypeBallisticID != ITB_None ? PhysMatProp.DefaultFXInfoBallistic.ImpactPS_AR : PhysMatProp.DefaultFXInfoExplosion.ImpactPS_AR;
						}
					}
					else
					{
						ImpactPS = NanoDmgType.default.ImpactTypeBallisticID != ITB_None ? PhysMatProp.FXInfoBallistic[NanoDmgType.default.ImpactTypeBallisticID].ImpactPS : PhysMatProp.FXInfoExplosion[NanoDmgType.default.ImpactTypeExplosionID].ImpactPS;
						// so now we need to check to see if we should use the Default For this PhysMaterial as we didn't find specific data
						if( ImpactPS == None && !bSkipDefaults )
						{
							ImpactPS = NanoDmgType.default.ImpactTypeBallisticID != ITB_None ? PhysMatProp.DefaultFXInfoBallistic.ImpactPS : PhysMatProp.DefaultFXInfoExplosion.ImpactPS;
							//`log( " having to use default: " @ ImpactPS @ PhysMaterial @ NanoDmgType @ bActiveReloadBonusActive );
						}
					}
				}
			}
	   // no gore case
			else
			{
				if( bShouldDisableEffectDueToFramerate == TRUE )
				{
					if( bActiveReloadBonusActive == TRUE )
					{
						ImpactPS = NanoDmgType.default.ImpactTypeBallisticID != ITB_None ? PhysMatProp.FXInfoBallistic[NanoDmgType.default.ImpactTypeBallisticID].ImpactPS_NoGore_ForSlowPerf_AR : PhysMatProp.FXInfoExplosion[NanoDmgType.default.ImpactTypeExplosionID].ImpactPS_NoGore_ForSlowPerf_AR;
						// so now we need to check to see if we should use the Default For this PhysMaterial as we didn't find specific data
						if( ImpactPS == None && !bSkipDefaults )
						{
							ImpactPS = NanoDmgType.default.ImpactTypeBallisticID != ITB_None ? PhysMatProp.DefaultFXInfoBallistic.ImpactPS_NoGore_ForSlowPerf_AR : PhysMatProp.DefaultFXInfoExplosion.ImpactPS_NoGore_ForSlowPerf_AR;
						}
					}

					if( ImpactPS == None )
					{
						ImpactPS = NanoDmgType.default.ImpactTypeBallisticID != ITB_None ? PhysMatProp.FXInfoBallistic[NanoDmgType.default.ImpactTypeBallisticID].ImpactPS_NoGore_ForSlowPerf : PhysMatProp.FXInfoExplosion[NanoDmgType.default.ImpactTypeExplosionID].ImpactPS_NoGore_ForSlowPerf;
						// so now we need to check to see if we should use the Default For this PhysMaterial as we didn't find specific data
						if( ImpactPS == None && !bSkipDefaults )
						{
							ImpactPS = NanoDmgType.default.ImpactTypeBallisticID != ITB_None ? PhysMatProp.DefaultFXInfoBallistic.ImpactPS_NoGore_ForSlowPerf : PhysMatProp.DefaultFXInfoExplosion.ImpactPS_NoGore_ForSlowPerf;
						}
					}

				}

				// so now we check to see if we still don't have an impact (as there were no ForSlowPerf set)
				if( ImpactPS == None )
				{
					if( bActiveReloadBonusActive == TRUE )
					{
						ImpactPS = NanoDmgType.default.ImpactTypeBallisticID != ITB_None ? PhysMatProp.FXInfoBallistic[NanoDmgType.default.ImpactTypeBallisticID].ImpactPS_NoGore_AR : PhysMatProp.FXInfoExplosion[NanoDmgType.default.ImpactTypeExplosionID].ImpactPS_NoGore_AR;
						// so now we need to check to see if we should use the Default For this PhysMaterial as we didn't find specific data
						if( ImpactPS == None && !bSkipDefaults )
						{
							ImpactPS = NanoDmgType.default.ImpactTypeBallisticID != ITB_None ? PhysMatProp.DefaultFXInfoBallistic.ImpactPS_NoGore_AR : PhysMatProp.DefaultFXInfoExplosion.ImpactPS_NoGore_AR;
						}
					}
					else
					{
						ImpactPS = NanoDmgType.default.ImpactTypeBallisticID != ITB_None ? PhysMatProp.FXInfoBallistic[NanoDmgType.default.ImpactTypeBallisticID].ImpactPS_NoGore : PhysMatProp.FXInfoExplosion[NanoDmgType.default.ImpactTypeExplosionID].ImpactPS_NoGore;
						// so now we need to check to see if we should use the Default For this PhysMaterial as we didn't find specific data
						if( ImpactPS == None && !bSkipDefaults )
						{
							ImpactPS = NanoDmgType.default.ImpactTypeBallisticID != ITB_None ? PhysMatProp.DefaultFXInfoBallistic.ImpactPS_NoGore : PhysMatProp.DefaultFXInfoExplosion.ImpactPS_NoGore;
						}
					}
				}
			}

			//`LogExt("- Valid material property");

		}
		PhysMaterial = PhysMaterial.Parent;
	}

	return ImpactPS;
}



final simulated static function ParticleSystem DetermineExitWoundParticleSystem( PhysicalMaterial PhysMaterial, const class<NanoDamageType> NanoDmgType, bool bActiveReloadBonusActive, const out WorldInfo WorldInfo )
{
	local NanoPhysicalMaterialProperty PhysMatProp;
	local ParticleSystem ImpactPS;
	local bool bShouldShowGore;

	// don't do exit wounds if low fps
	if( WorldInfo.bDropDetail )
	{
		return none;
	}

	bShouldShowGore = WorldInfo.GRI.ShouldShowGore();

	// until we find a particle system or run out of stuff to look in
	while( ImpactPS == None && PhysMaterial != None )
	{
		PhysMatProp = NanoPhysicalMaterialProperty(PhysMaterial.PhysicalMaterialProperty);
		if( PhysMatProp != None )
		{
			// usually show gore and usually do non AR effects
			//@todo:  when the LOD/Perf code is centralized hook this stuff up
			if( bShouldShowGore == TRUE )
			{
				if( bActiveReloadBonusActive == FALSE )
				{
					ImpactPS = PhysMatProp.FXInfoBallistic[NanoDmgType.default.ImpactTypeBallisticID].ExitWoundPS;
					// so now we need to check to see if we should use the Default For this PhysMaterial as we didn't find specific data
					if( ImpactPS == None )
					{
						ImpactPS = PhysMatProp.DefaultFXInfoBallistic.ExitWoundPS;
					}
				}
			}
			// exit wounds are always going to be bloody for gears so if we are not showing gore we are just going to return a None ImpactPS
			// the caller must deal with this
			else
			{
				ImpactPS = None;
				break;
			}

			//`LogExt("- Valid material property");

		}
		PhysMaterial = PhysMaterial.Parent;
	}

	return ImpactPS;
}


final simulated static function SoundCue DetermineFootStepSound( PhysicalMaterial PhysMaterial, ECharacterFootStepType TypeID, const out WorldInfo WorldInfo, bool bIsRunning )
{
	local SoundCue ImpactCue;
	local NanoPhysicalMaterialProperty PhysMatProp;

	// keep looking until we find a source data or run out of materials
	while( ImpactCue == none && PhysMaterial != None )
	{
		PhysMatProp = NanoPhysicalMaterialProperty(PhysMaterial.PhysicalMaterialProperty);
		if( PhysMatProp != None )
		{
			if( bIsRunning == TRUE )
			{
				ImpactCue = PhysMatProp.FootStepInfo[TypeID].FootStepRunning;
			}
			else
			{
				ImpactCue = PhysMatProp.FootStepInfo[TypeID].FootStep;
			}

			//`log( "PhysMatProp" @ PhysMatProp @ TypeID @ ImpactCue );

			// so now we need to check to see if we should use the Default For this PhysMaterial as we didn't find specific data
// 			if( ImpactCue == None )
// 			{
// 				ImpactCue = PhysMatProp.DefaultFXInfo.ImpactCue;
// 			}
		}
		PhysMaterial = PhysMaterial.Parent;
	}

	return ImpactCue;
}


final simulated static function SoundCue DetermineSlidingSound( PhysicalMaterial PhysMaterial, ECharacterFootStepType TypeID, const out WorldInfo WorldInfo )
{
	local SoundCue ImpactCue;
	local NanoPhysicalMaterialProperty PhysMatProp;

	// keep looking until we find a source data or run out of materials
	while( ImpactCue == none && PhysMaterial != None )
	{
		PhysMatProp = NanoPhysicalMaterialProperty(PhysMaterial.PhysicalMaterialProperty);
		if( PhysMatProp != None )
		{
			ImpactCue = PhysMatProp.FootStepInfo[TypeID].Sliding;
			// so now we need to check to see if we should use the Default For this PhysMaterial as we didn't find specific data
			// 			if( ImpactCue == None )
			// 			{
			// 				ImpactCue = PhysMatProp.DefaultFXInfo.ImpactCue;
			// 			}
		}
		PhysMaterial = PhysMaterial.Parent;
	}

	return ImpactCue;
}


final simulated static function SoundCue DetermineLandingSound( PhysicalMaterial PhysMaterial, ECharacterFootStepType TypeID, const out WorldInfo WorldInfo )
{
	local SoundCue ImpactCue;
	local NanoPhysicalMaterialProperty PhysMatProp;

	// keep looking until we find a source data or run out of materials
	while( ImpactCue == none && PhysMaterial != None )
	{
		PhysMatProp = NanoPhysicalMaterialProperty(PhysMaterial.PhysicalMaterialProperty);
		if( PhysMatProp != None )
		{
			ImpactCue = PhysMatProp.FootStepInfo[TypeID].Landing;
			// so now we need to check to see if we should use the Default For this PhysMaterial as we didn't find specific data
			// 			if( ImpactCue == None )
			// 			{
			// 				ImpactCue = PhysMatProp.DefaultFXInfo.ImpactCue;
			// 			}
		}
		PhysMaterial = PhysMaterial.Parent;
	}

	return ImpactCue;
}

final simulated static function SoundCue DetermineLeapingSound( PhysicalMaterial PhysMaterial, ECharacterFootStepType TypeID, const out WorldInfo WorldInfo )
{
	local SoundCue ImpactCue;
	local NanoPhysicalMaterialProperty PhysMatProp;

	// keep looking until we find a source data or run out of materials
	while( ImpactCue == none && PhysMaterial != None )
	{
		PhysMatProp = NanoPhysicalMaterialProperty(PhysMaterial.PhysicalMaterialProperty);
		if( PhysMatProp != None )
		{
			ImpactCue = PhysMatProp.FootStepInfo[TypeID].Leaping;
			// so now we need to check to see if we should use the Default For this PhysMaterial as we didn't find specific data
			// 			if( ImpactCue == None )
			// 			{
			// 				ImpactCue = PhysMatProp.DefaultFXInfo.ImpactCue;
			// 			}
		}
		PhysMaterial = PhysMaterial.Parent;
	}

	return ImpactCue;
}


/**
*
**/
final simulated static function DecalData GetBloodDecalData( PhysicalMaterial PhysMaterial, ENanoDecalType DecalType, const WorldInfo WorldInfo )
{
	local DecalData DecalData;
	local NanoPhysicalMaterialProperty PhysMatProp;

	while( !DecalData.bIsValid && PhysMaterial != None )
	{
		PhysMatProp = NanoPhysicalMaterialProperty(PhysMaterial.PhysicalMaterialProperty);
		if( PhysMatProp != None )
		{
			//@todo:  when the LOD/Perf code is centralized hook this stuff up
			if( WorldInfo.GRI.ShouldShowGore() == TRUE )
			{
				if( PhysMatProp.DecalInfo != None )
				{
					DecalData = class'NanoDecal'.static.GetRandomDecalMaterial( PhysMatProp.DecalInfo.DecalInfo[DecalType].DecalData );
				}
			}

			/** @TODO - find some better way to handle this case? */
			DecalData.bIsValid = (DecalData.DecalMaterial != None);
		}
		PhysMaterial = PhysMaterial.Parent;
	}


	return DecalData;
}







defaultproperties
{
	Version=5

	// These need to exist such that when new objects are made they have the current set of defaults
	// and for when we update older version of this object we know what the default ORDER should be.
	// @see UNanoPhysicalMaterialProperty::RefreshTypeData() where we will do reordering of existing
	// data based on the version.
	FXInfoBallistic(ITB_None)=(Type=ITB_None)
	FXInfoBallistic(ITB_MP7)=(Type=ITB_MP7)
	FXInfoBallistic(ITB_NanoSword)=(Type=ITB_NanoSword)

	
	FXInfoExplosion(ITE_None)=(Type=ITE_None)
	FXInfoExplosion(ITE_NanoGrenade)=(Type=ITE_NanoGrenade)


	FootStepInfo(NFST_Generic)=(Type=NFST_Generic)
	FootStepInfo(NFST_Lyrik)=(Type=NFST_Lyrik)
	FootStepInfo(NFST_Owen)=(Type=NFST_Owen)
	FootStepInfo(NFST_MetaCorp_Generic)=(Type=NFST_MetaCorp_Generic)
	
}
