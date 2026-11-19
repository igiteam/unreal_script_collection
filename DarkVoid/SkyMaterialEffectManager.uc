class SkyMaterialEffectManager extends Object
    native
    editinlinenew;

enum EMaterialEffectParams
{
    MEP_Health,                     // 0
    MEP_Boost_Activate,             // 1
    MEP_Boost_Deactivate,           // 2
    MEP_MuzzleFlash_Activate,       // 3
    MEP_MuzzleFlash_Deactivate,     // 4
    MEP_RocketPackThrust_Activate,  // 5
    MEP_RocketPackThrust_Deactivate,// 6
    MEP_RocketPackHover_Activate,   // 7
    MEP_RocketPackHover_Deactivate, // 8
    MEP_RocketPackHijackHop_Activate,// 9
    MEP_RocketPackHijackHop_Deactivate,// 10
    MEP_RocketPackLedgeJump_Activate,// 11
    MEP_RocketPackLedgeJump_Deactivate,// 12
    MEP_WeaponHeating_Activate,     // 13
    MEP_WeaponHeating_Deactivate,   // 14
    MEP_MAX                         // 15
};

struct native MaterialEffectTrigger
{
    var() SkyMaterialEffectManager.EMaterialEffectParams ParamType;
    var() name ParamName;
    var() float Threshold;
    var() float TargetValue;
    var() float StartValue;
    var() float InterpolationTime;
    var int ParamIndex;

    structdefaultproperties
    {
        ParamType=MEP_Health
        ParamName="None"
        Threshold=0.0000000
        TargetValue=0.0000000
        StartValue=0.0000000
        InterpolationTime=0.0000000
        ParamIndex=-1
    }
};

struct native MaterialInterpolationInfo
{
    var float TimeRemaining;
    var int TargetIndex;
    var float CurrentValue;

    structdefaultproperties
    {
        TimeRemaining=-1.0000000
        TargetIndex=-1
        CurrentValue=0.0000000
    }
};

var array<MaterialInstanceConstant> MaterialInstances;
var() array<MaterialEffectTrigger> MaterialEffectParams;
var array<MaterialInterpolationInfo> MaterialInterpolation;

simulated function Initialize()
{
    local int I, ParamIndex;
    local array<name> ParamNames;

    I = 0;
    J0x07:

    // End:0xD1 [Loop If]
    if(I < MaterialEffectParams.Length)
    {
        ParamIndex = ParamNames.Find(MaterialEffectParams[I].ParamName);
        // End:0x7E
        if(ParamIndex == -1)
        {
            ParamNames.AddItem(MaterialEffectParams[I].ParamName);
            MaterialInterpolation.Add(1);
            ParamIndex = MaterialInterpolation.Length - 1;
        }
        MaterialEffectParams[I].ParamIndex = ParamIndex;
        MaterialInterpolation[ParamIndex].CurrentValue = MaterialEffectParams[I].StartValue;
        ++I;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

simulated function ReInitialize()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x5F [Loop If]
    if(I < MaterialEffectParams.Length)
    {
        MaterialInterpolation[MaterialEffectParams[I].ParamIndex].CurrentValue = MaterialEffectParams[I].StartValue;
        ++I;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

// Export USkyMaterialEffectManager::execUpdateParams(FFrame&, void* const)
native function UpdateParams(float DeltaTime);

// Export USkyMaterialEffectManager::execActivateHealthEffect(FFrame&, void* const)
native function ActivateHealthEffect(float CurrentHealth);

// Export USkyMaterialEffectManager::execActivateEffect(FFrame&, void* const)
native function ActivateEffect(SkyMaterialEffectManager.EMaterialEffectParams EffectType);
