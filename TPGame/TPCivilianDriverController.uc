class TPCivilianDriverController extends TPAIController;

//***********************************************************************
// Macros
//***********************************************************************

//***********************************************************************
// enum Declarations
//***********************************************************************

//***********************************************************************
// struct Declarations
//***********************************************************************

//***********************************************************************
// Variable Declarations
//***********************************************************************
var array<Actor> PathList;
var Actor TargetNode;
var int CurrentTargetID;

var float OldBrakingFactor, OldStopThreshold;

//***********************************************************************
// CPP Text
//***********************************************************************


//***********************************************************************
// Function Declarations
//***********************************************************************


	
//***********************************************************************
// Functions/States
//***********************************************************************

function Actor getNextNode()
{
	CurrentTargetID++;
	if (CurrentTargetID < PathList.Length)
		return PathList[CurrentTargetID];

	return none;
}

// State to be in if we are waiting to go
auto state Waiting
{
	function BeginState(Name PreviousStateName)
	{
		if (PreviousStateName == 'Stop' || PreviousStateName == 'Driving')
		{
			// Call the Drivers Latent Finished
			StopLatentExecution();
			SVehicle(Pawn).Driver.ClearLatentAction(class'SeqAct_ScriptedVehiclePathLatent', false);		
			SVehicle(Pawn).Throttle = 0.0;
			SVehicle(Pawn).Steering = 0.0;
			
// 			if (SVehicleSimCarTransmission(SVehicle(Pawn).SimObj) != none)
// 			{
// 				OldBrakingFactor = SVehicleSimCarTransmission(SVehicle(Pawn).SimObj).EngineBrakeFactor;
// 				OldStopThreshold = SVehicleSimCarTransmission(SVehicle(Pawn).SimObj).StopThreshold;
// 		
// 				SVehicleSimCarTransmission(SVehicle(Pawn).SimObj).EngineBrakeFactor = 0.6;	
// 				SVehicleSimCarTransmission(SVehicle(Pawn).SimObj).StopThreshold = 500;
// 			}
		}
		CurrentTargetID = 0;
	}
	function EndState(Name NextStateName)
	{
		
	}

}

state Driving
{
	function BeginState(Name PreviousStateName)
	{
		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = false;
		if (OldBrakingFactor > 0)
		{
// 			if (SVehicleSimCarTransmission(SVehicle(Pawn).SimObj) != none)
// 			{
// 				SVehicleSimCarTransmission(SVehicle(Pawn).SimObj).EngineBrakeFactor = OldBrakingFactor;	
// 				SVehicleSimCarTransmission(SVehicle(Pawn).SimObj).StopThreshold = OldStopThreshold;
// 			}
		}
	}

	function EndState(Name NextStateName)
	{
		m_GrenadeUseData.m_IsValidStateToThrowOrRespondToGrenadeOut = true;

	}

Begin:
	TargetNode = PathList[0];
KeepMovin:
	if (CurrentTargetID <= 0)
		TargetNode = PathList[0];

	while (Pawn != None &&
		   TargetNode != None &&
		   !Pawn.ReachedDestination(TargetNode))
	{
		MoveToward(TargetNode);
	}
	
	TargetNode = getNextNode();
	if (TargetNode != none)
		Goto('KeepMovin');
	else
		GotoState('Waiting');
}

state Stop
{
	function BeginState(Name PreviousStateName)
	{
// 		if (SVehicleSimCarTransmission(SVehicle(Pawn).SimObj) != none)
// 		{
// 			OldBrakingFactor = SVehicleSimCarTransmission(SVehicle(Pawn).SimObj).EngineBrakeFactor;
// 			SVehicleSimCarTransmission(SVehicle(Pawn).SimObj).EngineBrakeFactor = 1.2;	
// 		}
	}

	function EndState(Name NextStateName)
	{
// 		if (SVehicleSimCarTransmission(SVehicle(Pawn).SimObj) != none)
// 		{
// 			SVehicleSimCarTransmission(SVehicle(Pawn).SimObj).EngineBrakeFactor = OldBrakingFactor;
// 		}
	}

Begin:
	MoveTarget = none;
	Pawn.Velocity = vect(0,0,0);
	Pawn.Acceleration = vect(0,0,0);
	SVehicle(Pawn).SetInputs(0,0,0);
}

