//------------------------------------
// Mission Failed Object - Will end the mission and bring up the mission failed menu when triggered
// Contains a string for the failure message
// For use only in Single Player Missions
// Author: Robert Faison
//------------------------------------

class MissionFailed extends Actor
	placeable;
	
var(MissionFailed) string FailureReason;

function Trigger ( Actor Other, Pawn EventInstigator ) {

	local SFRMPlayerController PC;

	ForEach DynamicActors(class'SFRMPlayerController',PC)
		break;
	
	// if we found a valid Player Controller	
	if ( PC != None ) {
	
		// call the mission failed function with the FailureReason
		PC.MissionFailed ( FailureReason );
	}
}


// Decompiled with UE Explorer.
defaultproperties
{
    FailureReason="reason"
    bHidden=true
}