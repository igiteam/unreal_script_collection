//***********************************************************************
// Class:		SPDAction_SelfDestruct
// Description: 
// Created By:  Asim Naseer, Spark Unlimited 2005
//***********************************************************************
class SPDAction_SelfDestruct extends SPDAction
	editinlinenew
	NotPlaceable;

//***********************************************************************
// FUNCTIONS/STATES
//***********************************************************************

//-----------------------------------------------------------------------
// Function:   
// Description:	
//-----------------------------------------------------------------------
event SPDActionState Run( float elapsedTime, Actor Actor, SPDProcessManager manager, SPDDamage DamageInfo )
{
	/* problem? not needed
	local Pawn pawn;
	pawn = Pawn(Actor); 
	if ( pawn != None )
	{
		//
		// Pawn.Dided will call NotifyFactoryOfDeath if the pawn really died.  Have to check for this
		// or we end up gettting 2 werewolves for every one we kill.
		//
		if ( Pawn.GetStateName() != 'Dying' )
		{
			if ( pawn.Died( DamageInfo.instigatedBy, DamageInfo.damageType, DamageInfo.location ) == false )
				SPPawn(pawn).NotifyFactoryOfDeath();
		}
	}
	*/
	actor.Destroy(); 
	return SPDActionState_Done;
}

//***********************************************************************
// Default Properties
//***********************************************************************

