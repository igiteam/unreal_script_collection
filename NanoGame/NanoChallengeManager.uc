/**
 * This manager handles all of the various events that our challenges care about.  so if you get a head shot it will route it through here
 * for it to update, alert (with a you have k/N), reward if you completed!
 *
 *
 * To use this just do:  NanoGRI(WorldInfo.GRI).NCM.HandleChallengeEvent( EChallengeEventType );
 *
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoChallengeManager extends Actor
	config(Game);


/** 
 * Here we keep track of the challenge event types.
 * examples:
 *
 *   -head shots
 *   -reach chaos level 5 and escaped
 *   -fell more than N distance
 *   -killed a guy
 *   -completed a mission
 *   -acquired a new dataplan
 *   -placed rebelhandprint
 *
 *
 *
 *
 **/
enum EChallengeEventType
{
	ECET_None,
	ECET_HeadShot,
	ECET_ReachedChaosTier5AndEscaped,
	ECET_FellMoreThan4000,
	ECET_KilledAMetaCorp,
	ECET_CompletedAMission,
	ECET_AcquiredANewDataPlan,
	ECET_PlacedRebelHandPrint,
	ECET_RebelHandPrintAbsorbed,
	ECET_CollectibleAbsorbed, // need to do rare and such also
	ECET_CompletedAProcMission,
	ECET_KilledABullRam,
	ECET_DetonateRebelSuperBomb,
};

// we need to map the enums to keys sort of sucks
var array<String> TypeToMCPMapping;


/**
 * This is a challenge.  It has:
 *
 * Care about:  EChallengeEventType
 * Amount needed
 * 
 * Reward
 *
 * We prob want to make these part of our reward struct.  So if you do a mission you can then get a challenge to complete!
 **/
struct ChallengeDatum
{
	var EChallengeEventType Type;
	var string Desc;
	var int AmountNeeded;
	var RewardDatum TheReward;
};



var SoundCue ChallengeCompletedSound;


//https://secure.wikimedia.org/wikipedia/en/wiki/Stag_hunt
// Basically, we need to give the player a choice of things to go after
// And those choices need to be things that are HARD vs Easy
// And that they don't do normally in every day actions.  (e.g. killing infantry is not good)
// Proc missions are on the edge, but we can raise the number up high enough such that people have
// to make a concertated effort to get to that number instead of just getting that number by accident
//

enum EAssuranceGameType
{
	EAGT_BullramOrProcMissions,
};


struct AssuranceGameDatum
{
	var EAssuranceGameType Type;
	var ChallengeDatum Stag;
	var ChallengeDatum Hare;
};



/**
 * This will look at our EChallengeEventType and then iterate over them
 * and then use the string value of each enum for the KEY for the MCP!
 **/
function InitLocalCache_PerUser_Worker( const out string InID )
{
	local NanoGRI NGRI;
	local int Idx;
	local string PlaceholderString;
	local string EnumString;

	
	NGRI = NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI);

	for( Idx = 0; Idx < EChallengeEventType.EnumCount; ++Idx )
	{
		EnumString = String(GetEnum(enum'EChallengeEventType', Idx));
		NGRI.MCP.DownloadFromMCP( InID, EnumString, PlaceholderString, NGRI.MCP, nameof(NGRI.MCP.UpdateFromMCP) );
	}
}


/** 
 * So when ever we get one of these we just increment that type by one.
 *
 * Additionally, we update MCP and check for reward!

 **/
function HandleChallengeEvent( const EChallengeEventType InType )
{
	local NanoGRI NGRI;
	local NanoMCP MCP;
	local string EnumString;
	local string UserName;
	local ChallengeDatum Challenge;
	local int CurrValue;

	NGRI = NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI);
	MCP = NGRI.MCP;
	EnumString =  String(GetEnum(enum'EChallengeEventType', InType));
	UserName = class'NanoTypes'.static.GetLocalPlayerUserName();

	foreach class'NanoChallenges'.default.TheChallenges( Challenge )
	{
		// if we found the type we are looking for
		if( Challenge.Type == InType )
		{
			// grab the data from MCP
			MCP.FindIntValue( UserName, EnumString, CurrValue );

			// increment value
			CurrValue++;

			// submit value back to mcp
			MCP.UpdateLocalMCPDatum( UserName, EnumString, CurrValue );

			// check to see if we beat the amount needed (only do reward once)
			if( CurrValue == Challenge.AmountNeeded )
			{
				// REWARD!
				NanoHUD_Base(NGRI.GetNanoPC().myHUD).SlideTextMessage( EnumString@" CHALLENGE COMPLETED!!!", 3.0f, class'Engine'.static.GetLargeFont(), ChallengeCompletedSound );
	
				NGRI.GiveReward( Challenge.TheReward, NanoPawn(NGRI.GetNanoPC().Pawn) );
			}

			break;
		}
	}


	UpdateAssuranceGames( InType );
}


