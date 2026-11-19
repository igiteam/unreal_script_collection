/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NSM_Melee_PinEnemy extends NSM_InteractionLeader_Base;

enum NanoPinState
{
	NPS_None,
	NPS_Start,
	NPS_Loop,
	NPS_Release,
};

var Name PinnedStartAnim, PinnedLoopAnim;
var Name ReleaseAnimName;
var NanoPinState PinState;
var float PinStartTime;
var float PinStartLength;


protected function bool InternalCanDoSpecialMove()
{
	return TRUE;
}

function bool CanOverrideMoveWith( Name NewMove )
{
	return TRUE;
}

function StartInteraction()
{
	local Vector RelLoc;

	MyNP.StopFiring();

	MyNP.SetPhysics( PHYS_None );
	MyNP.SetHardAttach( TRUE );
	MyNP.SetBase( MyNP.InteractionPawn, vect(0.f,0.f,1.f), MyNP.InteractionPawn.Mesh, 'b_MF_Attach' );

	RelLoc = MyNP.Location - MyNP.Mesh.GetBoneLocation( 'b_MF_Root' );
	MyNP.SetRelativeLocation( RelLoc );
//	MyNP.SetRelativeRotation( rot(0,-16384,0) );

	MyNP.bIgnoreBaseRotation = TRUE;
	MyNP.LockDesiredRotation( FALSE );
	MyNP.SetDesiredRotation( MyNP.Rotation, TRUE );

	MyNP.IgnoreBlockingList[MyNP.IgnoreBlockingList.Length] = MyNP.InteractionPawn;

	MyNP.InteractionPawn_AllowShootingOverride = TRUE;

	PlayPinnedStartAnim();

	MyNP.EnableFakeDenseEffects();
	PinStartTime = MyNP.WorldInfo.TimeSeconds;

	// modify combat effectors
	NanoGRI(MyNP.WorldInfo.GRI).AIBlackboard.HandleCombatEvent( NCAT_PlayerJumpAndPinnedAI, None ); 
}

function SpecialMoveEnded( Name PrevMove, Name NextMove )
{
	MyNP.ClearTimer( nameof(PlayPinnedLoopAnim), self );
	MyNP.ClearTimer( nameof(FinishSpecialMove), self );

	MyNP.LockDesiredRotation( FALSE );  
	MyNP.FullBodySlot.SetRootBoneAxisOption( RBA_Discard, RBA_Discard, RBA_Discard );
	MyNP.Mesh.RootMotionMode = RMM_Ignore;
	MyNP.bIgnoreBaseRotation = MyNP.default.bIgnoreBaseRotation;
	MyNP.FullBodySlot.StopCustomAnim( 0.25f );	

	MyNP.SetPhysics( PHYS_Walking );
	MyNP.SetHardAttach( MyNP.default.bHardAttach );
	MyNP.SetBase( None );

	MyNP.InteractionPawn_AllowShootingOverride = FALSE;
	MyNP.bWantsToShoot = FALSE;
	MyNP.bIsTargeting = FALSE;

	MyNP.InteractionType = PAWNINTER_None;
	MyNP.DisableFakeDenseEffects();

	if( Follower != None )
	{
		Follower.EndSpecialMove();
	}

	Super.SpecialMoveEnded( PrevMove, NextMove );

	PinState = NPS_None;
}

simulated function PlayPinnedStartAnim()
{
	MyNP.FullBodySlot.SetRootBoneAxisOption( RBA_Discard, RBA_Discard, RBA_Discard );

	// Play start animation
	PinStartLength = MyNP.FullBodySlot.PlayCustomAnim( PinnedStartAnim, GetSpeedModifier(), 0.1f, -1.f, FALSE, TRUE );
	MyNP.FullBodySlot.SetRootBoneAxisOption( RBA_Default, RBA_Default, RBA_Default );

	MyNP.SetTimer( PinStartLength, FALSE, nameof(PlayPinnedLoopAnim), self );

	PinState = NPS_Start;
}

simulated function PlayPinnedLoopAnim()
{
	MyNP.ClearTimer( nameof(PlayPinnedLoopAnim), self );
	MyNP.FullBodySlot.PlayCustomAnim( PinnedLoopAnim, GetSpeedModifier(), 0.f, -1.f, TRUE, TRUE );
	PinState = NPS_Loop;
}

