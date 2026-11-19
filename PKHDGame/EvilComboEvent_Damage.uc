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
    // End:0x5D
    if(!Other.CanBeDamagedBy(Instigator.Controller))
    {
        return false;
    }
    // End:0xAC
    if(IncludeDamageTypes.Length > 0)
    {
        // End:0x9B
        if(IncludeDamageTypes.Find(dmgType) >= 0)
        {
            // End:0x98
            if(bInvertDamageTypeFilter)
            {
                return false;
            }            
        }
        else
        {
            // End:0xAC
            if(!bInvertDamageTypeFilter)
            {
                return false;
            }
        }
    }
    // End:0xFB
    if(IncludeBodyParts.Length > 0)
    {
        // End:0xEA
        if(IncludeBodyParts.Find(BodyPart) >= 0)
        {
            // End:0xE7
            if(bInvertBodyPartFilter)
            {
                return false;
            }            
        }
        else
        {
            // End:0xFB
            if(!bInvertBodyPartFilter)
            {
                return false;
            }
        }
    }
    // End:0x1ED
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