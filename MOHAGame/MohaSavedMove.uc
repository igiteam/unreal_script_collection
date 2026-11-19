class MohaSavedMove extends SavedMove;

var bool bIronsightsActive;
var bool bFlaredChute;
var bool bLeftLean;
var bool bRightLean;
var bool bPeek;

function Clear()
{
    super.Clear();
    bIronsightsActive = false;
    bFlaredChute = false;
    bLeftLean = false;
    bRightLean = false;
    bPeek = false;
    //return;    
}

function bool IsImportantMove(Vector CompareAccel)
{
    return bDuck || super.IsImportantMove(CompareAccel);
    //return ReturnValue;    
}

function bool CanCombineWith(SavedMove NewMove, Pawn inPawn, float MaxDelta)
{
    return (((super.CanCombineWith(NewMove, inPawn, MaxDelta) && bIronsightsActive == MohaSavedMove(NewMove).bIronsightsActive) && bFlaredChute == MohaSavedMove(NewMove).bFlaredChute) && !bDuck) && !NewMove.bDuck;
    //return ReturnValue;    
}

function SetMoveFor(PlayerController PC, float DeltaTime, Vector newAccel, Actor.EDoubleClickDir InDoubleClick)
{
    local MOHAMultiplayerController mpc;
    local MOHAMultiplayerPawn MPP;

    mpc = MOHAMultiplayerController(PC);
    MPP = MOHAMultiplayerPawn(PC.Pawn);
    super.SetMoveFor(PC, DeltaTime, newAccel, InDoubleClick);
    bIronsightsActive = (MPP != none) && MPP.IsIronsightsActive() || MPP.IronsightsControlEnabled();
    bRun = mpc.bSprintRequested;
    bPressedJump = mpc.bSavedJumpRequested;
    // End:0xDF
    if((MPP != none) && int(MPP.eDesiredStance) == int(1))
    {
        bDuck = true;        
    }
    else
    {
        bDuck = false;
    }
    bFlaredChute = mpc.bFlaring;
    // End:0x15F
    if(MPP != none)
    {
        bLeftLean = MPP.CheckLeanState(1);
        bRightLean = MPP.CheckLeanState(2);
        bPeek = MPP.CheckLeanState(3);        
    }
    else
    {
        bLeftLean = false;
        bRightLean = false;
        bPeek = false;
    }
    //return;    
}

function byte CompressedFlags()
{
    local byte Result;

    // End:0x13
    if(bIronsightsActive)
    {
        Result += byte(1);
    }
    // End:0x27
    if(bRun)
    {
        Result += byte(2);
    }
    // End:0x3B
    if(bDuck)
    {
        Result += byte(4);
    }
    // End:0x4F
    if(bPressedJump)
    {
        Result += byte(8);
    }
    // End:0x63
    if(bFlaredChute)
    {
        Result += byte(16);
    }
    // End:0x77
    if(bPeek)
    {
        Result += byte(32);
    }
    // End:0x8B
    if(bLeftLean)
    {
        Result += byte(64);
    }
    // End:0x9F
    if(bRightLean)
    {
        Result += byte(128);
    }
    return Result;
    //return ReturnValue;    
}

static function Actor.EDoubleClickDir SetFlags(byte Flags, PlayerController PC)
{
    local MOHAPlayerController mpc;
    local MOHAMultiplayerPawn MPP;

    // End:0x1C
    if(LocalPlayer(PC.Player) != none)
    {
        return 0;
    }
    MPP = MOHAMultiplayerPawn(PC.Pawn);
    mpc = MOHAPlayerController(PC);
    mpc.bSprintRequested = (int(Flags) & 2) != 0;
    // End:0xEB
    if(MPP != none)
    {
        // End:0xAE
        if(((int(Flags) & 4) != 0) && int(MPP.eDesiredStance) != int(1))
        {
            mpc.bStanceChangeRequested = true;            
        }
        else
        {
            // End:0xEB
            if(((int(Flags) & 4) == 0) && int(MPP.eDesiredStance) != int(0))
            {
                mpc.bStanceChangeRequested = true;
            }
        }
    }
    mpc.bJumpRequested = mpc.bJumpRequested || (int(Flags) & 8) != 0;
    // End:0x210
    if(MPP != none)
    {
        MPP.bIronsightsActive = (int(Flags) & 1) != 0;
        MPP.UpdateLeanState(3, (int(Flags) & 32) != 0);
        MPP.UpdateLeanState(1, (int(Flags) & 64) != 0);
        MPP.UpdateLeanState(2, (int(Flags) & 128) != 0);
        // End:0x1EA
        if((int(Flags) & 16) != 0)
        {
            // End:0x1E7
            if(!mpc.bFlaring)
            {
                mpc.FlareChute();
            }            
        }
        else
        {
            // End:0x210
            if(mpc.bFlaring)
            {
                mpc.FlareChuteEnd();
            }
        }
    }
    mpc.NotifyPawnOfSprint();
    return 0;
    //return ReturnValue;    
}
