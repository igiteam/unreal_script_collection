class PartisanPawn extends TPPawn
	placeable
    dependson(TPGear)
    dependson(TPPartisanAIController)
    dependson(TPTeamInfoAlly)
    native
	config(Game);

//***********************************************************************
// INCLUDES
//***********************************************************************









#linenumber 13

//***********************************************************************
// DEFINES
//***********************************************************************



//var() bool m_bStandStill;
//var() bool m_bIgnorePlayer;
//var() bool m_bDontAttack;
//var() bool m_bRunPatrol;

var() ePartisanStartStates StartState;


var(Squad) eTPSquad_Allies SquadAssignment;







var SkeletalMesh HelmetMesh;
var PhysicsAsset HelmetPhysics; 
var int HelmetGearIndex;
var Name HelmetSocketName;

native function	ManDown();

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

	//Removing TPPatrol!
	if( StartStateName == 'TPPatrol' )
	{
		StartStateName = 'Idle';
	}

	return StartStateName;
}

simulated event PostBeginPlay()
{
	super.PostBeginPlay();

	SetMoveSpeeds( class'TPTuneManager'.static.Get().GetTuneData().PartisanMoveData );

	//give the MP50
	//CreateInventory(class'MP50');
}


function SetUniform( eUniform newUniform )
{

























}

function InitGear()
{
	if( ClassIsChildOf( class'PartisanPawn', class) ) //should only be true for PartisanPawn, not child classes
	{
	    HelmetMesh  = SkeletalMesh'CHA_Hats.Mesh.tam';
		InitHelmet();
	}
	
	//else Do nothing
}

function InitHelmet()
{
    local int gearIndex;
    local TPGear.GearInfoType Gi;

    gearIndex = Gear.Length;
    
	//Detachable helmet
	
    Gi.SkeletalMeshName  = HelmetMesh;
    Gi.PhysicsAssetName  = HelmetPhysics;
    
    Gi.DetachUponDeath   = true;
    Gi.SocketName        = HelmetSocketName;

	HelmetGearIndex = gearIndex;
	
    Gear[gearIndex] = Spawn(class'TPGear');
    Gear[gearIndex].AttachTo(self, Gi);
    Gear[gearIndex].Hide(false);

    gearIndex++;
    
}

event TPPawn GetAllyToPlayFFXOn()
{
	local	float			radius;
	local	vector			PlayerToEnemy;
	local	float			currDist;
	local	float			bestDist;
    local	PartisanPawn	currPawn;
    local	PartisanPawn	bestPawn;

	radius = class'TPTuneManager'.static.Get().GetTuneData().FaceFXTuneData.PlayOnOtherPawnMaxDist;

	bestDist	= radius;
	bestPawn	= None;

	ForEach VisibleActors( class'PartisanPawn', currPawn, radius )
    {
		if ( currPawn == self )
			continue;

		// Ensure that the pawn isn't without a controller (e.g. when manning a turret)
		if ( currPawn.Controller == None )
			continue;

		if ( currPawn.Health <= 0 )
			continue;

		if ( currPawn.Mesh == None )
			continue;

		PlayerToEnemy = currPawn.Location - Location;

		currDist = VSize(PlayerToEnemy);

		if ( currDist < bestDist )
		{
			bestDist	= currDist;
			bestPawn	= currPawn;
		}
	}

	return ( bestPawn );
}

State Dying
{
	function BeginState(Name PreviousStateName)
	{
		Mesh.StopFaceFXAnim();
		ManDown();

		Super.BeginState(PreviousStateName);
	}
}

