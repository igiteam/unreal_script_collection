class TurokDamageType extends DamageType
    abstract
    native
    config(DamageType);

enum eTurokDamageType
{
    eTurokDamageType_Bite,          // 0
    eTurokDamageType_Bow,           // 1
    eTurokDamageType_Claw,          // 2
    eTurokDamageType_DinoSmash,     // 3
    eTurokDamageType_Fire,          // 4
    eTurokDamageType_Flamethrower,  // 5
    eTurokDamageType_Flare,         // 6
    eTurokDamageType_Foot,          // 7
    eTurokDamageType_FragGrenade,   // 8
    eTurokDamageType_Geyser,        // 9
    eTurokDamageType_Handgun,       // 10
    eTurokDamageType_Head,          // 11
    eTurokDamageType_JeepTurret,    // 12
    eTurokDamageType_Knife,         // 13
    eTurokDamageType_MaulBegin,     // 14
    eTurokDamageType_MaulRaptor,    // 15
    eTurokDamageType_MaulRaptorMini,// 16
    eTurokDamageType_MaulLurker,    // 17
    eTurokDamageType_MaulDilo,      // 18
    eTurokDamageType_MaulBug,       // 19
    eTurokDamageType_MaulEnd,       // 20
    eTurokDamageType_Minigun,       // 21
    eTurokDamageType_Pellet,        // 22
    eTurokDamageType_Railgun,       // 23
    eTurokDamageType_RailgunGrenade,// 24
    eTurokDamageType_NapalmGrenade, // 25
    eTurokDamageType_StickyGunGrenade,// 26
    eTurokDamageType_RPG,           // 27
    eTurokDamageType_Shotgun,       // 28
    eTurokDamageType_Shredder,      // 29
    eTurokDamageType_SMG,           // 30
    eTurokDamageType_Sniper,        // 31
    eTurokDamageType_SpitRaptor,    // 32
    eTurokDamageType_SpitRazor,     // 33
    eTurokDamageType_Stealthkill,   // 34
    eTurokDamageType_Tail,          // 35
    eTurokDamageType_Tazer,         // 36
    eTurokDamageType_TazerElectricalBolt,// 37
    eTurokDamageType_TriShotgun,    // 38
    eTurokDamageType_VehicleCollision,// 39
    eTurokDamageType_VehicleRanOver,// 40
    eTurokDamageType_WaterBossBite, // 41
    eTurokDamageType_WaterBossSwipe,// 42
    eTurokDamageType_ArrowRemovedByPawn,// 43
    eTurokDamageType_ArrowCausesLegLimp,// 44
    eTurokDamageType_BugBite,       // 45
    eTurokDamageType_BugClaw,       // 46
    eTurokDamageType_BugSmash,      // 47
    eTurokDamageType_BugTail,       // 48
    eTurokDamageType_ExplodingArrow,// 49
    eTurokDamageType_ProjBluntImpact,// 50
    eTurokDamageType_Bomb,          // 51
    eTurokDamageType_Default,       // 52
    eTurokDamageType_NumTypes,      // 53
    eTurokDamageType_MAX            // 54
};

var byte mDamageType;
var float mUVAnimAmplitude;
var float mUVAnimFrequency;
var float mUVAnimDuration;

static simulated function bool IsMaulType()
{
    return (int(default.mDamageType) > int(14)) && int(default.mDamageType) < int(20);
    //return ReturnValue;    
}

defaultproperties
{
    mUVAnimAmplitude=0.0300000
    mUVAnimFrequency=5.0000000
    mUVAnimDuration=2.0000000
    // Reference: ForceFeedbackWaveform'Default__TurokDamageType.ForceFeedbackWaveform0'
    begin object name=ForceFeedbackWaveform0 class=Class'Engine.ForceFeedbackWaveform'
    end object
    DamagedFFWaveform=ForceFeedbackWaveform0
    // Reference: ForceFeedbackWaveform'Default__TurokDamageType.ForceFeedbackWaveform1'
    begin object name=ForceFeedbackWaveform1 class=Class'Engine.ForceFeedbackWaveform'
    end object
    KilledFFWaveform=ForceFeedbackWaveform1
}