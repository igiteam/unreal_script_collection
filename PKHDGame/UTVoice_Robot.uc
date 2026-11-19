class UTVoice_Robot extends UTVoice
    abstract;

static function bool SendLocationUpdate(Controller Sender, PlayerReplicationInfo Recipient, name MessageType, EvilGame G, Pawn StatusPawn, optional bool bDontSendMidfield)
{
    return false;
    //return ReturnValue;    
}

defaultproperties
{
    AckSounds[0]=none
    AckSounds[1]=none
    FriendlyFireSounds[0]=none
    FriendlyFireSounds[1]=none
    GotYourBackSounds[0]=none
    GotYourBackSounds[1]=none
    GotYourBackSounds[2]=none
    NeedOurFlagSounds[0]=none
    SniperSounds[0]=none
    InPositionSounds[0]=none
    HaveFlagSounds[0]=none
    AreaSecureSounds[0]=none
    LocationSpeechOffset=3
}