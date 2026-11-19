class DmgType_Fell extends DamageType
    abstract
    native
    config(DamageTypesConfig);

defaultproperties
{
    DeathString="%k pushed %o over the edge."
    FemaleSuicide="%o left a small crater"
    MaleSuicide="%o left a small crater"
    bLocationalHit=false
    bCausedByWorld=true
    GibModifier=2.0000000
}