class PKCheckpoint extends Checkpoint;

static function ShowSavingContentWarning(optional float MinDisplayTime = 3.0000000)
{
    local PKUIManager UIManager;

    UIManager = PKUIManager(Class'Engine.UIManager'.static.GetUIManager());
    // End:0x75
    if(UIManager != none)
    {
        UIManager.OpenUpdatingScene(,,, true, MinDisplayTime);
    }
    //return;    
}

static function HideSavingContentWarning()
{
    local PKUIManager UIManager;

    UIManager = PKUIManager(Class'Engine.UIManager'.static.GetUIManager());
    // End:0x61
    if(UIManager != none)
    {
        UIManager.CloseUpdatingScene(true);
    }
    //return;    
}

event PostSaveCheckpoint()
{
    local PKPlayerController PC;
    local PainGRI PGRI;

    super.PostSaveCheckpoint();
    PGRI = PainGRI(Class'Engine.WorldInfo'.static.GetWorldInfo().GRI);
    // End:0xE2
    if(!PGRI.IsCoopMultiplayerGame())
    {
        // End:0xE1
        foreach Class'Engine.WorldInfo'.static.GetWorldInfo().AllControllers(Class'PKPlayerController', PC)
        {
            PC.SetLastCompletedLevelID(0);            
        }        
    }
    //return;    
}

defaultproperties
{
    ActorClassesToRecord=/* Array type was not detected. */
    ActorClassesToDestroy=/* Array type was not detected. */
    ActorClassesNotToDestroy=/* Array type was not detected. */
}