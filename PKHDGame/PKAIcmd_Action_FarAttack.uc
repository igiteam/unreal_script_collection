class PKAIcmd_Action_FarAttack extends PKAICmd_Base_UtilitySelectedCmd within PKAIController;

var float WeaponDistanceModifier;
var bool bDelayStart;
var Vector CurrentMoveLocation;

function Pushed()
{
    super.Pushed();
    WeaponDistanceModifier = RandRange(0.6000000, 0.8000000);
    // End:0x5B
    if(Outer.bFirstTimeSee)
    {
        GotoState('FirstSeeEnemy');        
    }
    else
    {
        GotoState('Attack');
    }
    //return;    
}

static function float GetInitLastDeactivationTime(PKAIController AI, EvilUtilBasedAICmdMetaDataPacket ActivationData)
{
    return super.GetInitLastDeactivationTime(AI, ActivationData) + RandRange(0.0000000, AI.DelayBetweenAttacks);
    //return ReturnValue;    
}

function GettingCloser()
{
    Outer.LastMeleeHitTime = Outer.WorldInfo.TimeSeconds;
    //return;    
}

function Delay()
{
    //return;    
}

function Vector GetStrafePointEscape()
{
    local Vector StrafePoint;
    local float StrafeDistance, StrafeAngleOffset, Sign;

    Sign = ((FRand() < 0.5000000) ? -1.0000000 : 1.0000000);
    StrafeAngleOffset = (Sign * FRand()) * 0.3500000;
    StrafeDistance = ((Outer.MyPKPawn.MyEvilWeapon != none) ? Outer.MyPKPawn.MyEvilWeapon.WeaponRangeMin : Outer.ThrowRangeMin) * RandRange(1.0000000, 1.6000000);
    StrafePoint = Outer.GetStrafePointByDirection(4, StrafeDistance, StrafeAngleOffset, Outer.Enemy);
    // End:0x297
    if(!Outer.CheckStrafePointReachability(StrafePoint))
    {
        StrafeAngleOffset = -Sign * RandRange(0.3500000, 0.8727000);
        StrafePoint = Outer.GetStrafePointByDirection(4, StrafeDistance, StrafeAngleOffset, Outer.Enemy);
        // End:0x297
        if(!Outer.CheckStrafePointReachability(StrafePoint))
        {
            StrafePoint = Outer.GetStrafePointByDirection(5, StrafeDistance, StrafeAngleOffset, Outer.Enemy);
        }
    }
    return StrafePoint;
    //return ReturnValue;    
}

function UpdateFarAttackPrio()
{
    // End:0x111
    if(Outer.HasValidEnemy())
    {
        Outer.DelayBeforeHunt = 0.5000000;
        // End:0x10E
        if(Outer.DefaultNearAttackPriority > 0.0000000)
        {
            Outer.FarAttackPriority -= (Outer.DefaultNearAttackPriority * RandRange(0.0100000, 0.0500000));
            // End:0x10E
            if(Outer.FarAttackPriority < 0.0000000)
            {
                Outer.FarAttackPriority = 0.0000000;
            }
        }        
    }
    else
    {
        // End:0x182
        if(Outer.DelayBeforeHunt > 0.0000000)
        {
            Outer.DelayBeforeHunt -= Outer.GetTimerRate('UpdateFarAttackPrio', self);
        }
    }
    //return;    
}

static function float EvaluatePKActivation(PKAIController AI, EvilUtilBasedAICmdMetaDataPacket ActivationData)
{
    // End:0xE5
    if(((AI.HasValidEnemy() || ActivationData.bActive && AI.bChangePosOrEscapeInProgress) || AI.bFirstTimeSee) || AI.DelayBeforeHunt > 0.0000000)
    {
        return 0.4500000 + (AI.FarAttackPriority * 0.1000000);
    }
    return 0.0000000;
    //return ReturnValue;    
}

state FirstSeeEnemy
{End:

    GotoState('Attack');
    stop;        
}

