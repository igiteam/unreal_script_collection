class KynapseAIMeshLayerManager extends KynapseWorldService
	editinlinenew
	native
	hidecategories(Movement,Collision,Advanced,Attachment,Display,Object);


// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)


struct native AIMeshAccessor
{
	var() const string ClassName;
	var() const string MeshName;

	structdefaultproperties
	{
		ClassName="CAiMeshAccessor_Standard"
		MeshName="MoveMesh"
	}
};

struct native ObstaclesAccessor
{
	var() const string ClassName;

	structdefaultproperties
	{
		ClassName="CObstaclesAccessor_EntityOutline"
	}
};
		//ClassName="CObstaclesAccessor_EntityDeactivableOutline"

struct native AIMeshLayer
{
	var() const string Name;
	var() const string ClassName;
	var() const int MaxMeshCount;
	var() const int MaxObstacles;
	var() const int MaxProjections;
	var() const array<AIMeshAccessor> AIMeshAccessors;
	var() const array<ObstaclesAccessor> ObstaclesAccessors;
	
	structdefaultproperties
	{
		Name=None
		ClassName="CObstaclesLayer"
		MaxMeshCount=32
		MaxObstacles=100
		MaxProjections=400
	}
};
		//ClassName="CObstaclesLayerRender"
		//MaxProjections=4*MaxObstacles

var() const array<AIMeshLayer> AIMeshLayers;


