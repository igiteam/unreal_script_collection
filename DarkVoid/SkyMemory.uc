class SkyMemory extends Object
    native;

enum PawnStatus
{
    PawnStatus_Alive,               // 0
    PawnStatus_Dead,                // 1
    PawnStatus_FriendlyAlive,       // 2
    PawnStatus_FriendlyDead,        // 3
    PawnStatus_MAX                  // 4
};

enum TeamMemType
{
    TeamMemType_Follow,             // 0
    TeamMemType_Protect,            // 1
    TeamMemType_Attack,             // 2
    TeamMemType_Defend,             // 3
    TeamMemType_MAX                 // 4
};

enum DisturbanceType
{
    DisturbanceType_None,           // 0
    DisturbanceType_Noise,          // 1
    DisturbanceType_DeadBody,       // 2
    DisturbanceType_DamageCauser,   // 3
    DisturbanceType_FriendFighting, // 4
    DisturbanceType_MAX             // 5
};

struct native Memory
{
    var int MemoryID;
    var float TimeCreated;
    var float LastUpdated;

    structdefaultproperties
    {
        MemoryID=-1
        TimeCreated=0.0000000
        LastUpdated=0.0000000
    }
};

struct native SightMemory extends Memory
{
    var Pawn PawnSeen;
    var float SeenDuration;
    var Vector LastLocation;
    var Vector LastVelocity;
    var SkyMemory.PawnStatus LastStatus;
    var float DamageCausedBy;
    var bool bHaveGodSightFor;
    var float GodSightDuration;
    var bool bIgnoring;
    var float IgnoreDuration;
    var bool bIgnoreWasSetByKismet;

    structdefaultproperties
    {
        MemoryID=0
    }
};

struct native HearingMemory extends Memory
{
    var Vector Location;
    var Actor NoiseMaker;
    var Pawn Originator;
    var float Loudness;

    structdefaultproperties
    {
        MemoryID=0
    }
};

struct native PainMemory extends Memory
{
    var float DamageAmount;
    var Vector Location;
    var Vector Direction;
    var Actor Originator;

    structdefaultproperties
    {
        MemoryID=0
    }
};

struct native TeamMemory extends Memory
{
    var SkyMemory.TeamMemType TeamType;
    var Actor Commander;
    var Actor Target;
    var Vector Position;

    structdefaultproperties
    {
        MemoryID=0
    }
};

var SkyAIController OwnerController;
var int NextMemoryID;
var float MaxGapInSeePawnEvents;
var int MaxHearingMemories;
var int MaxPainMemories;
var float RetainHearingMemoriesDuration;
var protected array<SightMemory> SightMemories;
var protected array<HearingMemory> HearingMemories;
var protected array<PainMemory> PainMemories;
var protected array<TeamMemory> TeamMemories;

// Export USkyMemory::execTick(FFrame&, void* const)
native function Tick(float DeltaTime);

// Export USkyMemory::execFindSightMemoryIdx(FFrame&, void* const)
protected native function int FindSightMemoryIdx(Pawn PawnToFind);

// Export USkyMemory::execFindHearingMemoryIdx(FFrame&, void* const)
protected native function int FindHearingMemoryIdx(Actor NoiseSource);

// Export USkyMemory::execFindPainMemoryIdx(FFrame&, void* const)
protected native function int FindPainMemoryIdx(Actor DamageSource);

// Export USkyMemory::execInitMemory(FFrame&, void* const)
protected native function InitMemory(out Memory NewMemory);

// Export USkyMemory::execHandleSeenPawn(FFrame&, void* const)
native function HandleSeenPawn(Pawn SawPawn);

// Export USkyMemory::execHandleHeardNoise(FFrame&, void* const)
native function HandleHeardNoise(float Loudness, Actor NoiseMaker, name Type);

// Export USkyMemory::execHandleTakeDamage(FFrame&, void* const)
native function HandleTakeDamage(Actor InstigatedBy, Vector HitLocation, int Damage, class<DamageType> DamageType);

// Export USkyMemory::execCalcSoundPriority(FFrame&, void* const)
native final function float CalcSoundPriority(Vector SoundPosition, float Loudness);

// Export USkyMemory::execCanSee(FFrame&, void* const)
native final function bool CanSee(Pawn EnemyTest, float SeenThreshold, optional out SightMemory PawnMemory);

