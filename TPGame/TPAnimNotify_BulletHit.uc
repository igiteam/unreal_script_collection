class TPAnimNotify_BulletHit extends AnimNotify
    native;

/** The direction the pawn gets "shot."  Six clock is the front of the pawn */
enum EHitDirection {HD_OneOClock, HD_TwoOClock, HD_ThreeOClock, HD_FourOClock, HD_FiveOClock,
    HD_SixOClock, HD_SevenOClock, HD_EightOClock, HD_NineOClock, HD_TenOClock, HD_ElevenOClock,
    HD_TwelveOClock};

/** Amount of momentum to apply */
struct native HitInfo
{
    var() name                  BoneName;
    var() EHitDirection         HitDirection;

    structdefaultproperties
    {
        BoneName     = "JO_chest"
        HitDirection = HD_SixOClock
    }
};

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

var() HitInfo HitInformation;

