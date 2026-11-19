/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoBustableActor extends FracturedStaticMeshActor
	dependson(NanoTypes)
	implements( NanoInterface_Targetable, NanoInterface_GreyGooAffect, NanoInterface_PowerAffect, NanoInterface_OrbitalTarget )	
	native;


var	bool	bBusted;
var	repnotify bool bHealing;

var float	HealedChunks;

/** How many pieces per second will be healed when */
var()	float	GreyGooHealRate;

/** If TRUE, allows this actor to be dusted remotely, to allow passing through */
var()	bool	bAllowDusting;

var	protected transient ENanoState CurrentState;
var	protected transient repnotify ENanoState ReplicatedState;

/** This is the MIC for the NanoPower Effect which is active on this actor **/
var	transient MaterialInstanceConstant MIC_NanoPower;

/** How long we wait before returning to the default state after we have had our state changed **/
var()	float	ReturnToDefaultDelay;

/** Played when this object breaks.  SoundCue that can be overridden to have correct sound for the mesh type **/
var(Sound) SoundCue BreakSoundCue;

/** Played when this object is healing.  SoundCue that can be overridden to have correct sound for the mesh type **/
var(Sound) SoundCue HealingSoundCue;
var transient protected AudioComponent AC_HealingSound;

/** These are the orbital attractors currently on this actor.  They get turned on and off by the NanoWeap_Orbitals_Base **/
var transient array<NxForceField> OrbitalsAttractList;

/** Whether or not this Bustable Actor can be smashed by mechs **/
var bool bCanBeSmashedByMechs;

cpptext
{
	virtual void TickSpecial(FLOAT DeltaSeconds);
	virtual UBOOL IgnoreBlockingBy( const AActor *Other) const;
};


replication
{
	if( Role == ROLE_Authority )
		ReplicatedState, bBusted, bHealing;
}


simulated event ReplicatedEvent(Name VarName)
{
	switch( VarName )
	{
	case nameof(ReplicatedState):
		//`log( "ReplicatedEvent" @ VarName @ ReplicatedState );
		SetNanoState( ReplicatedState, None );
		break;

	case nameof(bHealing):
		//`log( "ReplicatedEvent" @ VarName @ bHealing );
		ClientHealingStateChanged();
		break;

	}

	Super.ReplicatedEvent(VarName);
}


simulated event PostBeginPlay()
{
	Super.PostBeginPlay();

	InitMICNanoPower();

	//SetUpOrbitalAttractor();
}

/** Called on client when healing state changes. */
simulated function ClientHealingStateChanged()
{
	if( bHealing )
	{
		// As soon as healing starts, you can't run through wall any more
		SetCollision(TRUE, TRUE, FALSE);	
		if( CollisionComponent != None )
		{
			CollisionComponent.SetBlockRigidBody( TRUE );
		}

		if( AC_HealingSound == None )
		{
			AC_HealingSound = new(self) class'AudioComponent';
			AttachComponent( AC_HealingSound );
			AC_HealingSound.SoundCue = HealingSoundCue;
		}
		AC_HealingSound.FadeIn( 0.100f, 1.0f );
	}
	else
	{
		// When not healing, look at bBusted to decide what collision to have
		SetCollision(TRUE, !bBusted, FALSE);
		if( CollisionComponent != None )
		{
			CollisionComponent.SetBlockRigidBody( FALSE );
		}

		if( AC_HealingSound != None )
		{
			AC_HealingSound.FadeOut( 0.100f, 0.0f );
		}
	}
}


