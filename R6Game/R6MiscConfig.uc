class R6MiscConfig extends R6Config
    native
    hidecategories(Object);

struct SkelBoneInfo
{
    var() R6EngineEnums.EBoneArmsAndHead m_Type;
    var() editconst name m_strBoneName;
    var() float m_fWeight;

    structdefaultproperties
    {
        m_Type=0
        m_strBoneName="None"
        m_fWeight=0.0000000
    }
};

struct SR6LodTemplate
{
    var() float m_fDisplayFactor;
    var() float m_fLODHysteresis;

    structdefaultproperties
    {
        m_fDisplayFactor=0.0000000
        m_fLODHysteresis=0.0000000
    }
};

struct SR6BonesInfo
{
    var Map_Mirror m_BonesInfos;

    structdefaultproperties
    {
        m_BonesInfos=none
    }
};

var(Pickup) float m_fItemDropStrength;
var(Pickup) bool m_bShowWeaponInfoForPickup;
var(PlayerRecognition) bool m_bEnableIcons;
var(PlayerRecognition) bool m_bEnableNames;
var(PlayerRecognition) bool m_bEnableNamesOnHUD;
var(PlayerRecognition) bool m_bEnableHeightScaling;
var(Pickup) float m_fPickupMessageDuration;
var(Pickup) int m_iMaxNbPickupsInMap;
var(Sounds) /*0x04000000-0x00000000*/ float m_fSoundEffectsVolume;
var(Sounds) /*0x04000000-0x00000000*/ float m_fVoiceVolume;
var(Sounds) /*0x04000000-0x00000000*/ float m_fMusicVolume;
var(Sounds) /*0x04000000-0x00000000*/ SoundCue m_SoundNoFlashLight;
var(Interact) float m_fInteractDistance;
var(Interact) float m_fRopePlacementInteractDistance;
var(Interact) float m_fTurretInteractDistance;
var(Interact) float m_fInteractOrderDistance;
var(Interact) float m_fWindowOpenTime;
var(Interact) float m_fHelicopterInteractDistance;
var(Interact) float m_fGeoBrushHeight;
var(Interact) float m_fGeoBrushWidth;
var(Interact) float m_fGeoSeparationRopes;
var(Interact) float m_fGeoLedgeHeightOffset;
var(Multiplayer) float m_fPlayerRecognitionDistance;
var(Multiplayer) float m_fHealingInteractionDistance;
var(Multiplayer) int m_iRespawnDelay;
var(Multiplayer) int m_iRespawnInvulnerabilityDelay;
var(Multiplayer) int m_iTeamKillerRespawnPenalty;
var(Multiplayer) float m_fOptimPawnStayRelevantTime;
var(Multiplayer) /*0x04000000-0x00000000*/ SoundCue m_sndBriefing;
var(Multiplayer) /*0x04000000-0x00000000*/ SoundCue m_sndMissionSucceeded;
var(Multiplayer) /*0x04000000-0x00000000*/ SoundCue m_sndMissionFailed;
var(Retrieval) /*0x04000000-0x00000000*/ SoundCue m_sndCanisterPossessionEnemy;
var(Retrieval) /*0x04000000-0x00000000*/ SoundCue m_sndCanisterPossessionTeam;
var(Retrieval) /*0x04000000-0x00000000*/ SoundCue m_sndCanisterPossessionPlayer;
var(Retrieval) /*0x04000000-0x00000000*/ SoundCue m_sndCanisterLostEnemy;
var(Retrieval) /*0x04000000-0x00000000*/ SoundCue m_sndCanisterLostTeam;
var(Retrieval) /*0x04000000-0x00000000*/ SoundCue m_sndCanisterDeliveredPlayer;
var(Retrieval) /*0x04000000-0x00000000*/ SoundCue m_sndAlphaBriefingPart1;
var(Retrieval) /*0x04000000-0x00000000*/ SoundCue m_sndAlphaBriefingPart2;
var(Retrieval) /*0x04000000-0x00000000*/ SoundCue m_sndAlphaItemDeliveredAlpha;
var(Retrieval) /*0x04000000-0x00000000*/ SoundCue m_sndAlphaItemDeliveredBravo;
var(Retrieval) /*0x04000000-0x00000000*/ SoundCue m_sndBravoBriefingPart1;
var(Retrieval) /*0x04000000-0x00000000*/ SoundCue m_sndBravoBriefingPart2;
var(Retrieval) /*0x04000000-0x00000000*/ SoundCue m_sndBravoItemDeliveredAlpha;
var(Retrieval) /*0x04000000-0x00000000*/ SoundCue m_sndBravoItemDeliveredBravo;
var(ADBombDefuse) /*0x04000000-0x00000000*/ SoundCue m_sndAttackerBriefing;
var(ADBombDefuse) /*0x04000000-0x00000000*/ SoundCue m_sndAttackerBombDefused;
var(ADBombDefuse) /*0x04000000-0x00000000*/ SoundCue m_sndAttackerBombExploded;
var(ADBombDefuse) /*0x04000000-0x00000000*/ SoundCue m_sndDefenderBriefing;
var(ADBombDefuse) /*0x04000000-0x00000000*/ SoundCue m_sndDefenderBombDefused;
var(ADBombDefuse) /*0x04000000-0x00000000*/ SoundCue m_sndDefenderBombExploded;
var(ADItemExtraction) /*0x04000000-0x00000000*/ SoundCue m_sndItemPossessionEnemy;
var(ADItemExtraction) /*0x04000000-0x00000000*/ SoundCue m_sndItemPossessionTeam;
var(ADItemExtraction) /*0x04000000-0x00000000*/ SoundCue m_sndItemPossessionPlayer;
var(ADItemExtraction) /*0x04000000-0x00000000*/ SoundCue m_sndItemLostEnemy;
var(ADItemExtraction) /*0x04000000-0x00000000*/ SoundCue m_sndItemLostTeam;
var(ADItemExtraction) /*0x04000000-0x00000000*/ SoundCue m_sndAttackerIEBriefingPart1;
var(ADItemExtraction) /*0x04000000-0x00000000*/ SoundCue m_sndAttackerIEBriefingPart2;
var(ADItemExtraction) /*0x04000000-0x00000000*/ SoundCue m_sndAttackerItemDeliverySucceeded;
var(ADItemExtraction) /*0x04000000-0x00000000*/ SoundCue m_sndAttackerItemDeliveryFailed;
var(ADItemExtraction) /*0x04000000-0x00000000*/ SoundCue m_sndDefenderIEBriefingPart1;
var(ADItemExtraction) /*0x04000000-0x00000000*/ SoundCue m_sndDefenderIEBriefingPart2;
var(ADItemExtraction) /*0x04000000-0x00000000*/ SoundCue m_sndDefenderItemDeliverySucceeded;
var(ADItemExtraction) /*0x04000000-0x00000000*/ SoundCue m_sndDefenderItemDeliveryFailed;
var(ADHostageRescue) /*0x04000000-0x00000000*/ SoundCue m_sndAttackerHRBriefingPart1;
var(ADHostageRescue) /*0x04000000-0x00000000*/ SoundCue m_sndAttackerHRBriefingPart2;
var(ADHostageRescue) /*0x04000000-0x00000000*/ SoundCue m_sndAttackerHostageRescued;
var(ADHostageRescue) /*0x04000000-0x00000000*/ SoundCue m_sndAttackerAllHostagesRescued;
var(ADHostageRescue) /*0x04000000-0x00000000*/ SoundCue m_sndAttackerNoHostagesRescued;
var(ADHostageRescue) /*0x04000000-0x00000000*/ SoundCue m_sndAttackerHostageDeath;
var(ADHostageRescue) /*0x04000000-0x00000000*/ SoundCue m_sndAttackerAllHostagesDeath;
var(ADHostageRescue) /*0x04000000-0x00000000*/ SoundCue m_sndDefenderHRBriefingPart1;
var(ADHostageRescue) /*0x04000000-0x00000000*/ SoundCue m_sndDefenderHRBriefingPart2;
var(ADHostageRescue) /*0x04000000-0x00000000*/ SoundCue m_sndDefenderHostageRescued;
var(ADHostageRescue) /*0x04000000-0x00000000*/ SoundCue m_sndDefenderAllHostagesRescued;
var(ADHostageRescue) /*0x04000000-0x00000000*/ SoundCue m_sndDefenderNoHostagesRescued;
var(ADHostageRescue) /*0x04000000-0x00000000*/ SoundCue m_sndDefenderHostageDeath;
var(ADHostageRescue) /*0x04000000-0x00000000*/ SoundCue m_sndDefenderAllHostagesDeath;
var(PlayerRecognition) float m_fIconDistanceAboveHead;
var(PlayerRecognition) float m_fIconMinSize;
var(PlayerRecognition) float m_fIconMaxSize;
var(PlayerRecognition) float m_fIconSizeInWorld;
var(PlayerRecognition) float m_fHeightScalingFactor;
var(PlayerRecognition) float m_fHeightScalingIdealW;
var(PlayerRecognition) float m_fMaxWIconVisible;
var(PlayerRecognition) float m_fNameAlphaDelta;
var(Pec) editconstarray int m_NumMaterialsOnHead;
var(Optim) float m_fSpawnInvPerTick;
var(FadeIn) float m_fFadeTimeSP;
var(FadeIn) float m_fFadeTimeMP;
var(FadeIn) float m_fFadeTimeDelaySP;
var(FadeIn) float m_fFadeTimeDelayMP;
var(FadeIn) float m_FadeUnlockInputDeltaSP;
var(FadeIn) float m_FadeUnlockInputDeltaMP;
var float m_fTimeBefore3DRendering;
var(FadeOut) float m_fFadeOutTimeSP;
var(EndCredits) float m_fFadeToBlackTimeBeforeCredits;
var(EndCredits) string m_VideoPackage;
var(EndCredits) string m_VideoName;
var(EndCredits) float m_fTimeBeforeStartCredits;
var(EndCredits) float m_fTimeToShowStory;
var() editconstarray array<SkelBoneInfo> m_ThirdPersonSkelBonesInfo;
var() editconstarray array<SkelBoneInfo> m_FirstPersonSkelBonesInfo;
var SR6BonesInfo m_ThirdPersonSkelBonesInfoMap;
var SR6BonesInfo m_FirstPersonSkelBonesInfoMap;
var(LODTemplate) array<SR6LodTemplate> m_LODTemplate;
var(FXPool) int m_iMaxEmittersInPool;
var(FXPool) int m_iMaxParticlesInPool;

