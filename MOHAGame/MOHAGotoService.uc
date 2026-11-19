class MOHAGotoService extends AxonGotoService;

function SubstateGotoOIR(delegate<AxonDelegate> callback, optional Vector Destination = vect(0.0000000, 0.0000000, 0.0000000), optional Object DestOIR, optional name initialActivity = 'None', optional float movedoneradius, optional float MaxSpeed = 500.0000000, optional bool bUseDefaultPathConstraints = true, optional name instanceID = 'Default', optional Actor destinationActor, optional name Key = 'stack')
{
    local OIROwnerInterface oirIface;

    GetController().SetCurrentCoverNode(none);
    oirIface = OIROwnerInterface(DestOIR);
    // End:0x118
    if(NotEqual_InterfaceInterface(oirIface, OIROwnerInterface(none)))
    {
        Destination = oirIface.GetOIRData().OIRPosition;
        GetController().QueueNextGotoOIR(oirIface, initialActivity);
        GetController().SetCurrentCoverNode(KynapseCoverNode(DestOIR));
        // End:0x115
        if(movedoneradius == float(0))
        {
            movedoneradius = oirIface.GetArrivedAtRadius();
        }        
    }
    else
    {
        // End:0x18A
        if(DestOIR == none)
        {
            // End:0x165
            if(movedoneradius == float(0))
            {
                movedoneradius = MOHAAIPawn(GetController().Pawn).FFImpl.GetArrivedAtRadius();
            }
            GetController().QueueNextGotoFixedFireOIR(Destination, initialActivity);            
        }
        else
        {
            // DebugMode: 0
            assert(false);
        }
    }
    SubstateGoto(callback, Destination, destinationActor, movedoneradius, MaxSpeed, bUseDefaultPathConstraints, instanceID, Key);
    //return;    
}

function MOHAScriptAIController GetController()
{
    return AxonControllerBrainState(owningBrainState).Controller;
    //return ReturnValue;    
}

function int GetRandDesiredPosture()
{
    return EALASmallArms(AxonControllerBrainState(owningBrainState).GetBot().Weapon).GetRandDesiredPosture();
    //return ReturnValue;    
}

function int GetDesiredPosture(optional int overridePosture)
{
    local int Posture;

    Posture = EALASmallArms(AxonControllerBrainState(owningBrainState).GetBot().Weapon).GetDesiredPosture();
    // End:0x51
    if(Posture < 0)
    {
        Posture = overridePosture;
    }
    return Posture;
    //return ReturnValue;    
}
