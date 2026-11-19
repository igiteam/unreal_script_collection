class SkyGripPointWithMesh extends SkyGripPoint
    native;

struct native GPWithMeshParameter
{
    var() int ActionIndex;
    var() name ParameterName;

    structdefaultproperties
    {
        ActionIndex=0
        ParameterName="None"
    }
};

struct native GPWithMeshFinishParameter
{
    var() int ActionIndex;
    var() name ParameterName;
    var() float StartDelay;
    var() float BlendTime;
    var float ActiveTime;

    structdefaultproperties
    {
        ActionIndex=0
        ParameterName="None"
        StartDelay=0.0000000
        BlendTime=0.0000000
        ActiveTime=0.0000000
    }
};

var() editconst export editinline StaticMeshComponent Mesh;
var() array<GPWithMeshParameter> ProgressParameters;
var() array<GPWithMeshFinishParameter> FinishParameters;
var() name AttachSocket;
var MaterialInstanceConstant MatInst;

simulated event PostBeginPlay()
{
    super(Actor).PostBeginPlay();
    MatInst = Mesh.CreateAndSetMaterialInstanceConstant(0);
    //return;    
}
