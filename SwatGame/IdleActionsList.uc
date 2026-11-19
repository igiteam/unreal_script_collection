///////////////////////////////////////////////////////////////////////////////
/// IdleActionsList.uc - The IdleActionsList class
/// Contains the lists of all possible IdleActions that AIs can use
///////////////////////////////////////////////////////////////////////////////
class IdleActionsList extends Engine.Actor
    config(IdleActionsList);
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
///
/// IdleActionsClassList config variables
var config array<Name>              AnimatorIdleNames;
var array<AnimatorIdleDefinition>   AnimatorIdleDefinitions;

var config array<Name>              ProceduralIdleNames;
var array<ProceduralIdleDefinition> ProceduralIdleDefinitions;

///////////////////////////////////////////////////////////////////////////////
///
/// Initialization Events
event PreBeginPlay()
{
    Super.PreBeginPlay();

    CreateAnimatorIdleActionDefinitions();
	// disabled this for now [crombie]
//    CreateProceduralIdleActionDefinitions();
}

private function CreateAnimatorIdleActionDefinitions()
{
    local int i, j;
    local AnimatorIdleDefinition NewAnimatorIdleDefinition;

	// sanity check for animators
	for(i=0; i<AnimatorIdleNames.Length; ++i)
	{
		for(j=i+1; j<AnimatorIdleNames.Length; ++j)
		{
			if (AnimatorIdleNames[i] == AnimatorIdleNames[j])
                warn("IdleActionsList::CreateAnimatorIdleActionDefinitions - Animator Idle Named " $ AnimatorIdleNames[i] $ " duplicated in IdleActionsList.ini");
		}
	}

    for (i=0; i<AnimatorIdleNames.length; ++i)
    {
        // Create the Animator Idle Definition
        NewAnimatorIdleDefinition = new(self, string(AnimatorIdleNames[i]), 0) class'AnimatorIdleDefinition';
        assert(NewAnimatorIdleDefinition != None);

        AnimatorIdleDefinitions[i] = NewAnimatorIdleDefinition;
    }
}


private function CreateProceduralIdleActionDefinitions()
{
    local int i;
    local ProceduralIdleDefinition NewProceduralIdleDefinition;

    for (i=0; i<ProceduralIdleNames.length; ++i)
    {
        // Create the Procedural Idle Definition
        NewProceduralIdleDefinition = new(self, string(ProceduralIdleNames[i]), 0) class'ProceduralIdleDefinition';
        assert(NewProceduralIdleDefinition != None);

        ProceduralIdleDefinitions[i] = NewProceduralIdleDefinition;
    }
}

///////////////////////////////////////////////////////////////////////////////




