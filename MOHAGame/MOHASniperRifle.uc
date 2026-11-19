class MOHASniperRifle extends MOHASingleShotReloadWeapon
    abstract
    config(Weapon)
    hidecategories(Navigation);

var bool RenderCursorWhenNotInIronSights;

function name GetPlayerShootStimulusID()
{
    return 'PlayerShootSniper';
    //return ReturnValue;    
}

function float GetPlayerShootThreatTime()
{
    return 10.0000000;
    //return ReturnValue;    
}

simulated function SpawnImpactStimulus(Vector StartTrace, Vector Loc)
{
    local name stimulusTableID;

    super(EALAWeapon).SpawnImpactStimulus(StartTrace, Loc);
    // End:0x11C
    if(NotEqual_InterfaceInterface(MOHAControllerInterface(Instigator.Controller), MOHAControllerInterface(none)))
    {
        // End:0x6C
        if(MOHAControllerInterface(Instigator.Controller).GetTeamIndex() == 0)
        {
            stimulusTableID = 'AlliedSniperFire';            
        }
        else
        {
            stimulusTableID = 'AxisSniperFire';
        }
        MOHAControllerInterface(Instigator.Controller).GetStimulusComponent().AttachSender('SniperFire', stimulusTableID, Loc, rot(0, 0, 0),, 0, true, true);
        MOHAControllerInterface(Instigator.Controller).GetStimulusComponent().PushStimuliSenderParamName('SniperFire', 'Shooter', Instigator.Name);
    }
    //return;    
}

simulated state IronsightsOut
{
    simulated function EndState(name NextStateName)
    {
        super.EndState(NextStateName);
        // End:0x28
        if(MOHAPlayerPawn(Instigator) != none)
        {
            RenderCursor = RenderCursorWhenNotInIronSights;
        }
        //return;        
    }
    stop;    
}

state WeaponSingleFire
{
    simulated function OutOfAmmo()
    {
        StopFire(CurrentFireMode);
        // End:0x30
        if(int(IronsightsState) == int(3))
        {
            GotoState('IronsightsWaitForReload');            
        }
        else
        {
            GotoState('WeaponReload');
        }
        //return;        
    }
    stop;    
}

state IronsightsWaitForReload
{
    simulated function StateTick(float DeltaTime)
    {
        super(EALASmallArms).StateTick(DeltaTime);
        // End:0x28
        if(!IronsightsButtonDown())
        {
            GotoState('IronsightsOut');
        }
        //return;        
    }

    simulated function ScopeStopFire(byte FireModeNum)
    {
        GotoState('IronsightsOut');
        //return;        
    }

    simulated event ProcessViewRotation(float DeltaTime, out Rotator out_ViewRotation, out Rotator out_DeltaRot)
    {
        super(EALASmallArms).ProcessViewRotation(DeltaTime, out_ViewRotation, out_DeltaRot);
        TrueTriggerComponent.InternalProcessViewRotation(DeltaTime, out_ViewRotation, out_DeltaRot);
        //return;        
    }
    stop;    
}

defaultproperties
{
    RenderCursorWhenNotInIronSights=true
    // Reference: WeaponAccuracyComponent'Default__MOHASniperRifle.WeaponAccuracy'
    begin object name=WeaponAccuracy
    end object
    AccuracyComponent=WeaponAccuracy
    // Reference: WeaponAccuracyComponent'Default__MOHASniperRifle.IronsightsWeaponAccuracy'
    begin object name=IronsightsWeaponAccuracy
    end object
    IronsightsAccuracyComponent=IronsightsWeaponAccuracy
    CanRechamberInIronsight=true
    bScopeEnabled=true
    bTrueTriggerEnabled=true
    // Reference: WeaponKickComponent'Default__MOHASniperRifle.WeaponKick'
    begin object name=WeaponKick
    end object
    KickComponent=WeaponKick
    // Reference: WeaponKickComponent'Default__MOHASniperRifle.IronsightsWeaponKick'
    begin object name=IronsightsWeaponKick
    end object
    IronsightsKickComponent=IronsightsWeaponKick
    // Reference: WeaponScopeComponent'Default__MOHASniperRifle.WeaponScope'
    begin object name=WeaponScope class=Class'WeaponScopeComponent'
    end object
    ScopeComponent=WeaponScope
    // Reference: WeaponTrueTriggerComponent'Default__MOHASniperRifle.WeaponTrueTrigger'
    begin object name=WeaponTrueTrigger class=Class'WeaponTrueTriggerComponent'
    end object
    TrueTriggerComponent=WeaponTrueTrigger
    // Reference: AudioComponent'Default__MOHASniperRifle.BreathingComponent'
    begin object name=BreathingComponent class=Class'Engine.AudioComponent'
        bStopWhenOwnerDestroyed=true
    end object
    BreathingAudioComponent=BreathingComponent
    // Reference: WhizSenderComponent'Default__MOHASniperRifle.whiz'
    begin object name=whiz
    end object
    WhizComponent=whiz
    WeaponFireNoiseRadius=10000.0000000
    BulletImpactStimulusThreat=10.0000000
    WeaponClass=4
    AttachmentClass=Class'SniperRifleAttachment'
    FiringStatesArray=/* Array type was not detected. */
    FireInterval=/* Array type was not detected. */
    InstantHitDamage=/* Array type was not detected. */
    InstantHitMomentum=/* Array type was not detected. */
    InstantHitDamageTypes=/* Array type was not detected. */
    // Reference: MOHASkeletalMeshComponent'Default__MOHASniperRifle.PickupMesh'
    begin object name=PickupMesh
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    Components[0]=WeaponAccuracy
    Components[1]=IronsightsWeaponAccuracy
    Components[2]=WeaponKick
    Components[3]=IronsightsWeaponKick
    Components[4]=WeaponScope
    Components[5]=WeaponTrueTrigger
    Components[6]=BreathingComponent
}