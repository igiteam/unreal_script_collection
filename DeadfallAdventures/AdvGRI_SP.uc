class AdvGRI_SP extends AdvGRI
    config(Game)
    hidecategories(Navigation,Movement,Collision);

var int ChapterNum;
var bool bForceNextLevel;
var repnotify bool bMusicTrackMuted;
var bool b666AmmoCardEnabled;

replication
{
    // Pos:0x000
    if(bNetDirty
        ChapterNum;

    // Pos:0x00A
    if((int(Role) == int(ROLE_Authority)) && bNetDirty
        b666AmmoCardEnabled, bMusicTrackMuted;
}

simulated event ReplicatedEvent(name VarName)
{
    // End:0x64
    if(VarName == 'bMusicTrackMuted')
    {
        WorldInfo.MusicComp.VolumeMultiplier = ((bMusicTrackMuted) ? 1.0000000 : 0.0000000);
    }
    //return;    
}

reliable server function ShowAndWriteLevelStatistics(bool bSuppressSaveCheckpoint)
{
    local AdvPlayerController PC;
    local LevelStatistics ls;

    CopyGlobalStatisticsToLevelStatisticsStruct(ls);
    Finished = true;
    // End:0xE0
    foreach WorldInfo.AllControllers(Class'AdvPlayerController', PC)
    {
        // End:0xAB
        if(PC.Pawn != none)
        {
            PC.Pawn.ZeroMovementVariables();
        }
        PC.WriteEndLevelStatistics(byte(ChapterNum), bSuppressSaveCheckpoint);        
    }    
    SetTimer(3.0000000, false, 'ServerShowEndStatisticsScreenOnClients_T');
    //return;    
}

reliable server function ServerShowEndStatisticsScreenOnClients_T()
{
    Class'AdvGFxUI_EndStats'.static.StartNextLevel();
    //return;    
}

function EndOfGame()
{
    local AdvPlayerController PC;

    // End:0x54
    foreach WorldInfo.AllControllers(Class'AdvPlayerController', PC)
    {
        PC.WriteEndGameInformations();        
    }    
    //return;    
}
