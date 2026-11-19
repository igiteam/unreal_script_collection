/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoPlan_ForgeRockets extends NanoPlan;

var() protected const vector SpawnOffset;
var() protected const float SpawnSpacing;
var() protected const int MaxRockets;

/** Queued up rockets, waiting to be launched */
var protected transient array<NanoProj_ForgedRocket> RocketQueue;

var protected transient bool bEnded;

var protected class<NanoProj_ForgedRocket> ProjClass;

/** Before we fire our rocket we want to give the player a chance to line up their shot **/
var config float DelayBeforeFiringFirstRocket;


function StartForge(optional delegate<NanoPawn.OnForgeFinished> OnFinishCallback)
{
	bEnded = FALSE;
	RocketQueue.length = 0;

	// start pawn's special move
	PawnOwner.DoSpecialMove( 'NSM_ForgeCycleFast',,,, 1 );

	PawnOwner.SetTimer( DelayBeforeFiringFirstRocket, FALSE, nameof(DoSingleRocketForge), self );

	Super.StartForge(OnFinishCallback);
}


protected function DoSingleRocketForge()
{
	local NanoProj_ForgedRocket Proj;
	local vector SpawnLoc, CamX, CamY, CamZ;
	local rotator CamRot;
	
	CamRot = PawnOwner.GetViewRotation();
	GetAxes(CamRot, CamX, CamY, CamZ);
	SpawnLoc = PawnOwner.Location + (SpawnOffset >> CamRot) + (CamY * SpawnSpacing * RocketQueue.length);

	Proj = PawnOwner.Spawn(ProjClass,,, SpawnLoc, CamRot,, TRUE);
	Proj.ForgeActor(SingleRocketForgeFinished);

	RocketQueue.AddItem(Proj);
}

function SingleRocketForgeFinished()
{
	if (!bEnded && RocketQueue.length < MaxRockets)
	{
		if( CanDoForge( PawnOwner ) == TRUE )
		{
			PayNanoPowerCost( PawnOwner );
			// forge another!
			DoSingleRocketForge();
		}
		else
		{
			 FireAllRockets();
		}
	}
	else
	{
		FireAllRockets();
	}
}


function FireAllRockets()
{
	local NanoProj_ForgedRocket Rocket;

	// trigger all rockets to launch
	foreach RocketQueue(Rocket)
	{
		Rocket.NanoProjInit(vector(Rocket.Rotation));
	}
	RocketQueue.Length = 0;

	FinishAnim();

}

function EndForge()
{
	FinishAnim();
	PawnOwner.ClearTimer( nameof(DoSingleRocketForge), self );

	// cache end signal, to let the current rocket finish forging
	bEnded = TRUE;
	Super.EndForge();
}


function FinishAnim()
{
	local NSM_ForgeCycle SM;

	// signal special move to end
	SM = NSM_ForgeCycle(PawnOwner.ActiveSpecialMove);
	if( SM != None )
	{
		SM.PlayCompleteAnimation();
	}
}


defaultproperties
{
	PlanName="Hand Rockets"
	PlanSlot=EPS_Utility

	ForgeUIData=(PlanName="Hand Rockets",PlanDescription="Fires rockets in the direction the camera is looking.",UIMesh=StaticMesh'REB_RocketLauncher.Meshes.SM_REB_Rocket')
	PlanIcon=(IconTex=Texture2D'UI_HUD.Menu.BlueprintMissiles',Coords=(U=0,V=0,UL=256,VL=256))

	AimingCrossHair=Texture2D'Warfare_HUD.HUD_Xhair_COG_silverback'

	SpawnOffset=(X=200.f,Z=150.f)
	SpawnSpacing=50.f
	MaxRockets=6

	ProjClass=class'NanoProj_ForgedRocket'
}