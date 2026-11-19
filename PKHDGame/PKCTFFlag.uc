class PKCTFFlag extends EvilCarriedObject
    abstract
    hidecategories(Navigation);

var ParticleSystem RespawnEffect;
var bool bBringUpBright;
var bool bBringDownFromBright;
var repnotify bool bFadingOut;
var repnotify bool bRespawning;
var repnotify bool bActivateFlash;
var bool bWasClothEnabled;
var array<MaterialInstanceConstant> MICArray;
var Vector RunningClothVelClamp;
var Vector HoverboardingClothVelClamp;
var export editinline ParticleSystemComponent SuccessfulCaptureSystem;
var export editinline DynamicLightEnvironmentComponent LightEnvironment;
var float LastLocationPingTime;

replication
{
    // Pos:0x000
    if(int(Role) == int(ROLE_Authority))
        bFadingOut, bRespawning;

    // Pos:0x011
    if(bNetDirty)
        bActivateFlash;
}

simulated event ReplicatedEvent(name VarName)
{
    // End:0x31
    if(VarName == 'bFadingOut')
    {
        // End:0x2E
        if(bFadingOut)
        {
            CustomFadeOutEffects();
        }        
    }
    else
    {
        // End:0x62
        if(VarName == 'bRespawning')
        {
            // End:0x5F
            if(bRespawning)
            {
                CustomRespawnEffects();
            }            
        }
        else
        {
            // End:0x93
            if(VarName == 'bActivateFlash')
            {
                // End:0x90
                if(bActivateFlash)
                {
                    FlashEffect();
                }                
            }
            else
            {
                super.ReplicatedEvent(VarName);
            }
        }
    }
    //return;    
}

simulated function PostBeginPlay()
{
    local int I;

    super.PostBeginPlay();
    I = 0;
    J0x15:

    // End:0xA1 [Loop If]
    if(I < SkelMesh.Materials.Length)
    {
        MICArray.Insert(I, 1);
        MICArray[I] = SkelMesh.CreateAndSetMaterialInstanceConstant(I);
        ++I;
        // [Loop Continue]
        goto J0x15;
    }
    SkelMesh.PlayAnim('Idle',, true);
    //return;    
}

simulated function Tick(float DeltaTime)
{
    local int I;
    local name TimerInUse;

    // End:0x1B8
    if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
    {
        // End:0x4C
        if(bFadingOut)
        {
            TimerInUse = 'CustomFadeOutEffects';            
        }
        else
        {
            // End:0x6C
            if(bRespawning)
            {
                TimerInUse = 'bringUpBrightOff';
            }
        }
        // End:0x117
        if(bBringUpBright)
        {
            I = 0;
            J0x84:

            // End:0x114 [Loop If]
            if(I < MICArray.Length)
            {
                MICArray[I].SetScalarParameterValue('FlagBrightness', 1.0000000 - ((GetTimerRate(TimerInUse) - GetTimerCount(TimerInUse)) / 0.5000000));
                ++I;
                // [Loop Continue]
                goto J0x84;
            }            
        }
        else
        {
            // End:0x1B8
            if(bBringDownFromBright)
            {
                I = 0;
                J0x12F:

                // End:0x1B8 [Loop If]
                if(I < MICArray.Length)
                {
                    MICArray[I].SetScalarParameterValue('FlagOpacity', (GetTimerRate(TimerInUse) - GetTimerCount(TimerInUse)) / 0.5000000);
                    ++I;
                    // [Loop Continue]
                    goto J0x12F;
                }
            }
        }
    }
    //return;    
}

simulated event OnBaseChainChanged()
{
    local PKPawn UTP;

    UTP = PKPawn(Base);
    // End:0xD6
    if(UTP != none)
    {
        UTP.Mesh.bForceUpdateAttachmentsInTick = true;
        SkelMesh.SetShadowParent(UTP.Mesh);
        ClearTimer('SetFlagDynamicLightToNotBeDynamic');
        LightEnvironment.bDynamic = true;        
    }
    else
    {
        SkelMesh.bClothBaseVelClamp = false;
        SkelMesh.SetAttachClothVertsToBaseBody(false);
        SkelMesh.SetShadowParent(none);
        LightEnvironment.bDynamic = true;
        SetTimer(5.0000000, false, 'SetFlagDynamicLightToNotBeDynamic');
        // End:0x1C2
        if(PKPawn(OldBase) != none)
        {
            PKPawn(OldBase).Mesh.bForceUpdateAttachmentsInTick = false;
        }
    }
    //return;    
}

simulated function FlashEffect()
{
    SuccessfulCaptureSystem.ActivateSystem();
    //return;    
}

simulated function bool ShouldMinimapRenderFor(PlayerController PC)
{
    return (bHome || PC.PlayerReplicationInfo.Team != Team) || (WorldInfo.TimeSeconds - LastLocationPingTime) < 5.0000000;
    //return ReturnValue;    
}

