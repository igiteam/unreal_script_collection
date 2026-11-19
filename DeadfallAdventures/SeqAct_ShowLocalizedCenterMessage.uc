class SeqAct_ShowLocalizedCenterMessage extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var() string LocTag;
var() string LocSection;
var() bool IsLong;
var() SoundCue Sound;
var transient array<AdvPlayerController> CachedPCs;

event Activated()
{
    local SeqVar_Object ObjVar;
    local AdvPawn P;
    local AdvPlayerController PC;

    CachedPCs.Remove(0, CachedPCs.Length);    
    // End:0xC2
    foreach LinkedVariables(Class'Engine.SeqVar_Object', ObjVar, "Players")
    {
        P = AdvPawn(ObjVar.GetObjectValue());
        // End:0xC1
        if(P != none)
        {
            PC = FindPC(P);
            // End:0xC1
            if(PC != none)
            {
                CachedPCs.AddItem(PC);                
            }
        }        
    }    
    // End:0x167
    foreach CachedPCs(PC)
    {
        PC.ShowCenterMessageOnHUD(LocSection, LocTag, IsLong);
        // End:0x166
        if(Sound != none)
        {
            PC.Kismet_ClientPlaySound(Sound, PC, 1.0000000, 1.0000000, 0.0000000, true, true);
        }        
    }    
    OutputLinks[0].bHasImpulse = true;
    //return;    
}

function AdvPlayerController FindPC(EvilPawn P)
{
    local AdvPlayerController PC;

    // End:0xA6
    foreach Class'Engine.WorldInfo'.static.GetWorldInfo().AllControllers(Class'AdvPlayerController', PC)
    {
        // End:0xA5
        if(PC.bIsPlayer && PC.Pawn == P)
        {            
            return PC;
        }        
    }    
    return none;
    //return ReturnValue;    
}

defaultproperties
{
    LocSection="LocalizedCenterMessages"
    bAutoActivateOutputLinks=false
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Players",LinkVar="None",PropertyName="Players",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Show Localized Center Message"
}