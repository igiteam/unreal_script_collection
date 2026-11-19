//***********************************************************************
// Class:		SPDActionList
// Description: 
// Created By:  Asim Naseer, Spark Unlimited 2005
// integrated from Pandora to TP by Doug Kuppinger 8/25/06
//***********************************************************************

class SPDActionList extends Object
	editinlinenew
	NotPlaceable
	abstract
	native
	dependson(SPDAction)
	hidecategories(Object);


//***********************************************************************
// VARIABLE DECLARATIONS
//***********************************************************************

var () bool bEnabled;
var () export editinline array<SPDAction>	Action;
var () bool ShowDebug;

//***********************************************************************
// CPP TEXT
//***********************************************************************
// (cpptext)
// (cpptext)
// (cpptext)

//-----------------------------------------------------------------------
// Function: PostBeginPlay    
// Description:	
//-----------------------------------------------------------------------
function bool HasActions()
{
	local int idx;

	if ( Action.length < 0 )
		return false;
	for (idx = 0; idx < Action.Length; idx++)
	{
		if ( Action[idx] != None )
			return true;
	}			
	return false;
		
}

//***********************************************************************
// Default Properties
//***********************************************************************

