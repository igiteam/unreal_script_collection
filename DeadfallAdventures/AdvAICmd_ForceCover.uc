class AdvAICmd_ForceCover extends AdvAICmd_Base_CoverAI within AdvAI_Ally;

var float TimeBetweenHitsWithoutCover;
var CoverInfo CoverInfoToForce;
var bool bFireFromCover;

static function bool ForceCover(AdvAI_Ally AI, CoverInfo CoverToForce, bool bCanFire)
{
    local AdvAICmd_ForceCover Cmd;

    // End:0xD1
    if((AI != none) && AI.MyEvilPawn != none)
    {
        Cmd = new (AI) Class'AdvAICmd_ForceCover';
        Cmd.bFireFromCover = bCanFire;
        Cmd.CoverInfoToForce = CoverToForce;
        AI.PushCommand(Cmd);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool ShouldBeInIdle()
{
    return false;
    //return ReturnValue;    
}

function Pushed()
{
    super.Pushed();
    Outer.ClearCoverGoal();
    GotoState('GoToCover');
    //return;    
}

function bool ShouldFireFromCover()
{
    return bFireFromCover && super.ShouldFireFromCover();
    //return ReturnValue;    
}

function EvadeAwayFromActor(Actor DangerActor, optional EvilPawn Attacker, optional bool bInCombatZones)
{
    //return;    
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

function Popped()
{
    super(EvilAICmd_Base_Combat).Popped();
    Outer.MyAdvPawn.MinTimeBetweenHits = Outer.MyAdvPawn.default.MinTimeBetweenHits;
    //return;    
}

state InCombat
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
    // End:0xCB
    if(!Outer.MyEvilPawn.IsInCover())
    {
        Outer.Sleep(0.5000000);
        GotoState('GoToCover');
    }
    // End:0x135
    if(!Outer.HasValidEnemy())
    {
        Outer.SelectEnemy();
        Outer.Sleep(0.5000000);
        goto 'Begin';
    }
    Outer.SetFocalPoint(Outer.Enemy.Location);
    // End:0x20C
    if(Outer.IsUnderAttack() != Outer.bUnderAttack)
    {
        Outer.bUnderAttack = !Outer.bUnderAttack;
    }
    // End:0x354
    if((EvilWeap_Base(Outer.MyEvilPawn.Weapon) != none) && float(EvilWeap_Base(Outer.MyEvilPawn.Weapon).MagazineAmmoCount) <= (float(EvilWeap_Base(Outer.MyEvilPawn.Weapon).MagazineMaxAmmoCount) * 0.1000000))
    {
        EvilWeap_Base(Outer.MyEvilPawn.Weapon).ReloadAmmo();
    }
    J0x354:

    Outer.Sleep(0.1000000);
    // End:0x354
    if(!(!Outer.MyEvilPawn.IsReloading()))
        goto J0x354;
    // End:0x3D6
    if(ShouldFireFromCover())
    {
        Outer.FireFromCover();
    }
    Outer.Sleep(0.1000000);
    goto 'Begin';
    stop;            
}

state GoToCover
{Begin:

    Outer.MyAdvPawn.MinTimeBetweenHits = TimeBetweenHitsWithoutCover;
    Outer.SetCoverGoal(CoverInfoToForce);
    GotoState('InCover');
    stop;                
}

defaultproperties
{
    TimeBetweenHitsWithoutCover=3.0000000
    bIgnoreStepAside=true
}