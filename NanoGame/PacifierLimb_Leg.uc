/**
 * Pacifier Bot Limb - Back Gun
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class PacifierLimb_Leg extends Pacifier_LimbBase;

var() PacifierLimb_Chasis_Wrapper Chassis;

var() LegInfo MyInfo;

var() SkelControlLimb		SkelCtrl_Leg;
var() float					FootPlantTraceDist;

function InitLimb( NanoAI_PacifierBot C )
{
	// Store ref to AI
	AI = C;
	Bot = NanoPawn_MetaCorp_PacifierBotBase(C.Pawn);
	// Attach to the owning pawn
	SetBase( Chassis,, Chassis.ChassisMesh, MyInfo.SocketName );
	SetRelativeLocation(MyInfo.RelLoc);
	// Setup weapon class
	SpawnDefaultWeapon();

	LimbMIC = Chassis.ChassisMesh.CreateAndSetMaterialInstanceConstant(MyInfo.MaterialIndex);
	class'NanoTypes'.static.SetMaterialInstanceToDefault( LimbMIC );

	SkelCtrl_Leg = SkelControlLimb(Bot.Mesh.FindSkelControl(MyInfo.SkelCtrlLimbName));
}

function bool ChooseTarget();
simulated function bool AbleToFire();

/** Allow the limb to handle being destroyed */
simulated event NotifyLimbDestroyed()
{
	local int BoneIdx;
	if( Chassis != None )
	{
		Chassis.NotifyLimbDestroyed();
		BoneIdx = Bot.Mesh.MatchRefBone(BaseBoneName);
		Bot.Mesh.HideBone( BoneIdx, PBO_Term );
		Chassis.ChassisMesh.HideBone( BoneIdx, PBO_Term );
	}

	SetCollision( FALSE );

	Destroy();
}

simulated function PickFootLocation( optional bool bShowDebug )
{
	local Actor HA;
	local Vector HL, HN, StartTrace, EndTrace, TraceExtent;

	if( SkelCtrl_Leg != None )
	{
		StartTrace = Bot.Mesh.GetBoneLocation( MyInfo.TraceBoneName ) + (vect(0,0,1) * (FootPlantTraceDist*0.5f));
		EndTrace = StartTrace + (vect(0,0,-1) * FootPlantTraceDist);
		HA = Bot.Trace( HL, HN, EndTrace, StartTrace, FALSE, TraceExtent );
		if( HA == None )
		{
			HL = EndTrace;
		}

		SkelCtrl_Leg.EffectorLocation = HL;

		if( bShowDebug )
		{
			FlushPersistentDebugLines();
			DrawDebugBox( StartTrace, vect(10,10,10), 255, 0, 0, TRUE );
			DrawDebugBox( EndTrace, vect(10,10,10), 0, 0, 255, TRUE );
			DrawDebugBox( HL, vect(10,10,10), 0, 255, 0, TRUE );
			DrawDebugLine( StartTrace, EndTrace, 255, 0, 0, TRUE );
			`log( self@GetFuncName()@"Trace Hit"@HA );
		}
	}
}

simulated function PlayFootStep( bool bLift )
{
	if( SkelCtrl_Leg != None )
	{
		if( bLift )
		{
			SkelCtrl_Leg.SetSkelControlStrength( 0.f, 0.1f );
		}
		else
		{
			PickFootLocation();
			SkelCtrl_Leg.SetSkelControlStrength( 1.f, 0.0f );
		}
	}
}

/////////////////////////////////////////////////////
//////// INTERFACE: NanoInterface_PowerAffect ////////
/////////////////////////////////////////////////////
simulated function bool CanBeDusted()
{
	return FALSE;
}

simulated function bool CanBeDensed()
{
	return (CurrNanoState!=ENS_Dense);
}

simulated function bool SetNanoState(ENanoState NewState, Actor InInstigator, optional float NanoPowerAmount)
{
	local bool bReturnValue;
	bReturnValue = Super.SetNanoState(NewState, InInstigator, NanoPowerAmount);
	if( CurrNanoState == ENS_Dense )
	{
		Bot.Controller.MoveTimer = -1.f;
	}
	return bReturnValue;
}

defaultproperties
{
	Begin Object Class=StaticMeshComponent Name=StaticMesh0
    	StaticMesh=StaticMesh'EngineMeshes.Cube'
		BlockZeroExtent=TRUE
		BlockNonZeroExtent=FALSE
		CollideActors=TRUE
		BlockActors=FALSE
		HiddenGame=TRUE
		Scale3D=(X=1.0,Y=0.5,Z=0.5)
		Rotation=(Yaw=8192)
		Translation=(Y=50)
    End Object
	Components.Add(StaticMesh0)
	StaticMeshComp=StaticMesh0
	CollisionComponent=StaticMesh0

	FootPlantTraceDist=512.f
}