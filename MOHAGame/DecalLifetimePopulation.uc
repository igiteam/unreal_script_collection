class DecalLifetimePopulation extends DecalLifetime
    native
    config(Weapon);

var() config int MaxDecals;

defaultproperties
{
    MaxDecals=50
    PolicyName="Population"
}