defaultproperties
{
    m_fItemDropStrength=50.0000000
    m_bShowWeaponInfoForPickup=true
    m_bEnableIcons=true
    m_bEnableNamesOnHUD=true
    m_fPickupMessageDuration=3.0000000
    m_iMaxNbPickupsInMap=20
    m_fSoundEffectsVolume=70.0000000
    m_fVoiceVolume=100.0000000
    m_fMusicVolume=90.0000000
    m_fInteractDistance=100.0000000
    m_fRopePlacementInteractDistance=100.0000000
    m_fTurretInteractDistance=100.0000000
    m_fInteractOrderDistance=1500.0000000
    m_fWindowOpenTime=1.5000000
    m_fHelicopterInteractDistance=400.0000000
    m_fGeoBrushHeight=50.0000000
    m_fGeoBrushWidth=50.0000000
    m_fGeoSeparationRopes=200.0000000
    m_fGeoLedgeHeightOffset=16.0000000
    m_fPlayerRecognitionDistance=1000.0000000
    m_fHealingInteractionDistance=100.0000000
    m_fOptimPawnStayRelevantTime=1.0000000
    m_sndBriefing=SoundCue'Dare.VO_Multiplayer.VO_MPB_SPSR_01NARR001'
    m_sndMissionSucceeded=SoundCue'Dare.VO_Multiplayer.VO_MPB_RTVL_06NARR001'
    m_sndMissionFailed=SoundCue'Dare.VO_Multiplayer.VO_MPB_RTVL_06NARR002'
    m_sndCanisterPossessionEnemy=SoundCue'Dare.VO_Multiplayer.VO_MPB_RTVL_02NARR003'
    m_sndCanisterPossessionTeam=SoundCue'Dare.VO_Multiplayer.VO_MPB_RTVL_02NARR002'
    m_sndCanisterPossessionPlayer=SoundCue'Dare.VO_Multiplayer.VO_MPB_RTVL_02NARR001'
    m_sndCanisterLostEnemy=SoundCue'Dare.VO_Multiplayer.VO_MPB_RTVL_03NARR002'
    m_sndCanisterLostTeam=SoundCue'Dare.VO_Multiplayer.VO_MPB_RTVL_03NARR001'
    m_sndCanisterDeliveredPlayer=SoundCue'Dare.VO_Multiplayer.VO_MPB_RTVL_04NARR001'
    m_sndAlphaBriefingPart1=SoundCue'Dare.VO_Multiplayer.VO_MPB_RTVL_01NARR001'
    m_sndAlphaBriefingPart2=SoundCue'Dare.VO_Multiplayer.VO_MPB_RTVL_01NARR002'
    m_sndAlphaItemDeliveredAlpha=SoundCue'Dare.VO_Multiplayer.VO_MPB_RTVL_04NARR002'
    m_sndAlphaItemDeliveredBravo=SoundCue'Dare.VO_Multiplayer.VO_MPB_RTVL_05NARR001'
    m_sndBravoBriefingPart1=SoundCue'Dare.VO_Multiplayer.VO_MPB_RTVL_01NARR003'
    m_sndBravoBriefingPart2=SoundCue'Dare.VO_Multiplayer.VO_MPB_RTVL_01NARR004'
    m_sndBravoItemDeliveredAlpha=SoundCue'Dare.VO_Multiplayer.VO_MPB_RTVL_04NARR003'
    m_sndBravoItemDeliveredBravo=SoundCue'Dare.VO_Multiplayer.VO_MPB_RTVL_05NARR002'
    m_sndAttackerBriefing=SoundCue'Dare.VO_Multiplayer.VO_MPB_ADBD_01NARR001'
    m_sndAttackerBombDefused=SoundCue'Dare.VO_Multiplayer.VO_MPB_ADBD_02NARR001'
    m_sndAttackerBombExploded=SoundCue'Dare.VO_Multiplayer.VO_MPB_ADBD_03NARR001'
    m_sndDefenderBriefing=SoundCue'Dare.VO_Multiplayer.VO_MPB_ADBD_01NARR002'
    m_sndDefenderBombDefused=SoundCue'Dare.VO_Multiplayer.VO_MPB_ADBD_02NARR002'
    m_sndDefenderBombExploded=SoundCue'Dare.VO_Multiplayer.VO_MPB_ADBD_03NARR002'
    m_sndItemPossessionEnemy=SoundCue'Dare.VO_Multiplayer.VO_MPB_ADIE_02NARR003'
    m_sndItemPossessionTeam=SoundCue'Dare.VO_Multiplayer.VO_MPB_ADIE_02NARR002'
    m_sndItemPossessionPlayer=SoundCue'Dare.VO_Multiplayer.VO_MPB_ADIE_02NARR001'
    m_sndItemLostEnemy=SoundCue'Dare.VO_Multiplayer.VO_MPB_ADIE_03NARR002'
    m_sndItemLostTeam=SoundCue'Dare.VO_Multiplayer.VO_MPB_ADIE_03NARR001'
    m_sndAttackerIEBriefingPart1=SoundCue'Dare.VO_Multiplayer.VO_MPB_ADIE_01NARR001'
    m_sndAttackerIEBriefingPart2=SoundCue'Dare.VO_Multiplayer.VO_MPB_ADIE_01NARR002'
    m_sndAttackerItemDeliverySucceeded=SoundCue'Dare.VO_Multiplayer.VO_MPB_ADIE_04NARR001'
    m_sndAttackerItemDeliveryFailed=SoundCue'Dare.VO_Multiplayer.VO_MPB_ADIE_05NARR001'
    m_sndDefenderIEBriefingPart1=SoundCue'Dare.VO_Multiplayer.VO_MPB_ADIE_01NARR003'
    m_sndDefenderIEBriefingPart2=SoundCue'Dare.VO_Multiplayer.VO_MPB_ADIE_01NARR004'
    m_sndDefenderItemDeliverySucceeded=SoundCue'Dare.VO_Multiplayer.VO_MPB_ADIE_04NARR002'
    m_sndDefenderItemDeliveryFailed=SoundCue'Dare.VO_Multiplayer.VO_MPB_ADIE_05NARR002'
    m_sndAttackerHRBriefingPart1=SoundCue'Dare.VO_Multiplayer.VO_MPB_ADHR_01NARR001'
    m_sndAttackerHRBriefingPart2=SoundCue'Dare.VO_Multiplayer.VO_MPB_ADHR_01NARR002'
    m_sndAttackerHostageRescued=SoundCue'Dare.VO_Multiplayer.VO_MPB_ADHR_02NARR001'
    m_sndAttackerAllHostagesRescued=SoundCue'Dare.VO_Multiplayer.VO_MPB_ADHR_03NARR001'
    m_sndAttackerNoHostagesRescued=SoundCue'Dare.VO_Multiplayer.VO_MPB_ADHR_04NARR001'
    m_sndAttackerHostageDeath=SoundCue'Dare.VO_Multiplayer.VO_MPB_ADHR_05NARR001'
    m_sndAttackerAllHostagesDeath=SoundCue'Dare.VO_Multiplayer.VO_MPB_ADHR_05NARR002'
    m_sndDefenderHRBriefingPart1=SoundCue'Dare.VO_Multiplayer.VO_MPB_ADHR_01NARR003'
    m_sndDefenderHRBriefingPart2=SoundCue'Dare.VO_Multiplayer.VO_MPB_ADHR_01NARR004'
    m_sndDefenderHostageRescued=SoundCue'Dare.VO_Multiplayer.VO_MPB_ADHR_02NARR002'
    m_sndDefenderAllHostagesRescued=SoundCue'Dare.VO_Multiplayer.VO_MPB_ADHR_03NARR002'
    m_sndDefenderNoHostagesRescued=SoundCue'Dare.VO_Multiplayer.VO_MPB_ADHR_04NARR002'
    m_sndDefenderHostageDeath=SoundCue'Dare.VO_Multiplayer.VO_MPB_ADHR_05NARR003'
    m_sndDefenderAllHostagesDeath=SoundCue'Dare.VO_Multiplayer.VO_MPB_ADHR_05NARR004'
    m_fIconDistanceAboveHead=50.0000000
    m_fIconMinSize=0.0015000
    m_fIconMaxSize=0.0100000
    m_fIconSizeInWorld=16.0000000
    m_fHeightScalingFactor=2.0000000
    m_fHeightScalingIdealW=300.0000000
    m_fMaxWIconVisible=5000.0000000
    m_fNameAlphaDelta=40.0000000
    m_fSpawnInvPerTick=0.1000000
    m_fFadeTimeSP=3.0000000
    m_fFadeTimeMP=1.0000000
    m_fFadeTimeDelaySP=1.5000000
    m_fFadeTimeDelayMP=0.1000000
    m_FadeUnlockInputDeltaSP=2.0000000
    m_FadeUnlockInputDeltaMP=0.5000000
    m_fTimeBefore3DRendering=0.1000000
    m_fFadeOutTimeSP=2.0000000
    m_fFadeToBlackTimeBeforeCredits=2.0000000
    m_VideoPackage="MenuMovies"
    m_VideoName="MenusSP"
    m_fTimeBeforeStartCredits=3.0000000
    m_fTimeToShowStory=15.0000000
    m_ThirdPersonSkelBonesInfo[0]=(m_Type=0,m_strBoneName="R65_Root",m_fWeight=0.0000000)
    m_ThirdPersonSkelBonesInfo[1]=(m_Type=4,m_strBoneName="R65_BA_Pelvis",m_fWeight=6.6914000)
    m_ThirdPersonSkelBonesInfo[2]=(m_Type=4,m_strBoneName="R65_BA_L_Thigh",m_fWeight=11.1414000)
    m_ThirdPersonSkelBonesInfo[3]=(m_Type=4,m_strBoneName="R65_BA_L_Calf",m_fWeight=6.7500000)
    m_ThirdPersonSkelBonesInfo[4]=(m_Type=4,m_strBoneName="R65_BA_L_Foot",m_fWeight=3.0000000)
    m_ThirdPersonSkelBonesInfo[5]=(m_Type=4,m_strBoneName="R65_BA_L_Toe",m_fWeight=0.7000000)
    m_ThirdPersonSkelBonesInfo[6]=(m_Type=4,m_strBoneName="R65_BJ_L_Knee",m_fWeight=0.0000000)
    m_ThirdPersonSkelBonesInfo[7]=(m_Type=4,m_strBoneName="R65_BA_R_Thigh",m_fWeight=11.6414000)
    m_ThirdPersonSkelBonesInfo[8]=(m_Type=4,m_strBoneName="R65_BA_R_Calf",m_fWeight=7.2500000)
    m_ThirdPersonSkelBonesInfo[9]=(m_Type=4,m_strBoneName="R65_BA_R_Foot",m_fWeight=3.0000000)
    m_ThirdPersonSkelBonesInfo[10]=(m_Type=4,m_strBoneName="R65_BA_R_Toe",m_fWeight=0.7000000)
    m_ThirdPersonSkelBonesInfo[11]=(m_Type=4,m_strBoneName="R65_BJ_R_Knee",m_fWeight=0.0000000)
    m_ThirdPersonSkelBonesInfo[12]=(m_Type=0,m_strBoneName="R65_BA_Spine",m_fWeight=6.6914000)
    m_ThirdPersonSkelBonesInfo[13]=(m_Type=0,m_strBoneName="R65_BA_Spine1",m_fWeight=6.6914000)
    m_ThirdPersonSkelBonesInfo[14]=(m_Type=0,m_strBoneName="R65_BA_Spine2",m_fWeight=6.6914000)
    m_ThirdPersonSkelBonesInfo[15]=(m_Type=1,m_strBoneName="R65_BA_Neck",m_fWeight=6.6914000)
    m_ThirdPersonSkelBonesInfo[16]=(m_Type=1,m_strBoneName="R65_BA_Neck1",m_fWeight=3.9000000)
    m_ThirdPersonSkelBonesInfo[17]=(m_Type=1,m_strBoneName="R65_BA_Head",m_fWeight=3.9000000)
    m_ThirdPersonSkelBonesInfo[18]=(m_Type=1,m_strBoneName="R65_BA_F_Cheek_L",m_fWeight=0.0000000)
    m_ThirdPersonSkelBonesInfo[19]=(m_Type=1,m_strBoneName="R65_BA_F_Cheek_R",m_fWeight=0.0000000)
    m_ThirdPersonSkelBonesInfo[20]=(m_Type=1,m_strBoneName="R65_BA_F_Eye_L",m_fWeight=0.0000000)
    m_ThirdPersonSkelBonesInfo[21]=(m_Type=1,m_strBoneName="R65_BA_F_Eye_R",m_fWeight=0.0000000)
    m_ThirdPersonSkelBonesInfo[22]=(m_Type=1,m_strBoneName="R65_BA_F_EyeBrow_L_In",m_fWeight=0.0000000)
    m_ThirdPersonSkelBonesInfo[23]=(m_Type=1,m_strBoneName="R65_BA_F_EyeBrow_L_Out",m_fWeight=0.0000000)
    m_ThirdPersonSkelBonesInfo[24]=(m_Type=1,m_strBoneName="R65_BA_F_EyeBrow_Middle",m_fWeight=0.0000000)
    m_ThirdPersonSkelBonesInfo[25]=(m_Type=1,m_strBoneName="R65_BA_F_EyeBrow_R_In",m_fWeight=0.0000000)
    m_ThirdPersonSkelBonesInfo[26]=(m_Type=1,m_strBoneName="R65_BA_F_EyeBrow_R_Out",m_fWeight=0.0000000)
    m_ThirdPersonSkelBonesInfo[27]=(m_Type=1,m_strBoneName="R65_BA_F_EyeLid_L_Low",m_fWeight=0.0000000)
    m_ThirdPersonSkelBonesInfo[28]=(m_Type=1,m_strBoneName="R65_BA_F_EyeLid_L_Up",m_fWeight=0.0000000)
    m_ThirdPersonSkelBonesInfo[29]=(m_Type=1,m_strBoneName="R65_BA_F_EyeLid_R_Low",m_fWeight=0.0000000)
    m_ThirdPersonSkelBonesInfo[30]=(m_Type=1,m_strBoneName="R65_BA_F_EyeLid_R_Up",m_fWeight=0.0000000)
    m_ThirdPersonSkelBonesInfo[31]=(m_Type=1,m_strBoneName="R65_BA_F_Lip_Corner_L",m_fWeight=0.0000000)
    m_ThirdPersonSkelBonesInfo[32]=(m_Type=1,m_strBoneName="R65_BA_F_Lip_Corner_R",m_fWeight=0.0000000)
    m_ThirdPersonSkelBonesInfo[33]=(m_Type=1,m_strBoneName="R65_BA_F_Lip_Corner_Up_L",m_fWeight=0.0000000)
    m_ThirdPersonSkelBonesInfo[34]=(m_Type=1,m_strBoneName="R65_BA_F_Lip_Corner_Up_R",m_fWeight=0.0000000)
    m_ThirdPersonSkelBonesInfo[35]=(m_Type=1,m_strBoneName="R65_BA_F_Lip_Upper_L",m_fWeight=0.0000000)
    m_ThirdPersonSkelBonesInfo[36]=(m_Type=1,m_strBoneName="R65_BA_F_Lip_Upper_R",m_fWeight=0.0000000)
    m_ThirdPersonSkelBonesInfo[37]=(m_Type=1,m_strBoneName="R65_BA_F_Mouth_Corner_L",m_fWeight=0.0000000)
    m_ThirdPersonSkelBonesInfo[38]=(m_Type=1,m_strBoneName="R65_BA_F_Mouth_Corner_R",m_fWeight=0.0000000)
    m_ThirdPersonSkelBonesInfo[39]=(m_Type=1,m_strBoneName="R65_BA_F_Mouth_Jaw",m_fWeight=0.0000000)
    m_ThirdPersonSkelBonesInfo[40]=(m_Type=1,m_strBoneName="R65_BA_F_Lip_Lower_R",m_fWeight=0.0000000)
    m_ThirdPersonSkelBonesInfo[41]=(m_Type=1,m_strBoneName="R65_BA_F_Lip_Lower_L",m_fWeight=0.0000000)
    m_ThirdPersonSkelBonesInfo[42]=(m_Type=1,m_strBoneName="R65_BA_F_Mouth_Chin",m_fWeight=0.0000000)
    m_ThirdPersonSkelBonesInfo[43]=(m_Type=1,m_strBoneName="R65_BA_F_Mouth_Tongue",m_fWeight=0.0000000)
    m_ThirdPersonSkelBonesInfo[44]=(m_Type=2,m_strBoneName="R65_BA_L_Clavicle",m_fWeight=0.0000000)
    m_ThirdPersonSkelBonesInfo[45]=(m_Type=2,m_strBoneName="R65_BA_L_UpperArm",m_fWeight=1.3500000)
    m_ThirdPersonSkelBonesInfo[46]=(m_Type=2,m_strBoneName="R65_BJ_L_Elbow",m_fWeight=2.1167000)
    m_ThirdPersonSkelBonesInfo[47]=(m_Type=2,m_strBoneName="R65_BR_L_UpperArm_Roll",m_fWeight=0.0000000)
    m_ThirdPersonSkelBonesInfo[48]=(m_Type=2,m_strBoneName="R65_BA_L_Forearm",m_fWeight=0.7667000)
    m_ThirdPersonSkelBonesInfo[49]=(m_Type=2,m_strBoneName="R65_BR_L_Forearm_Roll",m_fWeight=0.0000000)
    m_ThirdPersonSkelBonesInfo[50]=(m_Type=2,m_strBoneName="R65_BA_L_Hand",m_fWeight=1.3667000)
    m_ThirdPersonSkelBonesInfo[51]=(m_Type=2,m_strBoneName="R65_BA_L_F_Thumb_1",m_fWeight=0.0000000)
    m_ThirdPersonSkelBonesInfo[52]=(m_Type=2,m_strBoneName="R65_BA_L_F_Thumb_2",m_fWeight=0.0000000)
    m_ThirdPersonSkelBonesInfo[53]=(m_Type=2,m_strBoneName="R65_BA_L_F_Thumb_3",m_fWeight=0.0000000)
    m_ThirdPersonSkelBonesInfo[54]=(m_Type=2,m_strBoneName="R65_BA_L_F_Index_1",m_fWeight=0.0000000)
    m_ThirdPersonSkelBonesInfo[55]=(m_Type=2,m_strBoneName="R65_BA_L_F_Index_2",m_fWeight=0.0000000)
    m_ThirdPersonSkelBonesInfo[56]=(m_Type=2,m_strBoneName="R65_BA_L_F_Index_3",m_fWeight=0.0000000)
    m_ThirdPersonSkelBonesInfo[57]=(m_Type=2,m_strBoneName="R65_BA_L_F_Middle_1",m_fWeight=0.0000000)
    m_ThirdPersonSkelBonesInfo[58]=(m_Type=2,m_strBoneName="R65_BA_L_F_Middle_2",m_fWeight=0.0000000)
    m_ThirdPersonSkelBonesInfo[59]=(m_Type=2,m_strBoneName="R65_BA_L_F_Middle_3",m_fWeight=0.0000000)
    m_ThirdPersonSkelBonesInfo[60]=(m_Type=2,m_strBoneName="R65_BA_L_F_RingPink_1",m_fWeight=0.0000000)
    m_ThirdPersonSkelBonesInfo[61]=(m_Type=2,m_strBoneName="R65_BA_L_F_RingPink_2",m_fWeight=0.0000000)
    m_ThirdPersonSkelBonesInfo[62]=(m_Type=3,m_strBoneName="R65_BA_R_Clavicle",m_fWeight=0.0000000)
    m_ThirdPersonSkelBonesInfo[63]=(m_Type=3,m_strBoneName="R65_BA_R_UpperArm",m_fWeight=1.3500000)
    m_ThirdPersonSkelBonesInfo[64]=(m_Type=3,m_strBoneName="R65_BJ_R_Elbow",m_fWeight=2.1167000)
    m_ThirdPersonSkelBonesInfo[65]=(m_Type=3,m_strBoneName="R65_BR_R_UpperArm_Roll",m_fWeight=0.0000000)
    m_ThirdPersonSkelBonesInfo[66]=(m_Type=3,m_strBoneName="R65_BA_R_Forearm",m_fWeight=0.7667000)
    m_ThirdPersonSkelBonesInfo[67]=(m_Type=3,m_strBoneName="R65_BR_R_Forearm_Roll",m_fWeight=0.0000000)
    m_ThirdPersonSkelBonesInfo[68]=(m_Type=3,m_strBoneName="R65_BA_R_Hand",m_fWeight=1.3667000)
    m_ThirdPersonSkelBonesInfo[69]=(m_Type=3,m_strBoneName="R65_BA_R_F_Thumb_1",m_fWeight=0.0000000)
    m_ThirdPersonSkelBonesInfo[70]=(m_Type=3,m_strBoneName="R65_BA_R_F_Thumb_2",m_fWeight=0.0000000)
    m_ThirdPersonSkelBonesInfo[71]=(m_Type=3,m_strBoneName="R65_BA_R_F_Thumb_3",m_fWeight=0.0000000)
    m_ThirdPersonSkelBonesInfo[72]=(m_Type=3,m_strBoneName="R65_BA_R_F_Index_1",m_fWeight=0.0000000)
    m_ThirdPersonSkelBonesInfo[73]=(m_Type=3,m_strBoneName="R65_BA_R_F_Index_2",m_fWeight=0.0000000)
    m_ThirdPersonSkelBonesInfo[74]=(m_Type=3,m_strBoneName="R65_BA_R_F_Index_3",m_fWeight=0.0000000)
    m_ThirdPersonSkelBonesInfo[75]=(m_Type=3,m_strBoneName="R65_BA_R_F_Middle_1",m_fWeight=0.0000000)
    m_ThirdPersonSkelBonesInfo[76]=(m_Type=3,m_strBoneName="R65_BA_R_F_Middle_2",m_fWeight=0.0000000)
    m_ThirdPersonSkelBonesInfo[77]=(m_Type=3,m_strBoneName="R65_BA_R_F_Middle_3",m_fWeight=0.0000000)
    m_ThirdPersonSkelBonesInfo[78]=(m_Type=3,m_strBoneName="R65_BA_R_F_RingPink_1",m_fWeight=0.0000000)
    m_ThirdPersonSkelBonesInfo[79]=(m_Type=3,m_strBoneName="R65_BA_R_F_RingPink_2",m_fWeight=0.0000000)
    m_ThirdPersonSkelBonesInfo[80]=(m_Type=5,m_strBoneName="R65_BA_Camera",m_fWeight=0.0000000)
    m_ThirdPersonSkelBonesInfo[81]=(m_Type=0,m_strBoneName="R65_BA_Attach_01",m_fWeight=0.0000000)
    m_ThirdPersonSkelBonesInfo[82]=(m_Type=0,m_strBoneName="R65_BA_Attach_02",m_fWeight=0.0000000)
    m_ThirdPersonSkelBonesInfo[83]=(m_Type=0,m_strBoneName="R65_BA_Attach_03",m_fWeight=0.0000000)
    m_FirstPersonSkelBonesInfo[0]=(m_Type=0,m_strBoneName="R65_BA_ROOT",m_fWeight=0.0000000)
    m_FirstPersonSkelBonesInfo[1]=(m_Type=0,m_strBoneName="R65_BA_Spine2",m_fWeight=0.0000000)
    m_FirstPersonSkelBonesInfo[2]=(m_Type=1,m_strBoneName="R65_BA_Neck",m_fWeight=0.0000000)
    m_FirstPersonSkelBonesInfo[3]=(m_Type=1,m_strBoneName="R65_BA_Neck1",m_fWeight=0.0000000)
    m_FirstPersonSkelBonesInfo[4]=(m_Type=1,m_strBoneName="R65_BA_Head",m_fWeight=0.0000000)
    m_FirstPersonSkelBonesInfo[5]=(m_Type=2,m_strBoneName="R65_BA_L_Clavicle",m_fWeight=0.0000000)
    m_FirstPersonSkelBonesInfo[6]=(m_Type=2,m_strBoneName="R65_BA_L_UpperArm",m_fWeight=0.0000000)
    m_FirstPersonSkelBonesInfo[7]=(m_Type=2,m_strBoneName="R65_BA_L_Forearm",m_fWeight=0.0000000)
    m_FirstPersonSkelBonesInfo[8]=(m_Type=2,m_strBoneName="R65_BA_L_Hand",m_fWeight=0.0000000)
    m_FirstPersonSkelBonesInfo[9]=(m_Type=2,m_strBoneName="R65_BA_L_F_Thumb_1",m_fWeight=0.0000000)
    m_FirstPersonSkelBonesInfo[10]=(m_Type=2,m_strBoneName="R65_BA_L_F_Thumb_2",m_fWeight=0.0000000)
    m_FirstPersonSkelBonesInfo[11]=(m_Type=2,m_strBoneName="R65_BA_L_F_Thumb_3",m_fWeight=0.0000000)
    m_FirstPersonSkelBonesInfo[12]=(m_Type=2,m_strBoneName="R65_BA_L_F_Index_1",m_fWeight=0.0000000)
    m_FirstPersonSkelBonesInfo[13]=(m_Type=2,m_strBoneName="R65_BA_L_F_Index_2",m_fWeight=0.0000000)
    m_FirstPersonSkelBonesInfo[14]=(m_Type=2,m_strBoneName="R65_BA_L_F_Index_3",m_fWeight=0.0000000)
    m_FirstPersonSkelBonesInfo[15]=(m_Type=2,m_strBoneName="R65_BA_L_F_Middle_1",m_fWeight=0.0000000)
    m_FirstPersonSkelBonesInfo[16]=(m_Type=2,m_strBoneName="R65_BA_L_F_Middle_2",m_fWeight=0.0000000)
    m_FirstPersonSkelBonesInfo[17]=(m_Type=2,m_strBoneName="R65_BA_L_F_Middle_3",m_fWeight=0.0000000)
    m_FirstPersonSkelBonesInfo[18]=(m_Type=2,m_strBoneName="R65_BA_L_F_RingPink_1",m_fWeight=0.0000000)
    m_FirstPersonSkelBonesInfo[19]=(m_Type=2,m_strBoneName="R65_BA_L_F_RingPink_2",m_fWeight=0.0000000)
    m_FirstPersonSkelBonesInfo[20]=(m_Type=2,m_strBoneName="R65_BA_L_F_RingPink_3",m_fWeight=0.0000000)
    m_FirstPersonSkelBonesInfo[21]=(m_Type=2,m_strBoneName="R65_BA_L_F_Pinky_1",m_fWeight=0.0000000)
    m_FirstPersonSkelBonesInfo[22]=(m_Type=2,m_strBoneName="R65_BA_L_F_Pinky_2",m_fWeight=0.0000000)
    m_FirstPersonSkelBonesInfo[23]=(m_Type=2,m_strBoneName="R65_BA_L_F_Pinky_3",m_fWeight=0.0000000)
    m_FirstPersonSkelBonesInfo[24]=(m_Type=2,m_strBoneName="R65_BR_L_Forearm_Roll",m_fWeight=0.0000000)
    m_FirstPersonSkelBonesInfo[25]=(m_Type=2,m_strBoneName="R65_BJ_L_Elbow",m_fWeight=0.0000000)
    m_FirstPersonSkelBonesInfo[26]=(m_Type=3,m_strBoneName="R65_BA_R_Clavicle",m_fWeight=0.0000000)
    m_FirstPersonSkelBonesInfo[27]=(m_Type=3,m_strBoneName="R65_BA_R_UpperArm",m_fWeight=0.0000000)
    m_FirstPersonSkelBonesInfo[28]=(m_Type=3,m_strBoneName="R65_BA_R_Forearm",m_fWeight=0.0000000)
    m_FirstPersonSkelBonesInfo[29]=(m_Type=3,m_strBoneName="R65_BA_R_Hand",m_fWeight=0.0000000)
    m_FirstPersonSkelBonesInfo[30]=(m_Type=3,m_strBoneName="R65_BA_R_F_Thumb_1",m_fWeight=0.0000000)
    m_FirstPersonSkelBonesInfo[31]=(m_Type=3,m_strBoneName="R65_BA_R_F_Thumb_2",m_fWeight=0.0000000)
    m_FirstPersonSkelBonesInfo[32]=(m_Type=3,m_strBoneName="R65_BA_R_F_Thumb_3",m_fWeight=0.0000000)
    m_FirstPersonSkelBonesInfo[33]=(m_Type=3,m_strBoneName="R65_BA_R_F_Index_1",m_fWeight=0.0000000)
    m_FirstPersonSkelBonesInfo[34]=(m_Type=3,m_strBoneName="R65_BA_R_F_Index_2",m_fWeight=0.0000000)
    m_FirstPersonSkelBonesInfo[35]=(m_Type=3,m_strBoneName="R65_BA_R_F_Index_3",m_fWeight=0.0000000)
    m_FirstPersonSkelBonesInfo[36]=(m_Type=3,m_strBoneName="R65_BA_R_F_Middle_1",m_fWeight=0.0000000)
    m_FirstPersonSkelBonesInfo[37]=(m_Type=3,m_strBoneName="R65_BA_R_F_Middle_2",m_fWeight=0.0000000)
    m_FirstPersonSkelBonesInfo[38]=(m_Type=3,m_strBoneName="R65_BA_R_F_Middle_3",m_fWeight=0.0000000)
    m_FirstPersonSkelBonesInfo[39]=(m_Type=3,m_strBoneName="R65_BA_R_F_RingPink_1",m_fWeight=0.0000000)
    m_FirstPersonSkelBonesInfo[40]=(m_Type=3,m_strBoneName="R65_BA_R_F_RingPink_2",m_fWeight=0.0000000)
    m_FirstPersonSkelBonesInfo[41]=(m_Type=3,m_strBoneName="R65_BA_R_F_RingPink_3",m_fWeight=0.0000000)
    m_FirstPersonSkelBonesInfo[42]=(m_Type=3,m_strBoneName="R65_BA_R_F_Pinky_1",m_fWeight=0.0000000)
    m_FirstPersonSkelBonesInfo[43]=(m_Type=3,m_strBoneName="R65_BA_R_F_Pinky_2",m_fWeight=0.0000000)
    m_FirstPersonSkelBonesInfo[44]=(m_Type=3,m_strBoneName="R65_BA_R_F_Pinky_3",m_fWeight=0.0000000)
    m_FirstPersonSkelBonesInfo[45]=(m_Type=3,m_strBoneName="R65_BR_R_Forearm_Roll",m_fWeight=0.0000000)
    m_FirstPersonSkelBonesInfo[46]=(m_Type=3,m_strBoneName="R65_BJ_R_Elbow",m_fWeight=0.0000000)
    m_FirstPersonSkelBonesInfo[47]=(m_Type=5,m_strBoneName="R65_BA_Camera",m_fWeight=0.0000000)
    m_ThirdPersonSkelBonesInfoMap=(m_BonesInfos=none)
    m_FirstPersonSkelBonesInfoMap=(m_BonesInfos=none)
    m_LODTemplate[0]=(m_fDisplayFactor=0.0000000,m_fLODHysteresis=0.2000000)
    m_LODTemplate[1]=(m_fDisplayFactor=0.7000000,m_fLODHysteresis=0.2000000)
    m_LODTemplate[2]=(m_fDisplayFactor=0.4000000,m_fLODHysteresis=0.2000000)
    m_LODTemplate[3]=(m_fDisplayFactor=0.1500000,m_fLODHysteresis=0.2000000)
    m_iMaxEmittersInPool=50
    m_iMaxParticlesInPool=50
    m_szDescription="Misc configuration"
}