// Export USkyMemory::execGetClosestEnemyBySight(FFrame&, void* const)
native final function Pawn GetClosestEnemyBySight(Vector Location, optional out SightMemory PawnMemory);

// Export USkyMemory::execFindEnemyLocation(FFrame&, void* const)
native final function bool FindEnemyLocation(Pawn EnemyTest, out Vector EnemyLocation);

// Export USkyMemory::execGetClosestDisturbance(FFrame&, void* const)
native final function SkyMemory.DisturbanceType GetClosestDisturbance(Vector CheckLocation, out Vector DisturbanceLoc, optional out int MemoryID, optional out float Time);

// Export USkyMemory::execGetMostRecentDisturbance(FFrame&, void* const)
native final function SkyMemory.DisturbanceType GetMostRecentDisturbance(out Vector DisturbanceLoc, optional out int MemoryID, optional out float Time);

// Export USkyMemory::execGetKnownEnemies(FFrame&, void* const)
native final function GetKnownEnemies(float SeenSinceSeconds, out array<Pawn> KnownEnemies);

// Export USkyMemory::execGetMemoryOf(FFrame&, void* const)
native final function SightMemory GetMemoryOf(Pawn SeenPawn);

// Export USkyMemory::execPurgeMemory(FFrame&, void* const)
native final function bool PurgeMemory(int MemoryID);

// Export USkyMemory::execPurgeMemoriesBefore(FFrame&, void* const)
native final function PurgeMemoriesBefore(float Time);

// Export USkyMemory::execGiveGodSightFor(FFrame&, void* const)
native final function GiveGodSightFor(Pawn PawnToSee, float Duration);

// Export USkyMemory::execCancelGodSightFor(FFrame&, void* const)
native final function CancelGodSightFor(Pawn PawnToSee);

// Export USkyMemory::execSetIgnorePawn(FFrame&, void* const)
native final function SetIgnorePawn(Pawn PawnToIgnore, bool bIgnore, float Duration, bool bIgnoreWasSetByKismet);

// Export USkyMemory::execSetIgnoreAllSeenPawns(FFrame&, void* const)
native final function SetIgnoreAllSeenPawns(bool bIgnore, float Duration);

