class AdvAICmd_Base_CoverEvade extends EvilAICmd_Base_Evade within AdvAIController_Cover;

var Actor DangerActor;
var EvilPawn Attacker;
var bool bSavedCanSlowDown;

static function bool EvadeFromActor(AdvAIController_Cover AI, Actor InDangerActor, EvilPawn InAttacker)
{
    local AdvAICmd_Base_CoverEvade Cmd;

    // End:0xCF
    if((AI != none) && AI.Pawn != none)
    {
        Cmd = new (AI) default.Class;
        Cmd.DangerActor = InDangerActor;
        Cmd.Attacker = InAttacker;
        AI.PushCommand(Cmd);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function Pushed()
{
    super(EvilAICmd_Base_Combat).Pushed();
    bSavedCanSlowDown = Outer.MyAdvPawn.bCanSlowDown;
    Outer.MyAdvPawn.bCanSlowDown = false;
    GotoState('InCombat');
    //return;    
}

function Popped()
{
    super(EvilAICmd_Base_Combat).Popped();
    Outer.MyAdvPawn.bCanSlowDown = bSavedCanSlowDown;
    //return;    
}

function bool HasActiveDanger()
{
    local EvilProjectile_Base Proj;

    Proj = EvilProjectile_Base(DangerActor);
    // End:0x4D
    if(Proj != none)
    {
        return !Proj.bExploded;
    }
    return DangerActor != none;
    //return ReturnValue;    
}

function bool IsPawnInSafeDistance()
{
    local EvilProjectile_Base Proj;

    Proj = EvilProjectile_Base(DangerActor);
    // End:0xB8
    if(Proj != none)
    {
        return VSizeSq(Outer.MyEvilPawn.Location - Proj.Location) > Square(Proj.ExplosionArchetype.DamageRadius);
    }
    return DangerActor == none;
    //return ReturnValue;    
}

function bool MoveToNearestSafeCover()
{
    local CoverInfo CovToEnemy;

    // End:0x64
    if(Outer.EvaluateCover(2, DangerActor, CovToEnemy))
    {
        Outer.SetCoverGoal(CovToEnemy);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function MoveToSafePoint()
{
    local EvilProjectile_Base Proj;
    local float MoveRadius;

    Proj = EvilProjectile_Base(DangerActor);
    // End:0xA7
    if(Proj != none)
    {
        MoveRadius = (Outer.MyAdvPawn.GetCollisionRadius() * float(4)) + Proj.ExplosionArchetype.DamageRadius;        
    }
    else
    {
        MoveRadius = Outer.MyAdvPawn.GetCollisionRadius() * float(4);
    }
    Outer.SetMovePoint(Outer.GetBestEvadeLocation(MoveRadius, DangerActor.Location));
    bCanOuterFastSpinUp = false;
    //return;    
}

state InCombat
{
    function bool MoveToInitialCover()
    {
        // End:0x2F
        if(!Outer.HasValidCover())
        {
            return MoveToNearestSafeCover();
        }
        return true;
        //return ReturnValue;        
    }

    function bool MoveToBetterCover()
    {
        return MoveToNearestSafeCover();
        //return ReturnValue;        
    }

    function bool ShouldChangeCover()
    {
        // End:0x4F
        if(!Outer.HasValidCover() || !Outer.IsAtCover())
        {
            return true;            
        }
        else
        {
            // End:0xBF
            if(Outer.FastTrace(Outer.MyAdvPawn.Location, DangerActor.Location))
            {
                return true;
            }
        }
        return false;
        //return ReturnValue;        
    }
Begin:

    // End:0x50
    if(!HasActiveDanger() || IsPawnInSafeDistance())
    {
        Outer.Focus = Attacker;
        ExitWithSuccess();
    }
CoverCheck:


    // End:0x103
    if(ShouldChangeCover())
    {
        // End:0xD5
        if(!Outer.HasValidCover() || !Outer.IsAtCover())
        {
            // End:0xD2
            if(!MoveToInitialCover())
            {
                // End:0xCF
                if(!IsPawnInSafeDistance())
                {
                    MoveToSafePoint();
                }                
            }            
        }
        else
        {
            // End:0x100
            if(!MoveToBetterCover())
            {
                // End:0xFD
                if(!IsPawnInSafeDistance())
                {
                    MoveToSafePoint();
                }                
            }
        }        
    }
    else
    {
        // End:0x169
        if(Outer.HasValidCover() && Outer.IsAtCover())
        {
            Outer.Sleep(0.1000000);            
        }
    }
    J0x169:

    goto 'Begin';
    stop;                    
}
