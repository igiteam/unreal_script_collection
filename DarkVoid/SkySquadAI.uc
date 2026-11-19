class SkySquadAI extends ReplicationInfo
    native;

struct native s_IgnoreTarget
{
    var Pawn IgnoreTarget;
    var float ExpireTime;
    var bool bIgnoreWasSetByKismet;

    structdefaultproperties
    {
        IgnoreTarget=none
        ExpireTime=0.0000000
        bIgnoreWasSetByKismet=false
    }
};

var SkyTeamInfo Team;
var Controller SquadLeader;
var SkySquadAI NextSquad;
var int Size;
var SkyBotControllerBase SquadMembers;
var Actor Enemies[8];
var int MaxSquadSize;
var array<s_IgnoreTarget> IgnoreTargets;

// Export USkySquadAI::execValidEnemy(FFrame&, void* const)
native final function bool ValidEnemy(Actor newEnemy);

// Export USkySquadAI::execFriendlyToward(FFrame&, void* const)
native final function bool FriendlyToward(Actor Other);

simulated function byte GetTeamNum()
{
    return byte(((Team != none) ? Team.TeamIndex : 255));
    //return ReturnValue;    
}

function Reset()
{
    local int I;

    super(Actor).Reset();
    I = 0;
    J0x0D:

    // End:0x30 [Loop If]
    if(I < 8)
    {
        Enemies[I] = none;
        I++;
        // [Loop Continue]
        goto J0x0D;
    }
    //return;    
}

function Destroyed()
{
    // End:0x2A
    if(Team != none)
    {
        Team.AI.RemoveSquad(self);
    }
    super(Actor).Destroyed();
    //return;    
}

simulated function HandleEnemySwitchedPawn(Pawn OldPawn, Pawn NewPawn)
{
    local SkyBotControllerBase M;

    SetIgnorePawn(NewPawn, false, -1.0000000, false);
    // End:0xB0
    if(ValidEnemy(NewPawn) == true)
    {
        M = SquadMembers;
        J0x32:

        // End:0xA1 [Loop If]
        if(M != none)
        {
            // End:0x6B
            if(M.Enemy == OldPawn)
            {
                M.Enemy = NewPawn;
            }
            M.HandleEnemySwitchedPawn(OldPawn, NewPawn);
            M = M.NextSquadMember;
            // [Loop Continue]
            goto J0x32;
        }
        AddEnemy(NewPawn);
    }
    SetIgnorePawn(OldPawn, true, -1.0000000, false);
    //return;    
}

function bool LostEnemy(SkyBotControllerBase B)
{
    local Actor Lost;
    local bool bFound;
    local SkyBotControllerBase M;

    // End:0xC1
    if(B.Enemy.bDeleteMe || ((Pawn(B.Enemy) != none) && Pawn(B.Enemy).Health <= 0) || Pawn(B.Enemy).Controller == none)
    {
        B.Enemy = none;
        RemoveEnemy(B.Enemy);
        FindNewEnemyFor(B, false);
        return true;
    }
    // End:0xDF
    if(MustKeepEnemy(B.Enemy))
    {
        return false;
    }
    Lost = B.Enemy;
    B.Enemy = none;
    M = SquadMembers;
    J0x110:

    // End:0x188 [Loop If]
    if(M != none)
    {
        // End:0x170
        if(((M != B) && M.Enemy == Lost) && !M.LostContact(5.0000000))
        {
            bFound = true;
            // [Explicit Break]
            goto J0x188;
        }
        M = M.NextSquadMember;
        // [Loop Continue]
        goto J0x110;
    }
    J0x188:

    // End:0x1A9
    if(bFound)
    {
        B.Enemy = Lost;        
    }
    else
    {
        RemoveEnemy(Lost);
        FindNewEnemyFor(B, false);
    }
    return B.Enemy != Lost;
    //return ReturnValue;    
}

