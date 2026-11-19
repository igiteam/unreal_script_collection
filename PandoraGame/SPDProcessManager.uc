class SPDProcessManager extends Actor
    native
    notplaceable;

enum SPDActionState
{
    SPDActionState_InProgress,      // 0
    SPDActionState_Done,            // 1
    SPDActionState_Abort,           // 2
    SPDActionState_MAX              // 3
};

enum SPDProcessType
{
    SPDProcessType_Generic,         // 0
    SPDProcessType_Destruct,        // 1
    SPDProcessType_MAX              // 2
};

struct native SPDDamage
{
    var Vector Location;
    var Rotator Rotation;
    var int DamageAmount;
    var Controller instigatedBy;
    var Vector HitLocation;
    var Vector Momentum;
    var class<DamageType> DamageType;
    var TraceHitInfo HitInfo;
    var bool IsValid;
    var bool ShowDebug;
    var export editinline PrimitiveComponent Component;
    var Actor DamageCauser;

    structdefaultproperties
    {
        Location=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Rotation=(Pitch=0,Yaw=0,Roll=0)
        DamageAmount=0
        instigatedBy=none
        HitLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Momentum=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        DamageType=none
        HitInfo=(Material=none,PhysMaterial=none,Item=0,LevelIndex=0,BoneName="None",HitComponent=none)
        IsValid=false
        ShowDebug=false
        Component=none
        DamageCauser=none
    }
};

struct native SPDProcessState
{
    var float ProcessId;
    var SPDActionList ActionList;
    var int CurAction;
    var int CountActions;
    var bool Active;
    var bool ExecutingLatent;
    var SPDProcessManager.SPDProcessType ProcessType;
    var Actor Actor;
    var SPDDamage DamageInfo;
    var int StackIdx;
    var byte ProcessData[128];

