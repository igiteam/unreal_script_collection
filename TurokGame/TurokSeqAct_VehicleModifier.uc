class TurokSeqAct_VehicleModifier extends SequenceAction
    hidecategories(Object);

var() int Health;
var(Jeep) float MaxSpeed;
var(Jeep) float RedlineRPM;
var(Jeep) float ExplosionDamage;
var(Jeep) float ExplosionRadius;
var(Jeep) float ExplosionMomentum;
var(Jeep) float LightSmokeDamagePercent;
var(Jeep) float HeavySmokeDamagePercent;
var(RailJeep) float PushForce;

defaultproperties
{
    ObjName="Vehicle Modifier"
    ObjCategory="Turok Vehicle"
}