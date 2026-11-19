/**
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/

class SeqAct_NanoVehicleSpawner extends SeqAct_GameCrowdSpawner
	native(Sequence);

/** If non-empty, select a random mesh from this array and assign to car instead of default on for CarClass */
var()   array<StaticMesh> CarMeshes;

struct native AdditionalMeshInfo
{
	/** The additional mesh to potentially spawn **/
	var() StaticMeshComponent    MeshComp;
	/** How likely this mesh is to spawn on the car (1.0 = always spawn) **/
	var() float         Frequency;
};

var()   array<AdditionalMeshInfo> AdditionalMeshes;

/** The default offset of the car from the road spline */
var()   DistributionVector   RandomOffset;

/** If true, location / rotation of the vehicle will be aligned to the spawn point **/
var()   bool    bAlignToSpawnPoint;

cpptext
{
	//virtual void Activated();
	//virtual UBOOL UpdateOp(FLOAT DeltaTime);
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 3;
}

event GameCrowdAgent SpawnAgent(Actor SpawnLoc)
{
	local NanoVehicleAgent Agent;
	local StaticMesh CarMesh;
	local NanoVehicleSpline Spline;
	local int i;
	local StaticMeshComponent SMComp;
	local AdditionalMeshInfo AMI;

	if( GetWorldInfo().NetMode == NM_Client )
	{
		// Only spawn vehicles on the server!
		return None;
	}

	Spline = NanoVehicleSpline(SpawnLoc);
	if( (Spline != None) && !Spline.CanAcceptNewSpawnedVehicles() )
	{
		// If this is a nano spline, return if it can't accept new vehicles
		return None;
	}

	Agent = NanoVehicleAgent(super.SpawnAgent(SpawnLoc));	
	if(Agent != none)
	{
		// by default, unless SpawnLoc is a GameCrowdSpawnInterface, the location / rotation of the spawned agent is random.
		// since our vehicles are often spawned directly onto splines, allow that spline to override the random location here
		if( bAlignToSpawnPoint )
		{
			Agent.SetLocation(SpawnLoc.Location);
			Agent.SetRotation(SpawnLoc.Rotation);
		}

		if(CarMeshes.Length > 0)
		{
			CarMesh = CarMeshes[Rand(CarMeshes.Length)];
			if(CarMesh != none)
			{
				// If we're using static meshes for vehicles
 				if( StaticMeshComponent(Agent.VehicleMeshComponent) != None )
 				{
 					StaticMeshComponent(Agent.VehicleMeshComponent).SetStaticMesh(CarMesh);
 				}
 				
				// Need to do this again, to get material from new mesh
				Agent.CreateMaterialInstances();
			}
		}
		
		Agent.VehicleMeshComponent.CastShadow = bCastShadows;
		Agent.VehicleMeshComponent.bCastDynamicShadow = bCastShadows;		
		Agent.VehicleMeshComponent.SetLightingChannels(AgentLightingChannel);

		// Handle adding any additional mesh components to the car, if needed
		for( i = 0; i < AdditionalMeshes.Length; ++i )
		{
			AMI = AdditionalMeshes[i];

			if( (FRand() <= AMI.Frequency) && (AMI.MeshComp != None) && ( AMI.MeshComp.StaticMesh != none ) )
			{
				//`log( "Vehicle AdditionalMesh" @ AMI.MeshComp.StaticMesh );
				// Spawn a new mesh component based on the one specified in the spawner
				SMComp = new(Agent) class'StaticMeshComponent'(AMI.MeshComp);

				if( SMComp != None )
				{
					SMComp.SetStaticMesh(AMI.MeshComp.StaticMesh);
 					SMComp.SetShadowParent(Agent.VehicleMeshComponent);
 					SMComp.SetLightEnvironment(Agent.VehicleMeshComponent.LightEnvironment);

					// Attach the component to the vehicle
					Agent.AttachComponent(SMComp);
				}
			}
		}
		
		if( RandomOffset != none )
		{
		    Agent.SplineOffsetVector = RandomOffset.GetVectorValue();
		}
				
		if(Spline != none )
		{
			if( Spline.IsValidSplineForVehicle(Agent) )
			{
				Spline.AddVehicleToSpline(Agent, Spline.GetBestLaneForVehicle());
				Agent.FillOutTargetSplines();
			}
			else
			{
				`warn("Invalid spline for spawned vehicle " $ Agent $ "...wrong vehicle type?");
				Agent.Destroy();
			}
		}
	}
	
	return Agent;
}


defaultproperties
{
	Begin Object Class=DistributionVectorUniform Name=DistributionOffset
	End Object
	RandomOffset=DistributionOffset

	bAlignToSpawnPoint=true

	ObjName="Nano Vehicle Spawner"
	ObjCategory="Crowd"
}	
