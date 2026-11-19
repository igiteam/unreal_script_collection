class Civilian3Pawn extends CivilianPawn
	placeable
	config(Game);


//***********************************************************************
// INCLUDES
//***********************************************************************









#linenumber 10

var	StaticMeshComponent		BriefcasePropMesh;


simulated event PostBeginPlay()
{
	super.PostBeginPlay();

	SetMoveSpeeds( class'TPTuneManager'.static.Get().GetTuneData().Civilian3MoveData );

	//Mesh.AttachComponent( BriefcasePropMesh, 'JO_Prop');
	Mesh.AttachComponentToSocket( BriefcasePropMesh, 'briefcase');
}

