class R6Scope extends R6WeaponOption
    native
    notplaceable
    hidecategories(lighting);

var R6EngineEnums.EZoomType m_eCurrentZoomType;
var R6EngineEnums.EMagmaScopeType m_eMagmaScopeType;
var array<R6EngineEnums.EZoomType> m_SupportedZoomTypes;
var int m_iCurrentScopeIndex;
var export editinline StaticMeshComponent m_ScopeMeshFP;
var export editinline StaticMeshComponent m_ScopeMeshTP;
var export editinline StaticMeshComponent m_ScopeMountMeshFP;
var export editinline StaticMeshComponent m_ScopeMountMeshTP;
var name m_ScopeSocketName;
var float m_fMovementSpeed;
var float m_fMaxYawMovement;
var float m_fMaxPitchMovement;
var float m_fMagmaFadeDuration;

// Export UR6Scope::execNextScope(FFrame&, void* const)
native function bool NextScope();

// Export UR6Scope::execPrevScope(FFrame&, void* const)
native function bool PrevScope();

// Export UR6Scope::execSetScope(FFrame&, void* const)
native final function SetScope(int iScope);

// Export UR6Scope::execResetScope(FFrame&, void* const)
native function ResetScope();

defaultproperties
{
    m_SupportedZoomTypes=/* ERROR: System.ArgumentOutOfRangeException */
    m_ScopeSocketName="R65_AM_ScopeMount"
    m_fMovementSpeed=0.2000000
    m_fMaxYawMovement=200.0000000
    m_fMaxPitchMovement=300.0000000
    m_fMagmaFadeDuration=0.2500000
}