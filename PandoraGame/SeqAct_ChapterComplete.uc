class SeqAct_ChapterComplete extends SequenceAction
    native;

enum EPanChapterType
{
    EPanChapter_None,               // 0
    EPanChapter_Ep01,               // 1
    EPanChapter_Ep02,               // 2
    EPanChapter_Ep03,               // 3
    EPanChapter_Ep04,               // 4
    EPanChapter_Ep05,               // 5
    EPanChapter_Ep06,               // 6
    EPanChapter_Ep07,               // 7
    EPanChapter_Ep08,               // 8
    EPanChapter_MAX                 // 9
};

var() SeqAct_ChapterComplete.EPanChapterType ChapterToUnlock;

event Activated()
{
    local PlayerController HostPC;
    local PandoraPlayerController PC;
    local SeqAct_ChapterComplete.EPanChapterType currentChapter;
    local int Temp;

    currentChapter = ChapterToUnlock;
    // End:0x3D
    if(int(currentChapter) > int(0))
    {
        Temp = int(currentChapter);
        Temp -= 1;
        currentChapter = byte(Temp);
    }
    // End:0x149
    foreach GetWorldInfo().LocalPlayerControllers(Class'Engine.PlayerController', HostPC)
    {
        PC = PandoraPlayerController(HostPC);
        // End:0x148
        if((PC != none) && PC.ProfileSettings != none)
        {
            PC.ProfileSettings.UnlockChapter(int(currentChapter));
            PC.ProfileSettings.UnlockChapter(int(ChapterToUnlock));
            // End:0x111
            if(!PC.ProfileSettings.OkToWriteProfile())
            {
                PC.bDelayedProfileWrite = true;                
            }
            else
            {
                PC.ProfileSettings.SetProfileDirty(true);
                PC.WriteProfile();
            }
            // End:0x149
            break;
        }        
    }    
    //return;    
}
