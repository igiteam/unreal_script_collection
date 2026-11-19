class AdvAIController_Cover extends AdvAIController
    native(AI)
    config(AI)
    hidecategories(Navigation);

var AdvPawn_Armed_Base MyAdvPawn_Armed_Base;
var CoverInfo Cover;
var CoverInfo CoverGoal;
var CoverInfo LastCover;
var CoverInfo ForcedBetterCover;
var float EnterCoverTime;
var float CoveringTimeout;
var float LastFireFromCoverTime;
var bool bFailedToFireFromCover;
var config float MaxCoverTimeout_Covered;
var config float MaxCoverTimeout_Low;
var config float MaxCoverTimeout_Normal;
var config float MaxCoverTimeout_High;
var config float MinCoverTimeout_Covered;
var config float MinCoverTimeout_Low;
var config float MinCoverTimeout_Normal;
var config float MinCoverTimeout_High;
var config float CoverSearchEpsilon;
var float EnemyDistance_CoveringThreshold;
var config float EnemyDistance_CoveringThreshold_Covered;
var config float EnemyDistance_CoveringThreshold_Low;
var config float EnemyDistance_CoveringThreshold_Normal;
var config float EnemyDistance_CoveringThreshold_High;
var float MinCoverTimeout;
var float MaxCoverTimeout;
var EvilTypes.EAcquireCoverType AcquireCover;
var FireLinkItem PendingFireLinkItem;
var config float CoverLockTime;
var float LastRun2CoverTime;

event Possess(Pawn NewPawn, bool bVehicleTransition)
{
    super.Possess(NewPawn, bVehicleTransition);
    MyAdvPawn_Armed_Base = AdvPawn_Armed_Base(NewPawn);
    //return;    
}

