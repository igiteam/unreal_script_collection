class R6TacticTurret extends R6TacticSpecWeapon
    native;

var array<R6Turret> m_aGunSpec;
var array<R6Pawn> m_aGunners;
var R6Pawn m_pLastSentGunner;
var float m_fTimeTakeCover;

defaultproperties
{
    m_eType=24
    m_bIsInternalTactic=false
}