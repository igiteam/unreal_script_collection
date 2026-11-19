class UTDmgType_RanOver extends EvilDmgType_Base
    abstract;

var int NumMessages;

static function int IncrementKills(EvilPlayerReplicationInfo KillerPRI)
{
    local int KillCount;

    KillCount = super.IncrementKills(KillerPRI);
    // End:0x9D
    if((KillCount != default.RewardCount) && UTPlayerController(KillerPRI.Owner) != none)
    {
        SmallReward(UTPlayerController(KillerPRI.Owner), KillCount);
    }
    return KillCount;
    //return ReturnValue;    
}

static function SmallReward(UTPlayerController Killer, int KillCount)
{
    Killer.ReceiveLocalizedMessage(Class'UTVehicleKillMessage', KillCount % 4);
    //return;    
}

static function SpawnHitEffect(Pawn P, float Damage, Vector Momentum, name BoneName, Vector HitLocation)
{
    super.SpawnHitEffect(P, Damage, Momentum, BoneName, HitLocation);
    // End:0x95
    if(UTPawn(P) != none)
    {
        UTPawn(P).SoundGroupClass.static.PlayCrushedSound(P);
    }
    //return;    
}

defaultproperties
{
    NumMessages=4
    bLocationalHit=false
    bNeverGibs=true
    bUseTearOffMomentum=true
    bVehicleHit=true
    GibPerterbation=0.5000000
    KillStatsName="EVENT_RANOVERKILLS"
    DeathStatsName="EVENT_RANOVERDEATHS"
    RewardCount=10
    RewardAnnouncementClass=Class'UTVehicleKillMessage'
    RewardAnnouncementSwitch=7
    RewardEvent="REWARD_ROADRAMPAGE"
    // Reference: ForceFeedbackWaveform'Default__UTDmgType_RanOver.ForceFeedbackWaveform0'
    begin object name=ForceFeedbackWaveform0
    end object
    DamagedFFWaveform=ForceFeedbackWaveform0
    // Reference: ForceFeedbackWaveform'Default__UTDmgType_RanOver.ForceFeedbackWaveform1'
    begin object name=ForceFeedbackWaveform1
    end object
    KilledFFWaveform=ForceFeedbackWaveform1
}