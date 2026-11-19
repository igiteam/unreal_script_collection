class EvilComboEvent_Damage extends EvilComboEvent_Base
    editinlinenew
    hidecategories(Object)
    autoexpandcategories(Event,Damage);

var(Damage) array< class<DamageType> > IncludeDamageTypes;
var(Damage) bool bInvertDamageTypeFilter;
var(Damage) bool bInvertBodyPartFilter;
var(Damage) bool bReactUponDeathOnly;
var(Damage) bool bReactUponDirectHitsOnly;
var(Damage) bool bReactWhenRagdollOnly;
var(Damage) array<EvilTypes.EBodyParts> IncludeBodyParts;
var(Damage) float HealthFractionReactThreshold;

function bool check(name EventType, EvilPawn Instigator, EvilPawn Other, EvilPawn FirstOther, Vector Location, class<DamageType> dmgType, EvilTypes.EBodyParts BodyPart, bool directHit)
{
    // End:0x19
    if(EventType != EventID)
    {
        return false;
    }
    // End:0x66
    if(!Other.CanBeDamagedBy(Instigator.Controller, dmgType))
    {
        return false;
    }
    // End:0xB5
    if(IncludeDamageTypes.Length > 0)
    {
        // End:0xA4
        if(IncludeDamageTypes.Find(dmgType) >= )
        {            
            // End:0xA1
            if(bInvertDamageTypeFilter)
            {
                return false;
            }            
        }
        else
        {
            // End:0xB5
            if(!bInvertDamageTypeFilter)
            {
                return false;
            }
        }
    }
    // End:0x104
    if(IncludeBodyParts.Length > 0)
    {
        // End:0xF3
        if(IncludeBodyParts.Find(BodyPart) >= )
        {            
            // End:0xF0
            if(bInvertBodyPartFilter)
            {
                return false;
            }            
        }
        else
        {
            // End:0x104
            if(!bInvertBodyPartFilter)
            {
                return false;
            }
        }
    }
    // End:0x1F6
    if((((bReactUponDeathOnly && Other.Health > 0) || bReactWhenRagdollOnly && !Other.IsInState('KnockedDown')) || bReactUponDirectHitsOnly && !directHit) || (HealthFractionReactThreshold > 0.0000000) && (float(Other.Health) / Other.DefaultHealth) > HealthFractionReactThreshold)
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

defaultproperties
{
    EventID="Damage"
}