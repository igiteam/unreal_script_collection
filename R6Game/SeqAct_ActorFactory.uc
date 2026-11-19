class SeqAct_ActorFactory extends SeqAct_Latent
    native
    hidecategories(Object);

enum EPointSelection
{
    PS_Normal,                      // 0
    PS_Random,                      // 1
    PS_Reverse,                     // 2
    PS_MAX                          // 3
};

var() bool bEnabled;
var bool bIsSpawning;
var() bool bCheckSpawnCollision;
var() export editinline ActorFactory Factory;
var() SeqAct_ActorFactory.EPointSelection PointSelection;
var() array<Actor> SpawnPoints;
var() int SpawnCount;
var() float SpawnDelay;
var int LastSpawnIdx;
var int SpawnedCount;
var float RemainingDelay;

defaultproperties
{
    bEnabled=true
    bCheckSpawnCollision=true
    SpawnCount=1
    SpawnDelay=0.5000000
    LastSpawnIdx=-1
    InputLinks[0]=(LinkDesc="Spawn Actor",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    InputLinks[1]=(LinkDesc="Enable",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    InputLinks[2]=(LinkDesc="Disable",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    InputLinks[3]=(LinkDesc="Toggle",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    VariableLinks[0]=(ExpectedType=Class'SeqVar_Object',LinkedVariables=none,LinkDesc="Spawn Point",LinkVar="None",PropertyName="SpawnPoints",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    VariableLinks[1]=(ExpectedType=Class'SeqVar_Object',LinkedVariables=none,LinkDesc="Spawned",LinkVar="None",PropertyName="None",bWriteable=true,bHidden=false,MinVars=0,MaxVars=255,DrawX=0)
    VariableLinks[2]=(ExpectedType=Class'SeqVar_Int',LinkedVariables=none,LinkDesc="Spawn Count",LinkVar="None",PropertyName="SpawnCount",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    ObjName="Actor Factory"
    ObjCategory="Actor"
}