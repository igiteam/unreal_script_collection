/**********************************************************************
 *
 * Use of this file or software is subject to the terms of an end user 
 * license agreement.
 *
 * Confidential Information of Kynogon S.A.
 * Not for disclosure or distribution without Kynogon's prior written 
 * consent. This file contains code, techniques and know-how which is 
 * confidential and proprietary to Kynogon.
 *
 * Kynapse (C) Copyright 2000-2006. Kynogon and Kynapse are registered 
 * trademarks of Kynogon S.A. Kynogon All Rights Reserved.
 *
 **********************************************************************/

class KynapseAIController extends AIController
	native
	config(Game);


struct native DangerousPoint
{
	var Vector Point;
	var Float Radius;
};

struct native DangerousEntity
{
	//var CEntity Entity;
	var Float Radius;
};


var private KynapseEntityDefinition KEntityDefinition;
var private pointer KynapseEntity;
//var private bool IsActiveEntity;
var private float wanderTimer;

var bool bMakeKynapseEntity; // added to prevent vehicles from having multiple kynapse entities, on by default, vehicle controllers turn this off

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)


final native function InitKynapseEntity(string entityDefintionName);
final native function DestroyKynapseEntity();
final native function bool KynapseIsActive();
final native function bool KynapseHasArrived();
final native function KynapseClear();
final native function StopThisBot();
final native function vector AdjustPointAboveGround(vector Dest);
final native function vector AdjustPointInsideAIMesh(vector Dest);

native function bool KynapseCanGoStraight(Vector DestinationLocation);

// KynapseMoveTo might be a better function name
native latent function bool KynapseGoTo(Vector DestinationLocation);
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

native latent function bool KynapseWander(float duration);
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

// KynapsePursue might be a better function name
native latent function bool KynapseGoToward(KynapseGamePawn DestinationActor, float Distance);
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

native latent function bool KynapseFollow(KynapseGamePawn DestinationActor, float Distance, float Angle);
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

native latent function bool KynapseFleeDangerousPoint(DangerousPoint FirstDangerousPoint);
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
/*
native function KynapseFleeAddDangerousPoint(DangerousPoint NextDangerousPoint);
*/

native function bool KynapseFoundPath();

native latent function bool KynapseGoToFindPath(Vector DestinationLocation);
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

native latent function bool KynapseGoTowardFindPath(Controller DestinationController, float Distance);
//KynapseGamePawn DestinationActor, float Distance);
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

native latent function bool KynapseFollowPath();
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

native function TPAILog(INT LogDetailLevel, Name logCategory, string logText);


/*
	A necessary evil to make pawns spawned in other levels use the correct active entity definition.
	Might be better if a tag inside the KynapseGamePawn is matched with the active entity definition tag
*/
simulated function PreBeginPlay()
{
	/* don't need this crap, only have 1 active entity definition
	local KynapseActiveEntityDefinition KAED;
	*/

	Super.PreBeginPlay();

	if (TPGameInfo(WorldInfo.Game).bKynapseEnabled)
	{
		/* don't need this crap, only have 1 active entity definition
		// find the first active entity definition
		KEntityDefinition = None;
		foreach AllActors(class 'KynapseActiveEntityDefinition', KAED)
		{
			KEntityDefinition = KAED;
		}
		
		if (KEntityDefinition != None)
		{
			InitKynapseEntity(string(KEntityDefinition.Tag));
		}
		else
		{
			`log("NO Kynapse active entity definition!!!!!");
		}
		*/
		InitKynapseEntity("KynapseActiveEntityDefinition");
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


