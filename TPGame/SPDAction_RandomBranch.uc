//***********************************************************************
// Class:		SPDAction_RandomBranch
// Description: 
// Created By:  Asim Naseer, Spark Unlimited 2005
// integrated from Pandora to TP by Doug Kuppinger 8/25/06
//***********************************************************************

class SPDAction_RandomBranch extends SPDAction
	native
	editinlinenew
	NotPlaceable;

//***********************************************************************
// STRUCT DECLARATIONS
//***********************************************************************

//***********************************************************************
// VARIABLE DECLARATIONS
//***********************************************************************

var (SPDAction) export editinline array<SPDGenericActionList> 	OtherActionLists;

//***********************************************************************
// CPP TEXT
//***********************************************************************
// (cpptext)
// (cpptext)
// (cpptext)

//***********************************************************************
// FUNCTIONS/STATES
//***********************************************************************

//-----------------------------------------------------------------------
// Function:   
// Description:	
//-----------------------------------------------------------------------
event SPDActionState Run( float elapsedTime, Actor Actor, SPDProcessManager manager, SPDDamage DamageInfo )
{
	local int NumberOfActionsListsAvailable; 
	local int SelectedList;
	local array<int> NonEmptyListIndices;
	local int i;
	
	NumberOfActionsListsAvailable = OtherActionLists.length;

	// Ignore empty lists
	for (i = 0; i < NumberOfActionsListsAvailable; ++i )
	{
		if ( OtherActionLists[i].HasActions() )
		{
			NonEmptyListIndices.Insert(0,1);
			NonEmptyListIndices[0] = i;
		}
	}
	
	if ( NonEmptyListIndices.length == 0)
	{
		// Just continue with current action list
		return SPDActionState_Done;
	}

	SelectedList = 1;				  
	SelectedList = Rand( NonEmptyListIndices.length + 1 ); // +1 becuase one of the availbale action lists is the current one in progress.
	
	if ( SelectedList != 0 )
	{
		SelectedList -= 1;
		SelectedList = NonEmptyListIndices[SelectedList];
		manager.AddActionListWithDamageInfo(OtherActionLists[SelectedList], Actor, DamageInfo );
		return SPDActionState_Abort;  // Abort the current action list
	}
	
	// Just continue with current action list
	return SPDActionState_Done;
}

//***********************************************************************
// Default Properties
//***********************************************************************

