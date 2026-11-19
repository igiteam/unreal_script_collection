class CivilianPawn extends TPPawn
	placeable
	//dependson(TPCivilianAIController)
	//dependson(TPTeamInfoNeutral)
	config(Game);

//***********************************************************************
// INCLUDES
//***********************************************************************









#linenumber 11

//***********************************************************************
// DEFINES
//***********************************************************************



var int NotAByte; //for compiler warning!

var(Squad) eTPSquad_Neutral SquadAssignment;

var() eCivilianStartStates StartState;

var SkeletalMesh HelmetMesh;
var PhysicsAsset HelmetPhysics; 
var int HelmetGearIndex;
var Name HelmetSocketName;



simulated event PostBeginPlay()
{
	super.PostBeginPlay();

	SetMoveSpeeds( class'TPTuneManager'.static.Get().GetTuneData().CivilianMoveData );

	//give the minigun
	//CreateInventory(class'MP50');
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

function InitGear()
{
}

function InitHelmet()
{
    local int gearIndex;
    local TPGear.GearInfoType Gi;

    gearIndex = Gear.Length;
    
	//Detachable helmet
	
    Gi.SkeletalMeshName  = HelmetMesh;
    //Gi.PhysicsAssetName  = HelmetPhysics;
    
    Gi.DetachUponDeath   = false;
    Gi.SocketName        = HelmetSocketName;

	HelmetGearIndex = gearIndex;
	
    Gear[gearIndex] = Spawn(class'TPGear');
    Gear[gearIndex].AttachTo(self, Gi);
    Gear[gearIndex].Hide(false);

    gearIndex++;
    
}