simulated function ClientReturnedHome()
{
    super.ClientReturnedHome();
    // End:0x28
    if(HomeBase != none)
    {
        SetBase(HomeBase);
    }
    //return;    
}

function SetHolder(Controller C)
{
    local PKPawn UTP;

    SkelMesh.SetTranslation(vect(0.0000000, 0.0000000, 0.0000000));
    UTP = PKPawn(C.Pawn);
    LightEnvironment.bDynamic = true;
    SkelMesh.SetShadowParent(UTP.Mesh);
    ClearTimer('SetFlagDynamicLightToNotBeDynamic');
    super.SetHolder(C);
    //return;    
}

function bool ValidHolder(Actor Other)
{
    local Controller C;

    // End:0x1A
    if(!super.ValidHolder(Other))
    {
        return false;
    }
    C = Pawn(Other).Controller;
    // End:0xA1
    if(WorldInfo.GRI.OnSameTeam(self, C))
    {
        SameTeamTouch(C);
        return false;
    }
    return true;
    //return ReturnValue;    
}

function SameTeamTouch(Controller C)
{
    //return;    
}

simulated function CustomRespawnEffects()
{
    local int I;

    bRespawning = true;
    bFadingOut = false;
    ClearTimer('CustomFadeOutEffects');
    SetTimer(1.0000000, false, 'bringUpBrightOff');
    // End:0x194
    if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
    {
        // End:0xCA
        if(RespawnEffect != none)
        {
            WorldInfo.MyEmitterPool.SpawnEmitter(RespawnEffect, Location, Rotation, self);
        }
        bBringUpBright = true;
        bBringDownFromBright = false;
        I = 0;
        J0xED:

        // End:0x14A [Loop If]
        if(I < MICArray.Length)
        {
            MICArray[I].SetScalarParameterValue('FlagOpacity', 1.0000000);
            I++;
            // [Loop Continue]
            goto J0xED;
        }
        bWasClothEnabled = SkelMesh.bEnableClothSimulation;
        SkelMesh.SetEnableClothSimulation(false);
    }
    //return;    
}

simulated function bringUpBrightOff()
{
    local int I;

    // End:0xC6
    if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
    {
        bBringUpBright = false;
        I = 0;
        J0x40:

        // End:0x9D [Loop If]
        if(I < MICArray.Length)
        {
            MICArray[I].SetScalarParameterValue('FlagBrightness', 0.0000000);
            ++I;
            // [Loop Continue]
            goto J0x40;
        }
        SkelMesh.SetEnableClothSimulation(bWasClothEnabled);
    }
    bRespawning = false;
    //return;    
}

simulated function CustomFadeOutEffects()
{
    local int I;

    // End:0x15E
    if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
    {
        // End:0xB9
        if(bBringUpBright)
        {
            bBringUpBright = false;
            bBringDownFromBright = true;
            I = 0;
            J0x59:

            // End:0xB6 [Loop If]
            if(I < MICArray.Length)
            {
                MICArray[I].SetScalarParameterValue('FlagBrightness', 0.0000000);
                ++I;
                // [Loop Continue]
                goto J0x59;
            }            
        }
        else
        {
            // End:0x13F
            if(bBringDownFromBright)
            {
                I = 0;
                J0xD1:

                // End:0x12E [Loop If]
                if(I < MICArray.Length)
                {
                    MICArray[I].SetScalarParameterValue('FlagOpacity', 1.0000000);
                    ++I;
                    // [Loop Continue]
                    goto J0xD1;
                }
                bBringDownFromBright = false;
                return;                
            }
            else
            {
                bBringUpBright = true;
            }
        }
        SetTimer(0.5000000, false, 'CustomFadeOutEffects');
    }
    //return;    
}

function ClearCaptureFlag()
{
    bActivateFlash = false;
    //return;    
}

function Drop(optional Controller Killer)
{
    SetFlagPropertiesToStationaryFlagState();
    super.Drop(Killer);
    //return;    
}

function SetFlagPropertiesToStationaryFlagState()
{
    SkelMesh.SetTranslation(vect(0.0000000, 0.0000000, -40.0000000));
    LightEnvironment.bDynamic = true;
    SkelMesh.SetShadowParent(none);
    SetTimer(5.0000000, false, 'SetFlagDynamicLightToNotBeDynamic');
    //return;    
}

function SetFlagDynamicLightToNotBeDynamic()
{
    ClearTimer('SetFlagDynamicLightToNotBeDynamic');
    LightEnvironment.bDynamic = false;
    //return;    
}

