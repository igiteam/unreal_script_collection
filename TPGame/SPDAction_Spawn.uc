//***********************************************************************
// Class:		SPDAction_Spawn
// Description:
// Created By:  Asim Naseer, Spark Unlimited 2005
// integrated from Pandora to TP by Doug Kuppinger 8/25/06
//***********************************************************************

class SPDAction_Spawn extends SPDAction
	dependson(SPActorDestructComponent)
	native
	editinlinenew
	abstract
	NotPlaceable;

//***********************************************************************
// STRUCT DECLARATIONS
//***********************************************************************

//***********************************************************************
// VARIABLE DECLARATIONS
//***********************************************************************

var (SPDAction) bool	AttachToSpawner;
var (SPDAction) bool	InheritLinearVelocity;
var (SPDAction) bool	bCheckForSpawnCollision;
var (SPDAction) float	LinearVelocityScale;
var (SPDAction) vector	PositionOffset;
var (SPDAction) rotator RotationOffset;
var (SPDAction) name	SocketName;
var (SPDAction) export editinline array<SPDGenericActionList> 	OnSpawnActionsLists;

var	class<Actor>	NewActorClass;


//***********************************************************************
// CPP TEXT
//***********************************************************************
// (cpptext)
// (cpptext)
// (cpptext)

//***********************************************************************
// FUNCTIONS/STATES
//***********************************************************************

native function Name SocketNameToBoneName( SkeletalMeshComponent mesh, name SName );
native function FindSpawnSpot(Actor daActor);

//-----------------------------------------------------------------------
// Function:
// Description:
//-----------------------------------------------------------------------
function FindBestSpotForSpawnLocation(Actor daActor)
{
	if (bCheckForSpawnCollision == true)
	{
		FindSpawnSpot(daActor);
	}
}

//-----------------------------------------------------------------------
// Function:
// Description:
//-----------------------------------------------------------------------
function AddOnSpawnActions( Actor newActor, SPDProcessManager manager )
{
	local int   idx;
	local SPActorDestructComponent spComponent;

	if ( manager.HasActions(OnSpawnActionsLists) )
	{
		for ( idx = 0; idx < OnSpawnActionsLists.length; idx++ )
		{
			manager.AddActionList(OnSpawnActionsLists[idx], newActor );
		}
	}
	else
	{
		spComponent = SPActorDestructComponent( newActor.GetActorDestructComponent() );
		if ( spComponent != None && spComponent.properties != none )
		{
			for ( idx = 0; idx < spComponent.properties.OnSpawnActionList.length; idx++ )
			{
				manager.AddActionList(spComponent.properties.OnSpawnActionList[idx], newActor );
			}
		}
	}
}

//-----------------------------------------------------------------------
// Function:
// Description:
//-----------------------------------------------------------------------
function AddVelocity( Actor oldActor, Actor newActor )
{
	local MeshComponent MeshComp;

	if ( InheritLinearVelocity )
	{
		newActor.Velocity = oldActor.Velocity * LinearVelocityScale;
		MeshComp = newActor.GetSkeletalMeshComponent();
		if ( MeshComp == None )
			MeshComp = newActor.GetStaticMeshComponent();
		if ( MeshComp != None )
		{
			MeshComp.SetRBLinearVelocity( newActor.Velocity );
		}
	}
}

//-----------------------------------------------------------------------
// Function:
// Description:
//-----------------------------------------------------------------------
function AttachIt( Actor inOldActor, Actor newActor, vector SpawnLocation, rotator SpawnRotation )
{
	local bool HavePosition;
	local vector SocketLocation;
	local rotator SocketRotation;
	local SkeletalMeshComponent SkelMesh;
	//local name BoneName;
	local Actor oldActor;
	
	HavePosition = false;
	/* problem? not using this, think it has to do with lifeforce sucking
	// This is overriding the parent to attach to if its an intermediate lifeforce holder
	// probably a cleaner way would be to modify the Actor class to expose a virtual call
	// to a GetDesiredAttachActor function but its not critical here and we don't have a
	// SPActor class. (Cary)
   	if (SPLifeForceHolder(inOldActor) != None && SPLifeForceHolder(inOldActor).parentActor != None)
	{
		oldActor = SPLifeForceHolder(inOldActor).parentActor;
	}
	else
	{
		oldActor = inOldActor;
	}
	*/
	oldActor = inOldActor;
   
	if ( SocketName != 'None' )
	{
		SkelMesh = oldActor.GetSkeletalMeshComponent();
		if ( SkelMesh != None )
		{
			HavePosition = SkelMesh.GetSocketWorldLocationAndRotation( SocketName, SocketLocation, SocketRotation);
			if ( HavePosition )
			{	// this works if the old actor is a skeletal mesh with a socket
				//BoneName = SocketNameToBoneName( SkelMesh, SocketName );
				//log(SocketName);
				//log(BoneName);
				//log(SocketLocation);
				//log(SocketRotation);
				//newActor.SetCollision(FALSE, FALSE);
				/*if ( SkelMesh.PhysicsAsset != None ) // sockets don't seem to work with PHYS_RigidBody
				{	// make sure no relative offset gets in there
					SocketRotation = oldActor.Rotation;
					SocketLocation = oldActor.Location;
				}
				newActor.SetRotation(SocketRotation);
				newActor.SetLocation(SocketLocation);*/
				newActor.SetBase(oldActor,, SkelMesh, SocketName);
			}
		}
	}
	
	if ( !HavePosition )
	{
		newActor.SetHardAttach(true);
		newActor.SetBase( oldActor );
	}
}

