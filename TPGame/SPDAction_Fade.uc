//***********************************************************************
// Class:		SPDAction_Fade
// Description: 
// Created By:  Asim Naseer, Spark Unlimited 2005
// integrated from Pandora to TP by Doug Kuppinger 8/25/06
//***********************************************************************

class SPDAction_Fade extends SPDAction_Latent
	editinlinenew
	native
	NotPlaceable;

//***********************************************************************
// STRUCT DECLARATIONS
//***********************************************************************

struct	native MaterialSwap
{
	var MaterialInterface original;
	var MaterialInstanceConstant instance;
};						   

struct	native SPDAction_FadeData
{
	var float 						CurrentAlpha;
	var float			 			rate;
	var MaterialSwap				Swap[8];
};



//***********************************************************************
// VARIABLE DECLARATIONS
//***********************************************************************
var (SPDAction) 				float TimeInSeconds;
var SPDAction_FadeData data;

//***********************************************************************
// NATIVE FUNCTION DECLARATIONS
//***********************************************************************
native function PushDataNative( SPDProcessManager manager );
native function PopDataNative( SPDProcessManager manager );

//***********************************************************************
// FUNCTIONS/STATES
//***********************************************************************

//-----------------------------------------------------------------------
// Function:   
// Description:	
//-----------------------------------------------------------------------
function UpdateMaterialInstance()
{
	local int idx;
	
	for ( idx = 0; idx < 8; idx++ )
	{
		if ( data.Swap[idx].original == None )
			break;
		if ( data.Swap[idx].instance == None )
			break;
		data.Swap[idx].instance.SetScalarParameterValue('Opacity', data.CurrentAlpha );
	}
}

//-----------------------------------------------------------------------
// Function:   
// Description:	
//-----------------------------------------------------------------------
function CleanupMaterialInstance( Actor actor )
{
	local int idx;
	local StaticMeshComponent    StaticMesh;
	local SkeletalMeshComponent	 SkeletalMesh;

	StaticMesh = actor.GetStaticMeshComponent();
	SkeletalMesh = actor.GetSkeletalMeshComponent();
	
	for ( idx = 0; idx < 8; idx++ )
	{
		if ( data.Swap[idx].original == None )
			break;
		if ( data.Swap[idx].instance == None )
			break;
		if ( StaticMesh != None )
			StaticMesh.SetMaterial(idx, data.Swap[idx].original);
		else if ( SkeletalMesh != None )
			SkeletalMesh.SetMaterial(idx, data.Swap[idx].original);
		data.Swap[idx].instance.SetParent(None);
	}

	for ( idx = 0; idx < 8; idx++ )
	{
		data.Swap[idx].original = None;
		data.Swap[idx].instance = None;
	}
}

//-----------------------------------------------------------------------
// Function:   
// Description:	
//-----------------------------------------------------------------------
function MakeStaticMeshMaterialInstances( StaticMeshComponent StaticMesh )
{
	local int idx;
	
	idx = 0;
	for ( idx = 0; idx < 8; idx++ )
	{
		data.Swap[idx].original = StaticMesh.GetMaterial(idx);
		if ( data.Swap[idx].original == None )
		{
			data.Swap[idx].instance = None;
			break;
		}
		data.Swap[idx].instance = new(None) Class'MaterialInstanceConstant';
		if ( data.Swap[idx].instance == None )
		{
			data.Swap[idx].original = None;
			break;
		}
		data.Swap[idx].instance.SetParent(data.Swap[idx].original);
		StaticMesh.SetMaterial(idx, data.Swap[idx].instance);
	}
	UpdateMaterialInstance();
}

//-----------------------------------------------------------------------
// Function:   
// Description:	
//-----------------------------------------------------------------------
function MakeSkeletalMeshMaterialInstances( SkeletalMeshComponent SkeletalMesh )
{
	local int idx;
	
	idx = 0;
	for ( idx = 0; idx < 8; idx++ )
	{
		data.Swap[idx].original = SkeletalMesh.GetMaterial(idx);
		if ( data.Swap[idx].original == None )
		{
			data.Swap[idx].instance = None;
			break;
		}
		data.Swap[idx].instance = new(None) Class'MaterialInstanceConstant';
		if ( data.Swap[idx].instance == None )
		{
			data.Swap[idx].original = None;
			break;
		}
		data.Swap[idx].instance.SetParent(data.Swap[idx].original);
		SkeletalMesh.SetMaterial(idx, data.Swap[idx].instance);
	}
	UpdateMaterialInstance();
}

//-----------------------------------------------------------------------
// Function:   
// Description:	
//-----------------------------------------------------------------------
event SPDActionState Enter( float elapsedTime, Actor actor, SPDProcessManager manager, SPDDamage DamageInfo )  
{
	local StaticMeshComponent    StaticMesh;
	local SkeletalMeshComponent	 SkeletalMesh;

	data.CurrentAlpha = 1.0f;
	data.rate = data.CurrentAlpha / TimeInSeconds;
	StaticMesh = actor.GetStaticMeshComponent();
	if ( StaticMesh != None )
	{
		MakeStaticMeshMaterialInstances( StaticMesh );
		return SPDActionState_InProgress;
	}
	else
	{
		SkeletalMesh = actor.GetSkeletalMeshComponent();
		if ( SkeletalMesh != None )
		{		
			MakeSkeletalMeshMaterialInstances( SkeletalMesh );
			return SPDActionState_InProgress;
		}
	}
	return SPDActionState_Done;
}

//-----------------------------------------------------------------------
// Function:   
// Description:	
//-----------------------------------------------------------------------
event SPDActionState Run( float elapsedTime, Actor Actor, SPDProcessManager manager, SPDDamage DamageInfo )  
{
	data.CurrentAlpha -= data.rate * elapsedTime;
	if ( data.CurrentAlpha <= 0 )
	{
		data.CurrentAlpha = 0;
		UpdateMaterialInstance();
		return SPDActionState_Done;
	}
	UpdateMaterialInstance();
	return SPDActionState_InProgress;
}

//-----------------------------------------------------------------------
// Function:   
// Description:	
//-----------------------------------------------------------------------
event Exit( Actor Actor, SPDProcessManager manager, SPDDamage DamageInfo )  
{
	data.CurrentAlpha = 1;
	CleanupMaterialInstance( actor );
}

//-----------------------------------------------------------------------
// Function:   
// Description:	
//-----------------------------------------------------------------------
event Abort( Actor Actor, SPDProcessManager manager, SPDDamage DamageInfo )  
{
	Exit( actor, manager, DamageInfo );
}


//***********************************************************************
// Default Properties
//***********************************************************************

