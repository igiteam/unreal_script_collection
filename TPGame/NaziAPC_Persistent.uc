class NaziAPC_Persistent extends TPBaseVehicle
    native
	abstract;

var SkelControlSingleBone DriverRearDoorControl;
var SkelControlSingleBone PassengerRearDoorControl;
var float MaxRearDoorAngle;

var SkelControlSingleBone DriverRearHatchControl;
var SkelControlSingleBone PassengerRearHatchControl;
var float MaxRearHatchAngle;

var SkelControlSingleBone DriverTopHatchControl;
var SkelControlSingleBone PassengerTopHatchControl;
var float MaxTopHatchAngle;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	DriverRearDoorControl = SkelControlSingleBone(Mesh.FindSkelControl('DriverRearDoor'));
	PassengerRearDoorControl = SkelControlSingleBone(Mesh.FindSkelControl('PassRearDoor'));
	DriverRearHatchControl = SkelControlSingleBone(Mesh.FindSkelControl('DriverRearHatch'));
	PassengerRearHatchControl = SkelControlSingleBone(Mesh.FindSkelControl('PassRearHatch'));
	DriverTopHatchControl = SkelControlSingleBone(Mesh.FindSkelControl('DriverTopHatch'));
	PassengerTopHatchControl = SkelControlSingleBone(Mesh.FindSkelControl('PassTopHatch'));
}