/** Called when grey goo is fired at this mesh, repairs it. */
simulated function OnGreyGoo(NanoWeap_GreyGooCubeBase Weapon)
{
	`log( "OnGreyGooOnGreyGooOnGreyGooOnGreyGooOnGreyGooOnGreyGooOnGreyGoo" );
	// If broken, start the healing
	if(bBusted)
	{
		bBusted = FALSE;		
		bHealing = TRUE;
		
		ClientHealingStateChanged();
	}
}

/** Mark bustable actors as 'busted' if parts are broken off */
simulated function BreakOffPartsInRadius(vector Origin, float Radius, float RBStrength, bool bWantPhysChunksAndParticles)
{
	super.BreakOffPartsInRadius(Origin, Radius, RBStrength, bWantPhysChunksAndParticles);
	
	if(!bBusted)
	{
		bBusted = TRUE;
		bHealing = FALSE;
		
		ClientHealingStateChanged();
	}	
}

/** Called from C++ when busting happens */
simulated event OnBust()
{
	local PlayerController PC;

	// Stop any healing that was going on
	bHealing = FALSE;
	HealedChunks = 0.0;
	
	ClientHealingStateChanged();

	SetLoseChunkReplacementMaterial();

	ForEach LocalPlayerControllers( class'PlayerController', PC )
	{
		// 300.0f is from the SoundCue DiststanceCrossFade/Attenuation node
		if( (PC.ViewTarget != None) && (VSize(PC.ViewTarget.Location - Location) < 3000.0f) )
		{
			//`log( (VSize(PC.ViewTarget.Location - Location) ));
			PC.PlaySound( BreakSoundCue );
			break;
		}
	}
}

/** Don't let you shoot holes in bustable actor. */
simulated event TakeDamage(int Damage, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	return;
}

