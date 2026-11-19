class SeqAct_IsGameCompleted extends SequenceAction
    native;

event Activated()
{
    local PlayerController HostPC;
    local PandoraPlayerController PC;
    local bool bGameComplete;
    local int ChapterUnlocked, I;

    // End:0xC0
    foreach GetWorldInfo().LocalPlayerControllers(Class'Engine.PlayerController', HostPC)
    {
        PC = PandoraPlayerController(HostPC);
        // End:0xBF
        if((PC != none) && PC.ProfileSettings != none)
        {
            ChapterUnlocked = PC.ProfileSettings.GetChapterCompleted();
            bGameComplete = true;
            I = 0;
            J0x83:

            // End:0xBC [Loop If]
            if(I < (9 - 1))
            {
                // End:0xB2
                if(((ChapterUnlocked >> I) & 1) == 0)
                {
                    bGameComplete = false;
                    // [Explicit Break]
                    goto J0xBC;
                }
                I++;
                // [Loop Continue]
                goto J0x83;
            }
            J0xBC:

            // End:0xC0
            break;
        }        
    }    
    // End:0xE2
    if(bGameComplete)
    {
        OutputLinks[0].bHasImpulse = true;        
    }
    else
    {
        OutputLinks[1].bHasImpulse = true;
    }
    //return;    
}
