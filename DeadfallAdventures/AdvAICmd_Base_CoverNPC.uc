class AdvAICmd_Base_CoverNPC extends AdvAICmd_Base_CoverAI within AdvAI_Ally;

var float TimeBetweenHitsWithoutCover;

function EvadeAwayFromActor(Actor DangerActor, optional EvilPawn Attacker, optional bool bInCombatZones)
{
    //return;    
}

function bool ShouldBeInIdle()
{
    return false;
    //return ReturnValue;    
}

function bool CheckTransition(out class<EvilAICmd_Base_Combat> out_NewCommand, out string out_Reason)
{
    return !Outer.bBlockCombatTransition && !Outer.HasAnyEnemies();
    //return ReturnValue;    
}

function bool CanEvade()
{
    return false;
    //return ReturnValue;    
}

function bool ShouldChangeCover()
{
    // End:0x29
    if(!Outer.HasValidCover())
    {
        return true;        
    }
    else
    {
        // End:0x54
        if(int(Outer.AcquireCover) > int(0))
        {
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

function Popped()
{
    super(EvilAICmd_Base_Combat).Popped();
    Outer.MyAdvPawn.MinTimeBetweenHits = Outer.MyAdvPawn.default.MinTimeBetweenHits;
    //return;    
}

auto state InCombat
{Begin:

    // End:0x41
    if(Outer.HasAnyEnemies())
    {
        Outer.SelectEnemy();
    }
    // End:0x8B
    if(!Outer.MyEvilPawn.IsInCover())
    {
        GotoState('GoToCover');        
    }
    else
    {
        GotoState('InCover');
    }
    stop;            
}

state InCover
{Begin:

    Outer.MyAdvPawn.MinTimeBetweenHits = Outer.MyAdvPawn.default.MinTimeBetweenHits;
    // End:0xAE
    if(!Outer.MyEvilPawn.IsInCover())
    {
        GotoState('GoToCover');
    }
    // End:0xF9
    if(!Outer.HasValidEnemy())
    {
        Outer.Sleep(0.5000000);
        goto 'Begin';
    }
    // End:0x17D
    if(Outer.IsUnderAttack() != Outer.bUnderAttack)
    {
        Outer.bUnderAttack = !Outer.bUnderAttack;
    }
    // End:0x19B
    if(ShouldChangeCover())
    {
        GotoState('GoToCover');        
    }
    else
    {
        Outer.SetFocalPoint(Outer.Enemy.Location);
        // End:0x336
        if((EvilWeap_Base(Outer.MyEvilPawn.Weapon) != none) && float(EvilWeap_Base(Outer.MyEvilPawn.Weapon).MagazineAmmoCount) <= (float(EvilWeap_Base(Outer.MyEvilPawn.Weapon).MagazineMaxAmmoCount) * 0.1000000))
        {
            EvilWeap_Base(Outer.MyEvilPawn.Weapon).ReloadAmmo();
        }
        J0x336:

        Outer.Sleep(0.1000000);
        // End:0x336
        if(!(!Outer.MyEvilPawn.IsReloading()))
            goto J0x336;
        // End:0x3B8
        if(ShouldFireFromCover())
        {
            Outer.FireFromCover();
        }
        Outer.Sleep(0.1000000);
    }
    goto 'Begin';
    stop;                    
}

state GoToCover
{Begin:

    Outer.MyAdvPawn.MinTimeBetweenHits = TimeBetweenHitsWithoutCover;
    // End:0xDD
    if(!Outer.HasValidEnemy())
    {
        Outer.SelectEnemy();
        // End:0xB3
        if(Outer.MoveToNearestCoverPawn())
        {
            GotoState('InCover');            
        }
        else
        {
            Outer.Sleep(0.5000000);
            goto 'Begin';
        }        
    }
    else
    {
        // End:0x110
        if(Outer.MoveToNearestCoverEnemy())
        {
            GotoState('InCover');            
        }
        else
        {
            Outer.InvalidateCover();
            Outer.Focus = Outer.Enemy;
            // End:0x2B7
            if((EvilWeap_Base(Outer.MyEvilPawn.Weapon) != none) && float(EvilWeap_Base(Outer.MyEvilPawn.Weapon).MagazineAmmoCount) <= (float(EvilWeap_Base(Outer.MyEvilPawn.Weapon).MagazineMaxAmmoCount) * 0.1000000))
            {
                EvilWeap_Base(Outer.MyEvilPawn.Weapon).ReloadAmmo();
            }
            J0x2B7:

            Outer.Sleep(0.1000000);
            // End:0x2B7
            if(!(!Outer.MyEvilPawn.IsReloading()))
                goto J0x2B7;
            Outer.DoStrafe(Outer.Enemy.Location,, Outer.Enemy);
            Outer.Sleep(1.0000000);
            goto 'Begin';
        }
    }
    stop;            
}

defaultproperties
{
    TimeBetweenHitsWithoutCover=3.0000000
    bIgnoreStepAside=true
}