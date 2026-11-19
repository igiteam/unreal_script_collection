//***********************************************************************
// Class:		SPDAction_SpawnPrefab
// Description: 
// Created By:  Asim Naseer, Spark Unlimited 2005
// integrated from Pandora to TP by Doug Kuppinger 8/25/06
//***********************************************************************

class SPDAction_SpawnPrefab extends SPDAction_Spawn
	dependson(SPActorDestructComponent)
	native
	editinlinenew
	NotPlaceable;

//***********************************************************************
// STRUCT DECLARATIONS
//***********************************************************************

//***********************************************************************
// VARIABLE DECLARATIONS
//***********************************************************************

var	(SPDAction)	Object Archetype;
var	Actor	ArchetypeActor;

native function Actor CreateFromArcheType( vector SpawnLocation, rotator SpawnRotation );

//-----------------------------------------------------------------------
// Function:   
// Description:	
//-----------------------------------------------------------------------
function Actor CreateActorInternal( SPDProcessManager manager, vector SpawnLocation, rotator SpawnRotation, Actor BaseActor )
{
   return CreateFromArcheType( SpawnLocation, SpawnRotation );
}

//-----------------------------------------------------------------------
// Function:   
// Description:	
//-----------------------------------------------------------------------
event SPDActionState Run( float elapsedTime, Actor Actor, SPDProcessManager manager, SPDDamage DamageInfo )
{
	return SPDActionState_Done;
//	CreateActor( manager, actor, DamageInfo );
//	return SPDActionState_Done;
}
			  

//***********************************************************************
// Default Properties
//***********************************************************************