/** Used to change the nano state of an object */
simulated function bool SetNanoState(ENanoState NewState, Actor InInstigator, optional float NanoPowerAmount)
{
	//`log( "SetNanoState" @ CurrentState @ "->" @ NewState );
	//ScriptTrace();


	// Do nothing if already in correct state
	if(NewState == CurrentState)
	{
		`log( "NanoBustableActor: already in desired state!!!!!" @ CurrentState );
		return TRUE;
	}


	// DENSE power
	if(NewState == ENS_Dense)
	{
		// FROM NORMAL - make unbustable
		if(CurrentState == ENS_Normal) 
		{
			if(bBusted == FALSE)
			{
				class'NanoTypes'.static.SetMaterialInstanceToDensed( MIC_NanoPower );
				SetTimer( ReturnToDefaultDelay, FALSE, nameof( RestoreDefaultNanoState ) );
			}
			else
			{
				bBusted = FALSE;		
				bHealing = TRUE;

				ClientHealingStateChanged();

				return TRUE;
			}
		}
		// FROM DUST - Return to default
		else if(CurrentState == ENS_Dust)
		{
			RestoreDefaultNanoState();
			ReplicatedState = ENS_Dust; // replicate it out
			return TRUE;
		}
	}
	// DUST power
	else if(NewState == ENS_Dust)
	{
		// FROM DENSE - Return to default
		if(CurrentState == ENS_Dense)
		{
			RestoreDefaultNanoState();
			ReplicatedState = ENS_Dust; // replicate it out
			return TRUE;			
		}
		// FROM NORMAL - dustify, turn off collision etc.
		else if(CurrentState == ENS_Normal)
		{
			if(bAllowDusting)
			{
				class'NanoTypes'.static.SetMaterialInstanceToDusted( MIC_NanoPower );			
				SetTimer( ReturnToDefaultDelay, FALSE, nameof( RestoreDefaultNanoState ) );				
				
				SetCollision(bCollideActors, FALSE, bIgnoreEncroachers);
				bBreakChunksOnActorTouch = FALSE;
				
				FracturedStaticMeshComponent.SetRBChannel(RBCC_Untitled1);			
				FracturedStaticMeshComponent.SetRBCollidesWithChannel(RBCC_GameplayPhysics, FALSE);
				FracturedStaticMeshComponent.SetRBCollidesWithChannel(RBCC_EffectPhysics, FALSE);
				FracturedStaticMeshComponent.SetRBCollidesWithChannel(RBCC_Untitled2, FALSE);			
			}
			else
			{	
				// If we don't allow dusting this mesh, do nothing
				return TRUE;
			}
		}
	}

	`log( "setting current state to:" @ NewState );
	// Update current state
	CurrentState = NewState;
	ReplicatedState = CurrentState; // replicate it out

	// Fire any kismet events
	class'NanoTypes'.static.FireNanoStateChangeEvent( self, InInstigator, NewState );
	return TRUE;
}


/** Used to restore the nano state of an object to default */
simulated function RestoreDefaultNanoState()
{
	`log( "RestoreDefaultNanoState" );

	class'NanoTypes'.static.SetMaterialInstanceToDefault( MIC_NanoPower );

	// restore collision
	SetCollision(bCollideActors, !bBusted, bIgnoreEncroachers);
	bBreakChunksOnActorTouch = TRUE;
	
	FracturedStaticMeshComponent.SetRBChannel(RBCC_Untitled3);
	FracturedStaticMeshComponent.SetRBCollidesWithChannel(RBCC_GameplayPhysics, TRUE);
	FracturedStaticMeshComponent.SetRBCollidesWithChannel(RBCC_EffectPhysics, TRUE);
	FracturedStaticMeshComponent.SetRBCollidesWithChannel(RBCC_Untitled2, TRUE);
	
	// Set current state var back to normal
	CurrentState = ENS_Normal;

	// Fire any kismet events
	class'NanoTypes'.static.FireNanoStateChangeEvent(self, self, ENS_Normal);
	
	// Make sure timer for this is cleared
	ClearTimer(nameof(RestoreDefaultNanoState));
}

simulated function bool CanBeChanged( ENanoState NewState )
{
	if( NewState == ENS_Dust )
	{
		return CanBeDusted();
	}
	if( NewState == ENS_Dense )
	{
		return CanBeDensed();
	}
	return TRUE;
}

simulated function bool CanBeDusted()
{
	return TRUE;
}

simulated function bool CanBeDensed()
{
	return TRUE;
}


simulated function bool IsDensed()
{
	return (CurrentState == ENS_Dense);
}

simulated function bool IsDusted()
{
	return (CurrentState == ENS_Dust);
}

////// NanoInterface_Targetable
simulated function float GetBasePriority(NanoPC Askee, optional NanoPawn AskeePawn)
{
	return 10.0;
}

simulated function bool IsTargetable( optional ETargetQueryType QT )
{
	return FALSE;
}

/** Returns the Targetable Octree component */
simulated function TargetableOctreeComponent GetTargetableOctreeComponent()
{
	local TargetableOctreeComponent TargetableComp;

	foreach AllOwnedComponents( class'TargetableOctreeComponent', TargetableComp )
	{
		return TargetableComp;
	}

	return None;
}


simulated function bool ShouldRateTarget()
{
	 // if we have not seen this actor for 2 second then don't allow targeting of it
	return ((WorldInfo.TimeSeconds - LastRenderTime) < 2.0f);
}

simulated function bool ShouldIgnoreDistance()
{
	return FALSE;
}

simulated event vector GetTargetedLocation()
{
	// use middle of mesh bounds
	return FracturedStaticMeshComponent.Bounds.Origin;
}

/** Rotation of the target.  Useful to see if they are facing some dir **/
simulated event rotator GetRotation()
{
	return Rotation;
}

/** How fast the target is currently moving **/
simulated event vector GetVelocity()
{
	return Velocity;
}

/** Pass in a struct and then have the interface fill in a ton of different firing targetable data **/
simulated function GetFiringTargetableDatum( out FiringTargetableDatum Out_FiringTargetableDatum );

simulated event BoxSphereBounds GetTargetableBounds()
{
	return FracturedStaticMeshComponent.Bounds;
}


simulated function NotifyImpaledBySword( NanoProj_ThrownSword Sword );
simulated function bool NotifyStruckByHook( NanoProj_RicochetMoonHook Hook );

simulated function bool IsValidSwordDashTarget( NanoPawn Attacker )
{
	return FALSE;
}
//////

simulated function OnModifyNanoAffectedActor( SeqAct_ModifyNanoAffectedActor InAction )
{
	SetNanoState( InAction.NanoStateToBe, None );
}

/** This is used to instantiate and set the MIC on the actor **/
simulated event InitMICNanoPower()
{
	// Clear old material
	//FracturedStaticMeshComponent.SetMaterial( 0, None );
	// Make new instance from current material
	if( MI_LoseChunkPreviousMaterial != none )
	{
		MIC_NanoPower.SetParent( MI_LoseChunkPreviousMaterial );
		FracturedStaticMeshComponent.SetMaterial( 0, MIC_NanoPower );
	}
	else
	{
		MIC_NanoPower = FracturedStaticMeshComponent.CreateAndSetMaterialInstanceConstant( 0 );
	}
	class'NanoTypes'.static.SetMaterialInstanceToDefault( MIC_NanoPower );
}


/** This will activate orbital attractors on this target. **/
simulated function ActivateOrbitalAttractors()
{
	local NxForceField FF;

	// if we are busted then do not attact
	if( bBusted == true )
	{
		return;
	}

    // prob set up the force fields here so we are not always running around with them on

	foreach OrbitalsAttractList(FF)
	{
		//`log( "ActivateOrbitalAttractors" @ self @ FF );
		FF.bForceActive = TRUE;
		//FF.DoInitRBPhys();
	}
}


