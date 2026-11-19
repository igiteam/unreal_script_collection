//=============================================================================
// SASDamageableMesh.uc
//
//=============================================================================

class SASDamageableMesh extends StaticMeshActor
	native;
	
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

//-----------------------------------------------------------------------------
// Constants

//-----------------------------------------------------------------------------
// Enums

//-----------------------------------------------------------------------------
// Structs

struct native SASDamageStage
{
	var() int					Health;
	var() StaticMesh		    Mesh;
	
	// for the lighting, we have to have fresh lighting for each stage
	var   StaticMeshInstance	StaticMeshInstance;
	
	var() Class<SASEmitter>		DamageEmitter;
	var() Class<SASGenericExplosion>	DamageExplosion;
	var() rangevector			StartLocationRange;
    var() vector				StartLocationOffset;
    var() int					MaxParticles;
        
	var() bool					bChangeDensity;
	var() eSASDamageDensity		NewDensity;
	var() Sound					DamageSwitchSound;
	var() bool					bLoopSwitchSound;
	var() float					DamageSwitchSoundVolume;
	var() float					DamageSwitchSoundRadius;
	var() name					DamageEvent;
};


//-----------------------------------------------------------------------------
// Member Vars

// Vars for damage models
var() int					 Health;
var() array<SASDamageStage>  mDamageStages;
var() float					 mBulletVelocityMultiplier;

var int							mOriginalHealth;
var StaticMesh					mOriginalStaticMesh;
var StaticMeshInstance			mOriginalSMInstance;
var Sound						mOriginalAmbientSound;

var   int					 mCurrentStage;


//-----------------------------------------------------------------------------
// Native Functions

// Returns true if this is a window damageable mesh.
native(805) final function bool IsAWindow();

//-----------------------------------------------------------------------------
// Exec Functions

//-----------------------------------------------------------------------------
// Functions

simulated function PreBeginPlay()
{
	// Record original values for resetting level in multiplayer.
	mOriginalHealth			= Health;
	mOriginalStaticMesh		= StaticMesh;
	mOriginalSMInstance		= StaticMeshInstance;
	mOriginalAmbientSound	= AmbientSound;
}

simulated function Reset()
{
	mCurrentStage = 0;

	Health = mOriginalHealth;

	SetStaticMesh( mOriginalStaticMesh, mOriginalSMInstance );
	AmbientSound = mOriginalAmbientSound;
}

function TakeDamage (
	int					Damage,
	Pawn				instigatedBy,
	Vector				hitlocation, 
	Vector				momentum,
	class<DamageType>	damageType,
	optional Weapon		wpn)
{	
	local int			nextStage;
	local Vector		emitterDir;
	local Controller	P;

	Health -= Damage;

	// Find stage to move to.
	nextStage = mCurrentStage;
	while ( ( nextStage < mDamageStages.Length ) && ( Health < mDamageStages[nextStage].Health ) )
	{
		nextStage++;
	}

	if ( nextStage > mCurrentStage )
	{
		// Calc direction for any emitter effects.
		emitterDir = HitLocation - instigatedBy.Location;
		emitterDir = ( Normal ( emitterDir ) * mBulletVelocityMultiplier ) << Rotation;

		UpdateDamageStage( nextStage, emitterDir );

		if ( Level.NetMode != NM_Standalone && Role == ROLE_Authority )
		{
			for ( P = Level.ControllerList; P != None; P = P.nextController )
			{
				if (	SASPlayerController(P) != None &&
						SASPlayerController(P) != Level.GetLocalPlayerController() )
				{
					SASPlayerController(P).ClientNotifyDamagableMeshStageChange( self, nextStage, emitterDir );
				}
			}
		}
	}
}


