class AdvCTFBasementBase extends EvilGameObjective
    abstract
    hidecategories(Navigation,Lighting,LightColor,Force,VehicleUsage,VehicleUsage,Objective,VoiceMessage,Announcements);

var() export editinline AudioComponent TakenSound;
var AdvCTFFlagBase myFlag;
var class<AdvCTFFlagBase> FlagType;
var class<AdvCTFFlagBase> AlternateFlagType;
var() float MidFieldHighZOffset;
var() float MidFieldLowZOffset;
var() float NearBaseRadius;
var() float BaseExitTime;
var export editinline ParticleSystemComponent BaseParticles;
var export editinline ParticleSystemComponent AlternateBaseParticles;
var export editinline StaticMeshComponent FlagBaseMesh;
var class<UTLocalMessage> CTFAnnouncerMessagesClass;
var array<SoundNodeWave> NearLocationSpeech;
var array<SoundNodeWave> MidfieldHighSpeech;
var array<SoundNodeWave> MidfieldLowSpeech;
var Class CTFGameClass;

simulated function HideIfNotCTF()
{
    // End:0x113
    if((WorldInfo.GRI != none) && WorldInfo.GRI.GameClass != none)
    {
        // End:0x106
        if(class<AdvGameCTFBase>(WorldInfo.GRI.GameClass) == none)
        {
            FlagBaseMesh.SetHidden(true);
            BaseParticles.SetActive(false);
            AlternateBaseParticles.SetActive(false);            
        }
        else
        {
            SetParticles();
        }        
    }
    else
    {
        SetTimer(0.0100000, false, 'HideIfNotCTF');
    }
    //return;    
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    HideIfNotCTF();
    // End:0x2A
    if(int(Role) < int(ROLE_Authority))
    {
        return;
    }
    // End:0x61
    if(AdvGameCTFBase(WorldInfo.Game) != none)
    {
        Restart();
    }
    //return;    
}

function Restart()
{
    // End:0x32
    if(myFlag != none)
    {
        myFlag.Destroy();
        myFlag = none;
    }
    // End:0x98
    if(AdvGRI(WorldInfo.GRI).bTeamsInverted)
    {
        myFlag = Spawn(AlternateFlagType, self);        
    }
    else
    {
        myFlag = Spawn(FlagType, self);
    }
    // End:0xCF
    if(myFlag == none)
    {
        return;        
    }
    else
    {
        // End:0x133
        if(AdvGRI(WorldInfo.GRI).bTeamsInverted)
        {
            DefenderTeamIndex = ((int(DefenderTeamIndex) == int(1)) ? 0 : 1);
        }
        AdvGameCTFBase(WorldInfo.Game).RegisterFlag(myFlag, int(DefenderTeamIndex));
        myFlag.HomeBase = self;
    }
    //return;    
}

simulated function SetParticles()
{
    // End:0x85
    if(AdvGRI(WorldInfo.GRI).bTeamsInverted)
    {
        BaseParticles.SetActive(false);
        AlternateBaseParticles.SetActive(true);        
    }
    else
    {
        BaseParticles.SetActive(true);
        AlternateBaseParticles.SetActive(false);
    }
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
    // End:0xAA
    if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
    {
        // End:0x7C
        if(bNowOn)
        {
            // End:0x79
            if(TakenSound != none)
            {
                TakenSound.Play();
            }            
        }
        else
        {
            // End:0xAA
            if(TakenSound != none)
            {
                TakenSound.Stop();
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
    // Reference: CylinderComponent'Default__AdvCTFBasementBase.CollisionCylinder'
    begin object name=CollisionCylinder
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