/** This will deactivate orbital attractors on this target. **/
simulated function DeactivateOrbitalAttractors()
{
	local NxForceField FF;

    //`log( "DeactivateOrbitalAttractorsDeactivateOrbitalAttractorsDeactivateOrbitalAttractors" @ self );

	foreach OrbitalsAttractList(FF)
	{
		FF.bForceActive = FALSE;
		//FF.DoInitRBPhys();
	}
}

/** This is needed to find the location of this OrbitalTarget **/
simulated event vector GetOrbitalTargetLocation()
{    
	return Location;
}

/** Each Orbital target will have different valid damage distances. **/
simulated event float GetDistanceForDamage()
{
	return 256.0f;
}


simulated function SetUpOrbitalAttractor()
{
	AddAnOrbitalAttractorRadial( 200.0f, -50.0f );
}


/** How many orbitals need to be touching this pawn for damage to occur (where touching is being within range **/
simulated event int GetNumOrbitalsTouchingForDamage()
{
	return 10;
}


simulated function AddAnOrbitalAttractorRadial( float InRadius, float InStrength )
{
    local NanoForceField_OrbitalAttractorRadial OrbitalsAttact;

	// would be nice to have a socket here 
	OrbitalsAttact = Spawn( class'NanoForceField_OrbitalAttractorRadial', self,,Location+Vect(0,0,140) );
	OrbitalsAttact.Shape = new(OrbitalsAttact) class'ForceFieldShapeSphere';

    OrbitalsAttact.bForceActive = FALSE;

    OrbitalsAttact.ForceRadius = InRadius;
	OrbitalsAttact.ForceStrength = InStrength;
	OrbitalsAttact.ForceFalloff = RIF_Linear;

    //OrbitalsAttact.SetHardAttach( TRUE );
	OrbitalsAttact.SetBase( self );

	OrbitalsAttact.DoInitRBPhys();

	OrbitalsAttractList.AddItem( OrbitalsAttact );
}




defaultproperties
{
	bGameRelevant=TRUE
	RemoteRole=ROLE_SimulatedProxy

	CurrentState=ENS_Normal
	ReturnToDefaultDelay=10.0f

	Begin Object Name=FracturedStaticMeshComponent0
		RBChannel=RBCC_Untitled3
	End Object

	bBreakChunksOnActorTouch=TRUE
	bWorldGeometry=FALSE
	bPathColliding=FALSE
	
	GreyGooHealRate=30.0
	bCanBeSmashedByMechs=FALSE

	//CONTENT_REF_USING_MEM
	BreakSoundCue=SoundCue'Gameplay_Audio.DensingImpacts.Densing_ImpactGlassWall_Cue'
	HealingSoundCue=SoundCue'Gameplay_Audio.Densify.DenseRebuild_GlassWall_Cue'

	SupportedEvents.Add(class'SeqEvt_NanoStateChanged')

	Begin Object Class=TargetableOctreeComponent Name=TargetableOctreeComp0
	End Object
	Components.Add(TargetableOctreeComp0)

}