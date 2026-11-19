/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoFlag extends Actor
	placeable;

var() int Team;
var() NavigationPoint HomePoint;

var SkeletalMeshComponent FlagMeshComp;
var SkeletalMesh FlagMesh;

var NanoPawn FlagCarrier;

var float FlagReturnToHomeTime;

function FlagCarrierDied(Controller Killer, NanoPawn Victim);

function GiveFlagTo(NanoPawn NP)
{
	`log(`location@`showvar(NP));
	FlagCarrier = NP;
	SetCollision(FALSE,FALSE);
	SetLocation(FlagCarrier.Location + vect(0,0,64));
	SetBase(FlagCarrier);
	FlagCarrier.DeathNotifyReceivers.AddItem(FlagCarrierDied);
	FlagCarrier.LockNanoPower('HoldingFlag');
	GotoState('FlagCarried');
}

function CaptureFlag()
{
	`log(`location);
	GetTeamInfo(FlagCarrier.GetTeamNum()).ScoreCapture();
	FlagCarrier.UnlockNanoPower('HoldingFlag');
	FlagCarrier.DeathNotifyReceivers.RemoveItem(FlagCarrierDied);
	FlagCarrier = None;
	ReturnFlag();
}

function ReturnFlag()
{
	`log(`location);
	SetBase(None);
	SetCollision(TRUE,FALSE);
	SetLocation(HomePoint.Location);
	`log(`location@"returning to home");
	GotoState('FlagAtHome');
}

function DropFlag()
{
	`log(`location);
	FlagCarrier = None;
	SetBase(None);
	SetCollision(TRUE,FALSE);
	GotoState('FlagDropped');
}

auto state FlagAtHome
{
	function BeginState(Name PrevStateName)
	{
		GetTeamInfo().UpdateFlagStatus(FS_Home);
	}

	event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
	{
		local NanoPawn NP;
		local NanoFlag NF;
		local Actor AttachedToNP;
		NP = NanoPawn(Other);
		`log(`location@`showvar(NP));
		if (NP != None)
		{
			if (NP.GetTeamNum() != Team)
			{
				// flag taken
				GiveFlagTo(NP);
			}
			else
			{
				// flag captured?
				foreach NP.Attached(AttachedToNP)
				{
					NF = NanoFlag(AttachedToNP);
					if (NF != None)
					{
						NF.CaptureFlag();
					}
					break;
				}
			}
		}
	}
}

state FlagCarried
{
	function BeginState(Name PrevStateName)
	{
		GetTeamInfo().UpdateFlagStatus(FS_Carried);
	}

	function FlagCarrierDied(Controller Killer, NanoPawn Victim)
	{
		`log(`location@`showvar(Victim));
		DropFlag();
	}
}

state FlagDropped
{
	function BeginState(Name PrevStateName)
	{
		GetTeamInfo().UpdateFlagStatus(FS_Dropped);
	}

	event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
	{
		local NanoPawn NP;
		NP = NanoPawn(Other);
		if (NP != None && NP.Health > 0)
		{
			if (NP.GetTeamNum() != Team)
			{
				GiveFlagTo(NP);
			}
			else
			{
				ReturnFlag();
			}
		}
	}

Begin:
	Sleep(FlagReturnToHomeTime);
	ReturnFlag();
}

function NanoTeamInfo_CTF GetTeamInfo(optional int SpecifiedTeam = -1)
{
	local NanoGame NG;
	NG = NanoGame(WorldInfo.Game);
	if (SpecifiedTeam == -1)
	{
		SpecifiedTeam = Team;
	}
	return NanoTeamInfo_CTF(NG.Teams[SpecifiedTeam]);
}

defaultproperties
{
	FlagMesh=SkeletalMesh'Nano_Proto_CTF.Mesh.S_CTF_Flag_IronGuard_Dup'
	FlagReturnToHomeTime=30.f

	Begin Object Class=SkeletalMeshComponent Name=FlagMeshComp0
		SkeletalMesh=SkeletalMesh'Nano_Proto_CTF.Mesh.S_CTF_Flag_IronGuard_Dup'
		PhysicsAsset=PhysicsAsset'Nano_Proto_CTF.Mesh.S_CTF_Flag_IronGuard_Physics_Dup'
	End Object
	FlagMeshComp=FlagMeshComp0
	Components.Add(FlagMeshComp0)

	Begin Object Class=CylinderComponent Name=CollisionCylinder0
		CollisionRadius=+0050.000000
		CollisionHeight=+0050.000000
		CollideActors=TRUE
		BlockActors=FALSE
	End Object
	CollisionComponent=CollisionCylinder0
	Components.Add(CollisionCylinder0)

	bStatic=FALSE
	bWorldGeometry=FALSE
	bCollideActors=TRUE
	bCollideWhenPlacing=TRUE
	bHidden=FALSE
	bCanStepUpOn=FALSE

	bUpdateSimulatedPosition=TRUE
	RemoteRole=ROLE_SimulatedProxy
	bAlwaysRelevant=TRUE
}