    structdefaultproperties
    {
        ProcessId=0.0000000
        ActionList=none
        CurAction=0
        CountActions=0
        Active=false
        ExecutingLatent=false
        ProcessType=SPDProcessType_Generic
        Actor=none
        DamageInfo=(Location=(X=0.0000000,Y=0.0000000,Z=0.0000000),Rotation=(Pitch=0,Yaw=0,Roll=0),DamageAmount=0,instigatedBy=none,HitLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000),Momentum=(X=0.0000000,Y=0.0000000,Z=0.0000000),DamageType=none,HitInfo=(Material=none,PhysMaterial=none,Item=0,LevelIndex=0,BoneName="None",HitComponent=none),IsValid=false,ShowDebug=false,Component=none,DamageCauser=none)
        StackIdx=0
        ProcessData[0]=0
        ProcessData[1]=0
        ProcessData[2]=0
        ProcessData[3]=0
        ProcessData[4]=0
        ProcessData[5]=0
        ProcessData[6]=0
        ProcessData[7]=0
        ProcessData[8]=0
        ProcessData[9]=0
        ProcessData[10]=0
        ProcessData[11]=0
        ProcessData[12]=0
        ProcessData[13]=0
        ProcessData[14]=0
        ProcessData[15]=0
        ProcessData[16]=0
        ProcessData[17]=0
        ProcessData[18]=0
        ProcessData[19]=0
        ProcessData[20]=0
        ProcessData[21]=0
        ProcessData[22]=0
        ProcessData[23]=0
        ProcessData[24]=0
        ProcessData[25]=0
        ProcessData[26]=0
        ProcessData[27]=0
        ProcessData[28]=0
        ProcessData[29]=0
        ProcessData[30]=0
        ProcessData[31]=0
        ProcessData[32]=0
        ProcessData[33]=0
        ProcessData[34]=0
        ProcessData[35]=0
        ProcessData[36]=0
        ProcessData[37]=0
        ProcessData[38]=0
        ProcessData[39]=0
        ProcessData[40]=0
        ProcessData[41]=0
        ProcessData[42]=0
        ProcessData[43]=0
        ProcessData[44]=0
        ProcessData[45]=0
        ProcessData[46]=0
        ProcessData[47]=0
        ProcessData[48]=0
        ProcessData[49]=0
        ProcessData[50]=0
        ProcessData[51]=0
        ProcessData[52]=0
        ProcessData[53]=0
        ProcessData[54]=0
        ProcessData[55]=0
        ProcessData[56]=0
        ProcessData[57]=0
        ProcessData[58]=0
        ProcessData[59]=0
        ProcessData[60]=0
        ProcessData[61]=0
        ProcessData[62]=0
        ProcessData[63]=0
        ProcessData[64]=0
        ProcessData[65]=0
        ProcessData[66]=0
        ProcessData[67]=0
        ProcessData[68]=0
        ProcessData[69]=0
        ProcessData[70]=0
        ProcessData[71]=0
        ProcessData[72]=0
        ProcessData[73]=0
        ProcessData[74]=0
        ProcessData[75]=0
        ProcessData[76]=0
        ProcessData[77]=0
        ProcessData[78]=0
        ProcessData[79]=0
        ProcessData[80]=0
        ProcessData[81]=0
        ProcessData[82]=0
        ProcessData[83]=0
        ProcessData[84]=0
        ProcessData[85]=0
        ProcessData[86]=0
        ProcessData[87]=0
        ProcessData[88]=0
        ProcessData[89]=0
        ProcessData[90]=0
        ProcessData[91]=0
        ProcessData[92]=0
        ProcessData[93]=0
        ProcessData[94]=0
        ProcessData[95]=0
        ProcessData[96]=0
        ProcessData[97]=0
        ProcessData[98]=0
        ProcessData[99]=0
        ProcessData[100]=0
        ProcessData[101]=0
        ProcessData[102]=0
        ProcessData[103]=0
        ProcessData[104]=0
        ProcessData[105]=0
        ProcessData[106]=0
        ProcessData[107]=0
        ProcessData[108]=0
        ProcessData[109]=0
        ProcessData[110]=0
        ProcessData[111]=0
        ProcessData[112]=0
        ProcessData[113]=0
        ProcessData[114]=0
        ProcessData[115]=0
        ProcessData[116]=0
        ProcessData[117]=0
        ProcessData[118]=0
        ProcessData[119]=0
        ProcessData[120]=0
        ProcessData[121]=0
        ProcessData[122]=0
        ProcessData[123]=0
        ProcessData[124]=0
        ProcessData[125]=0
        ProcessData[126]=0
        ProcessData[127]=0
    }
};

var SPDestructibleProperties DestructibleProperties;
var Actor DestructibleActor;
var SPDDamage DestructibleDamageInfo;
var int CurProcess;
var array<SPDProcessState> ActiveProcessList;
var array<SPDProcessState> PendingProcessList;
var SPDProcessManager.SPDActionState actionState;
var const class<DamageType> DefaultDamageType;

// Export USPDProcessManager::execGetWorldInfo(FFrame&, void* const)
native static final function WorldInfo GetWorldInfo();

// Export USPDProcessManager::execSPDDamageSetDefault(FFrame&, void* const)
native function SPDDamageSetDefault(out SPDDamage DamageInfo);

// Export USPDProcessManager::execCreateProcess(FFrame&, void* const)
native function CreateProcess(SPDActionList ActionList, Actor Actor, out SPDDamage DamageInfo, optional SPDProcessManager.SPDProcessType ProcessType = 0, optional out float ProcessId);

// Export USPDProcessManager::execActivatePending(FFrame&, void* const)
native function ActivatePending();

// Export USPDProcessManager::execExecuteActiveProcess(FFrame&, void* const)
native function SPDProcessManager.SPDActionState ExecuteActiveProcess(float ElapsedTime);

// Export USPDProcessManager::execPostExecute(FFrame&, void* const)
native function PostExecute();

// Export USPDProcessManager::execAddOnDestructProcess(FFrame&, void* const)
native function AddOnDestructProcess();

