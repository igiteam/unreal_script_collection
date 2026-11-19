/** 
 * Hunt this guy down in the world 
 *
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class RebelSuperBomb extends DynamicSMActor_Spawnable
	implements( NanoInterface_Interact, NanoInterface_Objective )
	notplaceable;

var InteractableComponent InteractableComp;

/** Our UIIconComponent for easy access. **/
var UIIconComponent UIComponent;



// this needs a way to find cool places to hide.
// right now we will just choose a random rooftop indicator actor


// TODO:  we need to poll and remove self from the world if anyone else finds us


/** 
 * This will see if we already have one placed into the world by a previous engine run
 * if we do place it there
 * else find a new spot
 **/
static function PlaceARebelSuperBombIntoTheWorld()
{
	local NanoGRI NGRI;
	local NanoMCP MCP;
	//local string UserName;
	local String CurrValueString;
	local vector BombLocation;
	local rotator BombRotation;
	local string FoundBy;
	local String RebelSuperBombForge_BombState;

	NGRI = NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI);
	MCP = NGRI.MCP;
	//UserName = class'NanoMCPKeys'.default.MobileUserID; // class'NanoMobileTypes'.static.GetLocalPlayerUserName();

	MCP.FindStringValue( "", class'NanoMCPKeys'.default.RebelSuperBombForge_Location, CurrValueString );

	BombLocation = vector(CurrValueString);

	MCP.FindStringValue( "", class'NanoMCPKeys'.default.RebelSuperBombForge_FoundBy, FoundBy );

	MCP.FindStringValue( "", class'NanoMCPKeys'.default.RebelSuperBombForge_BombState, RebelSuperBombForge_BombState );



	`log( `showvar(BombLocation) @ `showvar(FoundBy) );

	// if no one has found the Bomb then we find a place and spawn it
	// found is determined by: 0,0,0 vect and a FoundBy user
	//if( ( VSize(BombLocation) == 0 ) && ( FoundBy == "" ) )
	// "" is when the DB is uninited
	if( ( RebelSuperBombForge_BombState == "FindPlaceToSpawn" ) || ( RebelSuperBombForge_BombState == "" ) )
	{
		`log( "No Bomb in play spawn one" );
		FindAPlaceToSpawnAndSpawn();
	}
	// someone has found it so don't spawn it into the world
	//else if( ( VSize(BombLocation) == 0 ) && ( FoundBy != "" ) )
	else if( ( RebelSuperBombForge_BombState == "WaitingForUnlock" )  )
	{
		// do nothing
		`log( "someone already has found the SuperBomb and we are just waiting for the mobile user to return it" );
	}
	else if( RebelSuperBombForge_BombState == "WaitingForDetonation" )
	{
		`log( "bomb has been decrypted.  We are just waiting for it to be detonated" );
	}
	// we need to spawn it in the world as it has not been found yet!
	// RebelSuperBombForge_BombState == SpawnIntoWorldAtSpecifiedLocation
	else
	{
		MCP.FindStringValue( "", class'NanoMCPKeys'.default.RebelSuperBombForge_Rotation, CurrValueString );
		BombRotation = rotator(CurrValueString);

		NGRI.Spawn( class'RebelSuperBomb',,, BombLocation, BombRotation,, TRUE );

		`log( "SPAWNED" @ `showvar(BombLocation) @ `showvar(BombRotation) );

		// SpawnIntoWorldAtSpecifiedLocation is already set on the mcp so don't set it again

	}
}



private static function FindAPlaceToSpawnAndSpawn()
{
	local NanoTargetPoint NTP;
	local NanoTargetPoint BestNTP;
	local int NumRooftopIndicators;
	local int SpawnAtIdx;
	local WorldInfo WI;

	WI = class'WorldInfo'.static.GetWorldInfo();


	foreach WI.AllActors( class'NanoTargetPoint', NTP )
	{
		if( NTP.Class.Name == 'NanoRooftopAccessIndicator' )
		{
			NumRooftopIndicators++;
		}
	}

	if( NumRooftopIndicators == 0 )
	{
		`warn( "No NanoRooftopAccessIndicator we will not spawn a RebelSuperBomb" );
	}


	SpawnAtIdx = Rand( NumRooftopIndicators );
	NumRooftopIndicators = 0;

	`log( `showvar(NumRooftopIndicators) @ `showvar(SpawnAtIdx) );

	foreach WI.AllActors( class'NanoTargetPoint', NTP )
	{
		if( NTP.Class.Name == 'NanoRooftopAccessIndicator' )
		{
			if( SpawnAtIdx == NumRooftopIndicators )
			{
				BestNTP = NTP;
				break;
			}

			NumRooftopIndicators++;
		}
	}


	//WI.DrawDebugLine( BestNTP.Location, NanoGRI(WI.GRI).GetNanoPC().Pawn.Location, 255,0,0, TRUE );


	// so now NTP should be at a NanoRooftopAccessIndicator that we can utilize to spawn our RebelSuperBomb
	NanoGRI(WI.GRI).MCP.UpdateLocalMCPDatum( "", class'NanoMCPKeys'.default.RebelSuperBombForge_Location, BestNTP.Location );
	NanoGRI(WI.GRI).MCP.UpdateLocalMCPDatum( "", class'NanoMCPKeys'.default.RebelSuperBombForge_Rotation, BestNTP.Rotation );
	//NanoGRI(WI.GRI).MCP.UpdateLocalMCPDatum( "", class'NanoMCPKeys'.default.RebelSuperBombForge_FoundBy, "" ); // back in the game!

	NanoGRI(WI.GRI).MCP.UpdateLocalMCPDatum( "", class'NanoMCPKeys'.default.RebelSuperBombForge_BombState, "SpawnIntoWorldAtSpecifiedLocation" );

	

	WI.Spawn( class'RebelSuperBomb',,, BestNTP.Location, BestNTP.Rotation,, TRUE );

}





simulated function Tick( float DeltaTime )
{
	Super.Tick( DeltaTime );

	InteractableComp.Tick( DeltaTime );
}


/** This is called when the interaction has completed successfully **/
simulated function InteractionSuccessfullyCompleted()
{
	local NanoMCP MCP;

	MCP = NanoGRI(WorldInfo.GRI).MCP;

	// since the RebelSuperBomb was absorbed we are going to update the DB

	// update that we found it
	MCP.AddIntToLocalMCPDatum( class'NanoTypes'.static.GetLocalPlayerUserName(), class'NanoMCPKeys'.default.RebelSuperBombForge_FoundCount, 1 );

	// reset so it doesn't appear in the world until it has been launched
	MCP.UpdateLocalMCPDatum( "", class'NanoMCPKeys'.default.RebelSuperBombForge_Location, vect(0,0,0) );
	MCP.UpdateLocalMCPDatum( "", class'NanoMCPKeys'.default.RebelSuperBombForge_Rotation, rot(0,0,0) );
	MCP.UpdateLocalMCPDatum( "", class'NanoMCPKeys'.default.RebelSuperBombForge_FoundBy, class'NanoTypes'.static.GetLocalPlayerUserName() );
	
	// tell the world that we need a mobile guy to unlock!
	MCP.UpdateLocalMCPDatum( "", class'NanoMCPKeys'.default.RebelSuperBombForge_BombState, "WaitingForUnlock" ); // tell mobile we need a decryption 

	NanoGRI(WorldInfo.GRI).NTM.HandleTutorialEvent( EET_SuperRebelBomb_Found, 1 );
}


event Destroyed()
{
	Super.Destroyed();
}



/**
 * Get tooltip for interacting 
 * Also will return the Texture button to Prefix the text with.
 * Since it is annoying and painful to put a button in the middle of things we will just do:
 * Button to interact   Button to speak to dude. etc.
 **/
simulated function string GetInteractToolTip( NanoPawn NP, out Texture2D out_TextureButtonToPrefix )
{

	if( InteractableComp.BeingAbsorbedBy != None )
	{
		return "Acquiring RebelSuperBomb!!!";
	}

	out_TextureButtonToPrefix = Texture2D'UI_Common.button_B';

	if( InteractableComp.bCanAbsorb == TRUE )
	{
		return "to acquire the RebelSuperBomb Plan";
	}
	else
	{
		return "Cannot interact";
	}	
}


/** Returns the UI component which we will then act upon. **/
simulated function InteractableComponent GetInteractableComponent()
{
	return InteractableComp;
}

simulated function bool CanInteract(NanoPawn NP, ENanoInteractType Type)
{
	return InteractableComp.CanInteract( NP, Type );
}

simulated function DoInteract( NanoPawn NP, ENanoInteractType Type )
{
	InteractableComp.DoInteract( NP, Type );
}


function vector GetObjectiveLocation()
{
	return Location;
}



/** Returns the UI component which we will then act upon. **/
function UIIconComponent GetUIIconComponent()
{
	return UIComponent;
}





defaultproperties
{

	Begin Object Name=StaticMeshComponent0
		StaticMesh=StaticMesh'MET_PacifierMechProto.SM.S_Proto_PacifierMech_Rocket'
		//Rotation=(Pitch=0,Yaw=16384,Roll=0)
		Scale=4.0f
	End Object


	// need a new icon for this
	Begin Object Class=UIIconComponent Name=UIIconComponent0
	    MiniMap=(bShown=TRUE,bShownEvenIfClamped=FALSE,DistancesToDrawIcon=(X=0,Y=0),Icon=Texture2D'UI_HUD.MiniMap.RebelSuperBomb',IconScale=0.125f,AboveBelowIconScale=0.1f,IconColor=(R=255,G=255,B=255,A=255),bAlternateAboveBelowIcon=TRUE)
	End Object
	UIComponent=UIIconComponent0
	Components.Add(UIIconComponent0)





	Begin Object Class=InteractableComponent Name=InteractableComponent0
	    InteractDistance=768.0f
		bCanGrab=FALSE
		bCanAbsorb=TRUE
		AbsorbTime=3.0f
	Reward=(NanoPowerBucketsGained=20)
	End Object
	//CollisionComponent=InteractableComponent0
	InteractableComp=InteractableComponent0
	Components.Add( InteractableComponent0 )

	bCollideActors=TRUE
	bBlockActors=FALSE

}