state Attack
{Begin:

    // End:0x756
    if(Outer.HasValidEnemy() || Outer.bChangePosOrEscapeInProgress)
    {
        // End:0x15C
        if(Outer.MyPKPawn.MyEvilWeapon != none)
        {
            // End:0x159
            if(Outer.GetEnemyInfo().DistanceToEnemy < Outer.MyPKPawn.MyEvilWeapon.WeaponRangeMin)
            {
                // End:0x159
                if(Outer.MyPKPawn.MyEvilWeapon.HasAnyAmmo())
                {
                    GotoState('Escape');
                }
            }            
        }
        else
        {
            // End:0x1C0
            if(Outer.GetEnemyInfo().DistanceToEnemy < Outer.ThrowRangeMin)
            {
                GotoState('Escape');
            }
        }
        // End:0x42A
        if(!Outer.bWalkAreaWhenAttack && (((Outer.MyPKPawn.MyEvilWeapon != none) && Outer.GetEnemyInfo().DistanceToEnemy > (Outer.MyPKPawn.MyEvilWeapon.WeaponRange * WeaponDistanceModifier)) || Outer.GetEnemyInfo().DistanceToEnemy > (Outer.EnemyDistance_Shoot * WeaponDistanceModifier)) || Outer.IsTimerActive('GettingCloser', self))
        {
            // End:0x419
            if(Outer.IsTimerActive('GettingCloser', self))
            {
                // End:0x419
                if(Outer.GetEnemyInfo().DistanceToEnemy < (Outer.MyPKPawn.MyEvilWeapon.WeaponRangeMin * 1.5000000))
                {
                    Outer.ClearTimer('GettingCloser', self);
                }
            }
            GotoState('MoveToEnemy');            
        }
        else
        {
            // End:0x4F2
            if((Outer.LastMeleeMissedTime > (Outer.LastMeleeHitTime + 6.0000000)) && Outer.GetEnemyInfo().DistanceToEnemy > 500.0000000)
            {
                Outer.SetTimer(RandRange(0.5000000, 1.0000000), false, 'GettingCloser', self);
                goto 'Loop';
            }
            Outer.SetFocalPoint(Outer.Enemy.Location);
            // End:0x581
            if(!Outer.bDontCareAboutOrientationDuringAttack)
            {
                Outer.FinishRotation();
            }
            Outer.bChangePosOrEscapeInProgress = false;
            // End:0x5D0
            if(!Outer.ClearFireLine())
            {
                goto 'Loop';
            }
            Outer.StartShootAttack();
            J0x5EF:

            // End:0x698 [Loop If]
            if((!Outer.bDontRotateWhenShooting && FRand() < 0.2000000) && Outer.HasValidEnemy())
            {
                Outer.SetFocalPoint(Outer.Enemy.Location);
            }
            Outer.Sleep(0.0500000);
            // End:0x5EF
            if(!(int(Outer.MyEvilPawn.PawnAction) != 11))
                goto J0x5EF;
            Outer.SetTimer(Outer.DelayBetweenAttacks * RandRange(0.8000000, 1.1000000), false, 'Delay', self);
            GotoState('BetweenAttacks');
        }
    }
    J0x756:

    Outer.Sleep(0.0500000);
    goto 'Begin';
    stop;            
}

