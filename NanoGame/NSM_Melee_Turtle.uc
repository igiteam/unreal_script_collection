/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NSM_Melee_Turtle extends NanoSpecialMove;


/** If we are turtled we take a fixed amount of damage not matter what **/
var config int DamageToTakeWhileTurtled;


var transient name CurrentBlockAnim;


var SoundCue BlockSound;

/** since our block anims do not have Root Motion, we will borrow from this anim **/
var name AnimWithBackwardsRootMotion;

var array<name> Blocks;

var name Block_R;

var name Block_L;

var name Block_U;


var transient float LastTimeHit;

var config float TimeToWaitAfterLastHitBeforeEnding;


function SpecialMoveStarted( bool bForced, Name PrevMove )
{
	Super.SpecialMoveStarted( bForced, PrevMove );

	MyNP.StopFiring();
	MyNP.ZeroMovementVariables();

	ChooseAndPlayAnAnim();
}


function SpecialMoveEnded( Name PrevMove, Name NextMove )
{
	Super.SpecialMoveEnded( PrevMove, NextMove );

	MyNP.FullBodySlot.StopCustomAnim( 0.1f );
}




simulated function Tick( float DeltaTime )
{
	Super.Tick( DeltaTime );

	//`log( `showvar(`TimeSinceEx(MyNP, LastTimeHit)) @ `showvar(TimeToWaitAfterLastHitBeforeEnding) );
	if( `TimeSinceEx(MyNP, LastTimeHit) > TimeToWaitAfterLastHitBeforeEnding )
	{
		MyNP.EndSpecialMove();
	}
}




function ChooseAndPlayAnAnim()
{
	local array<name> LocalBlocks;
	local name AnimToPlay;
//	local float AnimTime;

	LastTimeHit = MyNP.WorldInfo.TimeSeconds;

	//// set up root motion
	// since our block anims do not have Root Motion, we will borrow 
	MyNP.ExtractRootMotionCurve( AnimWithBackwardsRootMotion, (1.f / 30.f), MyNP.RootMotionInterpCurve, FALSE ); //TRUE );
	MyNP.RootMotionInterpCurrentTime = 0.f;
	MyNP.RootMotionInterpCurveLastValue = vect(0,0,0);
	MyNP.bRootMotionFromInterpCurve = TRUE;
	MyNP.Mesh.RootMotionMode = RMM_Accel;
	MyNP.FullBodySlot.SetRootBoneAxisOption( RBA_Translate, RBA_Translate, RBA_Discard );

	//// set up the block anim to play
	// find a random block post to so where
	LocalBlocks = Blocks;

	LocalBlocks.RemoveItem( CurrentBlockAnim );

	AnimToPlay = LocalBlocks[ Rand( LocalBlocks.Length ) ];
	CurrentBlockAnim = AnimToPlay;

	MyNP.FullBodySlot.PlayCustomAnim( AnimToPlay, GetSpeedModifier(), 0.2f, -1.f, TRUE, TRUE );

	`log( `showvar(AnimToPlay) );


	//// do any effects
	MyNP.PlaySound( BlockSound );
}


function PlayNewAnim()
{
	ChooseAndPlayAnAnim();
}









defaultproperties
{
	BlockSound=SoundCue'Weapon_Shield.Shield.ShieldMeleeSwingBlockCue'

	AnimWithBackwardsRootMotion="ShockTrooper_Evade_Staff_Dir_Back"

	Block_R="Baton_Block_Dir_R_A"
	Block_L="Baton_Block_Dir_L_A"
	Block_U="Baton_Block_Dir_U_A"

	Blocks.Add("Baton_Block_Dir_R_A")
	Blocks.Add("Baton_Block_Dir_L_A")
	Blocks.Add("Baton_Block_Dir_U_A")

	RootMotionScaleFactor=0.5f

}