simulated function UpdateDamageStage(
	int		aNewStage,
	Vector	aEmitterDir )
{
	local SASEmitter		tEmitter;
	local ParticleEmitter	pe;
	local SASProjectedDecal tDecal;

	if ( aNewStage > mDamageStages.Length )
	{
		aNewStage = mDamageStages.Length;
	}

	while ( mCurrentStage < aNewStage )
	{
		// Next Stage
		if ( SetStaticMesh ( mDamageStages[mCurrentStage].Mesh, mDamageStages[mCurrentStage].StaticMeshInstance ) )
		{
			if(bStopSoundWhenDamaged)
			{
				AmbientSound=None;	//Stop ambient sounds
			}

			// Remove decals on damage from all StaticMeshes which have the IsAWindow value set
			if (IsAWindow() )
			{
				// Remove decals (bullet-holes)
				foreach AllActors(class'SASProjectedDecal', tDecal)
				{
					if (tDecal.Owner == self)
					{
						tDecal.Destroy();
					}
				}
			}

			// Trigger damage stage swap event.
			if ( Level.NetMode != NM_Client && mDamageStages[mCurrentStage].DamageEvent != 'None' )
			{
				// Broadcast the Trigger message to all matching actors.
				TriggerEvent( mDamageStages[mCurrentStage].DamageEvent, self, None );

				// Notify scripts of event.
				if ( Level.Game != None )
				{
					Level.Game.EventTriggered( mDamageStages[mCurrentStage].DamageEvent );
				}
			}

			if(mDamageStages[mCurrentStage].DamageSwitchSound!=None)
			{
				if(mDamageStages[mCurrentStage].bLoopSwitchSound)
				{
					SoundVolume = (mDamageStages[mCurrentStage].DamageSwitchSoundVolume) * 255.0;
					SoundRadius = mDamageStages[mCurrentStage].DamageSwitchSoundRadius;
					AmbientSound = mDamageStages[mCurrentStage].DamageSwitchSound;
				}
				else
					PlaySound(mDamageStages[mCurrentStage].DamageSwitchSound, SLOT_None, mDamageStages[mCurrentStage].DamageSwitchSoundVolume,,mDamageStages[mCurrentStage].DamageSwitchSoundRadius);
			}
			if ( mDamageStages[mCurrentStage].DamageEmitter != None )
			{	
				tEmitter = Spawn ( mDamageStages[mCurrentStage].DamageEmitter );	//,,,Location, Rotation);
				if ( tEmitter != None )
				{
					// KW: conjecture - it looks like Emitter[0] is a special case used for effects
					// contained within a defined space (e.g. falling broken glass ... )
					pe = tEmitter.Emitters[0];
					if ( pe != None )
					{
						pe.StartVelocityRange.X.Min += aEmitterDir.x;
						pe.StartVelocityRange.X.Max += aEmitterDir.x;

						pe.StartVelocityRange.Y.Min += aEmitterDir.y;
						pe.StartVelocityRange.Y.Max += aEmitterDir.y;

						pe.StartVelocityRange.Z.Min += aEmitterDir.z;
						pe.StartVelocityRange.Z.Max += aEmitterDir.z;

						pe.StartLocationRange  = mDamageStages[mCurrentStage].StartLocationRange;
						pe.StartLocationOffset = mDamageStages[mCurrentStage].StartLocationOffset;
						pe.MaxParticles = mDamageStages[mCurrentStage].MaxParticles;
					}
				}
			}
			if ( mDamageStages[mCurrentStage].DamageExplosion != None )
			{
				Spawn( mDamageStages[mCurrentStage].DamageExplosion,,, Location, Rotation );
			}
		}
		
		// StaticFilterState = FS_Maybe;

		if ( mDamageStages[mCurrentStage].bChangeDensity )
		{
			meBaseDamageDensity = mDamageStages[mCurrentStage].NewDensity;
		}

		mCurrentStage++;
	}
}


simulated function ClientStateChange(
	int		aNewStage,
	vector	aEmitterDir )
{
	if ( aNewStage > mCurrentStage )
	{
		UpdateDamageStage( aNewStage, aEmitterDir );
	}
}

//-----------------------------------------------------------------------------
// Default Properties
//

// Decompiled with UE Explorer.
defaultproperties
{
    Health=100
    mBulletVelocityMultiplier=25.0000000
    RemoteRole=0
    bCantBeBatched=true
    bPathColliding=true
}