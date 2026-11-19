class AIDirectorBase extends Actor
    abstract
    native
    notplaceable
    hidecategories(Navigation);

struct native AIDirectorFixedParams
{
    var() float MaximumShootingIntensity;
    var() int MinNumberOfShootingActors;
    var() float MaximumThrowingIntensity;
    var() int MinNumberOfThrowingActors;
    var() float DelayBetweenStartShooting;

    structdefaultproperties
    {
        MaximumShootingIntensity=1.0000000
        MinNumberOfShootingActors=-1
        MaximumThrowingIntensity=0.0000000
        MinNumberOfThrowingActors=1
        DelayBetweenStartShooting=0.2500000
    }
};

struct native AIDirectorParams
{
    var() float DesiredGameIntensity;
    var() float GameIntensityTreshold;
    var() float MinTimeBetweenSpawns;
    var() bool PreferSpawnsInPlayerFOV;
    var() EvilTypes.EAggressionLevel AgrressionLevel;

    structdefaultproperties
    {
        DesiredGameIntensity=1.0000000
        GameIntensityTreshold=0.5000000
        MinTimeBetweenSpawns=2.0000000
        PreferSpawnsInPlayerFOV=true
        AgrressionLevel=EAggressionLevel.AL_High
    }
};

struct native IntensityInfluenceActorInfo
{
    var() EvilPawn IntensityInfluencePawn;
    var() EvilAIController IntensityInfluenceController;
    var() bool bUseOverridenFixedParameters;
    var AIDirectorFixedParams OverridenFixedParameters;

    structdefaultproperties
    {
        IntensityInfluencePawn=none
        IntensityInfluenceController=none
        bUseOverridenFixedParameters=false
        OverridenFixedParameters=(MaximumShootingIntensity=1.0000000,MinNumberOfShootingActors=-1,MaximumThrowingIntensity=0.0000000,MinNumberOfThrowingActors=1,DelayBetweenStartShooting=0.2500000)
    }
};

var float GameIntensity;
var float ScheduledIntensity;
var AIDirectorParams ActualParameters;
var AIDirectorFixedParams FixedParameters;
var protected bool bCanSpawn;
var protected bool bReachedMaxIntensity;
var float UpdateInterval;
var float DamegeModifierScale;
var float MaximumDamegeModifier;
var array<IntensityInfluenceActorInfo> IntensityInfluenceActorInfoList;
var array<IntensityInfluenceActorInfo> IntensityIgnoredActorInfoList;
var array<EvilPawn> Players;
var AIDirectorController_Interface AIDController;
var float LastSpawnTime;
var float LastStartShootTime;
var() export editinline AIBroadcastManager AIBroadcastManager;
var delegate<AIDSpawnDelegate> SpawnDelegateObject;
//var delegate<AIDSpawnDelegate> __AIDSpawnDelegate__Delegate;

delegate bool AIDSpawnDelegate()
{
    //return ReturnValue;    
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    // End:0x39
    if(AIBroadcastManager != none)
    {
        AIBroadcastManager.Activate(self);
    }
    //return;    
}

function UpdateParameters(AIDirectorParams Params)
{
    ActualParameters = Params;
    //return;    
}

function UpdateFixedParameters(AIDirectorFixedParams Params, optional out array<EvilPawn> Targets)
{
    local int I;
    local EvilPawn Target;

    // End:0xC2
    if(Targets.Length > 0)
    {
        // End:0xBE
        foreach Targets(Target)
        {
            I = IntensityInfluenceActorInfoList.Find('IntensityInfluencePawn', Target);            
            // End:0xBD
            if(I != -1)
            {
                IntensityInfluenceActorInfoList[I].OverridenFixedParameters = Params;
                IntensityInfluenceActorInfoList[I].bUseOverridenFixedParameters = true;
            }            
        }                
    }
    else
    {
        I = 0;
        J0xCD:

        // End:0x11C [Loop If]
        if(I < IntensityInfluenceActorInfoList.Length)
        {
            IntensityInfluenceActorInfoList[I].bUseOverridenFixedParameters = false;
            I++;
            // [Loop Continue]
            goto J0xCD;
        }
        FixedParameters = Params;
    }
    //return;    
}

function Activate(AIDirectorController_Interface Controller, AIDirectorParams Params)
{
    AIDController = Controller;
    UpdateParameters(Params);
    bCanSpawn = true;
    bReachedMaxIntensity = false;
    SetTimer(UpdateInterval, true, 'InternalUpdate');
    //return;    
}

function Deactivate()
{
    AIDController = none;
    ClearTimer('InternalUpdate');
    //return;    
}

function SetSpawnDelegate(delegate<AIDSpawnDelegate> spawn_delegate)
{
    SpawnDelegateObject = spawn_delegate;
    //return;    
}

