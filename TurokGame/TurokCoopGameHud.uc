class TurokCoopGameHud extends TurokTeamGameHud
    transient
    config(Game)
    hidecategories(Navigation);

function ShowObjectiveLocator()
{
    super.ShowObjectiveLocator();
    mDrawMissionInfo = true;
    //return;    
}

protected function CreateTeamIcons()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x33 [Loop If]
    if(I < 16)
    {
        mTeamIconBlock[I] = new Class'TurokHudCoopTargetIcon';
        ++I;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

defaultproperties
{
    mShowTeamNotification=false
    mGameStartSpeechEnabled=false
    mDrawMissionInfo=false
    mMedSecSpeechEnabled=false
    mLowSecSpeechEnabled=false
    m60SecsSpeechEnabled=false
    m30SecsSpeechEnabled=false
    // Reference: TurokSoundController'Default__TurokCoopGameHud.TurokSoundControllerComponent'
    begin object name=TurokSoundControllerComponent
    end object
    mSoundController=TurokSoundControllerComponent
    Components[0]=TurokSoundControllerComponent
}