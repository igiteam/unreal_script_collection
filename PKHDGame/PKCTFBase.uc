class PKCTFBase extends EvilGameObjective
    abstract
    hidecategories(Navigation,Lighting,LightColor,Force,VehicleUsage,VehicleUsage,Objective,VoiceMessage,Announcements);

var() export editinline AudioComponent TakenSound;
var PKCTFFlag myFlag;
var class<PKCTFFlag> FlagType;
var() float MidFieldHighZOffset;
var() float MidFieldLowZOffset;
var() float NearBaseRadius;
var() float BaseExitTime;
var export editinline ParticleSystemComponent FlagEmptyParticles;
var MaterialInstanceConstant FlagBaseMaterial;
var MaterialInstanceConstant MIC_FlagBaseColor;
var export editinline StaticMeshComponent FlagBaseMesh;
var class<UTLocalMessage> CTFAnnouncerMessagesClass;
var array<SoundNodeWave> NearLocationSpeech;
var array<SoundNodeWave> MidfieldHighSpeech;
var array<SoundNodeWave> MidfieldLowSpeech;
var Class CTFGameClass;

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    // End:0x20
    if(int(Role) < int(ROLE_Authority))
    {
        return;
    }
    // End:0xF5
    if(PKGameCTF(WorldInfo.Game) != none)
    {
        myFlag = Spawn(FlagType, self);
        // End:0x84
        if(myFlag == none)
        {
            return;            
        }
        else
        {
            PKGameCTF(WorldInfo.Game).RegisterFlag(myFlag, int(DefenderTeamIndex));
            myFlag.HomeBase = self;
        }
    }
    MIC_FlagBaseColor = new (Outer) Class'Engine.MaterialInstanceConstant';
    MIC_FlagBaseColor.SetParent(FlagBaseMaterial);
    FlagBaseMesh.SetMaterial(0, MIC_FlagBaseColor);
    //return;    
}

event Actor GetBestViewTarget()
{
    // End:0x46
    if(myFlag.Holder != none)
    {
        return myFlag.Holder;        
    }
    else
    {
        // End:0x77
        if(!myFlag.bHome)
        {
            return myFlag;            
        }
        else
        {
            return super(UDKGameObjective).GetBestViewTarget();
        }
    }
    //return ReturnValue;    
}

simulated function SoundNodeWave GetLocationSpeechFor(PlayerController PC, int LocationSpeechOffset, int MessageIndex)
{
    // End:0x41
    if(MessageIndex == 0)
    {
        return ((LocationSpeechOffset < LocationSpeech.Length) ? LocationSpeech[LocationSpeechOffset] : none);        
    }
    else
    {
        // End:0x82
        if(MessageIndex == 1)
        {
            return ((LocationSpeechOffset < NearLocationSpeech.Length) ? NearLocationSpeech[LocationSpeechOffset] : none);            
        }
        else
        {
            // End:0xC4
            if(MessageIndex == 2)
            {
                return ((LocationSpeechOffset < MidfieldHighSpeech.Length) ? MidfieldHighSpeech[LocationSpeechOffset] : none);                
            }
            else
            {
                // End:0x103
                if(MessageIndex == 3)
                {
                    return ((LocationSpeechOffset < MidfieldLowSpeech.Length) ? MidfieldLowSpeech[LocationSpeechOffset] : none);
                }
            }
        }
    }
    return none;
    //return ReturnValue;    
}

function ObjectiveChanged()
{
    local PlayerController PC;

    // End:0x12A
    if(myFlag != none)
    {
        // End:0x129
        foreach WorldInfo.AllControllers(Class'Engine.PlayerController', PC)
        {
            // End:0x128
            if(((PC.ViewTarget == self) || PC.ViewTarget == myFlag) || (PC.ViewTarget != none) && PC.ViewTarget == myFlag.Holder)
            {
                PC.SetViewTarget(GetBestViewTarget());
            }            
        }        
    }
    //return;    
}

function EvilCarriedObject GetFlag()
{
    return myFlag;
    //return ReturnValue;    
}

simulated function SetAlarm(bool bNowOn)
{
    bUnderAttack = bNowOn;
    // End:0x108
    if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
    {
        // End:0xAC
        if(bNowOn)
        {
            // End:0x79
            if(TakenSound != none)
            {
                TakenSound.Play();
            }
            // End:0xA9
            if(FlagEmptyParticles != none)
            {
                FlagEmptyParticles.SetActive(true);
            }            
        }
        else
        {
            // End:0xDA
            if(TakenSound != none)
            {
                TakenSound.Stop();
            }
            // End:0x108
            if(FlagEmptyParticles != none)
            {
                FlagEmptyParticles.DeactivateSystem();
            }
        }
    }
    //return;    
}

simulated event ReplicatedEvent(name VarName)
{
    // End:0x2E
    if(VarName == 'bUnderAttack')
    {
        SetAlarm(bUnderAttack);        
    }
    else
    {
        super.ReplicatedEvent(VarName);
    }
    //return;    
}

simulated event bool IsActive()
{
    return true;
    //return ReturnValue;    
}

defaultproperties
{
    MidFieldHighZOffset=250.0000000
    MidFieldLowZOffset=-250.0000000
    NearBaseRadius=4000.0000000
    MinimapIconScale=7.0000000
    // Reference: CylinderComponent'Default__PKCTFBase.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'EvilGame.Default__EvilGameObjective.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=none
    Components[1]=none
    Components[2]=none
    Components[3]=CollisionCylinder
    Components[4]=none
    CollisionComponent=CollisionCylinder
}