/**
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/
class AIcmd_Brumak_Action_Reposition extends AICmd_Base_UtilitySelectedCmd
	within GearAI_Brumak;


/**
 * this function will be called to evaluate whether or not this command should be activated 
 * @param ActivationData - the meta data packet for this command activation history, etc..
 * @return - float indicating the utility value of activation this action right now (-1 means not suitable to activate)
 */
static function float EvaluateActivation( GearAI AI, UtilBasedAICmdMetaDataPacket ActivationData )
{
	local Pawn	NearEnemy;
	local GearAI_Brumak BrumakAI;

	BrumakAI = GearAI_Brumak(AI);
	// Find the nearest enemy
	BrumakAI.GetNearEnemyDistance(BrumakAI.Pawn.Location, NearEnemy);

	if( !BrumakAI.HasEnemyWithinDistance(BrumakAI.EnemyDistance_Medium) )
	{
		`AILog_Ext("No enemy within distance! ADJUSTFORALL",,AI);
		// Adjust to a good starting spot
		return 0.f + RandRange(0.f,0.1f);
	}

	if( !BrumakAI.CanFireAtAnyTarget() || !BrumakAI.Brumak.HasAnyWeaponsAlive() )
	{
		`AILog_Ext("Can't fire at any targets! Reposition 1.0 goodness",,AI);

		return 1.0f;
	}

	if( `TimeSinceEx(AI, ActivationData.LastActivationTime ) > BrumakAI.MaxTimeBetweenMoves )
	{
		`AILog_Ext("Haven't moved in too long! Bumping up activation goodness",,AI);
		return 1.0f;
	}
	

	return -1.f;
}



function Pushed()
{
	Super.Pushed();
	GotoState('DoReposition');
}


state DoReposition
{
	function BeginState(Name PreviousStateName)
	{
		local Pawn	NearEnemy;
		local float NearestEnemyDist;
	
		// Find the nearest enemy
		NearestEnemyDist = GetNearEnemyDistance(Pawn.Location, NearEnemy);

		// If someone is nearby, scream!
		if( FRand() < 0.33f )
		{
			SetEnemy( NearEnemy );
			if( `TimeSince(LastRoarTime) > MinTimeBetweenRoars && ( NearestEnemyDist <= EnemyDistance_Short  ||
				(NearestEnemyDist <= EnemyDistance_Medium && FRand() < 0.50f) ))
			{
				DoRoar();
			}
		}

	}
Begin:
	//debug
	`AILog( "--"@GetStateName()$":"$Class@"-- BEGIN TAG"@Brumak.HasAnyWeaponsAlive()@Enemy@CanFireAtAnyTarget() );

	if(!Brumak.HasAnyWeaponsAlive() && Enemy != None)
	{
		class'AICmd_MoveToEnemy'.static.MoveToEnemy(Outer, false, EnemyDistance_Melee - 25, 0.f);
	}
	else if(!CanFireAtAnyTarget())
	{
		GotoBestFirePosition( BrumakSearchType_Direct );
	}
	else
	{
		GotoBestFirePosition( BrumakSearchType_All );
	}
	LastMoveTime = WorldInfo.TimeSeconds;
	Sleep(1.f);
	PopCommand(self);
};