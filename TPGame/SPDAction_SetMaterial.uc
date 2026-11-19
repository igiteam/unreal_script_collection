//***********************************************************************
// Class:		SPDAction_SetMaterial
// Description: 
// Created By:  Asim Naseer, Spark Unlimited 2005
// integrated from Pandora to TP by Doug Kuppinger 8/25/06
//***********************************************************************

class SPDAction_SetMaterial extends SPDAction
	editinlinenew
	native
	NotPlaceable;

//***********************************************************************
// STRUCT DECLARATIONS
//***********************************************************************

//***********************************************************************
// VARIABLE DECLARATIONS
//***********************************************************************

var (SPDAction) export array<MaterialInterface> Materials;

//***********************************************************************
// NATIVE FUNCTION DECLARATIONS
//***********************************************************************

//***********************************************************************
// FUNCTIONS/STATES
//***********************************************************************

//-----------------------------------------------------------------------
// Function:   
// Description:	
//-----------------------------------------------------------------------
event SPDActionState Run( float elapsedTime, Actor Actor, SPDProcessManager manager, SPDDamage DamageInfo )  
{
	local int idx;
	local StaticMeshComponent    StaticMesh;
	local SkeletalMeshComponent	 SkeletalMesh;

	StaticMesh = actor.GetStaticMeshComponent();
	if ( StaticMesh != None )
	{
		for ( idx = 0; idx < Materials.Length; idx++ )
		{
			if ( StaticMesh.GetMaterial(idx) != None && Materials[idx] != None )
			{
				StaticMesh.SetMaterial( idx, Materials[idx] );
			}
		}
	}
	else
	{
		SkeletalMesh = actor.GetSkeletalMeshComponent();
		if ( SkeletalMesh != None )
		{
			for ( idx = 0; idx < Materials.Length; idx++ )
			{
				if ( SkeletalMesh.GetMaterial(idx) != None && Materials[idx] != None )
				{
					SkeletalMesh.SetMaterial( idx, Materials[idx] );
				}
			}
		}
	}
	return SPDActionState_Done;
}

//***********************************************************************
// Default Properties
//***********************************************************************

