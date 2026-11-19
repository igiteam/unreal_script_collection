class SPActorFactorySPAnimusPack extends ActorFactory
    native
    config(Editor)
    editinlinenew
    collapsecategories;

var() bool m_bAddFactoryToAnimusManager;

defaultproperties
{
    m_bAddFactoryToAnimusManager=true
    MenuName="Add SPLifeForceHolder"
    NewActorClass=Class'AnimusHealthPack'
}