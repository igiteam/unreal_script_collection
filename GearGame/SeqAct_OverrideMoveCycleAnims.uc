
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class SeqAct_OverrideMoveCycleAnims extends SequenceAction
	native(Sequence);

/** Animation Definition. AnimName matched a slot. */
var(Anim) GearPawn.BodyStance Animation;
/** AnimGroup name, to sync animations together. */
var(Anim) Name AnimGroupName;
/** If animation should be slave in the AnimGroup (i.e. not drive the movement). */
var(Anim) bool bAnimGroupSlave;
/** Delay in seconds before playing the animation. */
var(Anim) FLOAT DelayBeforeActivate;
/** Blend in time */
var(Anim) FLOAT BlendInTime;
/** Blend out time */
var(Anim) FLOAT BlendOutTime;

/** Source Actor */
var(Source) Actor SourceActor;
/** Socket Name on Source Actor to define Location/Rotation */
var(Source) Name SourceSocketName;
/** Always trigger animation within that range from SourceActor. */
var(Source) FLOAT InnerRange;
/** Trigger animation only when SourceActor is visible within that range. */
var(Source) FLOAT OuterRange;

/** 
 *  Player FOV to consider the SourceActor Visible.
 *  In Degrees. 0 = Skip Check.
 */
var(Visibility) FLOAT PlayerFOV;
/** 
 *  SourceActor FOV to consider the Player Visible.
 *  In Degrees. 0 = Skip Check.
 */
var(Visibility) FLOAT SourceActorFOV;

/** 
 *  Do a simple line check for visibility to the SourceActor. 
 *  Don't over abuse, for performance. */
var(Visibility) BOOL bDoLineCheck;

/** Display debugging information in-game */
var(Debug) bool bDebug;

defaultproperties
{
	Animation={(Stance=(
		(Slot=BS_Layer_Stand_Idle_Idle,AnimName="ADD_Bright_Light"),
		(Slot=BS_Layer_Stand_Walk_Idle,AnimName="ADD_AR_Walk_React_Bright_Light"),
		(Slot=BS_Layer_Stand_Run_Idle,AnimName="ADD_AR_Run_React_Bright_Light"))
		)}
	AnimGroupName="RunWalk"
	BlendInTime=0.33f
	BlendOutTime=0.67f

	InnerRange=0.f
	OuterRange=400.f
	PlayerFOV=80.f
	SourceActorFOV=30.f
	bDebug=TRUE

	ObjName="Play Anim Directional"
	ObjCategory="Gear"

	InputLinks(0)=(LinkDesc="Play")
	InputLinks(1)=(LinkDesc="Stop")

	VariableLinks(1)=(ExpectedType=class'SeqVar_Object',LinkDesc="SourceActor",PropertyName=SourceActor)

	// define the base output link that this action generates (always assumed to generate at least a single output)
	OutputLinks(0)=(LinkDesc="Out")
}
