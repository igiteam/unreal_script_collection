class AdvAICmd_Attack_FireFromCover extends EvilAICommand within AdvAIController_Cover;

var float TimeOut;

static function bool FireFromCover(AdvAIController_Cover AI)
{
    local AdvAICmd_Attack_FireFromCover Cmd;

    Cmd = new (AI) Class'AdvAICmd_Attack_FireFromCover';
    // End:0x59
    if(Cmd != none)
    {
        AI.PushCommand(Cmd);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function Pushed()
{
    super.Pushed();
    Outer.bFailedToFireFromCover = false;
    GotoState('Firing');
    //return;    
}

function Popped()
{
    super(GameAICommand).Popped();
    Outer.LastFireFromCoverTime = Outer.WorldInfo.TimeSeconds;
    Outer.bFailedToFireFromCover = Status != 'Success';
    Outer.ResetCoverAction();
    //return;    
}

function bool SelectEnemyAndCoverAction()
{
    // End:0x82
    if(Outer.SelectTarget())
    {
        // End:0x82
        if(Outer.GetCoverAction(Outer.Cover, Outer.ShotTarget))
        {
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

state Firing
{PrepareFire:

    // End:0x234
    if(SelectEnemyAndCoverAction())
    {
        Outer.MyEvilPawn.CheckMirrorTransition(Outer.PendingFireLinkItem.SrcAction);
        J0x73:

        Outer.Sleep(0.1000000);
        // End:0x73
        if(!(!Outer.IsTransitioning()))
            goto J0x73;
        // End:0x166
        if(int(Outer.PendingFireLinkItem.SrcAction) == int(0))
        {
            // End:0x163
            if(int(Outer.MyEvilPawn.CoverType) == int(2))
            {
                Outer.MyEvilPawn.ShouldCrouch(true);
            }            
        }
        else
        {
            Outer.SetCoverAction(Outer.PendingFireLinkItem.SrcAction);
        }
        J0x1B6:

        Outer.Sleep(0.3000000);
        // End:0x1B6
        if(!(!Outer.IsTransitioning()))
            goto J0x1B6;
        // End:0x227
        if(Outer.HasValidTarget())
        {
            goto 'FireWeapon';            
        }
        else
        {
            goto 'ReturnToCover';
        }        
    }
    else
    {
        ExitWithFailure();
    }
    J0x23E:

    Outer.Focus = Outer.ShotTarget;
    Outer.MyEvilPawn.OnStartFire();
    J0x2AF:

    // End:0x346 [Loop If]
    if(!Outer.GetCoverAction(Outer.Cover, Outer.ShotTarget))
    {
        Outer.MyEvilPawn.OnStopFire();
        goto J0x83D;
    }
    // End:0x83D
    if((Outer.MyEvilPawn.LastCoverActionTime + 1.0000000) < Outer.WorldInfo.TimeSeconds)
    {
        // End:0x83D
        if(((((int(Outer.PendingFireLinkItem.SrcAction) != int(Outer.MyEvilPawn.CoverAction)) && int(Outer.MyEvilPawn.CoverAction) != int(5)) && !Outer.MyEvilPawn.IsBlindFiring(Outer.PendingFireLinkItem.SrcAction)) && !Outer.MyEvilPawn.IsBlindFiring(Outer.MyEvilPawn.CoverAction)) && (Outer.MyEvilPawn.IsRightCoverAction(Outer.MyEvilPawn.CoverAction) != Outer.MyEvilPawn.IsRightCoverAction(Outer.PendingFireLinkItem.SrcAction)) || Outer.MyEvilPawn.IsLeftCoverAction(Outer.MyEvilPawn.CoverAction) != Outer.MyEvilPawn.IsLeftCoverAction(Outer.PendingFireLinkItem.SrcAction))
        {
            Outer.ResetCoverAction();
            J0x705:

            Outer.Sleep(0.1000000);
            // End:0x705
            if(!(!Outer.IsTransitioning()))
                goto J0x705;
            Outer.MyEvilPawn.CheckMirrorTransition(Outer.PendingFireLinkItem.SrcAction);
            J0x7AC:

            Outer.Sleep(0.1000000);
            // End:0x7AC
            if(!(!Outer.IsTransitioning()))
                goto J0x7AC;
            Outer.SetCoverAction(Outer.PendingFireLinkItem.SrcAction);
        }
    }
    J0x83D:

    Outer.Sleep(0.1000000);
    // End:0x83D
    if(!(!Outer.IsTransitioning()))
        goto J0x83D;
    // End:0x957
    if(Outer.MyAdvPawn_Armed_Base.bBlindedByLight && !Outer.MyEvilPawn.IsBlindFiring(Outer.MyEvilPawn.CoverAction))
    {
        Outer.MyEvilPawn.OnStopFire();
    }
    // End:0x2AF
    if(!(Outer.MyEvilPawn.IsReloading() || !Outer.IsFiring()))
        goto J0x2AF;
ReturnToCover:


    Outer.ResetCoverAction();
    J0x9D4:

    Outer.Sleep(0.2500000);
    // End:0x9D4
    if(!(!Outer.IsTransitioning()))
        goto J0x9D4;
Finish:


    ExitWithSuccess();
    stop;                    
}

defaultproperties
{
    TimeOut=2.0000000
    bFiringCommand=true
    bIgnoreStepAside=true
}