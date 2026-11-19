/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NSM_GhostDash extends NanoSpecialMove;

// How long dash will last
var float PowerDashDuration;
// Last time dash power was activated/terminated - used to limit use frequency
var protected float LastPowerDashTime;

// Start/End location of the ghost dash
var Vector StartDashLocation, EndDashLocation;
// Direction to move in one second while dashing
var transient vector   GhostDashMovePerSec;

/** Sound to play when the bamf fires **/
var SoundCue BamfSound;
var SoundCue GhostDashSound;

// This is the trail you leave behind when ghost dashing
var name GhostDashTrailName;
var ParticleSystem PS_GhostDash;
var transient ParticleSystemComponent PSC_GhostDash;



protected function bool InternalCanDoSpecialMove()
{
	local NanoPC PC;
	local NanoSkill_Bamf BamfSkill;

	PC = NanoPC(MyNP.Controller);
	if( PC == None ) 
	{
		return FALSE;
	}

	if( MyNP.Physics != PHYS_Falling )
	{
		return FALSE;
	}

	BamfSkill = MyNP.GetSkill(class'NanoSkill_Bamf');
	if( BamfSkill == None || BamfSkill.GetBamfDistance( MyNP ) <= 0.f )
	{
		return FALSE;
	}

	if( `TimeSinceEx(MyNP,LastPowerDashTime) < 1.f )
	{
		return FALSE;
	}

	return Super.InternalCanDoSpecialMove();
}

function SpecialMoveStarted( bool bForced, Name PrevMove )
{
	local NanoPC PC;
	local Vector DeltaMove;

	Super.SpecialMoveStarted( bForced, PrevMove );

	ExtractSpecialMoveFlags( MyNP.SpecialMoveFlags );

	LastPowerDashTime = MyNP.WorldInfo.TimeSeconds;
	StartDashLocation = MyNP.Location;
	EndDashLocation	  = GetGhostDashEndLocation( NanoPC(MyNP.Controller), 1.f );

//	MyNP.LockDesiredRotation( TRUE );

	DeltaMove = EndDashLocation - StartDashLocation;
	GhostDashMovePerSec = (DeltaMove/PowerDashDuration);

	MyNP.bIsBamfing = TRUE;
	MyNP.EnableFakeGhostEffects();

	PC = NanoPC(MyNP.Controller);
	if( PC != None )
	{
		PC.PlaySound( GhostDashSound );

//		if( PSC_GhostDash == None )
//		{
			//PSC_GhostDash = new(self) class'NanoParticleSystemComponent';
			//PSC_GhostDash.SetTemplate( PS_GhostDash );
			//MyNP.Mesh.AttachComponentToSocket( PSC_GhostDash, GhostDashTrailName );
//		}
//		PSC_GhostDash.ActivateSystem();

		PC.PlaySound( BamfSound );
	}

	MyNP.EnableFakeGhostEffects();
}

function SpecialMoveEnded( Name PrevMove, Name NextMove )
{
	Super.SpecialMoveEnded( PrevMove, NextMove );

	LastPowerDashTime = MyNP.WorldInfo.TimeSeconds;
	MyNP.bIsBamfing = FALSE;
	MyNP.DisableFakeGhostEffects();

//	if( PSC_GhostDash != None )
//	{
	//	PSC_GhostDash.DeactivateSystem();
//	}
}

// This can take a modifier for how far (distance) we want to search for the dash location. Which allows us to modify how far we are going to move for curve moving around a target 
simulated function vector GetGhostDashEndLocation( PlayerController PC, float Modifier )
{
	local Vector EndLoc, DashDir, CamLoc;
	local rotator CamRot;
	local NanoSkill_Bamf BamfSkill;

	// Figure out direction and distance to teleport in world space
	DashDir.X = PC.PlayerInput.RawJoyUp;
	DashDir.Y = PC.PlayerInput.RawJoyRight;
	
	if( Abs(DashDir.X) < 0.2f && Abs(DashDir.Y) < 0.2f )
	{
		MyNP.GetActorEyesViewPoint( CamLoc, CamRot );
		DashDir = Vector(CamRot);
	}
	else
	{
		DashDir = DashDir >> GetGhostDashMoveRotation();
	}

	DashDir.Z = 0;
	DashDir = Normal(DashDir);

	BamfSkill = MyNP.GetSkill(class'NanoSkill_Bamf');
	EndLoc = StartDashLocation + (DashDir * BamfSkill.GetBamfDistance( MyNP ) * Modifier);

	return EndLoc;
}

simulated final function Rotator GetGhostDashMoveRotation()
{
	local Vector CamLoc;
	local rotator CamRot;

	MyNP.GetActorEyesViewPoint(CamLoc,CamRot);
	CamRot.Pitch = 0;//ClampRotAxisFromBase(CamRot.Pitch,0,8192);
	return CamRot;
}

simulated function Tick( float DeltaTime )
{
	local NanoSkill_Ghost GhostSkill;
	local float DashTime, DashTimeRemaining;
	local Vector MoveDelta;
	
	Super.Tick( DeltaTime );

	GhostSkill = MyNP.GetSkill( class'NanoSkill_Ghost' );

	DashTimeRemaining = PowerDashDuration - `TimeSinceEx(MyNP,LastPowerDashTime);
	if( DashTimeRemaining <= 0.f )
	{
		// Don't let bamf end inside a ghost thru object (ie fence)
		if( GhostSkill == None || !GhostSkill.ShouldActivate() )
		{
			MyNP.EndSpecialMove( 'NSM_GhostDash' );
		}
		else
		{
			DashTimeRemaining = DeltaTime;
		}
	}
	
	if( DashTimeRemaining > 0.f )
	{
		// How much dashing we should do this frame
		DashTime = FMin( DeltaTime, DashTimeRemaining );
		MoveDelta = (GhostDashMovePerSec * DashTime);
		PawnOwner.Move( MoveDelta );
	}
}

defaultproperties
{
	PowerDashDuration=0.15f

	BamfSound=SoundCue'Gameplay_Audio.Dusting.DustBamf_Stereo_01Cue'

	GhostDashSound=SoundCue'Gameplay_Audio.GhostDash.GhostDash_Cue'
	GhostDashTrailName="GhostDashTrail"
	PS_GhostDash=ParticleSystem'Nano_Effects_Ghost.Effects.P_Nano_Effects_DashTrail'



/*
	GhostDashSound=SoundCue'Gameplay_Audio.GhostDash.GhostDash_Cue'
	RunThroughDustifyEnemySoundCue=SoundCue'Gameplay_Audio.Dustify.Dustify_Airy_Cue'

// 	DustifySelfSoundCue=SoundCue'Gameplay_Audio.Dusting.Dusting_Magnetic_Cue'
// 	DustifyTargetSoundCue=SoundCue'Gameplay_Audio.Dustify.Dustify_Airy_Cue'
//
// 	DustifySelfSoundCue=SoundCue'Gameplay_Audio.Dusting.Dusting_WhooshA_Cue'
// 	DustifyTargetSoundCue=SoundCue'Gameplay_Audio.Dustify.Dustify_WhooshA_Cue'
//
// 	DensifySelfSoundCue=SoundCue'Gameplay_Audio.Densing.Densing_Bend_Cue'
// 	DensifyTargetSoundCue=SoundCue'Gameplay_Audio.Densify.Densify_Bend_Cue'

	MovingThroughADustableObjectCue=SoundCue'Gameplay_Audio.Dusting.Dusting_WhooshB_Cue'

	GhostDashTrailName="GhostDashTrail"
	PS_GhostDash=ParticleSystem'Nano_Effects_Ghost.Effects.P_Nano_Effects_DashTrail'

	DenseDashImpactSound=SoundCue'Gameplay_Audio.DenseDash.DenseDashImpact_Cue'

	Begin Object Class=NanoCameraShake Name=DenseDashScreenShake0
		OscillationDuration=0.25f
		RotOscillation={(Pitch=(Amplitude=1000.f,Frequency=80.f),
						Yaw=(Amplitude=400.f,Frequency=40.f),
						Roll=(Amplitude=600.f,Frequency=50.f))}
	End Object
	DenseDashScreenShake=DenseDashScreenShake0

	MinTimeBetweenGhostDash=1.0
	GhostDashTime=0.15
	GhostDashNanoCost=1.f
	GhostDenseDashThroughCost=2.0f
	GhostDashVertMaxDistance=200.0
	GhostDashAIStunTime=5.0f


	DenseDashKnockbackVelocity=1024.0f
	DenseDashKnockbackUpVelocity=400.0f
	DenseBashKnockbackDamage=100
*/
}