simulated function PlayPinnedReleaseAnim( Vector Dir )
{
	local float AnimTime;

//	MyNP.FullBodySlot.SetRootBoneAxisOption( RBA_Discard, RBA_Discard, RBA_Discard );
	AnimTime = MyNP.FullBodySlot.PlayCustomAnim( ReleaseAnimName, GetSpeedModifier(), 0.25f, -1.f, FALSE, TRUE );
	MyNP.FullBodySlot.SetRootBoneAxisOption( RBA_Translate, RBA_Translate, RBA_Translate );
	MyNP.Mesh.RootMotionMode = RMM_Accel;
	MyNP.SetTimer( AnimTime, FALSE, nameof(FinishSpecialMove), self );

	MyNP.SetPhysics( PHYS_Walking );
	MyNP.SetHardAttach( MyNP.default.bHardAttach );
	MyNP.SetBase( None );

	MyNP.SetRotation( Rotator(Dir) );
	MyNP.LockDesiredRotation( FALSE );
	MyNP.SetDesiredRotation( Rotator(Dir), TRUE );
	
	MyNP.ClearTimer( nameof(PlayPinnedLoopAnim), self );

	PinState = NPS_Release;
}

simulated function FinishSpecialMove()
{
	MyNP.EndSpecialMove();
}

simulated function Tick( float DeltaTime )
{
	Super.Tick( DeltaTime );

	if( MyNP.Physics == PHYS_Walking && PinState != NPS_Release )
	{
		MyNP.SetPhysics( PHYS_None );
	}

	if( PinState == NPS_Loop || (PinState == NPS_Start && (`TimeSinceEx(MyNP, PinStartTime) / PinStartLength) > 0.3f) )
	{
		CheckReleasePinnedPawn();
	}
}

simulated function CheckReleasePinnedPawn()
{
	local NanoPC PC;
	local Vector JoyDir;

	PC = NanoPC(MyNP.Controller);
	if( PC != None && PC.PlayerCamera != None )
	{
		if( Abs(PC.PlayerInput.RawJoyUp) > 0.2f )
		{
			JoyDir.X = PC.PlayerInput.RawJoyUp;
		}
		if( Abs(PC.PlayerInput.RawJoyRight) > 0.2f )
		{
			JoyDir.Y = PC.PlayerInput.RawJoyRight;
		}

		if( !IsZero( JoyDir ) )
		{
			JoyDir = JoyDir >> PC.PlayerCamera.Rotation;
			JoyDir.Z = 0;
			JoyDir = Normal(JoyDir);
			PlayPinnedReleaseAnim( JoyDir );
		}
	}
	else
	{
		PlayPinnedReleaseAnim( Vector(MyNP.Rotation) );
	}
}



/** 
 * If the player is:
 * 
 *  0) holding a Gun AND pulls the trigger, we head shot explode the pinned pawn
 *  1) some other button:  curb stomp / smash down on check to break the enemy
 *
 **/
function bool FilterButtonInput(Name ButtonName,bool bPressed,int ButtonIdx)
{

	//`log( `showvar(ButtonName) );

	switch( ButtonName )
	{
	case 'R2':
		// if we are holding a gun
		if( ( NanoWeap_Hands(MyNP.Weapon) == None ) && (NanoWeap_Melee(MyNP.Weapon) == None ) )
		{
			ShootPinnedPawnsHead();
			return TRUE;
		}
		break;
	}

	return TRUE;
}


private function ShootPinnedPawnsHead()
{
	local TraceHitInfo HitInfo;

	//`log( "ShootPinnedPawnsHead" @ `showvar(Follower) @ `showvar(Follower.HeadBoneNames[0]) );
	MyNP.bWantsToShoot = TRUE;
	MyNP.bIsTargeting = TRUE;

	HitInfo.BoneName = Follower.HeadBoneNames[0] ;
	Follower.TakeDamage( Follower.Health, MyNP.Controller, Follower.Mesh.GetBoneLocation( Follower.HeadBoneNames[0] ), vect(0,0,0), class'NDT_MP7', HitInfo, MyNP );

	// wait a second to allow for the glorious gibs to land
	MyNP.SetTimer( 1.0f, FALSE, nameof(FinishSpecialMove), self );

}




defaultproperties
{
	PinnedStartAnim=Sword_LandOnHead_Start
	PinnedLoopAnim=Sword_LandOnHead_Loop
	ReleaseAnimName=Sword_LandOnHead_WalkOff_Fwd

	FollowerSpecialMoveName=NSM_Melee_PinVictim

	InteractionType=PAWNINTER_Pin
}