/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class RebelMindShareManager extends Actor
	config(Game);

/** Name for the the chaos zones this manager handles **/
var transient name ZoneName;


/** This is the current rebel mindshare level **/
var transient protected int RebelMindShareLevel;

var transient protected float TimeRebelMindShareLevelLastModified;


/** Max amount of RebelMindShare (e,g, for displaying the lil mindshare bar on the HUD)**/
var config float MaxAmountOfRebelMindShare;



replication
{
	if( Role == ROLE_Authority )
		RebelMindShareLevel;
}


simulated event PostBeginPlay()
{
	Super.PostBeginPlay();

	// register self with the NanoGRI
	if( NanoGRI(WorldInfo.GRI) != none )
	{
		NanoGRI(WorldInfo.GRI).ListOfRebelMindShareManagers.AddItem( self );
	}

	//`log( `showvar(AmountOfMindShareGainedFromThisChaosTier.Length) @ `showvar(AmountOfMindShareGainedFromThisChaosTier[0]) @ `showvar(AmountOfMindShareGainedFromThisChaosTier[1]) )
}





simulated event Destroyed()
{
	Super.Destroyed();

	// deregister self with the NanoGRI
	NanoGRI(WorldInfo.GRI).ListOfRebelMindShareManagers.RemoveItem( self );
}




final function AddRebelMindShareLevel( int Amount )
{
	NanoHUD_Base(NanoGRI(WorldInfo.GRI).GetNanoPC().myHUD).SlideTextMessage( "RebelMindShare" @ Amount, 5.0f, class'Engine'.static.GetLargeFont(), None );

	RebelMindShareLevel += Amount;
	TimeRebelMindShareLevelLastModified = WorldInfo.TimeSeconds;

	if( NanoGRI(WorldInfo.GRI).GetNanoPC().CanGainEXP() == TRUE )
	{
		NanoGRI(WorldInfo.GRI).MCP.AddIntToLocalMCPDatum( class'NanoTypes'.static.GetLocalPlayerUserName(), class'NanoMCPKeys'.default.RebelMindShareLevel, Amount );
	}

	NanoGRI(WorldInfo.GRI).NTM.HandleTutorialEvent( EET_FirstRebelMindShare, Amount );
}


final function int GetRebelMindShareLevel()
{
	return RebelMindShareLevel;
}


final function ResetMindShare()
{
	AddRebelMindShareLevel( -RebelMindShareLevel );
}


function UpdateValuesFromMCP()
{
	local int TempInt;

	NanoGRI(WorldInfo.GRI).MCP.FindIntValue( class'NanoTypes'.static.GetLocalPlayerUserName(), class'NanoMCPKeys'.default.RebelMindShareLevel, TempInt);
	//AwardCurrency( TempInt );
	RebelMindShareLevel = TempInt;
	NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI).GetNanoPC().GetPRI().UpdateHUD( RebelMindShareLevel, "RebelMindShare from MCP" );
}








DefaultProperties
{
	TickGroup=TG_DuringAsyncWork
}