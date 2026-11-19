class WindEffect extends ParticleSystemComponent
    editinlinenew
    hidecategories(Object,Physics,Collision);

var float minwindeffecttime;
var float maxwindeffecttime;
var float minTimeBetweenWind;
var float maxTimeBetweenWind;
var float timeleft_nextwindeffect;
var float timeleft_nextwindeffectaftersleep;

defaultproperties
{
    bOverrideLODMethod=true
    SecondsBeforeInactive=0.2000000
    LODMethod=1
}