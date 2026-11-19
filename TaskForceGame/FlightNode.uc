//=============================================================================
// Flight Node.
//
// Super class for all AINode classes.  All AI node classes will accept specific
// Bot types or not based on the return from the AcceptBotType function.
//=============================================================================
class FlightNode extends NavigationPoint
	placeable;

var(FlightNode) bool bIsTakeoffNode;
var(FlightNode) bool bIsLandingNode;
var(FlightNode) bool bIsCrashNode;
var(FlightNode) bool bReverseFlight;

var(FlightNode) int ReverseCount;
var int ReverseCounter;

var(FlightNode) float FlightSpeed;

var(FlightNode) edfindable FlightNode LinkToNode;
var FlightNode LinkFromNode;

function PostBeginPlay()
{
	Super.PostBeginPlay();

	if( LinkToNode != None )
	{
		LinkToNode.LinkFromNode = self;
	}
}


// Decompiled with UE Explorer.
defaultproperties
{
    ReverseCount=1
    bNotBased=true
}