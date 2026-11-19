class R6Helicopter extends R6HelicopterBase
    native
    placeable
    hidecategories(lighting);

var(RainbowsFourhtSeat) R6EngineEnums.EChopperPawns m_eStartUpPawnInFourthSeat;
var(RainbowsPilotSeat) R6EngineEnums.EChopperPawns m_eStartUpPawnInPilotSeat;
var(RainbowsCoPilotSeat) R6EngineEnums.EChopperPawns m_eStartUpPawnInCoPilotSeat;
var(RainbowsFourhtSeat) R6CharacterTemplate m_CharaterTemplateInFourthSeat;
var(RainbowsPilotSeat) R6CharacterTemplate m_CharaterTemplateInPilotSeat;
var(RainbowsCoPilotSeat) R6CharacterTemplate m_CharaterTemplateInCoPilotSeat;
var export editinline SkeletalMeshComponent m_ChopperSkelMesh;
var export editinline StaticMeshComponent m_WindowsAndRotorMesh;
var R6Pawn m_pawnsInside[6];
var bool m_bPlayerReadyToEnter;
var bool m_bTeammatesReadyToEnter;
var bool m_bPlayerReadyToExit;
var bool m_bTeammatesReadyToExit;
var Vector m_interactionPositions[3];
var name m_sittingSocketNames[6];
var name m_enteringSocketNames[12];
var name m_enteringLoganOnlySocketName;
var R6InteractiveRopePlace m_RopePlace;
var name m_fastRopeSocketName;
var CameraActor m_pPIPCam;
var(PlayerOutIdleNoise) float m_fPlayerOutPitchNoiseScale;
var(PlayerOutIdleNoise) /*0x20000000-0x00000000*/ int m_iPlayerOutPitchNoiseAmplitude;
var(PlayerOutIdleNoise) float m_fPlayerOutYawNoiseScale;
var(PlayerOutIdleNoise) /*0x20000000-0x00000000*/ int m_iPlayerOutYawNoiseAmplitude;
var(PlayerOutIdleNoise) float m_fPlayerOutRollNoiseScale;
var(PlayerOutIdleNoise) /*0x20000000-0x00000000*/ int m_iPlayerOutRollNoiseAmplitude;
var(PlayerOutIdleNoise) float m_fPlayerOutLocXNoiseScale;
var(PlayerOutIdleNoise) float m_fPlayerOutLocXNoiseAmplitude;
var(PlayerOutIdleNoise) float m_fPlayerOutLocYNoiseScale;
var(PlayerOutIdleNoise) float m_fPlayerOutLocYNoiseAmplitude;
var(PlayerOutIdleNoise) float m_fPlayerOutLocZNoiseScale;
var(PlayerOutIdleNoise) float m_fPlayerOutLocZNoiseAmplitude;
var(HelicopterLighting) const editconst export editinline R6HelicopterPointLightComponent m_backPointLight;
var(HelicopterLighting) const editconst export editinline R6HelicopterSpotLightComponent m_laptopSpotLight;
var(HelicopterLighting) const editconst export editinline R6HelicopterPointLightComponent m_cockpitPointLight;
var(HelicopterLighting) const editconst export editinline R6HelicopterPointLightComponent m_outsidePointLight;
var(HelicopterLighting) const editconst export editinline R6HelicopterSpotLightComponent m_outsideSpotLight;

// Export UR6Helicopter::execSetExtraPawnsInside(FFrame&, void* const)
native final function SetExtraPawnsInside(R6EngineEnums.EChopperPawns ePawnInFourthSeat, R6CharacterTemplate FourthSeatTemplate, R6EngineEnums.EChopperPawns ePawnInPilotSeat, R6CharacterTemplate PilotSeatTemplate, R6EngineEnums.EChopperPawns ePawnInCopilotSeat, R6CharacterTemplate CopilotSeatTemplate);

// Export UR6Helicopter::execOnR6ChopperSetReadyForExit(FFrame&, void* const)
native function OnR6ChopperSetReadyForExit(SeqAct_R6ChopperSetReadyForExit pAction);

// Export UR6Helicopter::execOnR6ChopperSetReadyForEnter(FFrame&, void* const)
native function OnR6ChopperSetReadyForEnter(SeqAct_R6ChopperSetReadyForEnter pAction);

// Export UR6Helicopter::execOnR6ChopperSetPlayerInside(FFrame&, void* const)
native function OnR6ChopperSetPlayerInside(SeqAct_R6ChopperSetPlayerInside pAction);

// Export UR6Helicopter::execOnR6ChopperInstantSetRainbows(FFrame&, void* const)
native function OnR6ChopperInstantSetRainbows(SeqAct_R6ChopperInstantSetRainbows pAction);

// Export UR6Helicopter::execOnR6ChopperDropRope(FFrame&, void* const)
native function OnR6ChopperDropRope(SeqAct_R6ChopperDropRope pAction);

simulated event bool GetInteractDesc(out R6EngineEnums.ER6InteractDesc eDesc, optional PlayerController PC)
{
    // End:0x17
    if(GetGameManager().IsMultiplayer())
    {
        return false;
    }
    eDesc = 13;
    return true;
    return;
}

simulated event bool GetBusyInteractDesc(out R6EngineEnums.ER6InteractDesc eDesc, PlayerController PC)
{
    // End:0x16
    if(GetGameManager().IsMultiplayer())
    {
        return false;
    }
    eDesc = 13;
    return true;
    return;
}

