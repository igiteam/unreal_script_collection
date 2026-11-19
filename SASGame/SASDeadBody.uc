//=============================================================================
// SASDeadBody.uc
//
// Base class for 
//=============================================================================

class SASDeadBody extends SASPawn
	placeable;

//-----------------------------------------------------------------------------
// Constants

//-----------------------------------------------------------------------------
// Enums

//-----------------------------------------------------------------------------
// Structs

//-----------------------------------------------------------------------------
// Member Vars

//-----------------------------------------------------------------------------
// Native Functions

//-----------------------------------------------------------------------------
// Functions

simulated event PreBeginPlay()
{
	if ( Level.NetMode == NM_Client )
	{
		Role = ROLE_Authority;
		RemoteRole = ROLE_None;
	}

	Super.PreBeginPlay();
}

///////////////////////////////////////////////////////////////////////////////
// PostBeginPlay
//
simulated event PostBeginPlay()
{
	if ( KParams != None && KarmaParamsSkel( KParams ) != None )
	{
		if ( KarmaParamsSkel( KParams ).KSkeleton == "" )
		{
			KarmaParamsSkel( KParams ).KSkeleton = "SASSoldier";
		}
	}

	Super.PostBeginPlay();

	LifeSpan = 0.0;
	bPlayedDeath = true;
	Health = 0;
	bTearOff = true;
	KWake();

	GotoState( 'Dying' );
}


///////////////////////////////////////////////////////////////////////////////
// STATE Dying
//
auto simulated state Dying
{
ignores AnimEnd, Trigger, Bump, HitWall, HeadVolumeChange, PhysicsVolumeChange, Falling, BreathTimer;
	
	simulated event BeginState()
	{
		SetCollision( true, false, false );
	
		mOldLocation = Location;
		bInvulnerableBody = true;
	}
}


//-----------------------------------------------------------------------------
// Default properties


// Decompiled with UE Explorer.
defaultproperties
{
    ControllerClass=none
    Mesh=SkeletalMesh'CSas.CT02'
    InitialState="'"
    // Reference: KarmaParamsSkel'SASDeadBody.DeadBody0'
    begin object name=DeadBody0 class=Class'Engine.KarmaParamsSkel'
        KSkeleton="SASSoldier"
        KLinearDamping=0.3000000
        KAngularDamping=0.0500000
        KBuoyancy=1.0000000
        KStartEnabled=true
        KVelDropBelowThreshold=50.0000000
        bHighDetailOnly=false
        KFriction=0.9900000
        KRestitution=0.1500000
        KImpactThreshold=500.0000000
    end object
    KParams=DeadBody0
    Physics=14
    RemoteRole=0
    bNoDelete=true
    bBlockActors=false
    bBlockPlayers=false
}