state BetweenAttacks
{
    function BeginState(name PreviousStateName)
    {
        bDelayStart = true;
        //return;        
    }

    function bool GetMoveLocation(out Vector MoveLocation)
    {
        local float MoveDistance;
        local Rotator MoveRotation;
        local Vector AlternativeMoveLocation;

        // End:0x93
        if(Outer.bWalkAreaWhenAttack)
        {
            MoveLocation = ((Outer.bWalkAreaRandom) ? Outer.GetRandomLocationInWalkArea() : Outer.GetNextLocationInWalkArea());
            return true;            
        }
        else
        {
            // End:0x11C
            if(Outer.ChangePosAfterFireDistance > 0.0000000)
            {
                MoveDistance = RandRange(Outer.ChangePosAfterFireDistance * 0.8000000, Outer.ChangePosAfterFireDistance * 2.0000000);                
            }
            else
            {
                MoveDistance = (RandRange(6.0000000, 9.0000000) * Outer.MyPKPawn.GetCollisionRadius()) * 2.0000000;
                MoveRotation = MakeRotator(0, int(RandRange(0.8700000, 1.7400000) * 10430.3800000), 0);
                // End:0x1F1
                if(FRand() < 0.5000000)
                {
                    MoveRotation.Yaw = -MoveRotation.Yaw;
                }
                MoveRotation = Normalize(Outer.MyPKPawn.DesiredRotation + MoveRotation);
                MoveLocation = Outer.MyPKPawn.Location + (Normal(Vector(MoveRotation)) * MoveDistance);
                // End:0x4DB
                if(!Outer.ClearSightToActor(Outer.Enemy,,,, AlternativeMoveLocation) && Outer.NavigationHandle.PointReachable(AlternativeMoveLocation))
                {
                    MoveDistance = VSize(AlternativeMoveLocation - Outer.MyPKPawn.Location);
                    // End:0x4D8
                    if((MoveDistance > (1.5000000 * Outer.MyPKPawn.GetCollisionRadius())) && MoveDistance < (4.5000000 * Outer.MyPKPawn.GetCollisionRadius()))
                    {
                        // End:0x4D8
                        if(VSizeSq(Outer.Enemy.Location - Outer.MyPKPawn.Location) > Outer.MyPKPawn.MyEvilWeapon.WeaponRangeMin)
                        {
                            MoveLocation = AlternativeMoveLocation;
                            return true;
                        }
                    }                    
                }
                else
                {
                    // End:0x51F
                    if(Outer.NavigationHandle.PointReachable(MoveLocation))
                    {
                        return true;
                    }
                }
            }
        }
        return false;
        //return ReturnValue;        
    }
Begin:

    // End:0x389
    if(Outer.IsTimerActive('Delay', self))
    {
        // End:0x327
        if(bDelayStart)
        {
            // End:0x16C
            if((Outer.ChanceOfEscapeAfterFire > 0.0000000) && !Outer.bWalkAreaWhenAttack)
            {
                // End:0x16C
                if((Outer.LastMeleeHitTime > Outer.LastMeleeMissedTime) && FRand() < Outer.ChanceOfEscapeAfterFire)
                {
                    Outer.ActualEscapeTime = RandRange(Outer.EscapeTime * 0.7000000, Outer.EscapeTime * 1.2000000);
                    goto 'Loop';
                }
            }
            bDelayStart = false;
            // End:0x2D1
            if(FRand() < Outer.ChangePosAfterFireChance)
            {
                Outer.bChangePosOrEscapeInProgress = true;
                // End:0x27B
                if(GetMoveLocation(CurrentMoveLocation))
                {
                    Outer.SetFocalPoint(CurrentMoveLocation);
                    Outer.FinishRotation();
                    Outer.SetMovePoint(CurrentMoveLocation, Outer.Pawn.GetCollisionRadius() * float(2));                    
                }
                else
                {
                    Outer.SetFocalPoint(Outer.Enemy.Location);
                }                
            }
            else
            {
                Outer.SetFocalPoint(Outer.Enemy.Location);
            }            
        }
        else
        {
            // End:0x386
            if(FRand() < 0.5000000)
            {
                Outer.SetFocalPoint(Outer.Enemy.Location);
            }
        }        
    }
    else
    {
        GotoState('Attack');
    }
    J0x397:

    Outer.Sleep(0.0500000);
    goto 'Begin';
    stop;        
}

state Escape
{Begin:

    // End:0xB4
    if(!Outer.bDisableEscapeWhenTooClose)
    {
        // End:0x89
        if(Outer.bWalkAreaWhenAttack)
        {
            Outer.SetMovePoint(Outer.GetRandomLocationInWalkArea());            
        }
        else
        {
            Outer.SetMovePoint(GetStrafePointEscape());
        }
    }
    GotoState('Attack');
    stop;        
}

state MoveToEnemy
{Begin:

    // End:0x1C4
    if(Outer.HasValidEnemy())
    {
        Outer.SetMoveGoal(Outer.Enemy, ((Outer.MyPKPawn.MyEvilWeapon != none) ? FMin(Outer.EnemyDistance_Shoot, Outer.MyPKPawn.MyEvilWeapon.WeaponRange) : Outer.EnemyDistance_Shoot) * (WeaponDistanceModifier - 0.1000000), false);
        // End:0x177
        if(Outer.bResetFocusAfterMove)
        {
            Outer.Focus = none;
        }
        // End:0x1C4
        if((ChildStatus != 'Success') && ChildStatus != 'Aborted')
        {
            Outer.Sleep(2.0000000);
        }
    }
    GotoState('Attack');
    stop;        
}
