class AdvAICmd_CoverFromLight extends EvilAICmd_Base_Burning within AdvAIController;

var int SelectedStrafeIndex;
var int PackedAnimInfo;
var bool bWasBurning;
var bool bIsNotInLightInfluence;

function Pushed()
{
    super(EvilAICmd_Base_Combat).Pushed();
    Outer.MyEvilPawn.ZeroMovementVariables();
    GotoState('InCombat');
    //return;    
}

function Popped()
{
    super(EvilAICmd_Base_Combat).Popped();
    //return;    
}

function Resumed(name OldCommandName)
{
    super(GameAICommand).Resumed(OldCommandName);
    // End:0xC6
    if(!Outer.MyAdvPawn.HasShield())
    {
        // End:0xC6
        if(Outer.CoverFromLightStartTime < 0.0000000)
        {
            Outer.CoverFromLightStartTime = Outer.WorldInfo.TimeSeconds;
        }
    }
    // End:0x15F
    if(!Outer.MyEvilPawn.bCanBeAffectedByLight)
    {
        Outer.BeginCombatCommand(Outer.DefaultCommand, "CantBeAffectedByLightOnResume");        
    }
    else
    {
        // End:0x199
        if(!Outer.HasValidEnemy())
        {
            GotoState('InCombat', 'Begin');
        }
    }
    //return;    
}

function ToggleStrafes()
{
    local int I;
    local bool bCustomStrafeDisabled;

    bCustomStrafeDisabled = ((VSizeSq(Outer.Enemy.Location - Outer.MyEvilPawn.Location) < Square(Outer.EnemyDistance_MeleeCharge)) || int(Outer.StrafesData[Outer.LastStrafeIndex].StrafeDirection) == int(6)) || int(Outer.StrafesData[Outer.LastStrafeIndex].StrafeDirection) == int(7);
    I = 0;
    J0x15C:

    // End:0x233 [Loop If]
    if(I < Outer.StrafesData.Length)
    {
        switch(Outer.StrafesData[I].StrafeDirection)
        {
            // End:0x1D3
            case 6:
            // End:0x222
            case 7:
                Outer.StrafesData[I].bDisabled = bCustomStrafeDisabled;
                // End:0x225
                break;
            // End:0xFFFF
            default:
                break;
        }
        I++;
        // [Loop Continue]
        goto J0x15C;
    }
    //return;    
}

function EvilTypesNative.EStrafeDirection GetCoverFromLightStrafeDirection()
{
    local bool bCanStrafeLeft, bCanStrafeRight;
    local EvilStrafeData LeftStrafe, RightStrafe;
    local Vector RightDir;

    RightDir = GetRotatorAxis(Outer.Rotation, 1);
    LeftStrafe.StrafePoint = Outer.Location - (RightDir * 150.0000000);
    RightStrafe.StrafePoint = Outer.Location + (RightDir * 150.0000000);
    bCanStrafeRight = Outer.NavigationHandle.PointReachable(RightStrafe.StrafePoint);
    bCanStrafeLeft = Outer.NavigationHandle.PointReachable(LeftStrafe.StrafePoint);
    // End:0x2EF
    if(bCanStrafeLeft && bCanStrafeRight)
    {
        RightStrafe.Rating = Outer.RateStrafeByFlankEnemy(RightStrafe, Outer.StrafesData);
        LeftStrafe.Rating = Outer.RateStrafeByFlankEnemy(LeftStrafe, Outer.StrafesData);
        // End:0x2AC
        if(RightStrafe.Rating > LeftStrafe.Rating)
        {
            return 3;            
        }
        else
        {
            // End:0x2EC
            if(RightStrafe.Rating < LeftStrafe.Rating)
            {
                return 2;
            }
        }        
    }
    else
    {
        // End:0x302
        if(bCanStrafeLeft)
        {
            return 2;            
        }
        else
        {
            // End:0x312
            if(bCanStrafeRight)
            {
                return 3;
            }
        }
    }
    return ((FRand() < 0.5000000) ? 2 : 3);
    //return ReturnValue;    
}

