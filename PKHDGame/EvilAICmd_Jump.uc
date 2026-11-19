class EvilAICmd_Jump extends EvilAICommand within EvilAIController;

static function bool InitJump(EvilAIController AI)
{
    local EvilAICmd_Jump Cmd;

    // End:0x7F
    if((AI != none) && AI.Pawn != none)
    {
        Cmd = new (AI) Class'EvilAICmd_Jump';
        AI.PushCommand(Cmd);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function Pushed()
{
    super.Pushed();
    Outer.bAllowCombatTransitions = false;
    //return;    
}

function Popped()
{
    super(GameAICommand).Popped();
    Outer.bAllowCombatTransitions = true;
    //return;    
}

function PawnLanded(Vector HitNormal, Actor FloorActor)
{
    GotoState('Jumping', 'Landed');
    //return;    
}

auto state Jumping
{
    function bool GroundCheck()
    {
        local float FallingVelocity, PreLandTime;
        local Vector Grav, HowFar, outHitLoc, OutHitNorm, TraceStart, TraceEnd;

        local Actor Hit;

        FallingVelocity = Outer.MyEvilPawn.Velocity.Z;
        // End:0x267
        if(FallingVelocity < float(0))
        {
            PreLandTime = Outer.MyEvilPawn.CurrentJumpInfo.PreLandTime;
            Grav.Z = Outer.GetGravityZ();
            HowFar = (Outer.MyEvilPawn.Velocity * PreLandTime) + (((0.5000000 * Grav) * PreLandTime) * PreLandTime);
            TraceStart = Outer.MyEvilPawn.Location;
            TraceStart.Z -= Outer.MyEvilPawn.GetCollisionHeight();
            TraceEnd = TraceStart + HowFar;
            Hit = Outer.Trace(outHitLoc, OutHitNorm, TraceEnd, TraceStart);
            // End:0x267
            if(Hit != none)
            {
                return true;
            }
        }
        return false;
        //return ReturnValue;        
    }
Begin:

    Outer.MyEvilPawn.ServerDoPawnAction(26, true);
Falling:


    Outer.MyEvilPawn.ServerDoPawnAction(27, true);
    J0x74:

    // End:0xA3 [Loop If]
    if(!GroundCheck())
    {
        Outer.Sleep(0.0500000);
        // [Loop Continue]
        goto J0x74;
    }
    Outer.MyEvilPawn.ServerDoPawnAction(28, true);
Landed:


    Outer.MyEvilPawn.GroundSpeed = Outer.MyEvilPawn.default.GroundSpeed;
    Outer.MyEvilPawn.ServerDoPawnAction(29, true);
End:


    Outer.MyEvilPawn.JumpKismetAction.ForceActivateOutput(0);
    Outer.MyEvilPawn.JumpKismetAction = none;
    Outer.MyEvilPawn.CurrentJumpInfo = none;
    Outer.PopCommand(self);
    stop;        
}

defaultproperties
{
    bIgnoreNotifies=true
}