// Export USPDProcessManager::execAbortAllProcess(FFrame&, void* const)
native function AbortAllProcess();

// Export USPDProcessManager::execAbortAllProcessForActor(FFrame&, void* const)
native function AbortAllProcessForActor(Actor Actor);

// Export USPDProcessManager::execPushFloat(FFrame&, void* const)
native function PushFloat(float F);

// Export USPDProcessManager::execPushInt(FFrame&, void* const)
native function PushInt(int I);

// Export USPDProcessManager::execPushVector(FFrame&, void* const)
native function PushVector(out Vector V);

// Export USPDProcessManager::execPushObjectRef(FFrame&, void* const)
native function PushObjectRef(Object Object);

// Export USPDProcessManager::execPushBool(FFrame&, void* const)
native function PushBool(bool B);

// Export USPDProcessManager::execPopFloat(FFrame&, void* const)
native function float PopFloat();

// Export USPDProcessManager::execPopInt(FFrame&, void* const)
native function int PopInt();

// Export USPDProcessManager::execPopVector(FFrame&, void* const)
native function Vector PopVector();

// Export USPDProcessManager::execPopObjectRef(FFrame&, void* const)
native function Object PopObjectRef();

// Export USPDProcessManager::execPopBool(FFrame&, void* const)
native function bool PopBool();

// Export USPDProcessManager::execSPSpawn(FFrame&, void* const)
native final function Actor SPSpawn(class<Actor> SpawnClass, optional Actor SpawnOwner, optional name SpawnTag, optional Vector SpawnLocation, optional Rotator SpawnRotation);

static simulated function SPDProcessManager Get(Actor Actor)
{
    local PandoraGRI PGRI;
    local SPDProcessManager ProcessManager;

    PGRI = PandoraGRI(GetWorldInfo().GRI);
    // End:0x28
    if(PGRI == none)
    {
        return none;
    }
    // End:0x4D
    if(PGRI.ActiveSPDProcessManager != none)
    {
        return PGRI.ActiveSPDProcessManager;
    }
    // End:0xA8
    if(Actor == none)
    {
        ProcessManager = PGRI.Spawn(Class'SPDProcessManager');
        PGRI.ActiveSPDProcessManager = ProcessManager;
        ProcessManager.bKillDuringLevelTransition = true;
        return ProcessManager;
    }
    ProcessManager = Actor.Spawn(Class'SPDProcessManager');
    PGRI.ActiveSPDProcessManager = ProcessManager;
    ProcessManager.bKillDuringLevelTransition = true;
    return ProcessManager;
    //return ReturnValue;    
}

function MakeInActive()
{
    local PandoraGRI PGRI;

    PGRI = PandoraGRI(GetWorldInfo().GRI);
    // End:0x28
    if(PGRI == none)
    {
        return;
    }
    // End:0x4E
    if(PGRI.ActiveSPDProcessManager == self)
    {
        PGRI.ActiveSPDProcessManager = none;
    }
    //return;    
}

function bool HasActions(array<SPDActionList> List)
{
    local int Idx;

    Idx = 0;
    J0x07:

    // End:0x40 [Loop If]
    if(Idx < List.Length)
    {
        // End:0x36
        if(List[Idx].HasActions())
        {
            return true;
        }
        Idx++;
        // [Loop Continue]
        goto J0x07;
    }
    return false;
    //return ReturnValue;    
}

function bool AddActionListWithDamageInfo(SPDActionList ActionList, Actor Actor, SPDDamage DamageInfo, optional out float ProcessId)
{
    // End:0x1C
    if(!ActionList.HasActions())
    {
        return false;
    }
    CreateProcess(ActionList, Actor, DamageInfo,, ProcessId);
    return true;
    //return ReturnValue;    
}

