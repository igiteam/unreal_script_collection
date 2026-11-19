class SPKrakenAttackVolume extends SPDefendAreaVolume
    native;

enum eKrakenAttackVolumeDistance
{
    eKRegular,                      // 0
    eKLong,                         // 1
    eKrakenAttackVolumeDistance_MAX // 2
};

/** VARIABLE DECLARATIONS */
var(VolumeDistance) SPKrakenAttackVolume.eKrakenAttackVolumeDistance m_VolumeDistance;