//-----------------------------------------------------------------------
// Function:
// Description:
//-----------------------------------------------------------------------
function GetSpawnPosition( Actor inOldActor, SPDDamage DamageInfo, out vector SpawnLocation, out rotator SpawnRotation )
{
	local Quat QRot;
	local SkeletalMeshComponent SkelMesh;
	local bool HavePosition;
	local Actor actor;

	HavePosition = false;
	/* problem? not using this, think it has to do with lifeforce sucking
	// This is overriding the parent to attach to if its an intermediate lifeforce holder
	// probably a cleaner way would be to modify the Actor class to expose a virtual call
	// to a GetDesiredAttachActor function but its not critical here and we don't have a
	// SPActor class. (Cary)
   	if (SPLifeForceHolder(inOldActor) != None && SPLifeForceHolder(inOldActor).parentActor != None)
	{
		actor = SPLifeForceHolder(inOldActor).parentActor;
	}
	else
	{
		actor = inOldActor;
	}
	*/
	actor = inOldActor;
	
//	if ( Len( SocketName ) != 0 )
	if ( SocketName != 'None' )
	{
		SkelMesh = actor.GetSkeletalMeshComponent();
		if ( SkelMesh != None )
		{
			HavePosition = SkelMesh.GetSocketWorldLocationAndRotation( SocketName, SpawnLocation, SpawnRotation);
			if ( HavePosition )
			{
				SpawnRotation += RotationOffset;
				QRot = QuatFromRotator( SpawnRotation );
				SpawnLocation = QuatRotateVector( QRot, PositionOffset ) + SpawnLocation;
			}
		}
	}

	if ( !HavePosition )
	{
		if ( actor != None )
		{
			SpawnLocation = actor.location;
			SpawnRotation = actor.rotation;
		}
		else
		{
			SpawnLocation = DamageInfo.location;
			SpawnRotation = DamageInfo.rotation;
		}

		SpawnRotation += RotationOffset;

		QRot = QuatFromRotator( SpawnRotation);
		SpawnLocation = QuatRotateVector( QRot, PositionOffset ) + SpawnLocation;
	}
}

//-----------------------------------------------------------------------
// Function:
// Description:
//-----------------------------------------------------------------------
function Actor CreateActorInternal( SPDProcessManager manager, vector SpawnLocation, rotator SpawnRotation, Actor baseActor )
{
	local Actor newActor;

	newActor = manager.SPSpawn( NewActorClass ,baseActor,, SpawnLocation, SpawnRotation );
	return newActor;
}

//-----------------------------------------------------------------------
// Function:
// Description:
//-----------------------------------------------------------------------
function Actor CreateActor( SPDProcessManager manager, Actor actor, SPDDamage DamageInfo )
{
	local Actor newActor;
	local vector SpawnLocation;
	local rotator SpawnRotation;

	GetSpawnPosition( actor, DamageInfo, SpawnLocation, SpawnRotation );
	newActor = CreateActorInternal( manager, SpawnLocation, SpawnRotation, actor);
	if ( newActor != None )
	{
		AddOnSpawnActions( newActor, manager );
		if ( AttachToSpawner )
			AttachIt( actor, newActor, SpawnLocation, SpawnRotation );
		AddVelocity( actor, newActor );
	}
	return newActor;
}

//***********************************************************************
// Default Properties
//***********************************************************************

