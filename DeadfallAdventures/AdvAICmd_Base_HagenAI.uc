class AdvAICmd_Base_HagenAI extends AdvAICmd_Base_CoverAI within AdvAIController_Cover;

state InCombat
{Begin:

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

    // End:0xBD9
    if(ShouldChangeCover())
    {
        // End:0xBD6
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
                // End:0xBD6
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
                    // End:0xBC7
                    if(((ChildStatus != 'Success') || !bIdleWhenEnemyNotInCombatZone) || Outer.CanSeeByPoints(Outer.MyEvilPawn.GetWeaponStartTraceLocation(), Outer.GetAimLocation(Outer.Enemy, Outer.MyEvilPawn.RequestedAimZone), Rotator(Normal(Outer.GetAimLocation(Outer.Enemy, Outer.MyEvilPawn.RequestedAimZone) - Outer.MyEvilPawn.Location))))
                    {
                        Outer.InvalidateCover();
                        Outer.DoStrafeByDirections(Outer.OnRateStrafeByFlankEnemy, Outer.Enemy);
                    }
                    bCoverSearchFailedLastTime = true;                    
                }
            }
        }        
    }
    else
    {
        // End:0xE53
        if(Outer.HasValidCover() && Outer.IsAtCover())
        {
FireFromCover:


            // End:0xD67
            if((EvilWeap_Base(Outer.MyEvilPawn.Weapon) != none) && float(EvilWeap_Base(Outer.MyEvilPawn.Weapon).MagazineAmmoCount) <= (float(EvilWeap_Base(Outer.MyEvilPawn.Weapon).MagazineMaxAmmoCount) * 0.1000000))
            {
                EvilWeap_Base(Outer.MyEvilPawn.Weapon).ReloadAmmo();
            }
            J0xD67:

            Outer.Sleep(0.1000000);
            // End:0xD67
            if(!(!Outer.MyEvilPawn.IsReloading()))
                goto J0xD67;
            // End:0xDFA
            if((FRand() < 0.2000000) && ShouldThrowGrenadeFromCover())
            {
                Outer.ThrowAttack();                
            }
            else
            {
                // End:0xE29
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
            // End:0xF41
            if((int(Outer.CurrentAggressionLevel) <= int(1)) || !Outer.DoStrafeByDirections(Outer.OnRateStrafeByFlankEnemy, Outer.Enemy))
            {
                Outer.Focus = Outer.Enemy;
                Outer.Sleep(0.5000000);
            }
        }
    }
    J0xF41:

    // End:0x10ED
    if(!Outer.CanSeeByPoints(Outer.MyEvilPawn.GetWeaponStartTraceLocation(), Outer.GetAimLocation(Outer.Enemy, Outer.MyEvilPawn.RequestedAimZone), Rotator(Normal(Outer.GetAimLocation(Outer.Enemy, Outer.MyEvilPawn.RequestedAimZone) - Outer.MyEvilPawn.Location))))
    {
        // End:0x10ED
        if(Outer.ShouldThrowGrenade())
        {
            Outer.ThrowAttack();
        }
    }
    goto 'Begin';
PeekFromCover:


    Outer.PeekFromCover();
    Outer.Sleep(0.5000000);
    goto 'End';
    stop;            
}

defaultproperties
{
    bIdleWhenEnemyNotInCombatZone=false
}