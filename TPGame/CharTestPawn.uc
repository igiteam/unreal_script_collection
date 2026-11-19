class CharTestPawn extends TPPawn
	placeable
	config(Game);

//***********************************************************************
// INCLUDES
//***********************************************************************









#linenumber 9

//***********************************************************************
// DEFINES
//***********************************************************************

//test



var int NotAByte; //for compiler warning!

var(Squad) eTPSquad_Neutral SquadAssignment;

var() eCivilianStartStates StartState;




simulated event PostBeginPlay()
{
    super.PostBeginPlay();
    //give the Pistol
	//CreateInventory(class'Pistol');

	SetMoveSpeeds( class'TPTuneManager'.static.Get().GetTuneData().CivilianMoveData );
}



//-----------------------------------------------------------------------
// Function:
// Description:	Each Pawn type should override this.
//				Returns the index to the Pawn's SPTeamInfo pre-defined
//				squad names array.
//				This index is then passed into
//				SPTeamInfo.GetPreDefinedSquadName() function to get the
//				actual name string.
//-----------------------------------------------------------------------
function int GetSquadNameIndex()
{
	local int squadNameIdx;

	squadNameIdx = SquadAssignment;
	return squadNameIdx;
}


function Name GetStartStateName()
{
	local string statename;
	if( StartStateName == 'None' )
	{
		//Get the name directly from the enum...
		statename = statename $ StartState;
		StartStateName = name(statename);
	}

	return StartStateName;
}

