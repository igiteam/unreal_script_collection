class R6PlayerAmbienceManager extends Actor
    native
    notplaceable
    hidecategories(lighting);

var R6AmbianceEmmiter PrincipalEmmiters[4];
var R6AmbianceEmmiter SecondaryEmmiters[4];
var bool m_InPrimaryZone;
var bool m_bInTransition;
var bool m_bInitialized;
var bool m_bFirstAmbiencePlay;
var bool m_bAmbienceOnEmmitersInitialized;
var bool m_bPrimaryToSecondaryTransition;
var ZoneInfo m_OldZone;
var Vector m_vPawnHeadLocation;
var R6AmbientSplitter m_NearestAS;
var float m_fDistanceToNearestAS;
var ZoneInfo m_CurrentZone;
var ZoneInfo m_FadingZone;
var float m_fCurentRadius;

function Initialize()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x49 [Loop If]
    if(I < 4)
    {
        PrincipalEmmiters[I] = new (self) Class'R6AmbianceEmmiter';        
        SecondaryEmmiters[I] = new (self) Class'R6AmbianceEmmiter';        
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    m_bInitialized = true;
    return;
}
