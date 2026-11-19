//=============================================================================
// SASLODStaticMesh.uc
//
//=============================================================================

class SASLODStaticMesh extends StaticMeshActor
	native;

// A header file named the same as the class is implicitly included as soon as it exists... hence removed the cpptext here.


//-----------------------------------------------------------------------------
// Constants

//-----------------------------------------------------------------------------
// Enums

//-----------------------------------------------------------------------------
// Structs

struct native SASLODStage
{
	var() StaticMesh		    Mesh;
	var() float					MinDist;
	var StaticMeshInstance		StaticMeshInstance; // JS different instance for each LOD for the sake of lighting
};

//-----------------------------------------------------------------------------
// Member Vars

var() array<SASLODStage>	mLODStages;
var   int					mCurrentLOD;
var() int					mPS2DropLODs;

//-----------------------------------------------------------------------------
// Native Functions

//-----------------------------------------------------------------------------
// Exec Functions

//-----------------------------------------------------------------------------
// Functions


// Decompiled with UE Explorer.
defaultproperties
{
    bCantBeBatched=true
    bPathColliding=true
}