event bool AddActionList(SPDActionList ActionList, Actor Actor, optional bool bForceExecute = false, optional out float ProcessId)
{
    local SPDDamage DamageInfo;
    local bool bRetValue;

    // End:0x21
    if(!ActionList.HasActions())
    {
        return false;
    }
    SPDDamageSetDefault(DamageInfo);
    DamageInfo.Location = Actor.Location;
    DamageInfo.Rotation = Actor.Rotation;
    bRetValue = AddActionListWithDamageInfo(ActionList, Actor, DamageInfo, ProcessId);
    // End:0xAC
    if(bForceExecute)
    {
        GotoState('ExecutingDestroy');
    }
    return bRetValue;
    //return ReturnValue;    
}

event bool AddActionListFromKismet(SPDActionList ActionList, Actor Actor, optional out float ProcessId)
{
    // End:0x0E
    if(Actor == none)
    {
        return false;
    }
    AbortAllProcessForActor(Actor);
    return AddActionList(ActionList, Actor, true, ProcessId);
    //return ReturnValue;    
}

singular function AddDestruct(Actor SrcActor, PrimitiveComponent Component, SPDestructibleProperties Props, int Damage, Controller instigatedBy, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    // End:0x29
    if((Props == none) || SrcActor == none)
    {
        GotoState('FinishedDestroy');
        return;
    }
    // End:0x40
    if(!Props.bEnableCommands)
    {
        return;
    }
    DestructibleActor = SrcActor;
    DestructibleProperties = Props;
    SPDDamageSetDefault(DestructibleDamageInfo);
    DestructibleDamageInfo.Location = SrcActor.Location;
    DestructibleDamageInfo.Rotation = SrcActor.Rotation;
    DestructibleDamageInfo.DamageAmount = Damage;
    DestructibleDamageInfo.instigatedBy = instigatedBy;
    DestructibleDamageInfo.HitLocation = HitLocation;
    DestructibleDamageInfo.Momentum = Momentum;
    DestructibleDamageInfo.DamageType = DamageType;
    DestructibleDamageInfo.HitInfo = HitInfo;
    DestructibleDamageInfo.IsValid = true;
    DestructibleDamageInfo.Component = Component;
    DestructibleDamageInfo.DamageCauser = DamageCauser;
    AddOnDestructProcess();
    //return;    
}

function DoDestruct(Actor SrcActor, SPDestructibleProperties Props, int Damage, Controller instigatedBy, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    AddDestruct(SrcActor, none, Props, Damage, instigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    GotoState('ExecutingDestroy');
    //return;    
}

function DoComponentDestruct(Actor SrcActor, PrimitiveComponent Component, SPDestructibleProperties Props, int Damage, Controller instigatedBy, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    AddDestruct(SrcActor, Component, Props, Damage, instigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    GotoState('ExecutingDestroy');
    //return;    
}

event Tick(float ElapsedTime)
{
    //return;    
}

auto state Waiting
{Begin:

    stop;                
}

state ExecutingDestroy
{
    function DoDestruct(Actor SrcActor, SPDestructibleProperties Props, int Damage, Controller instigatedBy, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, TraceHitInfo HitInfo, optional Actor DamageCauser)
    {
        AddDestruct(SrcActor, none, Props, Damage, instigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
        //return;        
    }

    function DoComponentDestruct(Actor SrcActor, PrimitiveComponent Component, SPDestructibleProperties Props, int Damage, Controller instigatedBy, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, TraceHitInfo HitInfo, optional Actor DamageCauser)
    {
        AddDestruct(SrcActor, Component, Props, Damage, instigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
        //return;        
    }

    event Tick(float ElapsedTime)
    {
        ActivatePending();
        actionState = ExecuteActiveProcess(ElapsedTime);
        PostExecute();
        // End:0x5F
        if((int(actionState) == int(1)) && PendingProcessList.Length < 1)
        {
            MakeInActive();
            GotoState('FinishedDestroy');
        }
        //return;        
    }
    stop;    
}

state FinishedDestroy
{Begin:

    MakeInActive();
    DestructibleProperties = none;
    DestructibleActor = none;
    SPDDamageSetDefault(DestructibleDamageInfo);
    Destroy();
    stop;        
}