function UpdateAssuranceGames( const EChallengeEventType InType )
{
	local NanoGRI NGRI;
	local NanoMCP MCP;
	local string EnumString;
	local string UserName;
	local AssuranceGameDatum AssuranceGame;
	local String CurrValueString;
	local String AssuranceGamePartner;
	local bool bFoundAssuranceGame;
	local string EnumStringStag;
	local string EnumStringHare;
	local int StagValue;
	local int HareValue;
	local int StagValuePartner;
	local int HareValuePartner;
	local bool bCompleted;

	NGRI = NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI);
	MCP = NGRI.MCP;

	UserName = class'NanoTypes'.static.GetLocalPlayerUserName();


	// first find out if the user is in an assurance game
	MCP.FindStringValue( UserName, class'NanoMCPKeys'.default.CurrentAssuranceGame, CurrValueString );

	if( CurrValueString == "" )
	{
		return;
	}

	// find out who they are in the game with
	MCP.FindStringValue( UserName, class'NanoMCPKeys'.default.CurrentAssuranceGamePartner, AssuranceGamePartner );

	if( AssuranceGamePartner == "" )
	{
		`warn( "Somehow our partner is None" @ `showvar(CurrValueString) );
		return;
	}


	// find the actual game data to look for

	//// now check to see if we have any assurance games that are active
	foreach class'NanoChallenges'.default.AssuranceGames( AssuranceGame )
	{
		EnumString = String(GetEnum(enum'EAssuranceGameType', AssuranceGame.Type));

		`log( `showvar(EnumString) @ `showvar(CurrValueString) @ `showvar(AssuranceGame.Type) );

		if( CurrValueString == EnumString )
		{
			bFoundAssuranceGame = TRUE;
			break;
		}
	}

	if( bFoundAssuranceGame == FALSE )
	{
		`warn( "We were unable to find an Assurance Game of type:" @ `showvar(CurrValueString) @ `showvar(class'NanoChallenges'.default.AssuranceGames.Length));
		return;
	}

	EnumStringStag = String(GetEnum(enum'EChallengeEventType', AssuranceGame.Stag.Type))$"_Stag";
	EnumStringHare = String(GetEnum(enum'EChallengeEventType', AssuranceGame.Hare.Type))$"_Hare";

	// for this specific Game's Types we check to see if they match the passed in Type and then add 1 to
	// the specialized string.
	// this allows us to keep a separate count for the duration of the game  while still having other challenges
	// use that event (e.g. killing bullrams challenges are orthogonal to your current assurance game challenge)
	if( InType == AssuranceGame.Stag.Type )
	{
		MCP.AddIntToLocalMCPDatum( UserName, EnumStringStag, 1 );
	}
	
	if( InType == AssuranceGame.Hare.Type )
	{
		MCP.AddIntToLocalMCPDatum( UserName, EnumStringHare, 1 );
	}



	MCP.FindIntValue( UserName, EnumStringStag, StagValue );
	MCP.FindIntValue( UserName, EnumStringHare, HareValue );

	MCP.FindIntValue( AssuranceGamePartner, EnumStringStag, StagValuePartner );
	MCP.FindIntValue( AssuranceGamePartner, EnumStringHare, HareValuePartner );


	// then check to see if the users have completed any of them

	// if both stag then win for both!
	// hair then give reward and tell other user he was "defected on"

	`log( `showvar(EnumStringStag) @ `showvar(EnumStringHare) @ `showvar(StagValue) @ `showvar(HareValue) @ `showvar(StagValuePartner) @ `showvar(HareValuePartner) );

	`log( `showvar(AssuranceGame.Stag.AmountNeeded) @ `showvar(AssuranceGame.Hare.AmountNeeded) );

//    	        Stag 	Hare
//		Stag 	2, 2 	0, 1
//		Hare 	1, 0 	1, 1

	if( ( StagValue >= AssuranceGame.Stag.AmountNeeded )
		&& ( StagValuePartner >= AssuranceGame.Stag.AmountNeeded )
		)
	{
		bCompleted = GiveAssuranceReward( AssuranceGame.Stag.TheReward, CurrValueString@" Assurance Game Completed!!!" );
	}
	else if( ( StagValue >= AssuranceGame.Stag.AmountNeeded )
		&& ( HareValuePartner >= AssuranceGame.Hare.AmountNeeded )
		)
	{
		bCompleted = GiveAssuranceReward( AssuranceGame.Hare.TheReward, CurrValueString@" Assurance Game Failed!!! Your Partner chose the easy task!" );
	}
	else if( ( HareValue >= AssuranceGame.Hare.AmountNeeded )
		&& ( StagValuePartner >= AssuranceGame.Stag.AmountNeeded )
		)
	{
		bCompleted = GiveAssuranceReward( AssuranceGame.Hare.TheReward, CurrValueString@" Assurance Game Completed!!!" );
	}
	else if( ( HareValue >= AssuranceGame.Hare.AmountNeeded )
		&& ( HareValuePartner >= AssuranceGame.Hare.AmountNeeded )
		)
	{
		bCompleted = GiveAssuranceReward( AssuranceGame.Hare.TheReward, CurrValueString@" Assurance Game Completed!!!" );
	}



	// if we completed then we need to set our completed flag
	if( bCompleted == TRUE )
	{
		// check to see if our partner has completed
		MCP.FindStringValue( AssuranceGamePartner, class'NanoMCPKeys'.default.CurrentAssuranceGameCompleted, CurrValueString );

		// we have both completed and both gotten rewards
		// so clear our the various parts
		if( CurrValueString != "" )
		{
			`log( "clear out both yours and partners' assurance game info as the game has completed." );

			MCP.UpdateLocalMCPDatum( UserName, class'NanoMCPKeys'.default.CurrentAssuranceGamePartner, "" );

			MCP.UpdateLocalMCPDatum( UserName, class'NanoMCPKeys'.default.CurrentAssuranceGame, "" );

			MCP.UpdateLocalMCPDatum( UserName, class'NanoMCPKeys'.default.CurrentAssuranceGameCompleted, "" );

			MCP.UpdateLocalMCPDatum( UserName, EnumStringStag, "" );
			MCP.UpdateLocalMCPDatum( UserName, EnumStringHare, "" );


			MCP.UpdateLocalMCPDatum( AssuranceGamePartner, class'NanoMCPKeys'.default.CurrentAssuranceGamePartner, "" );

			MCP.UpdateLocalMCPDatum( AssuranceGamePartner, class'NanoMCPKeys'.default.CurrentAssuranceGame, "" );

			MCP.UpdateLocalMCPDatum( AssuranceGamePartner, class'NanoMCPKeys'.default.CurrentAssuranceGameCompleted, "" );

			MCP.UpdateLocalMCPDatum( AssuranceGamePartner, EnumStringStag, "" );
			MCP.UpdateLocalMCPDatum( AssuranceGamePartner, EnumStringHare, "" );
		}
		else
		{
			`log( "we have completed the game and been rewarded but our partner has not been rewarded yet.  So we need to wait for them to log on to remove our game. Deadlock will occur atm if they don't log on.");
		}
	}

} 


function bool GiveAssuranceReward( const out RewardDatum TheReward, string RewardText )
{
	local NanoGRI NGRI;
	local NanoMCP MCP;
	local string UserName;
	local String CurrValueString;

	NGRI = NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI);
	MCP = NGRI.MCP;
	UserName = class'NanoTypes'.static.GetLocalPlayerUserName();

	MCP.FindStringValue( UserName, class'NanoMCPKeys'.default.CurrentAssuranceGameCompleted, CurrValueString );

	// we have already completed this game
	if( CurrValueString != "" )
	{
		`log( "Already completed game" @ `showvar(CurrValueString) );
		return TRUE;
	}


	NanoHUD_Base(NGRI.GetNanoPC().myHUD).SlideTextMessage( RewardText, 3.0f, class'Engine'.static.GetLargeFont(), ChallengeCompletedSound );

	NGRI.GiveReward( TheReward, NanoPawn(NGRI.GetNanoPC().Pawn) );

	MCP.UpdateLocalMCPDatum( UserName, class'NanoMCPKeys'.default.CurrentAssuranceGameCompleted, "Yes" );


	return TRUE;

}






function ChallengeDatum FindChallengeViaString( const out String InType )
{
	local ChallengeDatum Retval;
	local ChallengeDatum Challenge;
	local string EnumString;

	foreach class'NanoChallenges'.default.TheChallenges( Challenge )
	{
		EnumString =  String(GetEnum(enum'EChallengeEventType', Challenge.Type));
		// if we found the type we are looking for
		if( EnumString == InType )
		{
			Retval = Challenge;
			break;
		}
	}


	return Retval;
}






defaultproperties
{
	ChallengeCompletedSound=SoundCue'UI_Temp.ChallengeCompleteCue'
}