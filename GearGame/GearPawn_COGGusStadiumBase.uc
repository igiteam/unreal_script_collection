/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearPawn_COGGusStadiumBase extends GearPawn_COGGear
	abstract
	config(Pawn)
	native(Pawn);

/** Interp group name for the stadium charge */
var	name InterpGroupName;
/** Interp data for the stadium charge */
var	InterpData StadiumChargePath;
/** Current position within movement path */
var	float CurrentInterpTime;
/** Most recent strafe input from our player controller */
var transient float LastStrafe;

var float   StrafeAccelRate;
var float   DeviationInterpSpeed;

/** Current deviation offset from the matinee path */
var transient float PathDeviation;
/** Maximum allowed deviation offset from the matinee path */
var float MaxPathDeviation;
var transient Vector LastInterpPos;
var transient bool bJustStartedSpecialMove;


var AnimNodeSequence RoadieRunAdditiveNode;

var StaticMeshComponent SMC_Bomb;
var repnotify bool bThashballHidden;


cpptext
{
	/** Util for getting current InterpGroup used by Cole */
	class UInterpGroup* GetCurrentInterpGroup();

	virtual void physWalking(FLOAT deltaTime, INT Iterations);
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	
	if( SMC_Bomb != None )
	{
		Mesh.AttachComponentToSocket( SMC_Bomb, 'Thrashball' );
		SMC_Bomb.SetShadowParent(Mesh);
		SMC_Bomb.SetLightEnvironment(LightEnvironment);
	}
}

simulated event ReplicatedEvent( name VarName )
{
	Super.ReplicatedEvent( VarName );

	switch( VarName )
	{
		case 'bThashballHidden':
			SetThrashballHidden( bThashballHidden );
			break;
	}
}


function Reset()
{
	CurrentInterpTime = 0.f;
	LastInterpPos = vect(0,0,0);
	LastStrafe = 0;
	PathDeviation = 0;
}

/** Cache additional animation nodes. */
simulated function CacheAnimNodes()
{
	Super.CacheAnimNodes();

	RoadieRunAdditiveNode = AnimNodeSequence(Mesh.FindAnimNode('RoadieRunAdditiveNode'));
}

simulated function ClearAnimNodes()
{
	Super.ClearAnimNodes();

	RoadieRunAdditiveNode = None;
}

/**
 * Handler for AssignInterpPath action, that tells Cole about the interp path
 *
 * @param AssignInterpPathAction - the kismet action assigning the interpolation path
 */
simulated function OnAssignInterpPath(SeqAct_AssignInterpPath AssignInterpPathAction)
{
	local Array<InterpData> IDataArray;
	local int idx;
	local InterpData IData;


	Reset();
	InterpGroupName = AssignInterpPathAction.InterpGroupName;	
	AssignInterpPathAction.GetInterpDataVars(IDataArray,"InterpPath");

	for (idx = 0; idx < IDataArray.Length; idx++)
	{
		IData = IDataArray[idx];
		if (IData != None)
		{
			StadiumChargePath = IData;
			return;
		}
	}

	InterpGroupName = '';
	StadiumChargePath = None;
}

simulated function SetThrashballHidden( bool bHide )
{
	bThashballHidden = bHide;
	if( SMC_Bomb != None )
	{
		SMC_Bomb.SetHidden( bThashballHidden );
	}
}

simulated function OnManageThrashball(SeqAct_ManageThrashball InAction)
{
	if( InAction.InputLinks[0].bHasImpulse )
	{
		SetThrashballHidden( FALSE );
	}
	else if( InAction.InputLinks[1].bHasImpulse )
	{
		SetThrashballHidden( TRUE );
	}
}

defaultproperties
{
	SpecialMoveClasses(SM_RoadieRun)=class'GSM_RoadieRunStadium'
	SpecialMoveClasses(SM_MidLvlJumpOver)=class'GSM_MidLvlJumpOver_Thrashball'
	SpecialMoveClasses(GSM_PounceAttack)=class'GSM_Thrashball_ShoulderCharge'
	SpecialMoveClasses(GSM_SwipeAttack)=class'GSM_Thrashball_StiffArm'
	SpecialMoveClasses(GSM_Scream)=class'GSM_Thrashball_Spin'

	MaxPathDeviation=150
	StrafeAccelRate=250.f
	DeviationInterpSpeed=8.f
}
