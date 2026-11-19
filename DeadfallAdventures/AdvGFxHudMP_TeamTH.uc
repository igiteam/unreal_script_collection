class AdvGFxHudMP_TeamTH extends AdvGFxHudMP_Team
    config(UI);

var int LastTreasuresAmount;
var int LocalActiveBlessings[5];

function SetHUDElementsVisible(bool Visible)
{
    super.SetHUDElementsVisible(Visible);
    ArtifactsMC.SetVisible(Visible);
    //return;    
}

function TickHud(float DeltaTime)
{
    local AdvPlayerController PC;
    local bool bBlessChanges;
    local int I, BlessingCount, CurrentTreasuresTFAmount;

    PC = AdvPlayerController(GetPC());
    // End:0x2E
    if(PC == none)
    {
        return;
    }
    // End:0x3C2
    if(AdvPRI(PC.PlayerReplicationInfo) != none)
    {
        ArtifactsMC.SetVisible(true);
        CurrentTreasuresTFAmount = AdvPRI(PC.PlayerReplicationInfo).EnemyMultiplayerTreasuresColected;
        // End:0x116
        if(CurrentTreasuresTFAmount != LastTreasuresAmount)
        {
            LastTreasuresAmount = CurrentTreasuresTFAmount;
            ArtifactsTF.SetText(string(CurrentTreasuresTFAmount));
        }
        bBlessChanges = false;
        I = 0;
        J0x12D:

        // End:0x222 [Loop If]
        if(I < 5)
        {
            // End:0x150
            if(I >= 7)
            {
                // [Explicit Break]
                goto J0x222;
            }
            // End:0x214
            if(LocalActiveBlessings[I] != AdvPRI(PC.PlayerReplicationInfo).ActiveBlessings[I])
            {
                LocalActiveBlessings[I] = AdvPRI(PC.PlayerReplicationInfo).ActiveBlessings[I];
                bBlessChanges = true;
            }
            I++;
            // [Loop Continue]
            goto J0x12D;
        }
        J0x222:

        // End:0x3BF
        if(bBlessChanges)
        {
            BlessingCount = 0;
            I = 0;
            J0x245:

            // End:0x333 [Loop If]
            if(I < 5)
            {
                // End:0x325
                if(LocalActiveBlessings[I] == 1)
                {
                    Blessings[BlessingCount].SetBool("visible", true);
                    Blessings[BlessingCount].SetString("source", "img://" $ Class'AdvBlessingManager'.default.AllBlessings[I].default.BlessingHUDIconPath);
                    BlessingCount++;
                }
                I++;
                // [Loop Continue]
                goto J0x245;
            }
            I = BlessingCount;
            J0x346:

            // End:0x397 [Loop If]
            if(I < 5)
            {
                Blessings[I].SetBool("visible", false);
                I++;
                // [Loop Continue]
                goto J0x346;
            }
            BlessingsMC.GotoAndStopI(BlessingCount);
        }        
    }
    else
    {
        ArtifactsMC.SetVisible(false);
    }
    super.TickHud(DeltaTime);
    //return;    
}
