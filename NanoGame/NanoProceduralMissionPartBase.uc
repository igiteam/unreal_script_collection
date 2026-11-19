/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoProceduralMissionPartBase extends Actor
	abstract
	config(Game);



/** Whether to do debug logging or not **/
var config bool bNPMMLogging;


var transient NanoProceduralMissionBase Mission;


/** Whether or not this Part has completed **/
var transient bool bCompleted;


var transient privatewrite vector MissionLocation;


static function NanoProceduralMissionPartBase SpawnMissionPart( NanoProceduralMissionBase NPMB, const vector InMissionLocation )
{
	local NanoProceduralMissionPartBase Retval;

	Retval = NPMB.Spawn( default.class, NPMB,, InMissionLocation );

	Retval.Mission = NPMB;
	Retval.MissionLocation = InMissionLocation;

	return Retval;
}


simulated function Tick( float DeltaTime )
{
	Super.Tick( DeltaTime );

	if( bCompleted == FALSE )
	{
		AttemptToStartMissionPart();
	}
}



function AttemptToStartMissionPart();





defaultproperties
{

}