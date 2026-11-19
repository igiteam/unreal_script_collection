class R6BreakableLight extends R6BreakableActor
    native
    editinlinenew
    hidecategories(Material);

var() array<Light> m_Lights;
var array<int> m_LightsSubPart;
var() array<R6InteractiveSwitch> m_aSwitches;
var() float m_fBrightnessDecrease;
var() export editinline array<export editinline LightComponent> m_aBreakableLights;

function ApplyEMPEffect(Vector vOrigin, float fEMPStrength, float fMaxEMPStrength, float fEMPDuration)
{
    // End:0x1A
    if(m_fLifePoints > float(0))
    {
        BreakableBreak(-1, none);
    }
    return;
}