auto state Home
{
    ignores SendHome, Score, Drop;

    function BeginState(name PreviousStateName)
    {
        SetFlagPropertiesToStationaryFlagState();
        CustomRespawnEffects();
        super.BeginState(PreviousStateName);
        // End:0x91
        if(Team != none)
        {
            PainGRI(WorldInfo.GRI).SetFlagHome(Team.TeamIndex);
        }
        EvilGameObjective(HomeBase).SetAlarm(false);
        HomeBase.bForceNetUpdate = true;
        bForceNetUpdate = true;
        bActivateFlash = false;
        SetBase(HomeBase);
        HomeBase.ObjectiveChanged();
        //return;        
    }

    function EndState(name NextStateName)
    {
        super.EndState(NextStateName);
        EvilGameObjective(HomeBase).SetAlarm(true);
        HomeBase.bForceNetUpdate = true;
        //return;        
    }

    function SameTeamTouch(Controller C)
    {
        local PKCTFFlag Flag;

        // End:0x13E
        if(PainPRI(C.PlayerReplicationInfo).bHasFlag)
        {
            Flag = PKCTFFlag(PainPRI(C.PlayerReplicationInfo).GetFlag());
            PKGameCTF(WorldInfo.Game).ScoreFlag(C, Flag);
            SuccessfulCaptureSystem.SetActive(true);
            bActivateFlash = true;
            SetTimer(0.5000000, false, 'ClearCaptureFlag');
            Flag.Score();
        }
        //return;        
    }
    stop;    
}

state Dropped
{
    ignores Drop;

    function SameTeamTouch(Controller C)
    {
        PKGameCTF(WorldInfo.Game).ScoreFlag(C, self);
        SendHome(C);
        //return;        
    }

    function Timer()
    {
        // End:0x26
        if(bFadingOut)
        {
            super.Timer();
            bFadingOut = false;            
        }
        else
        {
            bFadingOut = true;
            CustomFadeOutEffects();
            SetTimer(1.0000000);
        }
        //return;        
    }
    stop;    
}

defaultproperties
{
    RunningClothVelClamp=(X=500.0000000,Y=500.0000000,Z=200.0000000)
    HoverboardingClothVelClamp=(X=300.0000000,Y=300.0000000,Z=200.0000000)
    // Reference: DynamicLightEnvironmentComponent'Default__PKCTFFlag.FlagLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'FlagLightEnvironment'
    begin object name="FlagLightEnvironment" class=Class'Engine.DynamicLightEnvironmentComponent'
        bDynamic=false
    end object
    LightEnvironment=FlagLightEnvironment
    LastLocationPingTime=-100.0000000
    bUseTeamColorForIcon=true
    MapSize=0.4000000
    IconCoords=(U=843.0000000,V=86.0000000,UL=46.0000000,VL=44.0000000)
    GameObjBone3P="Spine"
    GameObjOffset3P=(X=0.0000000,Y=16.0000000,Z=0.0000000)
    GameObjRot3P=(Pitch=0,Yaw=16384,Roll=-16384)
    GameObjOffset1P=(X=-45.0000000,Y=-8.0000000,Z=30.0000000)
    GameObjRot1P=(Pitch=0,Yaw=0,Roll=-3640)
    // Reference: PointLightComponent'Default__PKCTFFlag.FlagLightComponent'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'FlagLightComponent'
    begin object name="FlagLightComponent" class=Class'Engine.PointLightComponent'
        Radius=250.0000000
        Brightness=5.0000000
        CastShadows=false
        LightingChannels=(Dynamic=false,CompositeDynamic=false)
    end object
    FlagLight=FlagLightComponent
    // Reference: ForceFeedbackWaveform'Default__PKCTFFlag.ForceFeedbackWaveformPickUp'
    // Archetype: ForceFeedbackWaveform'EvilGame.Default__EvilCarriedObject.ForceFeedbackWaveformPickUp'
    begin object name="ForceFeedbackWaveformPickUp"
    end object
    PickUpWaveForm=ForceFeedbackWaveformPickUp
    // Reference: SkeletalMeshComponent'Default__PKCTFFlag.TheFlagSkelMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'TheFlagSkelMesh'
    begin object name="TheFlagSkelMesh" class=Class'Engine.SkeletalMeshComponent'
        Animations=AnimNodeSequence'Default__PKCTFFlag.AnimNodeSeq0'
        AnimSets[0]=AnimSet'go_Flag_01.Anim.as_flag_01'
        bUpdateSkelWhenNotRendered=false
        bPerBoneMotionBlur=true
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__PKCTFFlag.FlagLightEnvironment'
        RBChannel=ERBCollisionChannel.RBCC_Nothing
        BlockRigidBody=true
        Translation=(X=0.0000000,Y=0.0000000,Z=-40.0000000)
    end object
    SkelMesh=TheFlagSkelMesh
    bHome=true
    HomeBaseOffset=(X=0.0000000,Y=0.0000000,Z=1.0000000)
    // Reference: CylinderComponent'Default__PKCTFFlag.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'EvilGame.Default__EvilCarriedObject.CollisionCylinder'
    begin object name="CollisionCylinder"
        CollisionHeight=85.0000000
        ReplacementPrimitive=none
    end object
    Components[0]=CollisionCylinder
    Components[1]=FlagLightComponent
    Components[2]=FlagLightEnvironment
    Components[3]=TheFlagSkelMesh
    bHardAttach=true
    bCollideActors=true
    NetPriority=3.0000000
    CollisionComponent=CollisionCylinder
}