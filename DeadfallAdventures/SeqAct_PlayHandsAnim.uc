class SeqAct_PlayHandsAnim extends SeqAct_Latent
    forcescriptorder(true)
    hidecategories(Object);

var() name AnimName;
var() float Duration;
var() float BlendInTime;
var() float BlendOutTime;
var() bool bLooping;
var() bool bOverride;
var() bool bPlayAnimOnLeftWeapon;
var bool bEndOfAnimation;
var() float StartTime;
var EvilPlayer_interface PawnInstigator;

function PlayHandsAnim()
{
    local Weapon Hands;

    // End:0x3A
    if(bPlayAnimOnLeftWeapon)
    {
        Hands = PawnInstigator.GetWeaponLeft();        
    }
    else
    {
        Hands = PawnInstigator.GetWeapon();
    }
    // End:0x1CA
    if(EvilWeap_MeleeHands(Hands) != none)
    {
        EvilWeap_MeleeHands(Hands).SetPlayingCustomAnim(true);
        EvilWeap_MeleeHands(Hands).PlayArmAnim(AnimName, Duration, BlendInTime, BlendOutTime, bLooping, bOverride, StartTime);
        EvilWeap_MeleeHands(Hands).PlayWeaponAnim(AnimName, Duration, BlendInTime, BlendOutTime, bLooping, bOverride, StartTime);
        PawnInstigator.SetOnArmAnimEndDelegate(OnArmAnimEnd, bPlayAnimOnLeftWeapon);
        bAborted = false;
        bEndOfAnimation = false;
    }
    //return;    
}

event Activated()
{
    local SeqVar_Object ObjVar;

    // End:0xC6
    if(InputLinks[0].bHasImpulse)
    {
        // End:0xC5
        foreach LinkedVariables(Class'Engine.SeqVar_Object', ObjVar, "Instigator")
        {
            PawnInstigator = EvilPlayer_interface(ObjVar.GetObjectValue());
            // End:0xAC
            if(NotEqual_InterfaceInterface(PawnInstigator, EvilPlayer_interface(none)))
            {
                PlayHandsAnim();
                // End:0xC4
                continue;
            }
            bAborted = true;
            bEndOfAnimation = true;            
        }        
    }
    //return;    
}

event Deactivated()
{
    // End:0x4A
    if(NotEqual_InterfaceInterface(PawnInstigator, EvilPlayer_interface(none)))
    {
        PawnInstigator.ResetOnArmAnimEndDelegate(bPlayAnimOnLeftWeapon);
    }
    //return;    
}

function OnArmAnimEnd(bool RightHand, optional AnimNodeSequence SeqNode, optional float PlayedTime, optional float ExcessTime)
{
    local Weapon Weap;

    // End:0x3D
    if(bPlayAnimOnLeftWeapon)
    {
        Weap = PawnInstigator.GetWeaponLeft();        
    }
    else
    {
        Weap = PawnInstigator.GetWeapon();
    }
    // End:0xA8
    if(EvilWeap_MeleeHands(Weap) != none)
    {
        EvilWeap_MeleeHands(Weap).SetPlayingCustomAnim(false);
    }
    bEndOfAnimation = true;
    //return;    
}

event bool Update(float DeltaTime)
{
    local Weapon Weap;

    // End:0xDF
    if(InputLinks[1].bHasImpulse)
    {
        // End:0x5C
        if(bPlayAnimOnLeftWeapon)
        {
            Weap = PawnInstigator.GetWeaponLeft();            
        }
        else
        {
            Weap = PawnInstigator.GetWeapon();
        }
        // End:0xC7
        if(EvilWeap_MeleeHands(Weap) != none)
        {
            EvilWeap_MeleeHands(Weap).SetPlayingCustomAnim(false);
        }
        bEndOfAnimation = true;
        LatentActors.Length = 0;
    }
    return !bEndOfAnimation;
    //return ReturnValue;    
}

static event int GetObjClassVersion()
{
    return super(SequenceObject).GetObjClassVersion() + 2;
    //return ReturnValue;    
}

defaultproperties
{
    InputLinks[0]=(LinkDesc="In",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    InputLinks[1]=(LinkDesc="Stop Playing",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Instigator",LinkVar="None",PropertyName="Instigator",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Play Hands Animation"
}