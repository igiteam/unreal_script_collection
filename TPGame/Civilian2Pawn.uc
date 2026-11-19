class Civilian2Pawn extends CivilianPawn
	placeable
	dependson(CivilianPawn)
	config(Game);

//***********************************************************************
// INCLUDES
//***********************************************************************









#linenumber 10

var	StaticMeshComponent		BundlePropMesh;


simulated event PostBeginPlay()
{
	super.PostBeginPlay();

	SetMoveSpeeds( class'TPTuneManager'.static.Get().GetTuneData().Civilian2MoveData );

	//Mesh.AttachComponent( BundlePropMesh, 'JO_Prop');
	Mesh.AttachComponentToSocket( BundlePropMesh, 'bundle');
}

function InitGear()
{
	InitHelmet();
}

