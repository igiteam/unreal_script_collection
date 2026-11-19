class SkyGameReplicationInfo extends GameReplicationInfo
    native
    config(Game);

enum EFlagState
{
    FLAG_Home,                      // 0
    FLAG_HeldFriendly,              // 1
    FLAG_HeldEnemy,                 // 2
    FLAG_Down,                      // 3
    FLAG_MAX                        // 4
};

struct native ObjectiveFlashDatum
{
    var bool bFlashObjective;
    var bool bAnimatingUp;
    var float Alpha;
    var float Duration;
    var float Age;
    var float Period;

    structdefaultproperties
    {
        bFlashObjective=false
        bAnimatingUp=false
        Alpha=0.0000000
        Duration=0.0000000
        Age=0.0000000
        Period=0.0000000
    }
};

var bool bUseRep;
var bool bShowMessages;
var bool bWarmupRound;
var SkyObjectPool SOP;
var int MinNetPlayers;
var int BotDifficulty;
var transient int NextRoundCountdown;
var transient array<Actor> CurrentObjectives;
var transient array<string> CurrentObjectiveStrings;
var transient array<ObjectiveFlashDatum> CurrentObjectiveFlashData;
var transient string CurrentObjectiveText;
var() Actor SkyPoolTemplate;
var SkyGameReplicationInfo.EFlagState FlagState[2];

replication
{
    // Pos:0x000
    if(int(Role) == int(ROLE_Authority)
        NextRoundCountdown, bShowMessages, 
        bUseRep;

    // Pos:0x00D
    if(bNetInitial && int(Role) == int(ROLE_Authority)
        BotDifficulty, MinNetPlayers;

    // Pos:0x025
    if(int(Role) == int(ROLE_Authority)
        FlagState, bWarmupRound;
}

simulated event PostBeginPlay()
{
    super.PostBeginPlay();
    // End:0x2C
    if(SkyPoolTemplate != none)
    {
        SOP = Spawn(Class'SkyObjectPool', self,,,, SkyPoolTemplate);
    }
    //return;    
}

// Export USkyGameReplicationInfo::execShouldShareEffectRequest(FFrame&, void* const)
native function bool ShouldShareEffectRequest(SkyPlayerController PC, Actor LocalEffect, Vector effectLoc);

// Export USkyGameReplicationInfo::execProjectileRequest(FFrame&, void* const)
native function ProjectileRequest(Projectile localProj, Vector Position, Vector Direction, class<Projectile> ProjectileClass, Pawn Instig, Actor Archetype);

function SetFlagHeldEnemy(int TeamIndex)
{
    FlagState[TeamIndex] = 2;
    //return;    
}

function SetFlagDown(int TeamIndex)
{
    FlagState[TeamIndex] = 3;
    //return;    
}

simulated function Timer()
{
    super.Timer();
    // End:0x3D
    if((int(WorldInfo.NetMode) == int(NM_Client)) && bWarmupRound)
    {
        // End:0x3D
        if(RemainingTime > 0)
        {
            RemainingTime--;
        }
    }
    //return;    
}

simulated function AddPRI(PlayerReplicationInfo PRI)
{
    super.AddPRI(PRI);
    // End:0x3D
    if(int(Role) == int(ROLE_Authority))
    {
        SetCurrentObjective(CurrentObjectives[0]);
        SetCurrentObjectiveText(CurrentObjectiveText);
    }
    //return;    
}

function Reset()
{
    SetCurrentObjective();
    super.Reset();
    //return;    
}

// Export USkyGameReplicationInfo::execAddObjectiveString(FFrame&, void* const)
native function AddObjectiveString(string objectiveString);

event SetCurrentObjective(optional Actor Objective, optional bool bReplace = true, optional string objectiveString)
{
    local int I;
    local SkyPlayerReplicationInfo PRI;
    local Actor outObjective;
    local ObjectiveFlashDatum NewObjectiveFlashEntry;

    // End:0x37
    if(bReplace)
    {
        CurrentObjectives.Remove(0, CurrentObjectives.Length);
        CurrentObjectiveStrings.Remove(0, CurrentObjectiveStrings.Length);
        CurrentObjectiveFlashData.Remove(0, CurrentObjectiveFlashData.Length);
    }
    CurrentObjectives.AddItem(Objective);
    AddObjectiveString(objectiveString);
    NewObjectiveFlashEntry.bFlashObjective = false;
    NewObjectiveFlashEntry.bAnimatingUp = false;
    NewObjectiveFlashEntry.Alpha = 1.0000000;
    NewObjectiveFlashEntry.Duration = 0.0000000;
    NewObjectiveFlashEntry.Age = 0.0000000;
    NewObjectiveFlashEntry.Period = 0.0000000;
    CurrentObjectiveFlashData.AddItem(NewObjectiveFlashEntry);
    I = 0;
    J0xE5:

    // End:0x201 [Loop If]
    if(I < PRIArray.Length)
    {
        PRI = SkyPlayerReplicationInfo(PRIArray[I]);
        // End:0x1F7
        if(PRI != none)
        {
            // End:0x1F7
            if((Controller(PRI.Owner) != none) && PlayerController(PRI.Owner) != none)
            {
                outObjective = Objective;
                // End:0x181
                if(bReplace)
                {
                    PRI.CurrentObjectives.Remove(0, PRI.CurrentObjectives.Length);
                }
                PRI.CurrentObjectives.AddItem(outObjective);
                // End:0x1F7
                if((Controller(PRI.Owner) != none) && Controller(PRI.Owner).IsLocalPlayerController())
                {
                    PRI.ReplicatedEvent('CurrentObjective');
                }
            }
        }
        ++I;
        // [Loop Continue]
        goto J0xE5;
    }
    //return;    
}

event SetCurrentObjectiveText(optional string Text)
{
    local int I;
    local SkyPlayerReplicationInfo PRI;

    I = 0;
    J0x08:

    // End:0x75 [Loop If]
    if(I < PRIArray.Length)
    {
        PRI = SkyPlayerReplicationInfo(PRIArray[I]);
        // End:0x6B
        if(PRI != none)
        {
            PRI.CurrentObjectiveText = Text;
            PRI.ReplicatedEvent('CurrentObjective');
        }
        ++I;
        // [Loop Continue]
        goto J0x08;
    }
    //return;    
}

function ClearObjective(Actor Objective)
{
    local int I, J;
    local SkyPlayerReplicationInfo PRI;

    I = 0;
    J0x07:

    // End:0xA2 [Loop If]
    if(I < PRIArray.Length)
    {
        PRI = SkyPlayerReplicationInfo(PRIArray[I]);
        // End:0x98
        if(PRI != none)
        {
            J = 0;
            J0x3F:

            // End:0x98 [Loop If]
            if(J < PRI.CurrentObjectives.Length)
            {
                // End:0x8E
                if(PRI.CurrentObjectives[J] == Objective)
                {
                    PRI.CurrentObjectives.Remove(J, 1);
                }
                ++J;
                // [Loop Continue]
                goto J0x3F;
            }
        }
        ++I;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

// Export USkyGameReplicationInfo::execFlashObjective(FFrame&, void* const)
native function FlashObjective(Actor ObjectiveActor, float FlashDuration, float FlashPeriod);

// Export USkyGameReplicationInfo::execAnimateFlashingObjectives(FFrame&, void* const)
native function AnimateFlashingObjectives(float DeltaSeconds);
