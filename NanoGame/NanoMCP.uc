/**
 * Provides an in-game mechanism for interacting with MCP backend
 *
 * Docs Located here:  https://epicwiki.epicgames.net/display/UEWiki/NanoProto
 *
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoMCP extends NanoMCPBase
	native(MCP);

// possibly switch struct native EventUploadConfig once we actually have more types?



///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////




protected function InitLocalCache_Global()
{
	//local string PlaceholderString;

	Super.InitLocalCache_Global();
}


protected event InitLocalCache_PerUser_Worker( const out string InID )
{
	//local string UserName;
	//local string PlaceholderString;

	Super.InitLocalCache_PerUser_Worker( InID );

	// now for this user we are going to update their Challenges
	NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI).NCM.InitLocalCache_PerUser_Worker( InID );
}





function PossiblyUpdatePRI()
{
	local NanoPRI NPRI;

	if( MCPConnections.Length > 0 )
	{
		return;
	}

	NPRI = NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI).GetNanoPC().GetPRI();

	if( NPRI != None )
	{
		NPRI.UpdateValuesFromMCP();
		NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI).GetCurrentRebelMindShareManager().UpdateValuesFromMCP();
		//NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI).UpdatePersistentWorldObjects();

		UpdatePersistentWorldObjects();

		NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI).ClearTimer( nameof(PossiblyUpdatePRI), self );
	}

	// Update feed from latest info from server
	NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI).GetNanoPC().MyNanoHUD.FeedPage.RebuildPostFeed(FALSE);
}


/* Note that calling this function will re-timestamp everything in the server!
function UploadAllDataToServer()
{
	local MCPDatum Datum;

	foreach MCPData( Datum )
	{
		UploadToMCP( Datum );	
	}
}
*/

// hand print madness

// grab all top level IDs
// FOR EACH ID
//  Grab Location
//  Grab Rotation
//  Creation HandPrint

function UpdateRebelHandPrintsInWorld()
{
	local string PlaceholderString;

	DownloadAllTopLevelObjects( PlaceholderString, PlaceholderString, PlaceholderString, self, nameof(ParseTopLevelIDs) );
}



function UpdatePersistentWorldObjects()
{
	local array<string> ListOfUsers;
	local string UserID;
	ListOfUsers = GetAllUsers();

	foreach ListOfUsers( UserID )
	{
		//`log( GetFuncName() @ `showvar(UserID) );
		UpdateRebelHandPrints( UserID );
	}


	// let's go ahead and place the RebelSuperBomb
	class'RebelSuperBomb'.static.PlaceARebelSuperBombIntoTheWorld();
}


function UpdateRebelHandPrints( const string InUserID )
{
	local string TmpStr;
	local vector SpawnLoc;
	local rotator SpawnRot;
	local RebelHandPrint HandPrint;

	if( FindStringValue( InUserID, class'NanoMCPKeys'.default.RebelHandPrintLocation, TmpStr ) )
	{
		SpawnLoc = vector(TmpStr);
	}

	if( FindStringValue( InUserID, class'NanoMCPKeys'.default.RebelHandPrintRotation, TmpStr ) )
	{
		SpawnRot = rotator(TmpStr);
	}


	// if we actually have one in the world
	if( Vsize(SpawnLoc) != 0 )
	{
		//`log( GetFuncName() @ `showvar(InUserID) );
		HandPrint = RebelHandPrint(class'WorldInfo'.static.GetWorldInfo().Spawn(class<Actor>(DynamicLoadObject("NanoGame.RebelHandPrint", class'class')),,, SpawnLoc, SpawnRot,, TRUE));

		HandPrint.OwnerID = InUserID;
	}
}

/** Get the timestamp of when this user last checked their feed */
function String GetLastCheckedFeedTimestamp()
{
	local MCPDatum Datum;
	local string LocalUserName;

	LocalUserName = class'NanoTypes'.static.GetLocalPlayerUserName();

	foreach MCPData( Datum )
	{
		// Looking for when this user last checked their feed..
		if( (Datum.Key == class'NanoMCPKeys'.default.LastCheckedFeed) && 
			(Datum.ID == LocalUserName))
		{
			if(Datum.Timestamp != "")
			{
				return Datum.Timestamp;
			}
			else
			{
				// no point looking any more
				break;
			}
		}
	}

	// If not found, default to date before feed existed...
	return "2010-01-01 12:00:00";
}






DefaultProperties
{

}

