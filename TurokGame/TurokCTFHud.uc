class TurokCTFHud extends TurokTeamGameHud
    transient
    config(Game)
    hidecategories(Navigation);

const H_FlagLocationNotAvailable = 1406112174;

var private bool mOldFlagAtHomeStatus0;
var private bool mOldFlagAtHomeStatus1;

protected function DrawTurokHudScoreboard()
{
    local @NULL GRI;

    GRI = TurokFlagGameReplicationInfo(WorldInfo.GRI);
    // End:0xFB
    if(GRI.GameClass == Class'TurokCTFGame')
    {
        // End:0x96
        if(GRI.mCurFlagAtHomeStatus0 != mOldFlagAtHomeStatus0)
        {
            // End:0x70
            if(GRI.mCurFlagAtHomeStatus0)
            {
                mHudScoreboard.SetFlagPossessed(0);                
            }
            else
            {
                mHudScoreboard.SetFlagLost(0);
            }
            mOldFlagAtHomeStatus0 = GRI.mCurFlagAtHomeStatus0;
        }
        // End:0xFB
        if(GRI.mCurFlagAtHomeStatus1 != mOldFlagAtHomeStatus1)
        {
            // End:0xD5
            if(GRI.mCurFlagAtHomeStatus1)
            {
                mHudScoreboard.SetFlagPossessed(1);                
            }
            else
            {
                mHudScoreboard.SetFlagLost(1);
            }
            mOldFlagAtHomeStatus1 = GRI.mCurFlagAtHomeStatus1;
        }
    }
    super(TurokMultiplayerHud).DrawTurokHudScoreboard();
    //return;    
}

function ShowObjectiveLocator()
{
    local int I, F;
    local @NULL FlagGRI;

    FlagGRI = TurokFlagGameReplicationInfo(WorldInfo.GRI);
    // End:0xC7
    if(FlagGRI != none)
    {
        I = 0;
        J0x2B:

        // End:0x9E [Loop If]
        if(I < FlagGRI.mIndicatorsNum)
        {
            // End:0x94
            if((TurokMPTeamFlagIndicator(FlagGRI.mIndicators[I]) != none) && FlagGRI.mIndicators[I].CanDraw(self))
            {
                F = 1;
                // [Explicit Break]
                goto J0x9E;
            }
            ++I;
            // [Loop Continue]
            goto J0x2B;
        }
        J0x9E:

        // End:0xC1
        if(F == 0)
        {
            mObjectiveText.InitObjText(1406112174);
        }
        super.ShowObjectiveLocator();
    }
    //return;    
}

defaultproperties
{
    mOldFlagAtHomeStatus0=true
    mOldFlagAtHomeStatus1=true
    // Reference: TurokSoundController'Default__TurokCTFHud.TurokSoundControllerComponent'
    begin object name=TurokSoundControllerComponent
    end object
    mSoundController=TurokSoundControllerComponent
    Components[0]=TurokSoundControllerComponent
}