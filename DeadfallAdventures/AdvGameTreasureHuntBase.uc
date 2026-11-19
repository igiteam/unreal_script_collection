class AdvGameTreasureHuntBase extends AdvGameDeathmatchBase
    config(Game)
    hidecategories(Navigation,Movement,Collision);

var int ScoreForPickingTeamTreasureUp;
var int ScoreForPickingEnemyTreasureUp;
var int ScoreForTreasureExchange;

function ScoreTreasurePickUp(Controller Scorer, AdvMultiplayerTreasure Treasure)
{
    local AdvPRI PRI;

    // End:0x32C
    if(Scorer.PlayerReplicationInfo != none)
    {
        PRI = AdvPRI(Scorer.PlayerReplicationInfo);
        // End:0x1A6
        if(PRI.Team.TeamIndex == Treasure.TeamIndex)
        {
            PRI.TeamMultiplayerTreasuresColected++;
            PRI.TotalTeamMultiplayerTreasuresColected++;
            PRI.Score += float(ScoreForPickingTeamTreasureUp);
            // End:0x182
            if(AdvGRI(WorldInfo.GRI).CanWriteStats())
            {
                AdvPlayerControllerMP(Scorer).IncrementGlobalIntStat(123);
            }
            PRI.bForceNetUpdate = true;            
        }
        else
        {
            PRI.EnemyMultiplayerTreasuresColected++;
            PRI.TotalEnemyMultiplayerTreasuresColected++;
            PRI.Score += float(ScoreForPickingEnemyTreasureUp);
            // End:0x27D
            if(AdvGRI(WorldInfo.GRI).CanWriteStats())
            {
                AdvPlayerControllerMP(Scorer).IncrementGlobalIntStat(122);
            }
            PRI.bForceNetUpdate = true;
        }
        AdvPlayerControllerMP(Scorer).SetOracleParticles(PRI.EnemyMultiplayerTreasuresColected >= PRI.BlessingManager.BlessingCost);
        CheckScore(PRI);
    }
    //return;    
}

function ScoreTreasureExchange(AdvPRI ScorerPRI, int TreasuresAmount)
{
    // End:0x66
    if(ScorerPRI != none)
    {
        ScorerPRI.Score += float(ScoreForTreasureExchange * TreasuresAmount);
        ScorerPRI.bForceNetUpdate = true;
    }
    //return;    
}

function ScoreKill(Controller Killer, Controller Other)
{
    local AdvMultiplayerTreasure T;

    super.ScoreKill(Killer, Other);
    // End:0x1BB
    if((((((Killer != Other) && Killer != none) && Other != none) && Killer.PlayerReplicationInfo != none) && Other.PlayerReplicationInfo != none) || ((Killer == none) && Other != none) && AdvPlayerControllerMP(Other).bKilledByTrap)
    {
        T = Spawn(Class'AdvMultiplayerTreasure',,, Other.Pawn.Location);
        T.SetTeamIndex(Other.PlayerReplicationInfo.Team.TeamIndex);
        // End:0x1BB
        if(T == none)
        {
        }
    }
    //return;    
}

function GenericPlayerInitialization(Controller C)
{
    // End:0x22
    if(!bUseClassicHUD)
    {
        HUDType = Class'AdvGFxHudWrapperMP_TH';
    }
    super(GameInfo).GenericPlayerInitialization(C);
    CommonForGenericPlayerInitialization(C);
    //return;    
}

function IncrementEndGameStatistics(AdvPlayerControllerMP Winner)
{
    Winner.IncrementGlobalIntStat(135);
    //return;    
}

defaultproperties
{
    ScoreForPickingEnemyTreasureUp=500
    StartMatchSound[0]=SoundCue'a_anno_thtth01_cue.ANNO_THTTH_BEG_001'
    StartMatchSound[1]=SoundCue'a_anno_thtth01_cue.ANNO_THTTH_BEG_002'
    StartMatchSound[2]=SoundCue'a_anno_thtth01_cue.ANNO_THTTH_BEG_003'
    StartMatchSound[3]=SoundCue'a_anno_thtth01_cue.ANNO_THTTH_BEG_004'
    StartMatchStringKey[0]="ANNO_THTTH_BEG_001"
    StartMatchStringKey[1]="ANNO_THTTH_BEG_002"
    StartMatchStringKey[2]="ANNO_THTTH_BEG_003"
    StartMatchStringKey[3]="ANNO_THTTH_BEG_004"
    EndMatchSoundWin[0]=SoundCue'a_anno_dthtth01_cue.ANNO_DTHTTH_WON_001'
    OnlineStatsWriteClass=Class'AdvLeaderboard_Write_TH'
    OnlineGameSettingsClass=Class'AdvGameTreasureHuntSettings'
}