function ResetOriginalData()
{
    ResetOriginalData();
    m_bPlayerReadyToEnter = false;
    m_bTeammatesReadyToEnter = false;
    m_bPlayerReadyToExit = false;
    m_bTeammatesReadyToExit = false;
    return;
}

defaultproperties
{
    // Reference: SkeletalMeshComponent'Default__R6Helicopter.ChopperSkelMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="ChopperSkelMesh" class=Class'Engine.SkeletalMeshComponent'
        BlockNonZeroExtent=true
        Rotation=(Pitch=0,Yaw=32768,Roll=0)
    end object
    m_ChopperSkelMesh=ChopperSkelMesh
    // Reference: StaticMeshComponent'Default__R6Helicopter.WindowRotorMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="WindowRotorMesh" class=Class'Engine.StaticMeshComponent'
        CastShadow=false
        Rotation=(Pitch=0,Yaw=32768,Roll=0)
    end object
    m_WindowsAndRotorMesh=WindowRotorMesh
    m_sittingSocketNames[0]="R65_AM_Sit1"
    m_sittingSocketNames[1]="R65_AM_Sit2"
    m_sittingSocketNames[2]="R65_AM_Sit3"
    m_sittingSocketNames[3]="R65_AM_Joanna"
    m_sittingSocketNames[4]="R65_AM_pilot"
    m_sittingSocketNames[5]="R65_AM_copilot"
    m_enteringSocketNames[0]="R65_AM_Entry1_JUNG"
    m_enteringSocketNames[1]="R65_AM_Entry1_MICHAEL"
    m_enteringSocketNames[2]="R65_AM_Entry1_LOGAN"
    m_enteringSocketNames[3]="R65_AM_Entry2_JUNG"
    m_enteringSocketNames[4]="R65_AM_Entry2_MICHAEL"
    m_enteringSocketNames[5]="R65_AM_Entry2_LOGAN"
    m_enteringSocketNames[6]="R65_AM_Entry3_JUNG"
    m_enteringSocketNames[7]="R65_AM_Entry3_MICHAEL"
    m_enteringSocketNames[8]="R65_AM_Entry3_LOGAN"
    m_enteringSocketNames[9]="R65_AM_Entry4_JUNG"
    m_enteringSocketNames[10]="R65_AM_Entry4_MICHAEL"
    m_enteringSocketNames[11]="R65_AM_Entry4_LOGAN"
    m_enteringLoganOnlySocketName="R65_AM_EntryAlone"
    m_fastRopeSocketName="R65_AM_FastRope"
    m_fPlayerOutPitchNoiseScale=0.2000000
    m_iPlayerOutPitchNoiseAmplitude=400
    m_fPlayerOutYawNoiseScale=0.2000000
    m_iPlayerOutYawNoiseAmplitude=400
    m_fPlayerOutRollNoiseScale=0.2000000
    m_iPlayerOutRollNoiseAmplitude=400
    m_fPlayerOutLocXNoiseScale=0.2000000
    m_fPlayerOutLocXNoiseAmplitude=30.0000000
    m_fPlayerOutLocYNoiseScale=0.2000000
    m_fPlayerOutLocYNoiseAmplitude=30.0000000
    m_fPlayerOutLocZNoiseScale=0.2000000
    m_fPlayerOutLocZNoiseAmplitude=30.0000000
    // Reference: R6HelicopterPointLightComponent'Default__R6Helicopter.BackPointLight'
    begin object name="BackPointLight" class=Class'Engine.R6HelicopterPointLightComponent'
        Translation=(X=198.0000000,Y=90.0000000,Z=-315.0000000)
    end object
    m_backPointLight=BackPointLight
    // Reference: R6HelicopterSpotLightComponent'Default__R6Helicopter.LaptopSpotLight'
    begin object name="LaptopSpotLight" class=Class'Engine.R6HelicopterSpotLightComponent'
        Translation=(X=166.0000000,Y=-27.0000000,Z=-240.0000000)
    end object
    m_laptopSpotLight=LaptopSpotLight
    // Reference: R6HelicopterPointLightComponent'Default__R6Helicopter.CockpitPointLight'
    begin object name="CockpitPointLight" class=Class'Engine.R6HelicopterPointLightComponent'
        Translation=(X=356.0000000,Y=-2.0000000,Z=-233.0000000)
    end object
    m_cockpitPointLight=CockpitPointLight
    // Reference: R6HelicopterPointLightComponent'Default__R6Helicopter.OutsidePointLight'
    begin object name="OutsidePointLight" class=Class'Engine.R6HelicopterPointLightComponent'
        Translation=(X=194.0000000,Y=400.0000000,Z=-258.0000000)
    end object
    m_outsidePointLight=OutsidePointLight
    // Reference: R6HelicopterSpotLightComponent'Default__R6Helicopter.OutsideSpotLight'
    begin object name="OutsideSpotLight" class=Class'Engine.R6HelicopterSpotLightComponent'
        Rotation=(Pitch=0,Yaw=-16384,Roll=0)
        Translation=(X=194.0000000,Y=400.0000000,Z=-170.0000000)
        bEnabled=false
    end object
    m_outsideSpotLight=OutsideSpotLight
    m_ChopperMesh=ChopperSkelMesh
    m_bSkipNormalLights=true
    Components[0]=ChopperSkelMesh
    Components[1]=WindowRotorMesh
    Components[2]=BackPointLight
    Components[3]=LaptopSpotLight
    Components[4]=CockpitPointLight
    Components[5]=OutsidePointLight
    Components[6]=OutsideSpotLight
    CollisionComponent=ChopperSkelMesh
    SupportedEvents=/* Array type was not detected. */
}