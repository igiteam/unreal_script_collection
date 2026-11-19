class CivilianDriverPawn extends TPPawn
	placeable
	config(Game);


//***********************************************************************
// INCLUDES
//***********************************************************************









#linenumber 10

//***********************************************************************
// DEFINES
//***********************************************************************





simulated event PostBeginPlay()
{
	super.PostBeginPlay();

	SetMoveSpeeds( class'TPTuneManager'.static.Get().GetTuneData().CivilianDriverMoveData );

	//give the minigun
	//CreateInventory(class'MP50');
}

function OnScriptedVehiclePathLatent(SeqAct_ScriptedVehiclePathLatent action)
{
	local SVehicle	V;
	
	if( action.TargetVehicle != None )
	{
		V = SVehicle(action.TargetVehicle);
		if (V != none)
		{
			if (V.Driver == none)
				V.TryToDrive( self );
			
			TPCivilianDriverController(V.Controller).PathList = action.PathList;
			V.Controller.GotoState('Driving');
		}
		else
		{
			;
		}
	}
}

function OnScriptedVehiclePath(SeqAct_ScriptedVehiclePath action)
{
	local SVehicle	V;
	
	if( action.TargetVehicle != None )
	{
		V = SVehicle(action.TargetVehicle);
		if (V != none)
		{
			if (V.Driver == none)
				V.TryToDrive( self );
			else
				V.TryToDrive(V.Driver);
			
			TPCivilianDriverController(V.Controller).PathList = action.PathList;
			V.Controller.GotoState('Driving');
		}
		else
		{
			;
		}
	}
}

