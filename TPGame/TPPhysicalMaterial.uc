class TPPhysicalMaterial extends PhysicalMaterial
	native
	DependsOn(TPPhysicalMaterialProperty);




native function Rotator FixupParticleAlignment( const Vector direction ) const;
native function bool GetClosestImpactProperty( class<DamageType>ImpactDamageType, out TPPhysicalMaterialProperty Property, out int index);


private function InitSearch( out TPPhysicalMaterialProperty closestProperty,
							 out int						closestIndex,
							 out int						closestDist,
							 out TPPhysicalMaterial			currMaterial
						   )
{
	closestProperty	= none;
	closestIndex	= -1;
	closestDist		= -1;

	currMaterial = self;
}

private function UpdateDist( out int							currDist,
							 out int							closestDist,
							 out int							index,
							 out int							closestIndex,
							 out TPPhysicalMaterialProperty		currProperty,
							 out TPPhysicalMaterialProperty		closestProperty
						   )
{
	if ( (currDist != -1) && ((currDist < closestDist) || (closestDist == -1)) )
	{
		closestDist		= currDist;
		closestIndex	= index;
		closestProperty	= currProperty;
	}
}

//***********************************************************************
// Impact Particles
//***********************************************************************

simulated function SpawnImpactParticles( class<DamageType> ImpactDamageType, ImpactInfo Impact)
{
	local TPPhysicalMaterialProperty	TPProperty;
	local TPEmitterSpawnable			emitter;
	local ParticleSystem				particles;

	local	Vector							direction;	//	The direction we orient the particles.
	local	Vector							projVec;

	local int index;
	
	//`log("TPPhysicalMaterial::SpawnImpactParticles");

	
	if( GetClosestImpactProperty( ImpactDamageType, TPProperty, index ) == false )
	{
		//failed for some reason?
		;
		
		TPProperty = TPPhysicalMaterialProperty(PhysicalMaterialProperty);
		index = 0;
	}
	
	
	if( TPProperty != None && TPProperty.ImpactParticles.Length > index && TPProperty.ImpactParticles[index].Particles != None )
	{
		switch ( TPProperty.ImpactParticles[index].Alignment )
		{
			case AlignToNormal:
				direction = impact.HitNormal;
				break;

			case AlignToIncidence:
				direction = -impact.RayDir;
				break;

			case AlignToReflection:
                projVec     = (impact.RayDir Dot impact.HitNormal) * impact.HitNormal;
                direction   = impact.RayDir - 2 * projVec;
				break;
		}



		if (Impact.HitActor != None)
		{
			emitter = Impact.HitActor.Spawn( class'TPEmitterSpawnable', Impact.HitActor, , Impact.HitLocation + impact.HitNormal, FixupParticleAlignment(direction) );
			particles = TPProperty.ImpactParticles[index].Particles;
		}
	
		if( emitter != None )
		{
			emitter.SetTemplate( particles, true );
			emitter.bDestroyOnSystemFinish = true;
			emitter.ParticleSystemComponent.SecondsBeforeInactive = 0.0f;
			emitter.ParticleSystemComponent.ActivateSystem();
		
			emitter.LifeSpan = TPProperty.ImpactParticles[index].LifeSpan;
		}
	}
}


//***********************************************************************
// Pawn sounds
//***********************************************************************


function SoundCue GetSoundCue( PawnSoundInfo soundInfo, PawnSoundType soundCueType )
{
	switch ( soundCueType )
	{
    case FootSprint:
		return soundInfo.FootSprint_SoundCue;
		break;
	case FootRun:
		return soundInfo.FootRun_SoundCue;
		break;
	case FootStep:
		return soundInfo.FootStep_SoundCue;
		break;
	case FootScuff:
		return soundInfo.FootScuff_SoundCue;
		break;
	case JumpInit:
		return soundInfo.JumpInit_SoundCue;
		break;
	case JumpLand:
		return soundInfo.JumpLand_SoundCue;
		break;
	case CrouchDown:
		return soundInfo.CrouchDown_SoundCue;
		break;
	case CrouchStep:
		return soundInfo.CrouchStep_SoundCue;
		break;
	case CrouchUp:
		return soundInfo.CrouchUp_SoundCue;
		break;
	case BodyFallSoft:
		return soundInfo.BodyFallSoft_SoundCue;
		break;
	case BodyFall:
		return soundInfo.BodyFall_SoundCue;
		break;
	}
	
	return None; //KMM added
}

