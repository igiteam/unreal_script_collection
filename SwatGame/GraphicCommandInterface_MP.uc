class GraphicCommandInterface_MP extends GraphicCommandInterface
    config(PlayerInterface_Command_MP);

simulated function CheckTeam()
{
    //in MP, the CI team should always be the Element, so the default is acceptable
}










// Decompiled with UE Explorer.
defaultproperties
{
    ContextsListClass=Class'CommandInterfaceContextsList_MP'
    MenuInfoClass=Class'CommandInterfaceMenuInfo_MP'
    StaticCommandsClass=Class'CommandInterfaceStaticCommands_MP'
    CommandClass=Class'Command_MP'
    Range=2000.0000000
    DoorRelatedContextClass=Class'CommandInterfaceDoorRelatedContext_MP'
    ContextClass=Class'CommandInterfaceContext_MP'
}