final event bool CanRun2Cover()
{
    local CoverInfo DestCover;
    local CoverLink DestCoverLink;
    local bool IsValidCover;
    local Vector CoverSlotLoc;

    // End:0x24
    if(CoverGoal.Link == none)
    {
        return false;
    }
    DestCover = ((CoverGoal.Link != none) ? CoverGoal : Cover);
    DestCoverLink = DestCover.Link;
    // End:0x127
    if(((DestCoverLink != none) && DestCoverLink.IsEnabled()) && DestCoverLink.Slots[DestCover.SlotIdx].SlotOwner == MyEvilPawn)
    {
        IsValidCover = true;
    }
    CoverSlotLoc = DestCoverLink.GetSlotLocation(DestCover.SlotIdx);
    // End:0x1D8
    if((IsValidCover && !MyEvilPawn.IsInCover()) && VSize(Pawn.Location - CoverSlotLoc) <= float(100))
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool CanEvade()
{
    return true;
    //return ReturnValue;    
}

function bool CanMeleeAttack()
{
    return super(EvilAIController).CanMeleeAttack();
    //return ReturnValue;    
}

function string GetDebugString()
{
    return (super(EvilAIController).GetDebugString() @ "\nCoverLink") @ string(Cover.Link);
    //return ReturnValue;    
}

function AgrressionLevelChanged(EvilTypes.EAggressionLevel InNewLevel, EvilTypes.EAggressionLevel InOldLevel)
{
    super(EvilAIController).AgrressionLevelChanged(InNewLevel, InOldLevel);
    switch(InNewLevel)
    {
        // End:0x70
        case 1:
            EnemyDistance_CoveringThreshold = EnemyDistance_CoveringThreshold_Covered;
            MinCoverTimeout = MinCoverTimeout_Covered;
            MaxCoverTimeout = MaxCoverTimeout_Covered;
            // End:0x136
            break;
        // End:0xB1
        case 2:
            EnemyDistance_CoveringThreshold = EnemyDistance_CoveringThreshold_Low;
            MinCoverTimeout = MinCoverTimeout_Low;
            MaxCoverTimeout = MaxCoverTimeout_Low;
            // End:0x136
            break;
        // End:0xF2
        case 3:
            EnemyDistance_CoveringThreshold = EnemyDistance_CoveringThreshold_Normal;
            MinCoverTimeout = MinCoverTimeout_Normal;
            MaxCoverTimeout = MaxCoverTimeout_Normal;
            // End:0x136
            break;
        // End:0x133
        case 4:
            EnemyDistance_CoveringThreshold = EnemyDistance_CoveringThreshold_High;
            MinCoverTimeout = MinCoverTimeout_High;
            MaxCoverTimeout = MaxCoverTimeout_High;
            // End:0x136
            break;
        // End:0xFFFF
        default:
            break;
    }
    //return;    
}

function NotifyFullBodyHit(Controller InstigatedBy)
{
    super(EvilAIController).NotifyFullBodyHit(InstigatedBy);
    // End:0x91
    if(MyEvilPawn.bMovingToCover && int(CurrentAggressionLevel) != int(1))
    {
        ReactionManager.NudgeChannel(InstigatedBy.Pawn, 'AbortCovering');
    }
    //return;    
}

function EvadeAwayFromPoint(Vector DangerPoint, optional EvilPawn Attacker, optional bool bInCombatZones)
{
    SetAcquireCover(1, string(GetFuncName()));
    //return;    
}

function EvadeAwayFromActor(Actor DangerActor, optional EvilPawn Attacker, optional bool bInCombatZones)
{
    // End:0x60
    if(EvilAICmd_Base_Evade(CommandList) == none)
    {
        AbortCommand(CommandList);
        Class'AdvAICmd_Base_CoverEvade'.static.EvadeFromActor(self, DangerActor, Attacker);
    }
    //return;    
}

function bool BlockCombatTransitions()
{
    local Pawn EnemyPawn;

    // End:0x1A7
    if(!super(EvilAIController).BlockCombatTransitions())
    {
        // End:0x1A5
        if(((HasValidEnemy()) && EvilAICmd_Base_Combat(CommandList) != none) && ((CoverGoal.Link != none) && VSizeSq(CoverGoal.Link.GetSlotLocation(CoverGoal.SlotIdx) - Enemy.Location) < ((EnemyDistance_CoveringThreshold * EnemyDistance_CoveringThreshold) * 0.8000000)) || HasEnemyWithinDistance(EnemyDistance_CoveringThreshold * 0.8000000, EnemyPawn))
        {
            // End:0x16D
            if(MyEvilPawn.bMovingToCover)
            {
                ReactionManager.NudgeChannel(EnemyPawn, 'AbortCovering');                
            }
            else
            {
                // End:0x1A0
                if((HasValidCover()) || IsAtCover())
                {
                    InvalidateCoverAction();
                    InvalidateCover();
                }
            }
            return true;            
        }
        else
        {
            return false;
        }
    }
    return true;
    //return ReturnValue;    
}

function bool MoveToNearestCoverPawn()
{
    local CoverInfo CovToPawn;
    local EvilCoverLink LastCoverLink;

    // End:0x71
    if((EvilWeap_Base(MyEvilPawn.Weapon) != none) && EvilWeap_Base(MyEvilPawn.Weapon).BlockSprint)
    {
        return false;
    }
    LastCoverLink = EvilCoverLink(LastCover.Link);
    // End:0x271
    if(((((((LastCoverLink != none) && LastCoverLink.NextBetterCoverLink != none) && LastCoverLink != Cover.Link) && ForcedBetterCover.Link != LastCoverLink.NextBetterCoverLink) && LastCoverLink != CoverGoal.Link) && LastCoverLink.NextBetterCoverLink.IsEnabled()) && LastCoverLink.NextBetterCoverLink.IsValidClaim(MyEvilPawn, 0))
    {
        CovToPawn.Link = LastCoverLink.NextBetterCoverLink;
        CovToPawn.SlotIdx = 0;
        ForcedBetterCover = CovToPawn;
        SetCoverGoal(CovToPawn);
        return true;        
    }
    else
    {
        // End:0x360
        if(EvaluateCover(2, Pawn, CovToPawn))
        {
            // End:0x360
            if(CovToPawn.Link != Cover.Link)
            {
                switch(AcquireCover)
                {
                    // End:0x2EA
                    case 0:
                    // End:0x33F
                    case 2:
                        // End:0x328
                        if(LastCover.Link == none)
                        {
                            SetCoverGoal(CovToPawn);                            
                        }
                        else
                        {
                            SetCoverGoal(CovToPawn);
                        }
                        // End:0x35E
                        break;
                    // End:0x35B
                    case 1:
                        SetCoverGoal(CovToPawn);
                        // End:0x35E
                        break;
                    // End:0xFFFF
                    default:
                        break;
                }
                return true;
            }
        }
    }
    return false;
    //return ReturnValue;    
}

function bool MoveToNearestCoverEnemy()
{
    local CoverInfo CovToEnemy;
    local EvilCoverLink LastCoverLink;

    // End:0x71
    if((EvilWeap_Base(MyEvilPawn.Weapon) != none) && EvilWeap_Base(MyEvilPawn.Weapon).BlockSprint)
    {
        return false;
    }
    LastCoverLink = EvilCoverLink(LastCover.Link);
    // End:0x271
    if(((((((LastCoverLink != none) && LastCoverLink.NextBetterCoverLink != none) && LastCoverLink != Cover.Link) && ForcedBetterCover.Link != LastCoverLink.NextBetterCoverLink) && LastCoverLink != CoverGoal.Link) && LastCoverLink.NextBetterCoverLink.IsEnabled()) && LastCoverLink.NextBetterCoverLink.IsValidClaim(MyEvilPawn, 0))
    {
        CovToEnemy.Link = LastCoverLink.NextBetterCoverLink;
        CovToEnemy.SlotIdx = 0;
        ForcedBetterCover = CovToEnemy;
        SetCoverGoal(CovToEnemy);
        return true;        
    }
    else
    {
        // End:0x3FD
        if(EvaluateCover(2, Enemy, CovToEnemy))
        {
            // End:0x3FD
            if((CovToEnemy.Link != Cover.Link) || CovToEnemy.SlotIdx != Cover.SlotIdx)
            {
                switch(AcquireCover)
                {
                    // End:0x329
                    case 0:
                    // End:0x3DC
                    case 2:
                        // End:0x367
                        if(LastCover.Link == none)
                        {
                            SetCoverGoal(CovToEnemy);                            
                        }
                        else
                        {
                            // End:0x3D7
                            if(VSizeSq(Enemy.Location - MyEvilPawn.Location) > (EnemyDistance_CoveringThreshold * EnemyDistance_CoveringThreshold))
                            {
                                SetCoverGoal(CovToEnemy);                                
                            }
                            else
                            {
                                return false;
                            }
                        }
                        // End:0x3FB
                        break;
                    // End:0x3F8
                    case 1:
                        SetCoverGoal(CovToEnemy);
                        // End:0x3FB
                        break;
                    // End:0xFFFF
                    default:
                        break;
                }
                return true;
            }
        }
    }
    return false;
    //return ReturnValue;    
}

function bool EvaluateCover(EvilTypes.ECoverSearchType Type, Actor GoalActor, out CoverInfo out_Cover, optional float Radius = 2000.0000000, optional bool bOverrideSearchStartLocation, optional Vector SearchStartLocation)
{
    // End:0xDC
    if(int(Type) == int(2))
    {
        // End:0x77
        if(NavigationHandle.PathGoalList != none)
        {
            NavigationHandle.PathGoalList.Recycle();
        }
        return Class'AdvNavMeshGoal_AtCover'.static.FindCoverNearActor(NavigationHandle, GoalActor, Radius,,, out_Cover, MyEvilPawn, bOverrideSearchStartLocation, SearchStartLocation);        
    }
    else
    {
        // End:0x197
        if(int(Type) == int(5))
        {
            // End:0x148
            if(NavigationHandle.PathGoalList != none)
            {
                NavigationHandle.PathGoalList.Recycle();
            }
            return Class'AdvNavMeshGoal_AtCover'.static.FindCoverAnyActor(NavigationHandle, GoalActor, Radius,,, out_Cover, MyEvilPawn);
        }
    }
    return false;
    //return ReturnValue;    
}

function FireFromCover()
{
    // End:0x6A
    if((FindCommandOfClass(Class'AdvAICmd_Attack_FireFromCover') == none) && GetActiveEvilCommand().AllowTransitionTo(Class'AdvAICmd_Attack_FireFromCover'))
    {
        Class'AdvAICmd_Attack_FireFromCover'.static.FireFromCover(self);        
    }
    else
    {
        ReactionManager.NudgeChannel(self, 'AbortedShooting');
    }
    //return;    
}

function SetCoverGoal(CoverInfo NewCoverGoal, optional bool bIsValidCache)
{
    Class'AdvAICmd_MoveToCover'.static.MoveToCover(self, NewCoverGoal);
    //return;    
}

function bool IsValidCover(CoverInfo TestCover)
{
    return ((((((TestCover.Link != none) && TestCover.SlotIdx >= 0) && TestCover.SlotIdx < TestCover.Link.Slots.Length) && !TestCover.Link.bPlayerOnly) && !TestCover.Link.bCircular) && TestCover.Link.Slots[TestCover.SlotIdx].bEnabled) && !TestCover.Link.Slots[TestCover.SlotIdx].bPlayerOnly;
    //return ReturnValue;    
}

simulated function bool NotifyCoverClaimViolation(Controller NewClaim, CoverLink Link, int SlotIdx)
{
    return super(Controller).NotifyCoverClaimViolation(NewClaim, Link, SlotIdx);
    //return ReturnValue;    
}

function bool ClaimCover(CoverInfo NewCover)
{
    // End:0x13E
    if(IsValidCover(NewCover))
    {
        // End:0xC0
        if((Cover.Link != none) && (Cover.Link != NewCover.Link) || Cover.SlotIdx != NewCover.SlotIdx)
        {
            UnClaimCover();
        }
        // End:0x13E
        if(MyEvilPawn != none)
        {
            // End:0x13E
            if(MyEvilPawn.ClaimCover(NewCover.Link, NewCover.SlotIdx))
            {
                Cover = NewCover;
                return true;
            }
        }
    }
    return false;
    //return ReturnValue;    
}

function UnClaimCover()
{
    // End:0x1D5
    if(Cover.Link != none)
    {
        LastCover = Cover;
        // End:0x1D5
        if(MyEvilPawn != none)
        {
            MyEvilPawn.UnClaimCover(Cover.Link, Cover.SlotIdx, true);
            MyEvilPawn.LockDesiredRotation(false);
            // End:0x1D5
            if((MyEvilPawn.CurrentLink != none) || VSizeSq(MyEvilPawn.Location - Cover.Link.GetSlotLocation(Cover.SlotIdx)) < 100.0000000)
            {
                Cover.Link.SetInvalidUntil(Cover.SlotIdx, WorldInfo.TimeSeconds + CoverLockTime);
            }
        }
    }
    Cover.Link = none;
    Cover.SlotIdx = -1;
    //return;    
}

function SetAcquireCover(EvilTypes.EAcquireCoverType NewACT, coerce optional string Reason)
{
    // End:0x45
    if((int(AcquireCover) < int(NewACT)) || int(NewACT) == int(0))
    {
        AcquireCover = NewACT;
    }
    //return;    
}

function EnableAI()
{
    InvalidateCoverAction();
    InvalidateCover();
    super(EvilAIController).EnableAI();
    //return;    
}

function bool IsEnemyExposed()
{
    local Vector TestLocation;
    local Rotator Rot;

    TestLocation = ShotTarget.Location;
    Rot = Rotator(TestLocation - MyEvilPawn.Location);
    return CanSeeByPoints(MyEvilPawn.GetWeaponStartTraceLocation(), TestLocation, Rot);
    //return ReturnValue;    
}

function bool IsAtCover()
{
    return bReachedCover;
    //return ReturnValue;    
}

function bool HasValidCover()
{
    return (IsValidCover(Cover)) && Cover.Link.IsValidClaim(MyEvilPawn, Cover.SlotIdx);
    //return ReturnValue;    
}

function bool HasAnyEnemiesRequiringCover()
{
    return (EnemyInfoList.Length > 0) || Enemy != none;
    //return ReturnValue;    
}

function NotifyReachedCover()
{
    MyEvilPawn.RegisterNavMeshObstacle();
    bReachedCover = true;
    MyEvilPawn.TriggerEventClass(Class'EvilGame.SeqEvent_Covered', MyEvilPawn, 1);
    //return;    
}

function bool SetCoverAction(CoverLink.ECoverAction Action)
{
    // End:0x39
    if(MyEvilPawn != none)
    {
        MyEvilPawn.SetCoverAction(Action);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function ResetCoverAction(optional bool bResetCrouch)
{
    // End:0x89
    if((MyEvilPawn != none) && int(MyEvilPawn.CoverAction) != int(0))
    {
        MyEvilPawn.SetCoverAction(0);
        // End:0x89
        if(bResetCrouch)
        {
            MyEvilPawn.ShouldCrouch(false);
        }
    }
    //return;    
}

function float CheckCoverVisibilityToTarget(CoverInfo ChkCover, optional Actor ChkTarget)
{
    local array<CoverLink.ECoverAction> Actions;
    local CoverLink.ECoverAction Action;
    local float VisibilityRating;
    local AdvPawn TargetPawn;
    local AdvAIController_Cover TargetAIController;
    local int FireLinkIdx;
    local array<int> FireLinkItems;

    // End:0x60
    if(ChkTarget == none)
    {
        // End:0x35
        if(ShotTarget != none)
        {
            ChkTarget = ShotTarget;            
        }
        else
        {
            // End:0x5A
            if(Enemy != none)
            {
                ChkTarget = Enemy;                
            }
            else
            {
                return 0.5000000;
            }
        }
    }
    TargetPawn = AdvPawn(ChkTarget);
    // End:0xBC
    if(TargetPawn != none)
    {
        TargetAIController = AdvAIController_Cover(TargetPawn.MyAdvAI);
    }
    // End:0x28C
    if((TargetAIController == none) || TargetAIController.Cover.Link == none)
    {
        ChkCover.Link.GetSlotActions(ChkCover.SlotIdx, Actions);
        // End:0x288
        foreach Actions(Action)
        {
            // End:0x287
            if(ClearFireLineToActor(ChkTarget, ChkCover.Link.GetSlotViewPoint(ChkCover.SlotIdx, ChkCover.Link.Slots[ChkCover.SlotIdx].CoverType, Action), true,,, true, true, true, GetAimLocation(ChkTarget, MyEvilPawn.RequestedAimZone)))
            {
                VisibilityRating += 2.0000000;
            }            
        }                
    }
    else
    {
        // End:0x3EF
        if(ChkCover.Link.GetFireLinkTo(ChkCover.SlotIdx, TargetAIController.Cover, TargetPawn.CoverAction, ((int(MyEvilPawn.CoverType) != int(0)) ? MyEvilPawn.CoverType : ChkCover.Link.Slots[ChkCover.SlotIdx].CoverType), FireLinkIdx, FireLinkItems))
        {
            VisibilityRating += float(FireLinkItems.Length);            
        }
    }
    // End:0x499
    if(VisibilityRating <= 0.0000000)
    {
        // End:0x44F
        if(int(MyEvilPawn.RequestedAimZone) == int(1))
        {
            MyEvilPawn.RequestedAimZone = 2;            
        }
        else
        {
            // End:0x499
            if(int(MyEvilPawn.RequestedAimZone) == int(2))
            {
                MyEvilPawn.RequestedAimZone = 1;
            }
        }
    }
    return VisibilityRating;
    //return ReturnValue;    
}

function bool GetCoverAction(CoverInfo ChkCover, optional Actor ChkTarget)
{
    local array<CoverLink.ECoverAction> Actions, ValidActions;
    local CoverLink.ECoverAction Action, BestAction;
    local float DistanceSq, BestDistanceSq;
    local bool bClearMiddle;
    local CoverSlot Slot;
    local int I;
    local float YawDelta;
    local AdvPawn TargetPawn;
    local AdvAIController_Cover TargetAIController;
    local int FireLinkIdx;
    local array<int> FireLinkItems;
    local int Interaction;

    // End:0x49
    if((ChkCover.Link == none) || ChkCover.SlotIdx < 0)
    {
        return false;
    }
    Slot = ChkCover.Link.Slots[ChkCover.SlotIdx];
    // End:0xFC
    if(ChkTarget == none)
    {
        // End:0xD5
        if(ShotTarget != none)
        {
            ChkTarget = ShotTarget;            
        }
        else
        {
            // End:0xFA
            if(Enemy != none)
            {
                ChkTarget = Enemy;                
            }
            else
            {
                return false;
            }
        }
    }
    TargetPawn = AdvPawn(ChkTarget);
    // End:0x158
    if(TargetPawn != none)
    {
        TargetAIController = AdvAIController_Cover(TargetPawn.MyAdvAI);
    }
    // End:0x408
    if((TargetAIController == none) || TargetAIController.Cover.Link == none)
    {
        YawDelta = float(Class'EvilGame.EvilAnim_TurnInPlace'.static.CheckYawDelta(MyEvilPawn, MyEvilPawn.AimRotation.Yaw));
        // End:0x248
        if(Slot.bLeanLeft && YawDelta < float(0))
        {
            Actions.AddItem(3);            
        }
        // End:0x28A
        if(Slot.bLeanRight && YawDelta > float(0))
        {
            Actions.AddItem(4);            
        }
        // End:0x2B9
        if(Slot.bCanPopUp)
        {
            Actions.AddItem(5);            
        }
        // End:0x404
        foreach Actions(Action)
        {
            bClearMiddle = ClearFireLineToActor(ChkTarget, ChkCover.Link.GetSlotViewPoint(ChkCover.SlotIdx, ChkCover.Link.Slots[ChkCover.SlotIdx].CoverType, Action), true,,, true, true, true, GetAimLocation(ChkTarget, MyEvilPawn.RequestedAimZone));
            // End:0x403
            if(bClearMiddle)
            {
                ValidActions.AddItem(Action);                                
            }            
        }                
    }
    else
    {
        // End:0x6A4
        if(ChkCover.Link.GetFireLinkTo(ChkCover.SlotIdx, TargetAIController.Cover, TargetPawn.CoverAction, ((int(MyEvilPawn.CoverType) != int(0)) ? MyEvilPawn.CoverType : ChkCover.Link.Slots[ChkCover.SlotIdx].CoverType), FireLinkIdx, FireLinkItems))
        {
            Interaction = int(ChkCover.Link.Slots[ChkCover.SlotIdx].FireLinks[FireLinkIdx].Interactions[FireLinkItems[Rand(FireLinkItems.Length)]]);
            ChkCover.Link.UnPackFireLinkInteractionInfo(byte(Interaction), PendingFireLinkItem.SrcType, PendingFireLinkItem.SrcAction, PendingFireLinkItem.DestType, PendingFireLinkItem.DestAction);
            return true;            
        }
    }
    // End:0x98D
    if(ValidActions.Length > 0)
    {
        // End:0x806
        foreach ValidActions(Action, I)
        {
            DistanceSq = VSizeSq(ChkTarget.Location - ChkCover.Link.GetSlotViewPoint(ChkCover.SlotIdx, ChkCover.Link.Slots[ChkCover.SlotIdx].CoverType, Action));
            // End:0x805
            if((I == 0) || DistanceSq < BestDistanceSq)
            {
                BestAction = Action;
                BestDistanceSq = DistanceSq;
            }            
        }        
        // End:0x8E6
        if(((ShouldBlindFire(ChkTarget)) && int(MyEvilPawn.CoverAction) == int(0)) || MyEvilPawn.IsBlindFiring(MyEvilPawn.CoverAction))
        {
            switch(BestAction)
            {
                // End:0x8B1
                case 3:
                    BestAction = 1;
                    // End:0x8E6
                    break;
                // End:0x8C5
                case 4:
                    BestAction = 2;
                    // End:0x8E6
                    break;
                // End:0x8CA
                case 7:
                // End:0x8CF
                case 8:
                // End:0x8E3
                case 5:
                    BestAction = 6;
                    // End:0x8E6
                    break;
                // End:0xFFFF
                default:
                    break;
            }
        }
        else
        {
            PendingFireLinkItem.SrcAction = BestAction;
            PendingFireLinkItem.SrcType = ChkCover.Link.Slots[ChkCover.SlotIdx].CoverType;            
        }/* !MISMATCHING REMOVE, tried If got Type:Else Position:0x8E6! */
        else
        {
            // End:0x9DA
            if(int(MyEvilPawn.RequestedAimZone) == int(1))
            {
                MyEvilPawn.RequestedAimZone = 2;                
            }
            else
            {
                // End:0xA24
                if(int(MyEvilPawn.RequestedAimZone) == int(2))
                {
                    MyEvilPawn.RequestedAimZone = 1;
                }
            }
            return false;
        }
        return int(BestAction) != int(0);
        //return ReturnValue;        
    }/* !MISMATCHING REMOVE, tried Else got Type:If Position:0x6A4! */
}

function bool SetCoverType()
{
    // End:0x307
    if((((MyEvilPawn != none) && Cover.Link != none) && Cover.SlotIdx >= 0) && Cover.SlotIdx < Cover.Link.Slots.Length)
    {
        // End:0x17C
        if(Cover.Link.Slots.Length <= 1)
        {
            MyEvilPawn.SetCoverInfo(Cover.Link, Cover.SlotIdx, Cover.SlotIdx, Cover.SlotIdx, 0.0000000, true);            
        }
        else
        {
            // End:0x26D
            if(Cover.SlotIdx == (Cover.Link.Slots.Length - 1))
            {
                MyEvilPawn.SetCoverInfo(Cover.Link, Cover.SlotIdx, Cover.SlotIdx - 1, Cover.SlotIdx, 1.0000000, true);                
            }
            else
            {
                MyEvilPawn.SetCoverInfo(Cover.Link, Cover.SlotIdx, Cover.SlotIdx, Cover.SlotIdx + 1, 0.0000000, true);
            }
        }
        return true;
    }
    return false;
    //return ReturnValue;    
}

function InvalidateCoverAction()
{
    OnStopFireWithLag();
    //return;    
}

function InvalidateCover(optional bool bUnclaimOnly, optional bool bDontClearCoverGoal, optional bool bDontClearClaimedGoal)
{
    StrafeRatingThreshold = 0.0000000;
    // End:0x2B
    if(!bDontClearClaimedGoal)
    {
        UnClaimCover();
    }
    // End:0x7F
    if(!bUnclaimOnly)
    {
        ResetCoverType();
        // End:0x5D
        if(!bDontClearCoverGoal)
        {
            ClearCoverGoal();
        }
        MyEvilPawn.UnregisterNavmeshObstacle();        
    }
    else
    {
        ResetCoverAction(true);
    }
    //return;    
}

function bool IsCoverRunning()
{
    return false;
    //return ReturnValue;    
}

function InvalidateCoverFromDamage(Actor Damager)
{
    //return;    
}

simulated function NotifyCoverDisabled(CoverLink Link, int SlotIdx, optional bool bAdjacentIdx)
{
    super(Controller).NotifyCoverDisabled(Link, SlotIdx, bAdjacentIdx);
    InvalidateCoverAction();
    InvalidateCover();
    SetAcquireCover(1, string(GetFuncName()));
    //return;    
}

function ResetCoverType()
{
    // End:0x2E
    if(MyEvilPawn != none)
    {
        MyEvilPawn.LeaveCover();
    }
    //return;    
}

function ClearCoverGoal()
{
    CoverGoal.Link = none;
    CoverGoal.SlotIdx = -1;
    //return;    
}

function bool ShouldBlindFire(Actor ChkTarget)
{
    return ((ChkTarget != none) && !MyEvilPawn.bThrowingGrenade) && ((((((FRand() < FMin((1.0000000 - float(MyEvilPawn.Health / MyEvilPawn.HealthMax)) + 0.5000000, 0.8000000)) && (Normal(Vector(Cover.Link.GetSlotRotation(Cover.SlotIdx))) Dot Normal(ChkTarget.Location - Cover.Link.GetSlotLocation(Cover.SlotIdx))) > 0.9000000) && (WorldInfo.TimeSeconds - MyEvilPawn.LastCoverActionTime) < 6.0000000) && !MyEvilPawn.IsBlindFiring(MyEvilPawn.PreviousCoverAction)) && int(MyEvilPawn.PreviousCoverAction) != int(0)) && int(MyEvilPawn.CoverAction) == int(0)) || MyAdvPawn_Armed_Base.bBlindedByLight;
    //return ReturnValue;    
}

function bool ShouldWaitForTransition(CoverLink.ECoverAction Action)
{
    local bool bWantsToBeMirrored, bSwitch;

    // End:0xFA
    if(MyEvilPawn != none)
    {
        // End:0x6A
        if(((int(Action) == int(3)) || int(Action) == int(1)) || int(Action) == int(7))
        {
            bWantsToBeMirrored = true;
            bSwitch = true;            
        }
        else
        {
            // End:0xC2
            if(((int(Action) == int(4)) || int(Action) == int(2)) || int(Action) == int(8))
            {
                bWantsToBeMirrored = false;
                bSwitch = true;
            }
        }
        // End:0xFA
        if(bSwitch)
        {
            MyEvilPawn.SetMirroredSide(bWantsToBeMirrored);
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

function bool IsTransitioning()
{
    // End:0xA3
    if((MyEvilPawn != none) && int(MyEvilPawn.CoverType) != int(0))
    {
        // End:0xA3
        if((MyEvilPawn.bWantsToBeMirrored != MyEvilPawn.bIsMirrored) || MyEvilPawn.DoingAnimationTransition())
        {
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

simulated function OnStartFire()
{
    local float DistanceSq, BurstTimeMul;

    super(EvilAIController).OnStartFire();
    // End:0x2C
    if(ShotTargetActor == none)
    {
        ShotTarget = Enemy;
    }
    // End:0x151
    if((ShotTarget != none) || ShotTargetActor != none)
    {
        DistanceSq = VSizeSq(ShotTarget.Location - MyEvilPawn.Location);
        BurstTimeLeft = BurstFireTimeout + RandRange(-BurstFireSpreadTime, BurstFireSpreadTime);
        BurstTimeMul = (500.0000000 * 500.0000000) / DistanceSq;
        // End:0x13E
        if(BurstTimeMul < 0.4000000)
        {
            FireTime = BurstTimeLeft * BurstTimeMul;
            FireDelay = 1.0000000 - (BurstTimeMul * float(2));            
        }
        else
        {
            FireTime = BurstTimeLeft;
        }
    }
    //return;    
}

function BeginRun2Cover(CoverInfo InCoverGoal)
{
    // End:0x95
    if((FindCommandOfClass(Class'AdvAICmd_Move_Run2Cover') == none) && GetActiveEvilCommand().AllowTransitionTo(Class'AdvAICmd_Move_Run2Cover'))
    {
        Class'AdvAICmd_Move_Run2Cover'.static.Run2Cover(self, InCoverGoal, Pawn.GetCollisionRadius() * float(4));
    }
    //return;    
}

function BehaviorModeChanged(EvilTypesNative.EBehaviorMode InNewMode, EvilTypesNative.EBehaviorMode InOldMode)
{
    ReactionManager.BehaviorModeChanged(InNewMode, InOldMode);
    // End:0x6B
    if(int(InNewMode) == int(1))
    {
        // End:0x68
        if(CommandList != none)
        {
            AbortCommand(CommandList);
        }        
    }
    else
    {
        // End:0xDC
        if((int(InNewMode) >= int(2)) && EvilAICmd_Base_Combat(CommandList) == none)
        {
            BeginCombatCommand(DefaultCommand, "BehaviorModeChanged for AdvAIController_Cover");
        }
    }
    // End:0x11C
    if(MyEvilPawn != none)
    {
        MyEvilPawn.NotifyBehaviorModeChanged(InNewMode, InOldMode);
    }
    //return;    
}

function AbortCovering(Pawn TargetPawn, coerce optional string Reason)
{
    ClearLatentAction(Class'Engine.SeqAct_AIMoveToActor', true);
    BeginCombatCommand(DefaultCommand, "AbortCovering" @ Reason, true);
    //return;    
}

function float GetBaseEnemyRating(EvilPawn EnemyP, float Distance)
{
    local float Rating;

    Rating = super(EvilAIController).GetBaseEnemyRating(EnemyP, Distance);
    // End:0x85
    if(((IsAtCover()) && HasValidCover()) && Rating > 0.0000000)
    {
        Rating *= FMax(0.1000000, CheckCoverVisibilityToTarget(Cover, EnemyP));
    }
    return Rating;
    //return ReturnValue;    
}

function bool ShouldThrowGrenade()
{
    return super(EvilAIController).ShouldThrowGrenade() && !MyAdvPawn_Armed_Base.bBlindedByLight;
    //return ReturnValue;    
}

defaultproperties
{
    MaxCoverTimeout_Covered=40.0000000
    MaxCoverTimeout_Low=30.0000000
    MaxCoverTimeout_Normal=25.0000000
    MaxCoverTimeout_High=7.0000000
    MinCoverTimeout_Covered=30.0000000
    MinCoverTimeout_Low=20.0000000
    MinCoverTimeout_Normal=15.0000000
    MinCoverTimeout_High=2.0000000
    CoverSearchEpsilon=-0.5000000
    EnemyDistance_CoveringThreshold_Low=600.0000000
    EnemyDistance_CoveringThreshold_Normal=600.0000000
    EnemyDistance_CoveringThreshold_High=800.0000000
    CoverLockTime=2.0000000
    bNotifiesInRange=true
    TargettedAimEpsilon=0.9800000
    EnemyDistance_MeleeCharge=500.0000000
    EnemyDistance_MinimalStrafeDistance=500.0000000
    BeginAttackDistance_Covered=500.0000000
    BeginAttackDistance_Low=500.0000000
    BeginAttackDistance_Normal=1000.0000000
    BeginAttackDistance_High=99999.0000000
    NotifiesInRangeRadius=1500.0000000
    // Reference: EvilAIReactManager'Default__AdvAIController_Cover.ReactionManager0'
    begin object name=ReactionManager0
    end object
    ReactionManager=ReactionManager0
    DefaultReactConditions=/* Array type was not detected. */
    DefaultReactConditionClasses=/* Array type was not detected. */
    RequestHelpEnemyDistance=600.0000000
    DefaultAggressionLevel=EAggressionLevel.AL_Normal
}