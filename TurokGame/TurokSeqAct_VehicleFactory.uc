class TurokSeqAct_VehicleFactory extends SeqAct_ActorFactory
    native
    hidecategories(Object);

var() int NumSeats;

defaultproperties
{
    bCheckSpawnCollision=false
    // Reference: TurokActorFactoryVehicle'Default__TurokSeqAct_VehicleFactory.VFactory'
    begin object name=VFactory class=Class'TurokActorFactoryVehicle'
    end object
    Factory=VFactory
    InputLinks[0]=(LinkDesc="Spawn Vehicle",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkAction="None",LinkedOp=none,DrawY=0,bHidden=false)
    InputLinks[1]=(LinkDesc="Enable",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkAction="None",LinkedOp=none,DrawY=0,bHidden=false)
    InputLinks[2]=(LinkDesc="Disable",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkAction="None",LinkedOp=none,DrawY=0,bHidden=false)
    InputLinks[3]=(LinkDesc="Toggle",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkAction="None",LinkedOp=none,DrawY=0,bHidden=false)
    InputLinks[4]=(LinkDesc="Disable Spawning",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkAction="None",LinkedOp=none,DrawY=0,bHidden=false)
    InputLinks[5]=(LinkDesc="Kill All",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkAction="None",LinkedOp=none,DrawY=0,bHidden=false)
    InputLinks[6]=(LinkDesc="Kill All Off Screen",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkAction="None",LinkedOp=none,DrawY=0,bHidden=false)
    ObjName="Vehicle Factory"
    ObjCategory="Turok Vehicle"
}