//-----------------------------------------------------------
// PlayPawnSound
//-----------------------------------------------------------
simulated function bool PlayPawnSound( Actor theActor, PawnSoundType soundCueType )
{
	local	TPPhysicalMaterial				currMaterial;
	local	TPPhysicalMaterialProperty		currProperty;
	local	int								index;

	local	TPPhysicalMaterialProperty		closestProperty;
	local	int								closestIndex;
	local	int								closestDist;

	local	int								currDist;

	InitSearch( closestProperty, closestIndex, closestDist, currMaterial );

	//
	// Check this physical material to see if there is a matching sound.
	//
	do
	{
		currProperty = TPPhysicalMaterialProperty( currMaterial.PhysicalMaterialProperty );

		//
		// Loop through all of the pawn sounds, looking for one with the correct class.
		//
		for ( index = 0; currProperty!=None && index < currProperty.PawnSounds.Length; index++ )
		{
			//
			// If we found a better matching sound, remember it.
			//
			if ( GetSoundCue( currProperty.PawnSounds[index], soundCueType ) != none )
			{
				currDist = DistClassFromAncestor( theActor.Class, currProperty.PawnSounds[index].PawnClass );
				UpdateDist( currDist, closestDist, index, closestIndex, currProperty, closestProperty );
			}
		}

		currMaterial = TPPhysicalMaterial( currMaterial.parent );

	} until ( currMaterial == none || closestDist == 0)

	//
	// Now play the best fitting sound we found.
	//
	if ( closestProperty != none )
	{
		if (theActor.WorldInfo.NetMode != NM_Standalone)
		{
			if (theActor != none && TPPawn(theActor) != none && !TPPawn(theActor).IsLocallyControlled())
			{
				//`log(theActor$" Played Sound - Non-Owner");
				if (theActor.WorldInfo.NetMode == NM_ListenServer)
					theActor.PlaySound( GetSoundCue( closestProperty.ClientPawnSounds[closestIndex], soundCueType ),,true );	
				else
					theActor.PlaySound( GetSoundCue( closestProperty.ClientPawnSounds[closestIndex], soundCueType ) );	
			}
			else
			{
				//if (theActor.WorldInfo.NetMode != NM_ListenServer)
					theActor.PlaySound( GetSoundCue( closestProperty.PawnSounds[closestIndex], soundCueType ), true);
				//else
				//{
				//6	theActor.PlaySound( GetSoundCue( closestProperty.PawnSounds[closestIndex], soundCueType ),true );
					//theActor.PlaySound( GetSoundCue( closestProperty.ClientPawnSounds[closestIndex], soundCueType ),,true );	
				//}
			}
		}
		else
		{
			theActor.PlaySound( GetSoundCue( closestProperty.PawnSounds[closestIndex], soundCueType ) );
		}
		return ( true );
	}

	return ( false );
}



//-----------------------------------------------------------
// PlayFootStepSound
//-----------------------------------------------------------
simulated function bool PlayFootStepSound( Actor theActor )
{
	return PlayPawnSound( theActor, FootStep );
}

//-----------------------------------------------------------
// PlayFootScuffSound
//-----------------------------------------------------------
simulated function bool PlayFootScuffSound( Actor theActor )
{
	return PlayPawnSound( theActor, FootScuff );
}

//-----------------------------------------------------------
// PlayFootRunSound
//-----------------------------------------------------------
simulated function bool PlayFootRunSound( Actor theActor )
{
	return PlayPawnSound( theActor, FootRun );
}

