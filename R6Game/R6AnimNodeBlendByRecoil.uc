class R6AnimNodeBlendByRecoil extends AnimNodeBlendBase
    native
    hidecategories(Object,Object,Object);

enum EAnimShootType
{
    ANIMSHOOTTYPE_NORMAL_SINGLE,    // 0
    ANIMSHOOTTYPE_ZOOM_SINGLE,      // 1
    ANIMSHOOTTYPE_NORMAL_BURST,     // 2
    ANIMSHOOTTYPE_ZOOM_BURST,       // 3
    ANIMSHOOTTYPE_MAX               // 4
};

var() R6AnimNodeBlendByRecoil.EAnimShootType m_eType;
var transient R6GameEnums.EBurstShootAnimState m_eBurstState;
var transient R6WeaponAnimConfig m_pConfig;
var transient bool m_bWasShieldUp;
var transient bool m_bWasSuppressorOn;

defaultproperties
{
    Children=/* Array type was not detected. */
    bFixNumChildren=true
}