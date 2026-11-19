class ActorFactoryR6DeadCharacter extends ActorFactoryPhysicsAsset
    native
    config(Editor)
    editinlinenew
    collapsecategories
    hidecategories(Object,Object,Object);

var() R6CharacterTemplate m_pCharacterTemplate;

defaultproperties
{
    bStartAwake=false
    MenuName="Add DeadCharacter"
    NewActorClass=Class'R6DeadCharacter'
}