final function bool IsIgnoring(Pawn CheckPawn)
{
    local SightMemory MemOfPawn;

    MemOfPawn = GetMemoryOf(CheckPawn);
    return (MemOfPawn.PawnSeen == CheckPawn) && MemOfPawn.bIgnoring;
    //return ReturnValue;    
}

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
    local Canvas Canvas;
    local int Idx;
    local float DrawR, DrawG, DrawB, Scale;
    local Vector ScreenLoc, DebugLoc;
    local SightMemory SM;
    local HearingMemory HM;
    local PainMemory PM;
    local string IgnoreTxt;

    Canvas = HUD.Canvas;
    Canvas.SetDrawColor(255, 255, 255);
    ScreenLoc.X = Canvas.CurX;
    ScreenLoc.Y = Canvas.CurY + float(25);
    Canvas.SetPos(ScreenLoc.X, ScreenLoc.Y);
    Canvas.DrawTextClipped("-MEMORIES-");
    ScreenLoc.Y += out_YL;
    Canvas.SetPos(ScreenLoc.X, ScreenLoc.Y);
    Canvas.DrawTextClipped("SightMemories: " $ string(SightMemories.Length));
    Idx = 0;
    J0x13F:

    // End:0x691 [Loop If]
    if(Idx < SightMemories.Length)
    {
        SM = SightMemories[Idx];
        // End:0x390
        if(SM.SeenDuration > float(0))
        {
            // End:0x1BB
            if(SM.bIgnoring)
            {
                Canvas.SetDrawColor(200, 200, 150);
                IgnoreTxt = "<<IGNORING>>:";                
            }
            else
            {
                Canvas.SetDrawColor(255, 255, 255);
                IgnoreTxt = "";
            }
            ScreenLoc.Y += out_YL;
            Canvas.SetPos(ScreenLoc.X + float(5), ScreenLoc.Y);
            Canvas.DrawTextClipped((((((((((("(" $ string(Idx)) $ ")") @ IgnoreTxt) $ string(SM.PawnSeen)) @ "Type:") $ string(GetEnum(Enum'SkyMemory.PawnStatus', int(SM.LastStatus)))) $ ", hurt us=") $ string(SM.DamageCausedBy)) $ ", seen for") @ string(SM.SeenDuration)) @ "seconds.");
            DebugLoc = HUD.Canvas.Project(SM.LastLocation);
            Canvas.SetPos(DebugLoc.X, DebugLoc.Y - float(10));
            Canvas.DrawTextClipped((string(SM.PawnSeen) @ "seen for") @ string(SM.SeenDuration));            
        }
        else
        {
            // End:0x3D3
            if(SM.bIgnoring)
            {
                Canvas.SetDrawColor(200, 200, 150);
                IgnoreTxt = "<<IGNORING>>:";                
            }
            else
            {
                Canvas.SetDrawColor(255, 200, 200);
                IgnoreTxt = "";
            }
            ScreenLoc.Y += out_YL;
            Canvas.SetPos(ScreenLoc.X + float(5), ScreenLoc.Y);
            Canvas.DrawTextClipped((((((((((("(" $ string(Idx)) $ ")") @ IgnoreTxt) $ string(SM.PawnSeen)) @ "Type:") $ string(GetEnum(Enum'SkyMemory.PawnStatus', int(SM.LastStatus)))) $ ", hurt us=") $ string(SM.DamageCausedBy)) $ ", last seen @") @ string(SM.LastUpdated)) @ "seconds.");
            OwnerController.DrawDebugSphere(SM.LastLocation, 32.0000000, 4, 255, 200, 200);
            OwnerController.DrawDebugLine(SM.LastLocation, SM.LastLocation + SM.LastVelocity, 255, 200, 200);
            DebugLoc = HUD.Canvas.Project(SM.LastLocation);
            Canvas.SetPos(DebugLoc.X, DebugLoc.Y - float(10));
            Canvas.DrawTextClipped((((string(OwnerController.Name) @ ": Saw") @ string(SM.PawnSeen)) @ "@") @ string(SM.LastUpdated));
        }
        // End:0x687
        if(FindEnemyLocation(SM.PawnSeen, DebugLoc))
        {
            OwnerController.DrawDebugLine(OwnerController.Pawn.Location, DebugLoc, 255, 0, 0);
        }
        ++Idx;
        // [Loop Continue]
        goto J0x13F;
    }
    Canvas.SetDrawColor(255, 255, 255);
    ScreenLoc.Y += out_YL;
    Canvas.SetPos(ScreenLoc.X, ScreenLoc.Y);
    Canvas.DrawTextClipped("HearingMemories: " $ string(HearingMemories.Length));
    Idx = 0;
    J0x727:

    // End:0x9E4 [Loop If]
    if(Idx < HearingMemories.Length)
    {
        HM = HearingMemories[Idx];
        DrawR = 200.0000000;
        DrawG = 200.0000000 + ((55.0000000 * float(Idx)) / (float(MaxHearingMemories) - 1.0000000));
        DrawB = 455.0000000 - DrawG;
        Canvas.SetDrawColor(byte(DrawR), byte(DrawG), byte(DrawB));
        Scale = CalcSoundPriority(HM.Location, HM.Loudness);
        ScreenLoc.Y += out_YL;
        Canvas.SetPos(ScreenLoc.X + float(5), ScreenLoc.Y);
        Canvas.DrawTextClipped(((((((((("(" $ string(Idx)) $ ")") @ string(HM.NoiseMaker)) @ "[Created by") @ string(HM.Originator)) @ "] with priority") @ string(Scale)) @ ", heard @") @ string(HM.LastUpdated)) @ "seconds");
        OwnerController.DrawDebugSphere(HM.Location, 64.0000000 * Scale, 8, byte(DrawR), byte(DrawG), byte(DrawB));
        DebugLoc = HUD.Canvas.Project(HM.Location);
        Canvas.SetPos(DebugLoc.X, DebugLoc.Y - float(10));
        Canvas.DrawTextClipped((((string(OwnerController.Name) @ ": Heard") @ string(HM.NoiseMaker)) @ "@") @ string(SM.LastUpdated));
        ++Idx;
        // [Loop Continue]
        goto J0x727;
    }
    Canvas.SetDrawColor(255, 255, 255);
    ScreenLoc.Y += out_YL;
    Canvas.SetPos(ScreenLoc.X, ScreenLoc.Y);
    Canvas.DrawTextClipped("PainMemories: " $ string(PainMemories.Length));
    Idx = 0;
    J0xA77:

    // End:0xD70 [Loop If]
    if(Idx < PainMemories.Length)
    {
        PM = PainMemories[Idx];
        DrawR = 255.0000000 - ((55.0000000 * float(Idx)) / (float(MaxPainMemories) - 1.0000000));
        DrawG = 455.0000000 - DrawR;
        DrawB = 200.0000000;
        Canvas.SetDrawColor(byte(DrawR), byte(DrawG), byte(DrawB));
        ScreenLoc.Y += out_YL;
        Canvas.SetPos(ScreenLoc.X + float(5), ScreenLoc.Y);
        Canvas.DrawTextClipped(((((((("(" $ string(Idx)) $ ")") @ string(PM.Originator)) @ "caused damage") @ string(PM.DamageAmount)) @ ", @") @ string(PM.LastUpdated)) @ "seconds");
        OwnerController.DrawDebugCylinder(PM.Location, PM.Location + vect(0.0000000, 0.0000000, 30.0000000), PM.DamageAmount + 32.0000000, 4, byte(DrawR), byte(DrawG), byte(DrawB));
        OwnerController.DrawDebugLine(PM.Location, PM.Location + (PM.Direction * float(200)), byte(DrawR), byte(DrawG), byte(DrawB));
        DebugLoc = HUD.Canvas.Project(PM.Location);
        Canvas.SetPos(DebugLoc.X, DebugLoc.Y - float(10));
        Canvas.DrawTextClipped((((string(OwnerController.Name) @ ": HitBy") @ string(PM.Originator)) @ "@") @ string(SM.LastUpdated));
        ++Idx;
        // [Loop Continue]
        goto J0xA77;
    }
    //return;    
}

