class SeqAct_SpawnGagPawn extends SequenceAction
    native
    hidecategories(Object);

enum eHeadMesh
{
    BOYD_HEAD,                      // 0
    MATT_HEAD,                      // 1
    NATHAN_HEAD,                    // 2
    TOM_HEAD,                       // 3
    TOBY_HEAD,                      // 4
    ANY_HEAD,                       // 5
    eHeadMesh_MAX                   // 6
};

var() class<MOHAAIPawn> GagPawnClass;
var() SeqAct_SpawnGagPawn.eHeadMesh PawnHeadMesh;
var() bool bAllowWeaponSpecificGear;
var() bool bUpdateSkelWhenNotRendered;
var() int iForcedLODModel;
var() SkeletalMesh HeadMesh;
var MOHAAIPawn SpawnedPawn;

defaultproperties
{
    bAllowWeaponSpecificGear=true
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Target",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="GagPawn",LinkVar="None",PropertyName="None",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    ObjName="Spawn Gag Pawn"
    ObjCategory="IGC Gags"
}