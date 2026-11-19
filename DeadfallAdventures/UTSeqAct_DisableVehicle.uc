class UTSeqAct_DisableVehicle extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

event Activated()
{
    local UDKVehicle TheVehicle;
    local int I;

    I = 0;
    J0x0B:

    // End:0x146 [Loop If]
    if(I < Targets.Length)
    {
        TheVehicle = UDKVehicle(Targets[I]);
        // End:0xD1
        if(TheVehicle == none)
        {
            ScriptLog((((("WARNING: UDKVehicle expected in Targets for" @ string(self)) @ ". Target[") $ string(I)) $ "] : ") $ string(Targets[I]));            
        }
        else
        {
            // End:0x117
            if(InputLinks[0].bHasImpulse)
            {
                TheVehicle.bIsDisabled = true;                
            }
            else
            {
                TheVehicle.bIsDisabled = false;
            }
        }
        ++I;
        // [Loop Continue]
        goto J0x0B;
    }
    //return;    
}

defaultproperties
{
    bCallHandler=false
    InputLinks[0]=(LinkDesc="Disable",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    InputLinks[1]=(LinkDesc="Enable",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Disable UDKVehicle"
}