class SeqAct_MarkAndBoom extends SeqAct_Latent
    forcescriptorder(true)
    hidecategories(Object);

var() EvilExplosion SignTemplate;
var() EvilExplosion ExplosionTemplate;
var() float TimeInterval;
var Pawn PlayerPawn;
var Vector LastKnownLocation;
var float ActualTime;
var bool bWaitingForExplosion;
var() Rotator RotationAdjust;
var() Vector LocationAdjust;

event Activated()
{
    local SeqVar_Object ObjVar;

    // End:0x10D
    if(InputLinks[0].bHasImpulse)
    {
        // End:0x10C
        foreach LinkedVariables(Class'Engine.SeqVar_Object', ObjVar, "Players")
        {
            PlayerPawn = Pawn(ObjVar.GetObjectValue());
            // End:0x10B
            if(PlayerPawn != none)
            {
                Explode(PlayerPawn, PlayerPawn.Location, SignTemplate);
                LastKnownLocation = PlayerPawn.Location;
                bWaitingForExplosion = true;
                ActualTime = 0.0000000;
                // End:0x10C
                break;
            }            
        }        
    }
    //return;    
}

event bool Update(float DeltaTime)
{
    // End:0x85
    if(bWaitingForExplosion)
    {
        ActualTime += DeltaTime;
        // End:0x85
        if(ActualTime > TimeInterval)
        {
            ActualTime = 0.0000000;
            bWaitingForExplosion = false;
            Explode(PlayerPawn, LastKnownLocation, ExplosionTemplate);
            ActivateOutputLink(0);
            return false;
        }
    }
    return true;
    //return ReturnValue;    
}

function Explode(Actor Locator, Vector Location, EvilExplosion Template)
{
    local EvilExplosionActor ExplosionActor;
    local EvilExplosion ExplosionObject;

    // End:0x102
    if((Locator != none) && Template != none)
    {
        ExplosionObject = new Template.Class (Template);
        ExplosionActor = Locator.Spawn(Class'EvilGame.EvilExplosionActor', Locator,, Location + LocationAdjust, RotationAdjust);
        ExplosionObject.HitNormal = Vector(RotationAdjust);
        ExplosionActor.Explode(ExplosionObject);
    }
    //return;    
}

defaultproperties
{
    SignTemplate=EvilExplosion'adv_ps_ch_BossFight.Archetype.ar_HellSign'
    ExplosionTemplate=EvilExplosion'adv_ps_ch_BossFight.Archetype.ar_HellFire'
    TimeInterval=2.0000000
    RotationAdjust=(Pitch=16380,Yaw=0,Roll=0)
    LocationAdjust=(X=0.0000000,Y=0.0000000,Z=-60.0000000)
    LatentActivationTime=0.5000000
    bAutoActivateOutputLinks=false
    InputLinks[0]=(LinkDesc="Activate",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Players",LinkVar="None",PropertyName="Players",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="MarkAndBoom"
}