final function Vector GetLastDamageDirection()
{
    local int PainIdx;
    local float MostRecentTime;
    local Vector Result;
    local PainMemory PM;

    MostRecentTime = -1.0000000;
    PainIdx = 0;
    J0x12:

    // End:0x83 [Loop If]
    if(PainIdx < PainMemories.Length)
    {
        PM = PainMemories[PainIdx];
        // End:0x79
        if(PM.LastUpdated > MostRecentTime)
        {
            Result = PM.Direction;
            MostRecentTime = PM.LastUpdated;
        }
        ++PainIdx;
        // [Loop Continue]
        goto J0x12;
    }
    return Result;
    //return ReturnValue;    
}

// Export USkyMemory::execGetBiggestThreatEnemy(FFrame&, void* const)
native final function Pawn GetBiggestThreatEnemy(bool bMustBeVisible, optional Pawn PreviousEnemy);

final function bool IsFriendlyInLineOfFire(Actor TargetActor, float FOVCosHalfAngle)
{
    local int Idx;
    local SightMemory SM;
    local Vector ToFriendly;
    local float ToEnemyDistSq;

    ToEnemyDistSq = VSizeSq(TargetActor.Location - OwnerController.Pawn.Location);
    Idx = 0;
    J0x3D:

    // End:0x184 [Loop If]
    if(Idx < SightMemories.Length)
    {
        SM = SightMemories[Idx];
        // End:0x17A
        if((((int(SM.LastStatus) == int(2)) && SM.SeenDuration > 0.0000000) && SM.PawnSeen != none) && !SM.PawnSeen.IsInteracting())
        {
            // End:0xF9
            if(SM.PawnSeen.IsA('SkyPawn_Slug'))
            {
                // [Explicit Continue]
                goto J0x17A;
            }
            ToFriendly = SM.PawnSeen.Location - OwnerController.Pawn.Location;
            // End:0x17A
            if(VSizeSq(ToFriendly) < ToEnemyDistSq)
            {
                ToFriendly = Normal(ToFriendly);
                // End:0x17A
                if((ToFriendly Dot Vector(OwnerController.Rotation)) > FOVCosHalfAngle)
                {
                    return true;
                }
            }
        }
        J0x17A:

        ++Idx;
        // [Loop Continue]
        goto J0x3D;
    }
    return false;
    //return ReturnValue;    
}