function bool AddEnemy(Actor newEnemy)
{
    local int I;
    local SkyBotControllerBase M;
    local bool bCurrentEnemy;

    I = 0;
    J0x07:

    // End:0x34 [Loop If]
    if(I < 8)
    {
        // End:0x2A
        if(Enemies[I] == newEnemy)
        {
            return false;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    I = 0;
    J0x3B:

    // End:0x10D [Loop If]
    if(I < 8)
    {
        // End:0x103
        if(Enemies[I] == none)
        {
            Enemies[I] = newEnemy;
            // End:0xD6
            if(((SkyAirVehicle_UFO(newEnemy) != none) && int(newEnemy.GetTeamNum()) != int(0)) && FRand() > 0.5000000)
            {
                SkyBotControllerPilot(SquadMembers).PlayPilotChatter(5, SkyBotControllerPilot(SquadMembers).TeamNum);                
            }
            else
            {
                SkyBotControllerPilot(SquadMembers).PlayPilotChatter(1, SkyBotControllerPilot(SquadMembers).TeamNum);
            }
            return true;
        }
        I++;
        // [Loop Continue]
        goto J0x3B;
    }
    I = 0;
    J0x114:

    // End:0x240 [Loop If]
    if(I < 8)
    {
        bCurrentEnemy = false;
        M = SquadMembers;
        J0x133:

        // End:0x180 [Loop If]
        if(M != none)
        {
            // End:0x168
            if(M.Enemy == Enemies[I])
            {
                bCurrentEnemy = true;
                // [Explicit Break]
                goto J0x180;
            }
            M = M.NextSquadMember;
            // [Loop Continue]
            goto J0x133;
        }
        J0x180:

        // End:0x236
        if(!bCurrentEnemy)
        {
            Enemies[I] = newEnemy;
            // End:0x209
            if(((SkyAirVehicle_UFO(newEnemy) != none) && int(newEnemy.GetTeamNum()) != int(0)) && FRand() > 0.5000000)
            {
                SkyBotControllerPilot(SquadMembers).PlayPilotChatter(5, SkyBotControllerPilot(SquadMembers).TeamNum);                
            }
            else
            {
                SkyBotControllerPilot(SquadMembers).PlayPilotChatter(1, SkyBotControllerPilot(SquadMembers).TeamNum);
            }
            return true;
        }
        I++;
        // [Loop Continue]
        goto J0x114;
    }
    return false;
    //return ReturnValue;    
}

simulated function SetIgnorePawn(Pawn PawnToIgnore, bool bIgnore, float Duration, bool bIgnoreWasSetByKismet)
{
    local s_IgnoreTarget iTarget;
    local int Index;

    Index = IgnoreTargets.Find('IgnoreTarget', PawnToIgnore);
    // End:0x199
    if(bIgnore)
    {
        iTarget.IgnoreTarget = PawnToIgnore;
        // End:0x63
        if(Duration <= 0.0000000)
        {
            iTarget.ExpireTime = -1.0000000;            
        }
        else
        {
            iTarget.ExpireTime = WorldInfo.TimeSeconds + Duration;
        }
        // End:0xC1
        if(Index == -1)
        {
            iTarget.bIgnoreWasSetByKismet = bIgnoreWasSetByKismet;
            IgnoreTargets.AddItem(iTarget);            
        }
        else
        {
            // End:0x142
            if((IgnoreTargets[Index].bIgnoreWasSetByKismet == false) || bIgnoreWasSetByKismet == true)
            {
                IgnoreTargets[Index].bIgnoreWasSetByKismet = iTarget.bIgnoreWasSetByKismet;
                IgnoreTargets[Index].ExpireTime = WorldInfo.TimeSeconds + Duration;
            }
        }
        RemoveEnemy(PawnToIgnore);
        // End:0x196
        if(iTarget.ExpireTime != float(-1))
        {
            // End:0x196
            if(IsTimerActive('CheckIgnoreTargetsExpired') == false)
            {
                SetTimer(5.0000000, true, 'CheckIgnoreTargetsExpired');
            }
        }        
    }
    else
    {
        // End:0x1DF
        if(Index != -1)
        {
            // End:0x1DF
            if((IgnoreTargets[Index].bIgnoreWasSetByKismet == false) || bIgnoreWasSetByKismet == true)
            {
                IgnoreTargets.Remove(Index, 1);
            }
        }
    }
    //return;    
}

simulated function CheckIgnoreTargetsExpired()
{
    local int Index;

    Index = 0;
    J0x07:

    // End:0xA0 [Loop If]
    if(Index < IgnoreTargets.Length)
    {
        // End:0x96
        if((IgnoreTargets[Index].IgnoreTarget == none) || (IgnoreTargets[Index].ExpireTime != float(-1)) && WorldInfo.TimeSeconds >= IgnoreTargets[Index].ExpireTime)
        {
            IgnoreTargets.Remove(Index, 1);
            Index--;
        }
        Index++;
        // [Loop Continue]
        goto J0x07;
    }
    // End:0xD2
    if(IgnoreTargets.Length == 0)
    {
        // End:0xD2
        if(IsTimerActive('CheckIgnoreTargetsExpired') == true)
        {
            ClearTimer('CheckIgnoreTargetsExpired');
        }
    }
    //return;    
}

function bool SetEnemy(SkyBotControllerBase B, Actor newEnemy)
{
    local bool bResult;

    // End:0x1B
    if(newEnemy == B.Enemy)
    {
        return false;
    }
    // End:0x2D
    if(!ValidEnemy(newEnemy))
    {
        return false;
    }
    AddEnemy(newEnemy);
    bResult = FindNewEnemyFor(B, false);
    // End:0x96
    if(bResult && B.Enemy == newEnemy)
    {
        B.AcquireTime = WorldInfo.TimeSeconds;
    }
    return bResult;
    //return ReturnValue;    
}

function RemoveEnemy(Actor E)
{
    local SkyBotControllerBase B;
    local int I;

    I = 0;
    J0x07:

    // End:0x3F [Loop If]
    if(I < 8)
    {
        // End:0x35
        if(Enemies[I] == E)
        {
            Enemies[I] = none;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    // End:0x5E
    if(WorldInfo.Game.bGameEnded)
    {
        return;
    }
    B = SquadMembers;
    J0x69:

    // End:0x18D [Loop If]
    if(B != none)
    {
        // End:0x175
        if(B.Enemy == E)
        {
            B.Enemy = none;
            FindNewEnemyFor(B, false);
            // End:0x175
            if(((B.Pawn != none) && B.Enemy == none) && !B.bIgnoreEnemyChange)
            {
                // End:0x161
                if((B.InLatentExecution(B.503) && NavigationPoint(B.MoveTarget) != none) && !B.bPreparingMove)
                {
                    B.GotoState('FlyingRangedAttack');                    
                }
                else
                {
                    B.WhatToDoNext();
                }
            }
        }
        B = B.NextSquadMember;
        // [Loop Continue]
        goto J0x69;
    }
    //return;    
}

function bool IsOnSquad(Controller C)
{
    // End:0x28
    if(SkyBotControllerBase(C) != none)
    {
        return SkyBotControllerBase(C).Squad == self;
    }
    return C == SquadLeader;
    //return ReturnValue;    
}

function NotifyKilled(Controller Killer, Controller Killed, Pawn KilledPawn)
{
    // End:0x0D
    if(Killed == none)
    {
        return;
    }
    // End:0x56
    if(((Team != none) && Killed.PlayerReplicationInfo != none) && Killed.PlayerReplicationInfo.Team == Team)
    {
        return;
    }
    RemoveEnemy(KilledPawn);
    //return;    
}

function float AssessThreat(SkyBotControllerBase B, Actor NewThreat, bool bThreatVisible)
{
    local float ThreatValue;
    local bool bIsAPriority;

    ThreatValue = 0.0000000;
    // End:0x25
    if(ValidEnemy(NewThreat) == false)
    {
        return ThreatValue;        
    }
    else
    {
        ThreatValue += 0.1000000;
    }
    // End:0x68
    if((B.bLockedEnemy == true) && B.LockedEnemy == NewThreat)
    {
        return 100000.0000000;
    }
    // End:0x16C
    if((SkyGame(WorldInfo.Game) != none) && SkyGame(WorldInfo.Game).RivalInfo != none)
    {
        bIsAPriority = SkyGame(WorldInfo.Game).RivalInfo.IsTeamARival(B.Pawn.GangName, NewThreat.GangName);
        // End:0x16C
        if(bIsAPriority == true)
        {
            ThreatValue += SkyGame(WorldInfo.Game).RivalInfo.GetEnemyRivalThreatMultiplier(B.Pawn.GangName, NewThreat.GangName);
        }
    }
    // End:0x191
    if(NewThreat == B.LastDamageCauser)
    {
        ThreatValue += 1.0000000;
    }
    // End:0x1D7
    if((B.EnemyWithThreatBonusDecay != none) && NewThreat == B.EnemyWithThreatBonusDecay)
    {
        ThreatValue += B.EnemyThreatBonusAmount;
    }
    // End:0x1EC
    if(bThreatVisible)
    {
        ThreatValue += 1.0000000;
    }
    // End:0x277
    if((NewThreat != B.Enemy) && B.Enemy != none)
    {
        // End:0x236
        if(!bThreatVisible)
        {
            ThreatValue -= 5.0000000;            
        }
        else
        {
            // End:0x26B
            if((WorldInfo.TimeSeconds - B.LastSeenTime) > float(2))
            {
                ThreatValue += 1.0000000;
            }
        }
        ThreatValue -= 0.2000000;
    }
    // End:0x2AD
    if((Pawn(NewThreat) != none) && Pawn(NewThreat).IsHumanControlled())
    {
        ThreatValue += 0.2500000;
    }
    return ThreatValue;
    //return ReturnValue;    
}

function Initialize(SkyTeamInfo T, Controller C)
{
    Team = T;
    SetLeader(C);
    Team.TeamIndex = int(C.GetTeamNum());
    SetTeamNum(byte(Team.TeamIndex));
    //return;    
}

event SetLeader(Controller C)
{
    SquadLeader = C;
    // End:0x2F
    if(SkyBotControllerBase(C) != none)
    {
        AddBot(SkyBotControllerBase(C));
    }
    //return;    
}

function RemovePlayer(PlayerController P)
{
    // End:0x11
    if(SquadLeader != P)
    {
        return;
    }
    // End:0x21
    if(SquadMembers == none)
    {
        Destroy();
        return;
    }
    PickNewLeader();
    //return;    
}

function RemoveBot(SkyBotControllerBase B)
{
    local SkyBotControllerBase Prev;

    // End:0x17
    if(B.Squad != self)
    {
        return;
    }
    B.Squad = none;
    Size--;
    // End:0x66
    if(SquadMembers == B)
    {
        SquadMembers = B.NextSquadMember;
        // End:0x63
        if(SquadMembers == none)
        {
            Destroy();
            return;
        }        
    }
    else
    {
        Prev = SquadMembers;
        J0x71:

        // End:0xCF [Loop If]
        if(Prev != none)
        {
            // End:0xB7
            if(Prev.NextSquadMember == B)
            {
                Prev.NextSquadMember = B.NextSquadMember;
                // [Explicit Break]
                goto J0xCF;
            }
            Prev = Prev.NextSquadMember;
            // [Loop Continue]
            goto J0x71;
        }
    }
    J0xCF:

    // End:0xE8
    if(SquadLeader == B)
    {
        PickNewLeader();
    }
    //return;    
}

function AddBot(SkyBotControllerBase B)
{
    // End:0x17
    if(B.Squad == self)
    {
        return;
    }
    // End:0x4F
    if(B.Squad != none)
    {
        B.Squad.RemoveBot(B);
    }
    Size++;
    B.NextSquadMember = SquadMembers;
    SquadMembers = B;
    B.Squad = self;
    //return;    
}

function int GetSize()
{
    // End:0x1C
    if(PlayerController(SquadLeader) != none)
    {
        return Size + 1;        
    }
    else
    {
        return Size;
    }
    //return ReturnValue;    
}

function PickNewLeader()
{
    local SkyBotControllerBase B;

    B = SquadMembers;
    J0x0B:

    // End:0xAE [Loop If]
    if(B != none)
    {
        // End:0x96
        if(!B.PlayerReplicationInfo.bOutOfLives && ((B.Pawn == none) || !B.Pawn.bStationary) || B.Pawn.GetVehicleBase() == none)
        {
            // [Explicit Break]
            goto J0xAE;
        }
        B = B.NextSquadMember;
        // [Loop Continue]
        goto J0x0B;
    }
    J0xAE:

    // End:0x109
    if(B == none)
    {
        B = SquadMembers;
        J0xC4:

        // End:0x109 [Loop If]
        if(B != none)
        {
            // End:0xF1
            if(!B.PlayerReplicationInfo.bOutOfLives)
            {
                // [Explicit Break]
                goto J0x109;
            }
            B = B.NextSquadMember;
            // [Loop Continue]
            goto J0xC4;
        }
    }
    J0x109:

    // End:0x123
    if(SquadLeader != B)
    {
        SquadLeader = B;
    }
    //return;    
}

function float MaxVehicleDist(Pawn P)
{
    return 3000.0000000;
    //return ReturnValue;    
}

function bool NeverBail(Pawn P)
{
    return (SkyVehicle(P) != none) && SkyVehicle(P).bKeyVehicle;
    //return ReturnValue;    
}

function BotEnteredVehicle(SkyBotControllerBase B)
{
    //return;    
}

simulated function DisplayDebug(HUD HUD, out float YL, out float YPos)
{
    local string EnemyList;
    local int I;
    local Canvas Canvas;

    Canvas = HUD.Canvas;
    Canvas.SetDrawColor(255, 255, 255);
    Canvas.DrawText("Leader " $ SquadLeader.GetHumanReadableName(), false);
    YPos += YL;
    Canvas.SetPos(4.0000000, YPos);
    EnemyList = "     Enemies: ";
    I = 0;
    J0xA2:

    // End:0xF0 [Loop If]
    if(I < 8)
    {
        // End:0xE6
        if(Enemies[I] != none)
        {
            EnemyList = EnemyList @ Enemies[I].GetHumanReadableName();
        }
        I++;
        // [Loop Continue]
        goto J0xA2;
    }
    Canvas.DrawText(EnemyList, false);
    YPos += YL;
    Canvas.SetPos(4.0000000, YPos);
    //return;    
}

function bool MustKeepEnemy(Actor E)
{
    local SkyBotControllerBase M;

    M = SquadMembers;
    J0x0B:

    // End:0x5E [Loop If]
    if(M != none)
    {
        // End:0x46
        if(M.bLockedEnemy && M.LockedEnemy == E)
        {
            return true;
        }
        M = M.NextSquadMember;
        // [Loop Continue]
        goto J0x0B;
    }
    return false;
    //return ReturnValue;    
}

function bool FindNewEnemyFor(SkyBotControllerBase B, bool bSeeEnemy)
{
    local int I;
    local Actor BestEnemy, OldEnemy;
    local bool bSeeNew;
    local float BestThreat, NewThreat;

    bSeeEnemy = true;
    // End:0x1F
    if(B.Pawn == none)
    {
        return true;
    }
    // End:0x4B
    if((B.Enemy != none) && B.bLockedEnemy)
    {
        return false;
    }
    I = 0;
    J0x52:

    // End:0x16A [Loop If]
    if(I < 8)
    {
        // End:0x160
        if(Pawn(Enemies[I]) != none)
        {
            // End:0x153
            if((((Enemies[I].bDeleteMe == false) && Pawn(Enemies[I]).Health > 0) && Pawn(Enemies[I]).Controller != none) && ValidEnemy(Enemies[I]))
            {
                bSeeNew = true;
                NewThreat = AssessThreat(B, Enemies[I], bSeeNew);
                // End:0x150
                if((BestEnemy == none) || NewThreat > BestThreat)
                {
                    BestEnemy = Enemies[I];
                    BestThreat = NewThreat;
                }
                // [Explicit Continue]
                goto J0x160;
            }
            Enemies[I] = none;
        }
        J0x160:

        I++;
        // [Loop Continue]
        goto J0x52;
    }
    I = 0;
    J0x171:

    // End:0x218 [Loop If]
    if(I < WorldInfo.Game.TargetableActors.Length)
    {
        NewThreat = AssessThreat(B, WorldInfo.Game.TargetableActors[I], bSeeEnemy);
        // End:0x20E
        if(NewThreat > BestThreat)
        {
            BestEnemy = WorldInfo.Game.TargetableActors[I];
            BestThreat = NewThreat;
        }
        I++;
        // [Loop Continue]
        goto J0x171;
    }
    OldEnemy = B.Enemy;
    B.Enemy = BestEnemy;
    // End:0x28E
    if((B.Enemy != OldEnemy) && B.Enemy != none)
    {
        B.EnemyChanged(bSeeEnemy);
        return true;
    }
    return false;
    //return ReturnValue;    
}