function AddMonitoredPawn(EvilPawn Pawn)
{
    local IntensityInfluenceActorInfo IntActInfo;

    // End:0x3B
    if(Pawn.IsPlayerPawn())
    {
        Players.InsertItem(0, Pawn);        
        return;
    }
    // End:0x63
    if(Pawn.GameIntesityFactor == float(0))
    {
        return;
    }
    IntActInfo.IntensityInfluencePawn = Pawn;
    IntActInfo.IntensityInfluenceController = Pawn.MyEvilAI;
    // End:0x116
    if(Pawn.bSpawnDone)
    {
        IntensityInfluenceActorInfoList.InsertItem(0, IntActInfo);        
        IntensityIgnoredActorInfoList.RemoveItem(IntActInfo);                
    }
    else
    {
        IntensityIgnoredActorInfoList.InsertItem(0, IntActInfo);        
    }
    UpdateGlobalIntensity();
    //return;    
}

function Cleanup()
{
    IntensityInfluenceActorInfoList.Remove(0, IntensityInfluenceActorInfoList.Length);    
    IntensityIgnoredActorInfoList.Remove(0, IntensityIgnoredActorInfoList.Length);    
    //return;    
}

function RemoveMonitoredPawn(EvilPawn Pawn)
{
    local IntensityInfluenceActorInfo IntActInfo;
    local int I;

    // End:0x3B
    if(Pawn.IsPlayerPawn())
    {
        Players.RemoveItem(Pawn);                
    }
    else
    {
        // End:0x9D
        foreach IntensityInfluenceActorInfoList(IntActInfo, I)
        {
            // End:0x9C
            if(IntActInfo.IntensityInfluencePawn == Pawn)
            {
                IntensityInfluenceActorInfoList.Remove(I, 1);                                
            }
            else
            {                
            }
        }        
        // End:0x100
        foreach IntensityIgnoredActorInfoList(IntActInfo, I)
        {
            // End:0xFF
            if(IntActInfo.IntensityInfluencePawn == Pawn)
            {
                IntensityIgnoredActorInfoList.Remove(I, 1);                                
            }
            else
            {                
            }
        }        
    }
    UpdateGlobalIntensity();
    //return;    
}

function bool CanSpawn()
{
    return bCanSpawn;
    //return ReturnValue;    
}

final function InternalUpdate()
{
    UpdateGlobalIntensity();
    UpdateLogic();
    //return;    
}

function UpdateLogic()
{
    // End:0xA6
    if((CanSpawn()) && (WorldInfo.TimeSeconds - LastSpawnTime) > ActualParameters.MinTimeBetweenSpawns)
    {
        // End:0xA6
        if(SpawnDelegateObject != none)
        {
            // End:0xA6
            if(AIDSpawnDelegate())
            {
                LastSpawnTime = WorldInfo.TimeSeconds;
            }
        }
    }
    //return;    
}

function UpdateGlobalIntensity()
{
    local IntensityInfluenceActorInfo IntActInfo;

    GameIntensity = 0.0000000;
    // End:0x84
    foreach IntensityInfluenceActorInfoList(IntActInfo)
    {
        // End:0x83
        if(IntActInfo.IntensityInfluencePawn != none)
        {
            IntActInfo.IntensityInfluencePawn.ModifyGameIntensity(GameIntensity);
        }        
    }    
    GameIntensity = AdjustGameIntensity(GameIntensity);
    // End:0xF6
    if(!bReachedMaxIntensity && GameIntensity > ActualParameters.DesiredGameIntensity)
    {
        MaxIntensityReached();
        bReachedMaxIntensity = true;        
    }
    else
    {
        // End:0x145
        if(bReachedMaxIntensity && GameIntensity <= ActualParameters.GameIntensityTreshold)
        {
            IntensityBelowTreshold();
            bReachedMaxIntensity = false;
        }
    }
    //return;    
}

function MaxIntensityReached()
{
    bCanSpawn = false;
    //return;    
}

function IntensityBelowTreshold()
{
    bCanSpawn = true;
    //return;    
}

function float GetActualThrowingIntensity()
{
    local IntensityInfluenceActorInfo IntActInfo;
    local float sum;

    // End:0xB7
    if(IntensityInfluenceActorInfoList.Length > 0)
    {
        // End:0x9B
        foreach IntensityInfluenceActorInfoList(IntActInfo)
        {
            // End:0x9A
            if((IntActInfo.IntensityInfluencePawn != none) && IntActInfo.IntensityInfluencePawn.bThrowingGrenade)
            {
                sum = sum + 1.0000000;
            }            
        }        
        return sum / float(IntensityInfluenceActorInfoList.Length);        
    }
    else
    {
        return 0.0000000;
    }
    //return ReturnValue;    
}

