class R6AnimNodeSequenceWeapon extends R6AnimNodeSequenceCustom
    native
    hidecategories(Object,Object,Object,Object);

var transient R6EngineEnums.EWeaponAnimType m_eWeaponAnimType;
var() bool m_bDontDisplaySlider;
var() bool m_bSupportShotgunAnims;
var() bool m_bSupportSniperAnims;
var() bool m_bSupportPistolAnims;
var bool m_bAllowForceMG;

defaultproperties
{
    m_eWeaponAnimType=6
    m_bSupportPistolAnims=true
}