state InCombat
{Begin:

    // End:0x19A
    if((Outer.CoverFromLightStartTime >= 0.0000000) && (Outer.CoverFromLightStartTime + Outer.CoverFromLightTime) < Outer.WorldInfo.TimeSeconds)
    {
        // End:0x143
        if(Outer.MyEvilPawn.bOnLightInfluenceFromFlashLight)
        {
            Outer.MyAdvPawn.bShouldWalkFast = true;
            Outer.MyAdvPawn.ForceLimitedMoveMode(1);
        }
        Outer.BeginCombatCommand(Outer.DefaultCommand, "CoverFromLightExceed");        
    }
    else
    {
        // End:0x24A
        if(!Outer.MyEvilPawn.bOnLightInfluenceFromFlashLight)
        {
            // End:0x23B
            if(bIsNotInLightInfluence)
            {
                Outer.BeginCombatCommand(Outer.DefaultCommand, "NotInFlashlightInfluence");                
            }
            else
            {
                bIsNotInLightInfluence = true;
            }            
        }
        else
        {
            bIsNotInLightInfluence = false;
        }
    }
    // End:0x2E1
    if((Outer.CoverFromLightStartTime < 0.0000000) && !bIsNotInLightInfluence)
    {
        Outer.CoverFromLightStartTime = Outer.WorldInfo.TimeSeconds;
    }
    // End:0x32C
    if(!Outer.HasValidEnemy())
    {
        Outer.Sleep(0.1000000);
        goto 'Begin';
    }
    Outer.Focus = Outer.Enemy;
    // End:0x39B
    if(Outer.LastStrafeIndex > -1)
    {
        ToggleStrafes();
    }
    SelectedStrafeIndex = Outer.GetBestStrafeByDirectionIndex(Outer.OnRateStrafeByFlankEnemy, Outer.Enemy);
    // End:0x45A
    if(SelectedStrafeIndex < 0)
    {
        PackedAnimInfo = Outer.MyAdvPawn.GetCoverFromLightStartAnimPackedIndex();        
    }
    else
    {
        // End:0x4E5
        if((bWasBurning != true) && Outer.MyAdvPawn.IsBurning())
        {
            PackedAnimInfo = Outer.MyAdvPawn.GetCoverFromLightHitAnimPackedIndex();            
        }
        else
        {
            PackedAnimInfo = -1;
            switch(Outer.StrafesData[SelectedStrafeIndex].StrafeDirection)
            {
                // End:0x6AC
                case 5:
                    // End:0x630
                    if((Outer.CoverFromLightStartTime + Outer.CoverFromLightTime) > Outer.WorldInfo.TimeSeconds)
                    {
                        PackedAnimInfo = Outer.MyAdvPawn.GetCoverFromLightStrafeForwardAnimPackedIndex(Outer.StrafesData[SelectedStrafeIndex].AnimIndex);                        
                    }
                    else
                    {
                        PackedAnimInfo = Outer.MyAdvPawn.GetCoverFromLightStrafeForwardFastAnimPackedIndex(Outer.StrafesData[SelectedStrafeIndex].AnimIndex);
                    }
                    // End:0x974
                    break;
                // End:0x72D
                case 4:
                    PackedAnimInfo = Outer.MyAdvPawn.GetCoverFromLightStartAnimPackedIndex(Outer.StrafesData[SelectedStrafeIndex].AnimIndex);
                    // End:0x974
                    break;
                // End:0x7AE
                case 3:
                    PackedAnimInfo = Outer.MyAdvPawn.GetCoverFromLightStrafeRightAnimPackedIndex(Outer.StrafesData[SelectedStrafeIndex].AnimIndex);
                    // End:0x974
                    break;
                // End:0x82F
                case 2:
                    PackedAnimInfo = Outer.MyAdvPawn.GetCoverFromLightStrafeLeftAnimPackedIndex(Outer.StrafesData[SelectedStrafeIndex].AnimIndex);
                    // End:0x974
                    break;
                // End:0x8D0
                case 6:
                    Outer.Focus = none;
                    PackedAnimInfo = Outer.MyAdvPawn.GetCoverFromLightJumpLeftAnimPackedIndex(Outer.StrafesData[SelectedStrafeIndex].AnimIndex);
                    // End:0x974
                    break;
                // End:0x971
                case 7:
                    Outer.Focus = none;
                    PackedAnimInfo = Outer.MyAdvPawn.GetCoverFromLightJumpRightAnimPackedIndex(Outer.StrafesData[SelectedStrafeIndex].AnimIndex);
                    // End:0x974
                    break;
                // End:0xFFFF
                default:
                    break;
            }
        }
    }
    J0x974:

    // End:0xBC3
    if(true)
    {
        // End:0xAA1
        if(Outer.MyAdvPawn.CanDoPawnAction(57))
        {
            Outer.MyAdvPawn.ServerDoPawnAction(57,,, PackedAnimInfo);
            Outer.LastStrafeIndex = SelectedStrafeIndex;
            // End:0xA9E
            if(SelectedStrafeIndex > -1)
            {
                Outer.StrafesData[SelectedStrafeIndex].LastStrafeTime = Outer.WorldInfo.TimeSeconds;
            }            
        }
        else
        {
            // End:0xBA3
            if(Outer.MyEvilPawn.CanDoPawnAction(57))
            {
                // End:0xB57
                if(FRand() < 0.1000000)
                {
                    Outer.MyEvilPawn.ServerDoPawnAction(57,,, Outer.MyAdvPawn.GetCoverFromLightStopAnimPackedIndex());                    
                }
                else
                {
                    PackedAnimInfo = Outer.MyAdvPawn.GetCoverFromLightStartAnimPackedIndex();
                    goto 'PlayPackedAnim';
                }                
            }
            else
            {
                Outer.Sleep(0.1000000);
            }
        }        
    }
    else
    {
        // End:0xCC5
        if(Outer.MyEvilPawn.CanDoPawnAction(57))
        {
            // End:0xC79
            if(FRand() < 0.1000000)
            {
                Outer.MyAdvPawn.ServerDoPawnAction(57,,, Outer.MyAdvPawn.GetCoverFromLightStopAnimPackedIndex());                
            }
            else
            {
                PackedAnimInfo = Outer.MyAdvPawn.GetCoverFromLightStartAnimPackedIndex();
                goto 'PlayPackedAnim';
            }            
        }
        else
        {
            Outer.Sleep(0.1000000);
        }
    }
    bWasBurning = Outer.MyAdvPawn.IsBurning();
    J0xD21:

    Outer.Sleep(0.0100000);
    // End:0xD21
    if(!((int(Outer.MyAdvPawn.PawnAction) == 0) || bWasBurning != Outer.MyAdvPawn.IsBurning()))
        goto J0xD21;
    goto 'Begin';
    stop;                
}

defaultproperties
{
    PackedAnimInfo=-1
}