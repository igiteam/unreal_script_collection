class SPDAction_SetMaterialParam extends SPDAction_Latent
    native
    editinlinenew
    collapsecategories;

struct native SPDMaterialSwap
{
    var MaterialInterface original;
    var MaterialInstanceConstant Instance;

    structdefaultproperties
    {
        original=none
        Instance=none
    }
};

struct native SPDAction_SetMaterialParamData
{
    var float CurrentAlpha;
    var float totalElapsedTime;
    var SPDMaterialSwap Swap[8];

    structdefaultproperties
    {
        CurrentAlpha=0.0000000
        totalElapsedTime=0.0000000
        Swap[0]=(original=none,Instance=none)
        Swap[1]=(original=none,Instance=none)
        Swap[2]=(original=none,Instance=none)
        Swap[3]=(original=none,Instance=none)
        Swap[4]=(original=none,Instance=none)
        Swap[5]=(original=none,Instance=none)
        Swap[6]=(original=none,Instance=none)
        Swap[7]=(original=none,Instance=none)
    }
};

/** VARIABLE DECLARATIONS */
var(SPDActionMaterialParam) name ParamName;
var(SPDActionMaterialParam) float StartValue;
var(SPDActionMaterialParam) float EndValue;
var(SPDAction) float TimeInSeconds;
var SPDAction_SetMaterialParamData Data;

// Export USPDAction_SetMaterialParam::execPushDataNative(FFrame&, void* const)
native function PushDataNative(SPDProcessManager Manager);

// Export USPDAction_SetMaterialParam::execPopDataNative(FFrame&, void* const)
native function PopDataNative(SPDProcessManager Manager);

function UpdateMaterialInstance()
{
    local int Idx;

    Idx = 0;
    J0x07:

    // End:0xB6 [Loop If]
    if(Idx < 8)
    {
        // End:0x3D
        if(Data.Swap[Idx].original == none)
        {
            // [Explicit Break]
            goto J0xB6;
        }
        // End:0x67
        if(Data.Swap[Idx].Instance == none)
        {
            // [Explicit Break]
            goto J0xB6;
        }
        Data.Swap[Idx].Instance.SetScalarParameterValue(ParamName, Data.CurrentAlpha);
        Idx++;
        // [Loop Continue]
        goto J0x07;
    }
    J0xB6:

    //return;    
}

function CleanupMaterialInstance(Actor Actor)
{
    local int Idx;
    local editinline StaticMeshComponent StaticMesh;
    local editinline SkeletalMeshComponent SkeletalMesh;

    StaticMesh = Actor.GetStaticMeshComponent();
    SkeletalMesh = Actor.GetSkeletalMeshComponent();
    Idx = 0;
    J0x33:

    // End:0x15B [Loop If]
    if(Idx < 8)
    {
        // End:0x69
        if(Data.Swap[Idx].original == none)
        {
            // [Explicit Break]
            goto J0x15B;
        }
        // End:0x93
        if(Data.Swap[Idx].Instance == none)
        {
            // [Explicit Break]
            goto J0x15B;
        }
        // End:0xDB
        if(StaticMesh != none)
        {
            StaticMesh.SetMaterial(Idx, Data.Swap[Idx].original);            
        }
        else
        {
            // End:0x120
            if(SkeletalMesh != none)
            {
                SkeletalMesh.SetMaterial(Idx, Data.Swap[Idx].original);
            }
        }
        Data.Swap[Idx].Instance.SetParent(none);
        Idx++;
        // [Loop Continue]
        goto J0x33;
    }
    J0x15B:

    Idx = 0;
    J0x162:

    // End:0x1BE [Loop If]
    if(Idx < 8)
    {
        Data.Swap[Idx].original = none;
        Data.Swap[Idx].Instance = none;
        Idx++;
        // [Loop Continue]
        goto J0x162;
    }
    //return;    
}

