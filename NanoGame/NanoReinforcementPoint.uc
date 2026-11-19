/** 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoReinforcementPoint extends NanoTargetPoint
	AutoExpandCategories( NanoWaves );


/** The max number of AI that will spawn from this ReinforcementPoint per wave. **/
var(NanoWaves) int MaxAIPerWave;

/** How often this node can send a wave out **/
var(NanoWaves) float MinTimeBetweenSendingWaves;

/** This keeps track of the number of AI that we have spawned from this point **/
var transient int NumAISpawnFrom;

/** When the last wave was sent. **/
var transient float LastWaveSentTime;


var Texture2D Tex_PlayerCanSeeMe;

var Texture2D Tex_WaitingToSpawn;

/** This is the visual representation of this NRP **/
var() StaticMeshComponent VisualRepresentation;


simulated event PostBeginPlay()
{
	Super.PostBeginPlay();

	LastWaveSentTime = -MinTimeBetweenSendingWaves - 1;
}


function DecrementSpawnFrom()
{
	//`log( "DecrementSpawnFrom" @ `showvar(NumAISpawnFrom) );
	NumAISpawnFrom--;
}

function GetDebugOverheadText( PlayerController PC, out array<string> OutText )
{
	Super.GetDebugOverheadText( PC, OutText );

	OutText.AddItem( "MinTimeBetweenSendingWaves" @ MinTimeBetweenSendingWaves @ `TimeSince(LastWaveSentTime));
	OutText.AddItem( "CanSendWave:" @ `TimeSince(LastWaveSentTime) > MinTimeBetweenSendingWaves );
}



simulated function GetDebugIcons( out array<Texture2D> Icons )
{
	Icons.AddItem( Debug_Icon );

	if( `TimeSince(LastWaveSentTime) < MinTimeBetweenSendingWaves )
	{
		Icons.AddItem( Tex_WaitingToSpawn ); 
	}

	if( LastRenderTime > 1.0f )
	{
		Icons.AddItem( Tex_PlayerCanSeeMe ); 
	}
}




defaultproperties
{
	Begin Object Name=Sprite
		Sprite=Texture2D'UI_HUD.ResponseSystem.ReinforcementPoint'
	End Object

	Debug_InfoTextVerticalOffset=0
	Debug_DistanceToStopDrawingDebugInfo=6000

	//Texture2D'UI_HUD.ResponseSystem.ReinforcementPoint_WaitingToSpawn'
	//Texture2D'UI_HUD.ResponseSystem.ReinforcementPoint_ReadyToSpawn'

	Debug_Icon=Texture2D'UI_HUD.ResponseSystem.ReinforcementPoint'

	Tex_WaitingToSpawn=Texture2D'UI_HUD.ResponseSystem.DefenseTimerGuy'
	//Player can see Reinforcement Point. Will not spawn guys here.
	Tex_PlayerCanSeeMe=Texture2D'UI_HUD.ResponseSystem.SeeSpawn'


}