function float GetActualShootingIntensity()
{
    local IntensityInfluenceActorInfo IntActInfo;
    local float sum;

    // End:0xDB
    if(IntensityInfluenceActorInfoList.Length > 0)
    {
        // End:0xBF
        foreach IntensityInfluenceActorInfoList(IntActInfo)
        {
            // End:0xBE
            if(((IntActInfo.IntensityInfluencePawn != none) && IntActInfo.IntensityInfluenceController != none) && IntActInfo.IntensityInfluenceController.IsFiringAtPlayer())
            {
                sum = sum + 1.0000000;
            }            
        }        
        return sum / float(IntensityInfluenceActorInfoList.Length);        
    }
    else
    {
        return 0.0000000;
    }
    //return ReturnValue;    
}

function bool ReachedThrowingIntensity(EvilAIController Controller)
{
    local float ThrowingIntensity;
    local IntensityInfluenceActorInfo IntActInfo;
    local AIDirectorFixedParams FixParams;

    // End:0xB5
    foreach IntensityInfluenceActorInfoList(IntActInfo)
    {
        // End:0xB4
        if(IntActInfo.IntensityInfluenceController == Controller)
        {
            ThrowingIntensity = GetActualThrowingIntensity();
            // End:0x9E
            if(IntActInfo.bUseOverridenFixedParameters)
            {
                FixParams = IntActInfo.OverridenFixedParameters;                
            }
            else
            {
                FixParams = FixedParameters;
            }            
        }
        else
        {            
        }
    }    
    // End:0x150
    if(((float(FixParams.MinNumberOfThrowingActors) >= 0.0000000) && FCeil(ThrowingIntensity * float(IntensityInfluenceActorInfoList.Length)) >= FixParams.MinNumberOfThrowingActors) && ThrowingIntensity >= FixParams.MaximumThrowingIntensity)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool IsDelayBetweenShootersAchieved()
{
    local bool bResult;

    // End:0x59
    if(WorldInfo.TimeSeconds > (LastStartShootTime + FixedParameters.DelayBetweenStartShooting))
    {
        bResult = true;        
    }
    else
    {
        bResult = false;
    }
    return bResult;
    //return ReturnValue;    
}

function bool ReachedShootingIntensity(EvilAIController Controller)
{
    local float ShootingIntensity;
    local IntensityInfluenceActorInfo IntActInfo;
    local AIDirectorFixedParams FixParams;

    // End:0xB5
    foreach IntensityInfluenceActorInfoList(IntActInfo)
    {
        // End:0xB4
        if(IntActInfo.IntensityInfluenceController == Controller)
        {
            ShootingIntensity = GetActualShootingIntensity();
            // End:0x9E
            if(IntActInfo.bUseOverridenFixedParameters)
            {
                FixParams = IntActInfo.OverridenFixedParameters;                
            }
            else
            {
                FixParams = FixedParameters;
            }            
        }
        else
        {            
        }
    }    
    // End:0x150
    if(((float(FixParams.MinNumberOfShootingActors) >= 0.0000000) && FCeil(ShootingIntensity * float(IntensityInfluenceActorInfoList.Length)) >= FixParams.MinNumberOfShootingActors) && ShootingIntensity >= FixParams.MaximumShootingIntensity)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function EvilPawn FindPlayer()
{
    //return ReturnValue;    
}

function float GetDamageInfluence(EvilPawn DamagedPawn)
{
    //return ReturnValue;    
}

function float AdjustGameIntensity(float origIntensity)
{
    //return ReturnValue;    
}

function bool ValidateAdditionalIntensity(float Intensity)
{
    //return ReturnValue;    
}

function int GetInfluenceActorCount()
{
    return IntensityInfluenceActorInfoList.Length;
    //return ReturnValue;    
}

function CleanDeadActors()
{
    local int I;

    I = IntensityInfluenceActorInfoList.Length - 1;
    J0x17:

    // End:0xA3 [Loop If]
    if(I >= 0)
    {
        // End:0x95
        if((IntensityInfluenceActorInfoList[I].IntensityInfluencePawn == none) || IntensityInfluenceActorInfoList[I].IntensityInfluenceController == none)
        {
            IntensityInfluenceActorInfoList.Remove(I, 1);            
        }
        I--;
        // [Loop Continue]
        goto J0x17;
    }
    //return;    
}

defaultproperties
{
    ActualParameters=(DesiredGameIntensity=1.0000000,GameIntensityTreshold=0.5000000,MinTimeBetweenSpawns=2.0000000,PreferSpawnsInPlayerFOV=true,AgrressionLevel=EAggressionLevel.AL_High)
    FixedParameters=(MaximumShootingIntensity=1.0000000,MinNumberOfShootingActors=-1,MaximumThrowingIntensity=0.0000000,MinNumberOfThrowingActors=1,DelayBetweenStartShooting=0.2500000)
    UpdateInterval=1.0000000
    MaximumDamegeModifier=2.0000000
    LastSpawnTime=-1.0000000
    // Reference: AIBroadcastManager'Default__AIDirectorBase.AIBroadcastManager0'
    begin object name=AIBroadcastManager0 class=Class'AIBroadcastManager'
    end object
    AIBroadcastManager=AIBroadcastManager0
    CollisionType=ECollisionType.COLLIDE_CustomDefault
}