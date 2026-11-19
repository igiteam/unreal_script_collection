class SkySeqAct_RestartPlayer extends SequenceAction
    native;

event Activated()
{
    local SkyPlayerController TargetController;
    local Pawn TargetPawn;
    local int I;

    I = 0;
    J0x07:

    // End:0x105 [Loop If]
    if(I < Targets.Length)
    {
        TargetController = SkyPlayerController(Targets[I]);
        // End:0x73
        if(TargetController == none)
        {
            TargetPawn = Pawn(Targets[I]);
            // End:0x73
            if(TargetPawn != none)
            {
                TargetController = SkyPlayerController(TargetPawn.Controller);
            }
        }
        // End:0xFB
        if(TargetController != none)
        {
            TargetController.bResettingPlayer = true;
            // End:0xBC
            if(TargetController.Pawn != none)
            {
                TargetController.Pawn.Destroy();
            }
            TargetController.WorldInfo.Game.RestartPlayer(TargetController);
            TargetController.bResettingPlayer = false;
        }
        ++I;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}
