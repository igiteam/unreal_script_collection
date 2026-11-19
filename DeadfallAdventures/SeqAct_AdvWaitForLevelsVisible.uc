class SeqAct_AdvWaitForLevelsVisible extends SeqAct_WaitForLevelsVisible
    forcescriptorder(true)
    hidecategories(Object);

var() bool bShowIndicator;
var array<AdvPlayerController> CachedAPCs;

event Activated()
{
    local AdvPlayerController APC;
    local bool Result;
    local AdvUIManager UIManager;

    UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
    CachedAPCs.Remove(0, CachedAPCs.Length);    
    // End:0x94
    foreach GetWorldInfo().AllControllers(Class'AdvPlayerController', APC)
    {
        CachedAPCs.AddItem(APC);                
    }    
    Result = CheckLevelsVisible();
    // End:0x159
    if(!Result && bShowIndicator)
    {
        // End:0x155
        foreach CachedAPCs(APC)
        {
            Class'AdvUIManager'.static.OpenUpdatingScene(,,, true, 2.0000000);
            UIManager.CheckpointScene.TitleTF.SetText("");            
        }                
    }
    else
    {
        // End:0x1EB
        if(bShowIndicator)
        {
            // End:0x1EA
            foreach CachedAPCs(APC)
            {
                Class'AdvUIManager'.static.CloseUpdatingScene(true);
                UIManager.CheckpointScene.TitleTF.SetText("");                
            }            
        }
    }
    //return;    
}

event Deactivated()
{
    local AdvPlayerController APC;
    local AdvUIManager UIManager;

    // End:0xED
    if(bShowIndicator)
    {
        UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
        // End:0xEC
        foreach CachedAPCs(APC)
        {
            Class'AdvUIManager'.static.CloseUpdatingScene(true);
            Class'AdvUIManager'.static.OpenUpdatingScene(,,, true, 2.0000000, true);
            UIManager.CheckpointScene.TitleTF.SetText("");            
        }        
    }
    //return;    
}

defaultproperties
{
    bShouldBlockOnLoad=true
    ObjName="Adv Wait for Levels to be visible"
}