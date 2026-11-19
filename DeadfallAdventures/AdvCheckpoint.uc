class AdvCheckpoint extends Checkpoint;

static function ShowSavingContentWarning(optional float MinDisplayTime = 3.0000000)
{
    local AdvUIManager UIManager;

    UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
    // End:0x77
    if(UIManager != none)
    {
        UIManager.OpenUpdatingScene(,,, true, MinDisplayTime);
    }
    //return;    
}

static function HideSavingContentWarning()
{
    local AdvUIManager UIManager;

    UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
    // End:0x61
    if(UIManager != none)
    {
        UIManager.CloseUpdatingScene(true);
    }
    //return;    
}

event PostSaveCheckpoint()
{
    super.PostSaveCheckpoint();
    //return;    
}

event SaveWasSkipped()
{
    local WorldInfo WI;
    local EvilPlayerController PC;

    WI = Class'Engine.WorldInfo'.static.GetWorldInfo();
    // End:0x8D
    if(WI != none)
    {
        // End:0x8C
        foreach WI.AllControllers(Class'EvilGame.EvilPlayerController', PC)
        {
            PC.NotifyCheckpointSkipped();            
        }        
    }
    //return;    
}

event FillCheckpointWithAdditionalData()
{
    local int I;
    local AdvEngine Eng;

    Eng = AdvEngine(Class'AdvEngine'.static.GetEngine());
    I = 0;
    J0x3D:

    // End:0x112 [Loop If]
    if(I < Eng.TemporaryCollectedTreasureIDs.Length)
    {
        // End:0x104
        if(HeaderData.UniqueCollectedTreasures.Find(Eng.TemporaryCollectedTreasureIDs[I]) == )
        {            
            HeaderData.UniqueCollectedTreasures.AddItem(Eng.TemporaryCollectedTreasureIDs[I]);            
        }
        I++;
        // [Loop Continue]
        goto J0x3D;
    }
    // End:0x15F
    if(int(bIsLevelStart) == int(1))
    {
        HeaderData.LevelInitialUniqueCollectedTreasures = HeaderData.UniqueCollectedTreasures;
    }
    Eng.TemporaryCollectedTreasureIDs.Length = 0;
    //return;    
}

event PostLoadCheckpoint()
{
    local AdvEngine Eng;

    Eng = AdvEngine(Class'AdvEngine'.static.GetEngine());
    Eng.TemporaryCollectedTreasureIDs.Length = 0;
    //return;    
}

event PreLoadCheckpoint()
{
    local WorldInfo WI;
    local EvilGame Game;

    WI = Class'Engine.WorldInfo'.static.GetWorldInfo();
    // End:0x7E
    if(WI.Game != none)
    {
        Game = EvilGame(WI.Game);
    }
    // End:0xE7
    if((Game != none) && Game.AIDirectorInstance != none)
    {
        Game.AIDirectorInstance.Cleanup();
    }
    // End:0x166
    if(EvilGameReplicationInfo(WI.GRI) != none)
    {
        EvilGameReplicationInfo(WI.GRI).GOP.CleanupEmitters();
    }
    //return;    
}

defaultproperties
{
    ActorClassesToRecord=/* Array type was not detected. */
    ActorClassesToDestroy=/* Array type was not detected. */
}