function MakeStaticMeshMaterialInstances(StaticMeshComponent StaticMesh)
{
    local int Idx;

    Idx = 0;
    Idx = 0;
    J0x0E:

    // End:0x1B0 [Loop If]
    if(Idx < 8)
    {
        Data.Swap[Idx].original = StaticMesh.GetMaterial(Idx);
        // End:0xA2
        if(Data.Swap[Idx].original == none)
        {
            Data.Swap[Idx].Instance = none;
            // [Explicit Break]
            goto J0x1B0;
        }
        Data.Swap[Idx].Instance = new (none) Class'Engine.MaterialInstanceConstant';
        // End:0x11B
        if(Data.Swap[Idx].Instance == none)
        {
            Data.Swap[Idx].original = none;
            // [Explicit Break]
            goto J0x1B0;
        }
        Data.Swap[Idx].Instance.SetParent(Data.Swap[Idx].original);
        StaticMesh.SetMaterial(Idx, Data.Swap[Idx].Instance);
        Idx++;
        // [Loop Continue]
        goto J0x0E;
    }
    J0x1B0:

    UpdateMaterialInstance();
    //return;    
}

function MakeSkeletalMeshMaterialInstances(SkeletalMeshComponent SkeletalMesh)
{
    local int Idx;

    Idx = 0;
    Idx = 0;
    J0x0E:

    // End:0x1B0 [Loop If]
    if(Idx < 8)
    {
        Data.Swap[Idx].original = SkeletalMesh.GetMaterial(Idx);
        // End:0xA2
        if(Data.Swap[Idx].original == none)
        {
            Data.Swap[Idx].Instance = none;
            // [Explicit Break]
            goto J0x1B0;
        }
        Data.Swap[Idx].Instance = new (none) Class'Engine.MaterialInstanceConstant';
        // End:0x11B
        if(Data.Swap[Idx].Instance == none)
        {
            Data.Swap[Idx].original = none;
            // [Explicit Break]
            goto J0x1B0;
        }
        Data.Swap[Idx].Instance.SetParent(Data.Swap[Idx].original);
        SkeletalMesh.SetMaterial(Idx, Data.Swap[Idx].Instance);
        Idx++;
        // [Loop Continue]
        goto J0x0E;
    }
    J0x1B0:

    UpdateMaterialInstance();
    //return;    
}

event SPDProcessManager.SPDActionState Enter(float ElapsedTime, Actor Actor, SPDProcessManager Manager, SPDDamage DamageInfo)
{
    local editinline StaticMeshComponent StaticMesh;
    local editinline SkeletalMeshComponent SkeletalMesh;

    // End:0x16
    if(ParamName == 'None')
    {
        return 1;
    }
    // End:0x28
    if(TimeInSeconds < 0.0010000)
    {
        return 1;
    }
    // End:0x3A
    if(StartValue == EndValue)
    {
        return 1;
    }
    Data.totalElapsedTime = 0.0000000;
    Data.CurrentAlpha = StartValue;
    StaticMesh = Actor.GetStaticMeshComponent();
    // End:0x9C
    if(StaticMesh != none)
    {
        MakeStaticMeshMaterialInstances(StaticMesh);
        return 0;        
    }
    else
    {
        SkeletalMesh = Actor.GetSkeletalMeshComponent();
        // End:0xCF
        if(SkeletalMesh != none)
        {
            MakeSkeletalMeshMaterialInstances(SkeletalMesh);
            return 0;
        }
    }
    return 1;
    //return ReturnValue;    
}

event SPDProcessManager.SPDActionState Run(float ElapsedTime, Actor Actor, SPDProcessManager Manager, SPDDamage DamageInfo)
{
    Data.totalElapsedTime += ElapsedTime;
    // End:0x57
    if(Data.totalElapsedTime >= TimeInSeconds)
    {
        Data.CurrentAlpha = EndValue;
        UpdateMaterialInstance();
        return 1;        
    }
    else
    {
        Data.CurrentAlpha = ((Data.totalElapsedTime / TimeInSeconds) * (EndValue - StartValue)) + StartValue;
    }
    UpdateMaterialInstance();
    return 0;
    //return ReturnValue;    
}

event Exit(Actor Actor, SPDProcessManager Manager, SPDDamage DamageInfo)
{
    Data.CurrentAlpha = EndValue;
    CleanupMaterialInstance(Actor);
    //return;    
}

event Abort(Actor Actor, SPDProcessManager Manager, SPDDamage DamageInfo)
{
    Exit(Actor, Manager, DamageInfo);
    //return;    
}

defaultproperties
{
    TimeInSeconds=0.5000000
    Action="Action Set Material Parameter"
}