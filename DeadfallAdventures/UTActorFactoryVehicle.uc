class UTActorFactoryVehicle extends ActorFactoryVehicle
    config(Editor)
    editinlinenew
    collapsecategories
    hidecategories(Object);

var() bool bTeamLocked;
var() bool bKeyVehicle;
var() byte TeamNum;

simulated event PostCreateActor(Actor NewActor, optional SeqAct_ActorFactory ActorFactoryData)
{
    local EvilVehicle_Base NewVehicle;

    NewVehicle = EvilVehicle_Base(NewActor);
    // End:0x103
    if(NewVehicle != none)
    {
        NewVehicle.SetTeamNum(TeamNum);
        NewVehicle.bTeamLocked = bTeamLocked;
        // End:0xAA
        if(bKeyVehicle)
        {
            NewVehicle.SetKeyVehicle();
        }
        // End:0x103
        if(NewVehicle.Mesh != none)
        {
            NewVehicle.Mesh.WakeRigidBody();
        }
    }
    //return;    
}

defaultproperties
{
    bTeamLocked=true
    VehicleClass=Class'EvilVehicle_Base'
}