simulated function bool PlayFootSprintSound( Actor theActor )
{
	return PlayPawnSound( theActor, FootSprint );
}

//-----------------------------------------------------------
// PlayJumpInitSound
//-----------------------------------------------------------
simulated function bool PlayJumpInitSound( Actor theActor )
{
	return PlayPawnSound( theActor, JumpInit );
}

//-----------------------------------------------------------
// PlayJumpLandSound
//-----------------------------------------------------------
simulated function bool PlayJumpLandSound( Actor theActor )
{
	return PlayPawnSound( theActor, JumpLand );
}

//-----------------------------------------------------------
// PlayBodyFallSound
//-----------------------------------------------------------
simulated function bool PlayBodyFallSound( Actor theActor )
{
	return PlayPawnSound( theActor, BodyFall );
}

//-----------------------------------------------------------
// PlayBodyFallSoftSound
//-----------------------------------------------------------
simulated function bool PlayBodyFallSoftSound( Actor theActor )
{
	return PlayPawnSound( theActor, BodyFallSoft );
}

//-----------------------------------------------------------
// PlayCrouchDownSound
//-----------------------------------------------------------
simulated function bool PlayCrouchDownSound( Actor theActor )
{
	return PlayPawnSound( theActor, CrouchDown );
}

//-----------------------------------------------------------
// PlayCrouchStepSound
//-----------------------------------------------------------
simulated function bool PlayCrouchStepSound( Actor theActor )
{
	return PlayPawnSound( theActor, CrouchStep );
}

//-----------------------------------------------------------
// PlayCrouchUpSound
//-----------------------------------------------------------
simulated function bool PlayCrouchUpSound( Actor theActor )
{
	return PlayPawnSound( theActor, CrouchUp );
}


//***********************************************************************
// Impact sounds
//***********************************************************************

simulated function bool PlayImpactSound( class<DamageType> theDamageType, Actor dummyActor, Vector SoundPosition )
{
	local	TPPhysicalMaterial				currMaterial;
	local	TPPhysicalMaterialProperty		currProperty;
	local	int								index;

	local	TPPhysicalMaterialProperty		closestProperty;
	local	int								closestIndex;
	local	int								closestDist;

	local	int								currDist;
	local	AudioComponent					AC;

	InitSearch( closestProperty, closestIndex, closestDist, currMaterial );

	//
	// Check this physical material to see if there is a matching sound.
	//
	do
	{
		currProperty = TPPhysicalMaterialProperty( currMaterial.PhysicalMaterialProperty );

		//
		// Loop through all of the pawn body fall sounds, looking for one with the correct class.
		//
		for ( index = 0; currProperty!=None && index < currProperty.ImpactSounds.Length; index++ )
		{
			//
			// If we found a better matching sound, remember it.
			//
			currDist = DistClassFromAncestor( theDamageType, currProperty.ImpactSounds[index].ImpactClass );
			UpdateDist( currDist, closestDist, index, closestIndex, currProperty, closestProperty );
		}

		currMaterial = TPPhysicalMaterial( currMaterial.parent );

	} until ( currMaterial == none || closestDist == 0)

	//
	// Now play the best fitting sound we found.
	//
	if ( closestProperty != none )
	{
		//`log(self  @ "trying to play impact sound" @ 	closestProperty.ImpactSounds[closestIndex].Impact_SoundCue @ "from dummy actor" @ dummyActor );

		AC = dummyActor.WorldInfo.CreateAudioComponent( closestProperty.ImpactSounds[closestIndex].Impact_SoundCue, false, false );
		if( AC != None )
		{
			AC.Location				= SoundPosition;
			AC.bUseOwnerLocation	= false;
			AC.bAutoDestroy			= true;
			AC.Play();
		}
		// else we failed to create an audio component?

		return ( true );
	}

	return ( false );
}



