class AIDirectorBase extends Actor
    abstract
    native
    notplaceable
    hidecategories(Navigation);

struct native AIDirectorFixedParams
{
    var() float MaximumShootingIntensity;
    var() int MinNumberOfShootingActors;

    structdefaultproperties
    {
        MaximumShootingIntensity=1.0000000
        MinNumberOfShootingActors=-1
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

    structdefaultproperties
    {
        IntensityInfluencePawn=none
        IntensityInfluenceController=none
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
var array<EvilPawn> Players;
var AIDirectorController_Interface AIDController;
var float LastSpawnTime;
var delegate<AIDSpawnDelegate> SpawnDelegateObject;
//var delegate<AIDSpawnDelegate> __AIDSpawnDelegate__Delegate;

delegate bool AIDSpawnDelegate()
{
    //return ReturnValue;    
}

function UpdateParameters(AIDirectorParams Params)
{
    ActualParameters = Params;
    //return;    
}

function UpdateFixedParameters(AIDirectorFixedParams Params)
{
    FixedParameters = Params;
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
    IntensityInfluenceActorInfoList.InsertItem(0, IntActInfo);
    UpdateGlobalIntensity();
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
    // End:0x62
    foreach IntensityInfluenceActorInfoList(IntActInfo)
    {
        IntActInfo.IntensityInfluencePawn.ModifyGameIntensity(GameIntensity);        
    }    
    GameIntensity = AdjustGameIntensity(GameIntensity);
    // End:0xD4
    if(!bReachedMaxIntensity && GameIntensity > ActualParameters.DesiredGameIntensity)
    {
        MaxIntensityReached();
        bReachedMaxIntensity = true;        
    }
    else
    {
        // End:0x123
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

function float GetActualShootingIntensity()
{
    local IntensityInfluenceActorInfo IntActInfo;
    local float sum;

    // End:0x112
    if(IntensityInfluenceActorInfoList.Length > 0)
    {
        // End:0xF6
        foreach IntensityInfluenceActorInfoList(IntActInfo)
        {
            // End:0xF5
            if(((IntActInfo.IntensityInfluencePawn != none) && IntActInfo.IntensityInfluencePawn.IsFiring()) || (IntActInfo.IntensityInfluenceController != none) && IntActInfo.IntensityInfluenceController.IsFiring())
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

function bool ReachedShootingIntensity(EvilAIController Controller)
{
    local float ShootingIntensity;
    local IntensityInfluenceActorInfo IntActInfo;

    // End:0x56
    foreach IntensityInfluenceActorInfoList(IntActInfo)
    {
        // End:0x55
        if(IntActInfo.IntensityInfluenceController == Controller)
        {
            ShootingIntensity = GetActualShootingIntensity();
        }        
    }    
    // End:0xE9
    if(((float(FixedParameters.MinNumberOfShootingActors) >= 0.0000000) && (ShootingIntensity * float(IntensityInfluenceActorInfoList.Length)) >= float(FixedParameters.MinNumberOfShootingActors)) && ShootingIntensity >= FixedParameters.MaximumShootingIntensity)
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

defaultproperties
{
    ActualParameters=(DesiredGameIntensity=1.0000000,GameIntensityTreshold=0.5000000,MinTimeBetweenSpawns=2.0000000,PreferSpawnsInPlayerFOV=true,AgrressionLevel=EAggressionLevel.AL_High)
    FixedParameters=(MaximumShootingIntensity=1.0000000,MinNumberOfShootingActors=-1)
    UpdateInterval=1.0000000
    MaximumDamegeModifier=2.0000000
    LastSpawnTime=-1.0000000
    CollisionType=ECollisionType.COLLIDE_CustomDefault
}