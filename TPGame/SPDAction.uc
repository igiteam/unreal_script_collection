//=============================================================================
// SPDAction.
// 
// integrated from Pandora to TP by Doug Kuppinger 8/25/06
//=============================================================================

class SPDAction extends Object
	abstract
	editinlinenew
	NotPlaceable
	native
	collapsecategories
	dependson(SPDProcessManager)
	hidecategories(Object);


//***********************************************************************
// STRUCT DECLARATIONS
//***********************************************************************

struct native SPDProcesData 
{
	var byte padding[4];
};

//***********************************************************************
// VARIABLE DECLARATIONS
//***********************************************************************
var () const editconst string Action;



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
	return SPDActionState_Done;
}



