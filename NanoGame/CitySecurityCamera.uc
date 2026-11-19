/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class CitySecurityCamera extends CitySecurityCamera_Base
	implements( NanoInterface_TattlerBotDock )
	placeable;


var() bool bAutoSpawnBot;

var() transient NanoPawn_MetaCorp_SentryBotBase Bot;

var transient MaterialInstanceConstant BaseMIC;


/** When the bot spawned by this cemera dies this is how long it will take to respawn another. **/
var protected config float BotRespawnTime;

/** Whether or not to spawn the super tattler!! **/
var() bool bSpawnSuperTattler;


simulated event PostBeginPlay()
{
	Super.PostBeginPlay();

	BaseMIC = Mesh.CreateAndSetMaterialInstanceConstant(0);

	if( bAutoSpawnBot )
	{
		SetTimer( FRand() * 5.0f, FALSE, nameof(SpawnABot) );
	}
}


/** This will spawn a new bot from this Dock **/
simulated function SpawnABot()
{
	local vector SocketLoc;
	local rotator SocketRot;
	local NanoAI_SentryBot AI;

	Mesh.GetSocketWorldLocationAndRotation('Cam_Origin',SocketLoc,SocketRot);

	if( bSpawnSuperTattler == TRUE )
	{
		Bot = Spawn(class'NanoPawn_MetaCorp_SentryBotSuper',,,SocketLoc,SocketRot,,TRUE);
	}
	else
	{
		Bot = Spawn(class'NanoPawn_MetaCorp_SentryBot',,,SocketLoc,SocketRot,,TRUE);
	}

	if (Bot != None)
	{
		if( bSpawnSuperTattler == TRUE )
	    {
			AI = Spawn(class'NanoAI_SentryBotSuper');
	    }
		else
		{
			AI = Spawn(class'NanoAI_SentryBot');
		}

		if (AI != None)
		{
			AI.Possess(Bot,FALSE);
			AI.RegisterDock(self);
		}
	}
}


/** This gets called when the bot this camera has spawned has been killed **/
simulated function BotHasBeenKilled()
{
	SetTimer( BotRespawnTime, FALSE, nameof(SpawnABot) );
}


event HandleSpawn( NanoPawnBase NewSpawn, int SlotIdx )
{
	local NanoAI_SentryBot AI;

	AI = NanoAI_SentryBot(NewSpawn.Controller);
	if( AI != None )
	{
		AI.RegisterDock(self);
	}
}
event bool GetSpawnSlot( out int out_SpawnSlotIdx, out vector out_SpawnLocation, out rotator out_SpawnRotation )
{
	if( Bot == None )
	{
		out_SpawnSlotIdx = 0;
		Mesh.GetSocketWorldLocationAndRotation('Cam_Origin',out_SpawnLocation,out_SpawnRotation);
		return TRUE;
	}
	return FALSE;
}


simulated private function LaunchBot()
{
	local vector SocketLoc;
	local rotator SocketRot;
	if (Bot != None)
	{
		Mesh.GetSocketWorldLocationAndRotation('Cam_Origin',SocketLoc,SocketRot);
		Bot.Undock(vector(SocketRot));

		// Fire kismet event to notify launch of bot
		TriggerEventClass(class'SeqEvt_CamSpawnTattler', Bot, 0);

		Bot = None;
	}
}

simulated private function PlayCloseAnim()
{
	Mesh.PlayAnim('Base_Unit_Close');
}


simulated function bool IsTargetable( optional ETargetQueryType QT )
{
	return (Health > 0 && Bot != None && `TimeSince(LastRenderTime) < 1.f);
}

simulated function float GetBasePriority(NanoPC Askee, optional NanoPawn AskeePawn)
{	
	// ignore if dead
	if( !IsTargetable() )
	{
		return INDEX_NONE;
	}

	return 10.f; // these should be pretty low
}


/////////////////////////////////////////////////////
////// INTERFACE: NanoInterface_TattlerBotDock //////
/////////////////////////////////////////////////////
simulated function Actor GetInterfaceActor()
{
	return self;
}

function HandleNewDock(NanoPawn_MetaCorp_SentryBotBase InBot)
{
	local NanoAI AI;

	InBot.AccelRate = 0.f;
	InBot.SetPhysics(PHYS_Flying);

	AI = NanoAI(InBot.Controller);
	AI.bClampRotation	 	 = TRUE;
	AI.ClampedBaseRotation	 = Rotator(GetDockLookDir(InBot));
	AI.ClampedRotationLimits = rot(7000,5000,4096);
}

simulated function PrepareReturnToDock(NanoPawn_MetaCorp_SentryBotBase InBot);

simulated function PrepareToDockBot(NanoPawn_MetaCorp_SentryBotBase InBot)
{
	local LinearColor LinColor;

	InBot.bCanStrafe = TRUE;
	InBot.SetPhysics(PHYS_Flying);

	//@todo -- Someone should make this a const in default properties since it doesn't change
	LinColor = MakeLinearColor(0.5,1,2,1);
	BaseMIC.SetVectorParameterValue('EmissiveColor',LinColor);
	PlayCloseAnim();
	Bot = InBot;
}

simulated function PrepareToUndockBot(NanoPawn_MetaCorp_SentryBotBase InBot)
{
	local LinearColor LinColor;

	if (Bot != None && !IsTimerActive(nameof(LaunchBot)))
	{
		//@todo -- Someone should make this a const in default properties since it doesn't change
		LinColor = MakeLinearColor(2,0.1,0,1);
		BaseMIC.SetVectorParameterValue('EmissiveColor',LinColor);
		Mesh.PlayAnim('Base_Unit_Open' );
		SetTimer(1.8f,FALSE,nameof(LaunchBot));
		SetTimer(2.5f,FALSE,nameof(PlayCloseAnim));
	}
}

simulated function vector GetDockLocation(NanoPawn_MetaCorp_SentryBotBase InBot, optional bool bFinalDock)
{
	local vector SocketLoc;
	local rotator SocketRot;
	Mesh.GetSocketWorldLocationAndRotation('Cam_Origin',SocketLoc,SocketRot);
	return SocketLoc;
}

simulated function Vector GetDockLookDir(NanoPawn_MetaCorp_SentryBotBase InBot)
{
	return Vector(InBot.Rotation);
}

simulated function CompleteDock( NanoPawn_MetaCorp_SentryBotBase InBot )
{
	InBot.SetLocation( GetDockLocation(InBot) );
	InBot.bCanStrafe = InBot.default.bCanStrafe;
	InBot.Velocity = vect(0,0,0);
	InBot.SetPhysics(PHYS_None);
}

defaultproperties
{
	Begin Object Class=AnimNodeSequence Name=AnimNodeSeq0
	End Object

	Begin Object Name=CamBaseMesh
		SkeletalMesh=SkeletalMesh'MET_TattleCam.SK_MET_TattleCam_Base'
		//PhysicsAsset=PhysicsAsset'MET_TattleCam.SK_MET_TattleCam_Physics'
		Animations=AnimNodeSeq0
		AnimSets(0)=AnimSet'MET_TattleCam.AS_MET_TattleCam_Base'
		Rotation=(Yaw=-32768)
	End Object

	bAutoSpawnBot=TRUE

	SupportedEvents.Add(class'SeqEvt_CamSpawnTattler')

}
