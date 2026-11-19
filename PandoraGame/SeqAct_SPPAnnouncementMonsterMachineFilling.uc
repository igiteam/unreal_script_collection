class SeqAct_SPPAnnouncementMonsterMachineFilling extends SeqAct_SPPlayAnnouncement;

event Activated()
{
    local WorldInfo WI;
    local Pawn TargetPawn;
    local PandoraPlayerController targetController;

    TargetPawn = Pawn(Targets[0]);
    // End:0xB7
    if(TargetPawn != none)
    {
        targetController = PandoraPlayerController(TargetPawn.Controller);
        // End:0xB7
        if((targetController != none) && targetController.PlayerReplicationInfo != none)
        {
            // End:0xB7
            if(!targetController.m_bShowedFillMessage)
            {
                targetController.m_bShowedFillMessage = true;
                WI = GetWorldInfo();
                WI.BroadcastLocalizedMessage(MessageClass, 0, targetController.PlayerReplicationInfo);
            }
        }
    }
    //return;    
}
