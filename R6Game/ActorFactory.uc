class ActorFactory extends Object
    abstract
    native
    config(Editor)
    editinlinenew
    collapsecategories
    hidecategories(Object);

var string MenuName;
var config int MenuPriority;
var class<Actor> NewActorClass;
var bool bPlaceable;
var string SpecificGameName;

defaultproperties
{
    MenuName="Add Actor"
    NewActorClass=Class'Actor'
    bPlaceable=true
}