// Decompiled with UE Explorer.
defaultproperties
{
    AnimatorIdleNames[0]="CrouchedFidget"
    AnimatorIdleNames[1]="CrouchedFidgetMG"
    AnimatorIdleNames[2]="CrouchedAlertHGA"
    AnimatorIdleNames[3]="CrouchedAlertHGB"
    AnimatorIdleNames[4]="CrouchedAlertHGc"
    AnimatorIdleNames[5]="CrouchedAlertMGA"
    AnimatorIdleNames[6]="CrouchedAlertMGB"
    AnimatorIdleNames[7]="CrouchedAlertMGC"
    AnimatorIdleNames[8]="CrouchedAlertSMG"
    AnimatorIdleNames[9]="CrouchedAlertSG"
    AnimatorIdleNames[10]="CrouchedFidgetEnemyNoGun"
    AnimatorIdleNames[11]="CrouchedFidgetG36"
    AnimatorIdleNames[12]="CrouchedAlertG36A"
    AnimatorIdleNames[13]="CrouchedAlertG36B"
    AnimatorIdleNames[14]="CrouchedAlertG36C"
    AnimatorIdleNames[15]="CrouchedAlertUMP"
    AnimatorIdleNames[16]="StandingFidgetHG"
    AnimatorIdleNames[17]="StandingFidgetScratchHG"
    AnimatorIdleNames[18]="StandingGuardHGA"
    AnimatorIdleNames[19]="StandingGuardHGB"
    AnimatorIdleNames[20]="StandingFidgetMG"
    AnimatorIdleNames[21]="StandingFidgetCheckGunMG"
    AnimatorIdleNames[22]="StandingFidgetLookBehindMG"
    AnimatorIdleNames[23]="StandingFidgetLookAroundMG"
    AnimatorIdleNames[24]="StandingFidgetLookLeftMG"
    AnimatorIdleNames[25]="StandingGuardMGA"
    AnimatorIdleNames[26]="StandingGuardMGB"
    AnimatorIdleNames[27]="StandingGuardSMG"
    AnimatorIdleNames[28]="StandingGuardSG"
    AnimatorIdleNames[29]="StandingFidgetG36"
    AnimatorIdleNames[30]="StandingFidgetCheckGunG36"
    AnimatorIdleNames[31]="StandingFidgetLookBehindG36"
    AnimatorIdleNames[32]="StandingFidgetLookAroundG36"
    AnimatorIdleNames[33]="StandingFidgetLookLeftG36"
    AnimatorIdleNames[34]="StandingGuardG36A"
    AnimatorIdleNames[35]="StandingGuardG36B"
    AnimatorIdleNames[36]="StandingGuardUMP"
    AnimatorIdleNames[37]="StandingFidgetCheckGunUMP"
    AnimatorIdleNames[38]="StandingFidgetUMP"
    AnimatorIdleNames[39]="StandingFidgetCheckGunSMG"
    AnimatorIdleNames[40]="StandingFidgetSMG"
    AnimatorIdleNames[41]="StandingFidgetEnemyNoGun"
    AnimatorIdleNames[42]="StandingStackUpLowReadyHG"
    AnimatorIdleNames[43]="StandingStackUpLowReadyAltHG"
    AnimatorIdleNames[44]="StandingStackUpGripHG"
    AnimatorIdleNames[45]="StandingStackUpLookLeftHG"
    AnimatorIdleNames[46]="StandingStackUpShiftHG"
    AnimatorIdleNames[47]="StandingFidgetLookLeftHG"
    AnimatorIdleNames[48]="StandingFidgetLookRightHG"
    AnimatorIdleNames[49]="StandingFidgetLookAroundHG"
    AnimatorIdleNames[50]="StandingFidgetStepBackLookLeftHG"
    AnimatorIdleNames[51]="StandingStackUpLowReadyMG"
    AnimatorIdleNames[52]="StandingStackUpLowReadyAltMG"
    AnimatorIdleNames[53]="StandingStackUpGripMG"
    AnimatorIdleNames[54]="StandingStackUpHandMG"
    AnimatorIdleNames[55]="StandingStackUpLookLeftMG"
    AnimatorIdleNames[56]="StandingStackUpLookRightMG"
    AnimatorIdleNames[57]="StandingStackUpNeckRollMG"
    AnimatorIdleNames[58]="StandingStackUpShiftMG"
    AnimatorIdleNames[59]="StandingStackUpShoulderMG"
    AnimatorIdleNames[60]="StandingStackUpLowReadyG36"
    AnimatorIdleNames[61]="StandingStackUpLookAroundG36"
    AnimatorIdleNames[62]="StandingStackUpLookLeftG36"
    AnimatorIdleNames[63]="StandingStackUpLookBehindG36"
    AnimatorIdleNames[64]="StandingStackUpLowReadySMG"
    AnimatorIdleNames[65]="StandingStackUpLowReadyAltSMG"
    AnimatorIdleNames[66]="StandingStackUpGripSMG"
    AnimatorIdleNames[67]="StandingStackUpHandSMG"
    AnimatorIdleNames[68]="StandingStackUpLookLeftSMG"
    AnimatorIdleNames[69]="StandingStackUpLookRightSMG"
    AnimatorIdleNames[70]="StandingStackUpNeckRollSMG"
    AnimatorIdleNames[71]="StandingStackUpShiftSMG"
    AnimatorIdleNames[72]="StandingStackUpShoulderSMG"
    AnimatorIdleNames[73]="StandingFidgetLookLeftSMG"
    AnimatorIdleNames[74]="StandingFidgetLookRightSMG"
    AnimatorIdleNames[75]="StandingFidgetLookAroundSMG"
    AnimatorIdleNames[76]="StandingStackUpLowReadyUMP"
    AnimatorIdleNames[77]="StandingStackUpHandUMP"
    AnimatorIdleNames[78]="StandingStackUpShiftUMP"
    AnimatorIdleNames[79]="StandingStackLookRightUMP"
    AnimatorIdleNames[80]="StandingStackUpLowReadySG"
    AnimatorIdleNames[81]="StandingStackUpLowReadyAltSG"
    AnimatorIdleNames[82]="StandingStackUpGripSG"
    AnimatorIdleNames[83]="StandingStackUpHandSG"
    AnimatorIdleNames[84]="StandingStackUpLookLeftSG"
    AnimatorIdleNames[85]="StandingStackUpLookRightSG"
    AnimatorIdleNames[86]="StandingStackUpNeckRollSG"
    AnimatorIdleNames[87]="StandingStackUpShiftSG"
    AnimatorIdleNames[88]="StandingStackUpShoulderSG"
    AnimatorIdleNames[89]="StandingFidgetLookLeftSG"
    AnimatorIdleNames[90]="StandingFidgetLookRightSG"
    AnimatorIdleNames[91]="StandingFidgetLookAroundSG"
    AnimatorIdleNames[92]="StandingFidgetStepBackLookLeftSG"
    AnimatorIdleNames[93]="StandingStackupGrenade"
    AnimatorIdleNames[94]="StandingStackUpLowReadyPB"
    AnimatorIdleNames[95]="StandingStackUpGripPB"
    AnimatorIdleNames[96]="StandingStackUpLookAroundPB"
    AnimatorIdleNames[97]="StandingFidgetLookLeftPB"
    AnimatorIdleNames[98]="StandingFidgetLookRightPB"
    AnimatorIdleNames[99]="StandingFidgetLookAroundPB"
    AnimatorIdleNames[100]="CrouchedHostageFidgetA"
    AnimatorIdleNames[101]="CrouchedHostageFidgetB"
    AnimatorIdleNames[102]="CrouchedHostageFidgetC"
    AnimatorIdleNames[103]="StandingCivilian"
    AnimatorIdleNames[104]="Standing1Civilian"
    AnimatorIdleNames[105]="Standing2Civilian"
    AnimatorIdleNames[106]="StandingArmsFoldedCivilian"
    AnimatorIdleNames[107]="StandingHostageCowerFidgetA"
    AnimatorIdleNames[108]="StandingHostageCowerFidgetB"
    AnimatorIdleNames[109]="StandingHostageCowerFidgetC"
    AnimatorIdleNames[110]="StandingHostageCowerFidgetD"
    AnimatorIdleNames[111]="StandingHostageCowerFidgetE"
    AnimatorIdleNames[112]="StandingLookingIdleA"
    AnimatorIdleNames[113]="StandingAimingEnemy"
    AnimatorIdleNames[114]="CrouchingAiming"
    AnimatorIdleNames[115]="StandingAimingOfficerMG"
    AnimatorIdleNames[116]="StandingAimingOfficerSMG"
    AnimatorIdleNames[117]="StandingAimingOfficerSG"
    AnimatorIdleNames[118]="StandingAimingOfficerHG"
    AnimatorIdleNames[119]="StandingAimingOfficerPB"
    AnimatorIdleNames[120]="Compliant"
    AnimatorIdleNames[121]="CompliantHostage"
    AnimatorIdleNames[122]="CompliantHostageScaredA"
    AnimatorIdleNames[123]="CompliantHostageScaredB"
    AnimatorIdleNames[124]="RestrainedFidget"
    AnimatorIdleNames[125]="RestrainedAggressiveFidgetA"
    AnimatorIdleNames[126]="RestrainedAggressiveFidgetB"
    AnimatorIdleNames[127]="RestrainedAggressiveFidgetC"
    AnimatorIdleNames[128]="TrainerFidgetRail"
    AnimatorIdleNames[129]="TrainerFidgetArmsFolded"
    AnimatorIdleNames[130]="TrainerFidgetArmsHips"
    AnimatorIdleNames[131]="NonCompliantConfusedA"
    AnimatorIdleNames[132]="NonCompliantConfusedB"
    AnimatorIdleNames[133]="NonCompliantConfusedC"
    AnimatorIdleNames[134]="NonCompliantBelligerentA"
    AnimatorIdleNames[135]="NonCompliantBelligerentB"
    AnimatorIdleNames[136]="NonCompliantBelligerentC"
    AnimatorIdleNames[137]="HostageCowerStanding"
    AnimatorIdleNames[138]="HostageCowerCrouchingA"
    AnimatorIdleNames[139]="HostageCowerCrouchingB"
    AnimatorIdleNames[140]="EnemyCowerCrouchingA"
    AnimatorIdleNames[141]="EnemyCowerCrouchingB"
    AnimatorIdleNames[142]="FoodWallWipeCounter"
    AnimatorIdleNames[143]="TalkingA"
    AnimatorIdleNames[144]="TalkingB"
    AnimatorIdleNames[145]="ListeningA"
    AnimatorIdleNames[146]="ListeningB"
    AnimatorIdleNames[147]="NearBoombox"
    AnimatorIdleNames[148]="SmokingA"
    AnimatorIdleNames[149]="StandHostageWallHugRight"
    AnimatorIdleNames[150]="StandHostageWallHugLeft"
    AnimatorIdleNames[151]="StandHostageWallHugCenter"
    AnimatorIdleNames[152]="BarflyLeaning"
    AnimatorIdleNames[153]="WashFaceSink"
    AnimatorIdleNames[154]="LookInCooler"
    AnimatorIdleNames[155]="HittingRegister"
    AnimatorIdleNames[156]="OnFloor"
    AnimatorIdleNames[157]="cCowerInCorner"
    AnimatorIdleNames[158]="sCowerInCorner_FaceOut"
    AnimatorIdleNames[159]="Gargoyle"
    AnimatorIdleNames[160]="hurtLyingAgainstWall"
    AnimatorIdleNames[161]="hurtLyingAgainstWallA"
    AnimatorIdleNames[162]="hurtLyingAgainstWallB"
    AnimatorIdleNames[163]="HurtFacingWall"
    AnimatorIdleNames[164]="hurtFacingWallA"
    AnimatorIdleNames[165]="hurtLyingOnSide"
    AnimatorIdleNames[166]="hurtLyingOnSideA"
    AnimatorIdleNames[167]="hurtOnSideInPain"
    AnimatorIdleNames[168]="hurtOnSideInPainA"
    AnimatorIdleNames[169]="ChairKO"
    AnimatorIdleNames[170]="TamWilSilence"
    AnimatorIdleNames[171]="IncapacitatedA"
    AnimatorIdleNames[172]="IncapacitatedB"
    AnimatorIdleNames[173]="IncapacitatedC"
    AnimatorIdleNames[174]="IncapacitatedD"
    AnimatorIdleNames[175]="IncapacitatedE"
    AnimatorIdleNames[176]="IncapacitatedF"
    AnimatorIdleNames[177]="IncapacitatedG"
    AnimatorIdleNames[178]="IncapacitatedH"
    AnimatorIdleNames[179]="IncapacitatedI"
    AnimatorIdleNames[180]="GenericAllTypesIdleStandingFallback"
    AnimatorIdleNames[181]="GenericOfficerIdleStandingFallback"
    AnimatorIdleNames[182]="GenericAllTypesIdleCrouchingFallback"
    AnimatorIdleNames[183]="GenericOfficerIdleCrouchingFallback"
    AnimatorIdleNames[184]="FreakOut"
    AnimatorIdleNames[185]="FreakOutAgain"
    bHidden=true
}