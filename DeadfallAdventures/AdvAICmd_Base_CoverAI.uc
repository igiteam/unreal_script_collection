class AdvAICmd_Base_CoverAI extends EvilAICmd_Base_Combat within AdvAIController_Cover;

var bool bCoverSearchFailedLastTime;
var bool bIdleWhenEnemyNotInCombatZone;

function AgrressionLevelChanged(EvilTypes.EAggressionLevel InNewLevel, EvilTypes.EAggressionLevel InOldLevel)
{
    // End:0x5F
    if((int(InNewLevel) == int(4)) && !IsInState('InCombat', true))
    {
        Outer.AbortCommand(none, Class'EvilGame.EvilAICmd_MoveToGoal');
        GotoState('InCombat');
    }
    //return;    
}

function Pushed()
{
    super.Pushed();
    GotoState('InCombat');
    //return;    
}

function Resumed(name OldCommandName)
{
    super(GameAICommand).Resumed(OldCommandName);
    // End:0x4D
    if(!Outer.HasValidEnemy())
    {
        GotoState('InCombat', 'Begin');
    }
    //return;    
}

function bool ShouldFireFromCover()
{
    // End:0x1A2
    if(((((Outer.HasEnemyWithinDistance(Outer.EnemyDistance_Shoot,,, false) && Outer.SelectTarget()) && int(Outer.MyEvilPawn.CurrentAimZone) != int(0)) && Outer.bFailedToFireFromCover || (Outer.WorldInfo.TimeSeconds - Outer.LastFireFromCoverTime) > Outer.TimeBetweenFireBurst) && Outer.MyEvilPawn.HasRangedAttack()) && Outer.ShouldStartShootAttack())
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool ShouldThrowGrenadeFromCover()
{
    return Outer.ShouldThrowGrenade();
    //return ReturnValue;    
}

state InCombat
{
    function bool MoveToInitialCover()
    {
        // End:0x44
        if(!Outer.HasValidCover())
        {
            return Outer.MoveToNearestCoverEnemy();
        }
        return true;
        //return ReturnValue;        
    }

    function bool MoveToBetterCover()
    {
        switch(Outer.AcquireCover)
        {
            // End:0xFFFF
            default:
                // End:0x52
                if(Outer.MoveToNearestCoverEnemy())
                {
                    return true;                    
                }
                else
                {
                    // End:0xD5
                    if(int(Outer.CurrentAggressionLevel) <= int(3))
                    {
                        Outer.SetAcquireCover(0, "Clearing Acquire Cover because there is no better cover");
                    }
                }
                // End:0xD8
                break;
                break;
        }
        return false;
        //return ReturnValue;        
    }

    function bool ShouldChangeCover()
    {
        // End:0x1E
        if(bCoverSearchFailedLastTime)
        {
            bCoverSearchFailedLastTime = false;
            return false;            
        }
        else
        {
            // End:0x6D
            if(!Outer.HasValidCover() || !Outer.IsAtCover())
            {
                return true;                
            }
            else
            {
                // End:0xAB
                if(ShouldChangeCoverDueToExposure())
                {
                    Outer.SetAcquireCover(1, string('ImmediateChangeCoverDueToExposure'));
                    return true;                    
                }
                else
                {
                    // End:0xD6
                    if(int(Outer.AcquireCover) > int(0))
                    {
                        return true;
                    }
                }
            }
        }
        // End:0x1F6
        if(((Outer.WorldInfo.TimeSeconds - Outer.EnterCoverTime) > Outer.CoveringTimeout) && (Outer.WorldInfo.TimeSeconds - Outer.LastFireTime) > (Outer.CoveringTimeout / float(2)))
        {
            Outer.SetAcquireCover(2, "Timeout");
            return true;
        }
        return false;
        //return ReturnValue;        
    }

    function bool ShouldChangeCoverDueToExposure()
    {
        local float CovDotEnemy;

        CovDotEnemy = Normal(Vector(Outer.Cover.Link.GetSlotRotation(Outer.Cover.SlotIdx))) Dot Normal(Outer.Enemy.Location - Outer.Cover.Link.GetSlotLocation(Outer.Cover.SlotIdx));
        return CovDotEnemy < 0.5000000;
        //return ReturnValue;        
    }
Begin:

    // End:0x4E
    if(!Outer.HasValidEnemy())
    {
        Outer.Sleep(0.5000000);
        goto 'Begin';        
    }
    else
    {
        Outer.SetFocalPoint(Outer.Enemy.Location);
    }
    J0xA1:

    // End:0xBFB
    if(ShouldChangeCover())
    {
        // End:0xBF8
        if(Outer.HasAnyEnemiesRequiringCover())
        {
            // End:0x723
            if(!Outer.HasValidCover() || !Outer.IsAtCover())
            {
                // End:0x720
                if(!MoveToInitialCover())
                {
                    // End:0x601
                    if(!Outer.CanSeeByPoints(Outer.MyEvilPawn.GetWeaponStartTraceLocation(), Outer.GetAimLocation(Outer.Enemy, Outer.MyEvilPawn.RequestedAimZone), Rotator(Normal(Outer.GetAimLocation(Outer.Enemy, Outer.MyEvilPawn.RequestedAimZone) - Outer.MyEvilPawn.Location))))
                    {
                        // End:0x382
                        if((int(Outer.CurrentAggressionLevel) <= int(0)) || !Outer.DoStrafeByDirections(Outer.OnRateStrafeByFlankEnemy, Outer.Enemy))
                        {
                            Outer.Focus = Outer.Enemy;
                            Outer.Sleep(0.5000000);
                        }
                        // End:0x5FE
                        if(!Outer.CanSeeByPoints(Outer.MyEvilPawn.GetWeaponStartTraceLocation(), Outer.GetAimLocation(Outer.Enemy, Outer.MyEvilPawn.RequestedAimZone), Rotator(Normal(Outer.GetAimLocation(Outer.Enemy, Outer.MyEvilPawn.RequestedAimZone) - Outer.MyEvilPawn.Location))))
                        {
                            // End:0x5D4
                            if(!Outer.HasCombatZones() || Outer.IsLocationInCombatZones(Outer.Enemy.Location))
                            {
                                Outer.SetEnemyMoveGoal(Outer.EnemyDistance_MinimalStrafeDistance, true, int(Outer.CurrentAggressionLevel) <= int(3),,, true, true);                                
                            }
                            else
                            {
                                // End:0x5FE
                                if(bIdleWhenEnemyNotInCombatZone)
                                {
                                    Outer.Sleep(0.1000000);
                                }
                            }
                        }                        
                    }
                    else
                    {
                        // End:0x711
                        if((int(Outer.CurrentAggressionLevel) <= int(0)) || !Outer.DoStrafeByDirections(Outer.OnRateStrafeByFlankEnemy, Outer.Enemy))
                        {
                            Outer.InvalidateCover();
                            Outer.Focus = Outer.Enemy;
                            Outer.Sleep(0.5000000);
                        }
                    }
                    bCoverSearchFailedLastTime = true;                    
                }                
            }
            else
            {
                // End:0xBF8
                if(!MoveToBetterCover())
                {
                    // End:0x9AE
                    if(!Outer.CanSeeByPoints(Outer.MyEvilPawn.GetWeaponStartTraceLocation(), Outer.GetAimLocation(Outer.Enemy, Outer.MyEvilPawn.RequestedAimZone), Rotator(Normal(Outer.GetAimLocation(Outer.Enemy, Outer.MyEvilPawn.RequestedAimZone) - Outer.MyEvilPawn.Location))))
                    {
                        // End:0x984
                        if(!Outer.HasCombatZones() || Outer.IsLocationInCombatZones(Outer.Enemy.Location))
                        {
                            Outer.SetEnemyMoveGoal(Outer.EnemyDistance_MinimalStrafeDistance, true, int(Outer.CurrentAggressionLevel) <= int(3),,, true, true);                            
                        }
                        else
                        {
                            // End:0x9AE
                            if(bIdleWhenEnemyNotInCombatZone)
                            {
                                Outer.Sleep(0.1000000);
                            }
                        }
                    }
                    // End:0xBE9
                    if(((ChildStatus != 'Success') || !bIdleWhenEnemyNotInCombatZone) || Outer.CanSeeByPoints(Outer.MyEvilPawn.GetWeaponStartTraceLocation(), Outer.GetAimLocation(Outer.Enemy, Outer.MyEvilPawn.RequestedAimZone), Rotator(Normal(Outer.GetAimLocation(Outer.Enemy, Outer.MyEvilPawn.RequestedAimZone) - Outer.MyEvilPawn.Location))))
                    {
                        Outer.InvalidateCover();
                        // End:0xBE9
                        if(!Outer.DoStrafeByDirections(Outer.OnRateStrafeByFlankEnemy, Outer.Enemy))
                        {
                            Outer.Sleep(0.5000000);
                        }
                    }
                    bCoverSearchFailedLastTime = true;                    
                }
            }
        }        
    }
    else
    {
        // End:0xE76
        if(Outer.HasValidCover() && Outer.IsAtCover())
        {
FireFromCover:


            // End:0xD89
            if((EvilWeap_Base(Outer.MyEvilPawn.Weapon) != none) && float(EvilWeap_Base(Outer.MyEvilPawn.Weapon).MagazineAmmoCount) <= (float(EvilWeap_Base(Outer.MyEvilPawn.Weapon).MagazineMaxAmmoCount) * 0.1000000))
            {
                EvilWeap_Base(Outer.MyEvilPawn.Weapon).ReloadAmmo();
            }
            J0xD89:

            // End:0xDE0 [Loop If]
            if(Outer.MyEvilPawn.IsReloading())
            {
                Outer.Sleep(0.1000000);
                // [Loop Continue]
                goto J0xD89;
            }
            // End:0xE1D
            if((FRand() < 0.2000000) && ShouldThrowGrenadeFromCover())
            {
                Outer.ThrowAttack();                
            }
            else
            {
                // End:0xE4C
                if(ShouldFireFromCover())
                {
                    Outer.FireFromCover();                    
                }
                else
                {
                    goto 'PeekFromCover';
                }
            }
            Outer.Sleep(0.5000000);            
        }
        else
        {
            // End:0xF64
            if((int(Outer.CurrentAggressionLevel) <= int(1)) || !Outer.DoStrafeByDirections(Outer.OnRateStrafeByFlankEnemy, Outer.Enemy))
            {
                Outer.Focus = Outer.Enemy;
                Outer.Sleep(0.5000000);
            }
        }
    }
    J0xF64:

    goto 'Begin';
PeekFromCover:


    Outer.PeekFromCover();
    Outer.Sleep(0.5000000);
    goto 'End';
    stop;                
}

auto state MoveToEnemy
{Begin:

    // End:0x43
    if(!Outer.HasValidEnemy())
    {
        Outer.ReturnToIdle();
    }
Loop:


    // End:0x86
    if(!Outer.HasValidEnemy())
    {
        Outer.ReturnToIdle();
    }
    Outer.SetMoveGoal(Outer.Enemy, RandRange(100.0000000, 200.0000000), false, false);
    // End:0x13A
    if(Outer.CommandList.ChildStatus == 'Failure')
    {
        Outer.Sleep(0.1000000);
    }
    goto 'Loop';
    stop;                
}

defaultproperties
{
    bIdleWhenEnemyNotInCombatZone=true
}