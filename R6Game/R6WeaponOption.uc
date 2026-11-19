class R6WeaponOption extends Actor
    abstract
    native
    notplaceable
    hidecategories(lighting);

var R6WeaponAttachments m_pAttachments;
var bool m_bActivated;
var const localized string m_szDescription;

// Export UR6WeaponOption::execInitOption(FFrame&, void* const)
native function InitOption(R6WeaponAttachments pAttachments);

// Export UR6WeaponOption::execSetPawn(FFrame&, void* const)
native function SetPawn(R6Pawn pPawn);

// Export UR6WeaponOption::execToggle(FFrame&, void* const)
native function Toggle();

// Export UR6WeaponOption::execActivate(FFrame&, void* const)
native function Activate(bool bActivate);

// Export UR6WeaponOption::execAttachOption(FFrame&, void* const)
native function AttachOption();

// Export UR6WeaponOption::execDetachOption(FFrame&, void* const)
native function DetachOption();

defaultproperties
{
    bNoSelect=true
    Components=none
    TickGroup=1
}