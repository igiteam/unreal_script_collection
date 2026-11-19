//=============================================================================
// KynapseGamePlayerController
// Example specific playercontroller
// PlayerControllers are used by human players to control pawns.
//
// Copyright ? 2004-2005 Epic Games, Inc. All Rights Reserved.
//=============================================================================
class KynapseGamePlayerController extends GamePlayerController
	config(Game)
	native;

/** internal variable keeping a pointer on the Kynapse entity */
var private pointer KynapseEntity;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
final native function InitKynapseEntity(string entityDefintionName);
final native function bool DestroyKynapseEntity();

function PreBeginPlay()
{
	Super.PreBeginPlay();
	if (TPGameInfo(WorldInfo.Game).bKynapseEnabled)
	{
		InitKynapseEntity("KynapsePassiveEntityDefinition");
	}
}

// this kills them quicker than FinishDestroy
simulated function Destroyed()
{
	if (TPGameInfo(WorldInfo.Game).bKynapseEnabled)
	{
		DestroyKynapseEntity(); // better to kill entity as soon as possible
	}
	Super.Destroyed();
}
