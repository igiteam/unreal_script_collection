class R6AnimNodeSequenceFPWeaponMovement extends R6AnimNodeSequenceFPWeaponAutoChange
    native
    hidecategories(Object,Object,Object,Object);

enum EAnimWeaponMovementType
{
    ANIMWEAPONMOVEMENTTYPE_WALK,    // 0
    ANIMWEAPONMOVEMENTTYPE_FASTWALK,// 1
    ANIMWEAPONMOVEMENTTYPE_JOG,     // 2
    ANIMWEAPONMOVEMENTTYPE_ZOOMWALK,// 3
    ANIMWEAPONMOVEMENTTYPE_ZOOMFASTWALK,// 4
    ANIMWEAPONMOVEMENTTYPE_ZOOMJOG, // 5
    ANIMWEAPONMOVEMENTTYPE_MAX      // 6
};

var() R6AnimNodeSequenceFPWeaponMovement.EAnimWeaponMovementType m_eType;
