/**
* Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
*/
/** This is a generic reaction which will push a command whenever one of its subscribed channels is nudged **/
class AIReactCond_EnteredAvoidanceZone  extends AIReactCond_GenericPushCommand;

event Activate( Actor EventInstigator, AIReactChannel OriginatingChannel )
{
	;
	//if( class'AICmd_VacateAvoidanceVolume'.static.VacateVolume(Outer,EventInstigator,OriginatingChannel.ChannelName == 'EnteredEvadeAvoidanceZone',OriginatingChannel.ChannelName == 'EnteredRoadieRunAvoidanceZone') )
	if( class'AICmd_VacateAvoidanceVolume'.static.VacateVolume(Outer,EventInstigator, FALSE,OriginatingChannel.ChannelName == 'EnteredRoadieRunAvoidanceZone') )
	{
		LastOutputTime = WorldInfo.TimeSeconds;
	}
}

