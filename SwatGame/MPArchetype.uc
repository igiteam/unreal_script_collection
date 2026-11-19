class MPArchetype extends Archetype
    config(MPArchetypes);

var config class<Actor> ActorClass;

function class<Actor> PickClass()
{
    return ActorClass;
}





// Decompiled with UE Explorer.
defaultproperties
{
    InstanceClass=Class'MPArchetypeInstance'
}