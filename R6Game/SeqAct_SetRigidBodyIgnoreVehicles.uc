class SeqAct_SetRigidBodyIgnoreVehicles extends SequenceAction
    native
    hidecategories(Object);

defaultproperties
{
    InputLinks[0]=(LinkDesc="Turn On",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    InputLinks[1]=(LinkDesc="Turn Off",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    ObjName="Set RigidBodyIgnoreVehicles"
    ObjCategory="Physics"
}