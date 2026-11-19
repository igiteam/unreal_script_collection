/**
 * Pacifier Bot Limb - Core
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class PacifierLimb_Core extends Pacifier_LimbBase;

/** Particle system for core when activated */
var	protected const ParticleSystem		PS_CoreEffect;
/** Emitter to core particle system */
var transient NanoEmitter				CoreEmitter;

simulated function Destroyed()
{
	Super.Destroyed();

	// Cleaup effects
	CoreEmitter.Destroy();
}

function SetEnabled( bool bInEnabled )
{
	Super.SetEnabled( bInEnabled );
	SetCollision( bEnabled );

	if( bEnabled )
	{
		PlayCoreEffects();
	}
}

simulated function PlayCoreEffects()
{
	Bot.ChestPlateComp.SetHidden( TRUE );
	Bot.ChestPlateComp.SetActorCollision( FALSE, FALSE );

	// Spawn effects
	if( CoreEmitter == None )
	{
		CoreEmitter = Spawn(class'SpawnedNanoEmitter', self);
		if( CoreEmitter != None )
		{
			CoreEmitter.LifeSpan = 0.0f;
			CoreEmitter.bPostUpdateTickGroup = TRUE;
			CoreEmitter.SetTemplate( PS_CoreEffect, FALSE );
			CoreEmitter.SetBase( Bot,, Bot.Mesh, 'Core' );
		}
	}
}

simulated event NotifyLimbDestroyed()
{
	SetEnabled( FALSE );

	Bot.Died( None, class'NDT_Bomb', Location );
}

/////////////////////////////////////////////////////
//////// INTERFACE: NanoInterface_Targetable /////////
/////////////////////////////////////////////////////
simulated function float GetBasePriority(NanoPC Askee, optional NanoPawn AskeePawn)
{
	if( !IsTargetable() )
	{
		return INDEX_NONE;
	}

	return 1;
}

simulated function bool IsTargetable( optional ETargetQueryType QT )
{
	return (bEnabled);
}

defaultproperties
{
	SocketName=Core

	Begin Object Class=StaticMeshComponent Name=StaticMesh0
    	StaticMesh=StaticMesh'EngineMeshes.Cube'
		BlockZeroExtent=TRUE
		BlockNonZeroExtent=FALSE
		CollideActors=TRUE
		BlockActors=FALSE
		HiddenGame=TRUE
		Scale3D=(X=0.25,Y=0.25,Z=0.25)
		Translation=(X=100,Y=-25,Z=20)
    End Object
	Components.Add(StaticMesh0)
	StaticMeshComp=StaticMesh0
	CollisionComponent=StaticMesh0

	bCollideActors=FALSE

	// EFFECTS
	PS_CoreEffect=ParticleSystem'MET_PacifierMechProto.Effects.P_FX_PacBot_CoreSystem'
}