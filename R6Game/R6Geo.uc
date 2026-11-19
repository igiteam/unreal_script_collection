class R6Geo extends PhysicsVolume
    abstract
    native
    hidecategories(lighting,Object,Movement,Display,Actor,Advanced,Collision,R6SoundPropagation,R6Sound,Heat,Brush,Volume,PhysicsVolume,Attachment,NavMeshGeneration);

var Vector m_vVertex[2];
var R6NavInformation m_pNavInformation;
var bool m_bGoneUseIt;
var bool m_bPathForwardPlaningUse;
var transient bool m_bIsSelected;

// Export UR6Geo::execGetPoints(FFrame&, void* const)
native final function GetPoints(out Vector vA, out Vector vB);

// Export UR6Geo::execDisableCollision(FFrame&, void* const)
native final function DisableCollision(bool bVal);

// Export UR6Geo::execHasSpaceToUse(FFrame&, void* const)
native final function bool HasSpaceToUse(Pawn pPawn, optional bool bUseLoc, optional Vector vLoc);

// Export UR6Geo::execGetClosestPoint(FFrame&, void* const)
native final function Vector GetClosestPoint(Vector vP);

defaultproperties
{
    bHiddenEd=true
    bNoSelect=true
}