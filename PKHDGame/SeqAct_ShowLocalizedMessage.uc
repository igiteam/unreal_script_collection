class SeqAct_ShowLocalizedMessage extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var() string Id;
var() bool long;
var() bool ParseTags;
var transient array<EvilPlayerController> CachedPCs;

event Activated()
{
    local EvilGame Game;
    local SeqVar_Object ObjVar;
    local EvilPawn P;
    local EvilPlayerController PC;
    local MessageInfo MSI;

    Game = EvilGame(Class'Engine.WorldInfo'.static.GetWorldInfo().Game);
    MSI = Game.LocalizedMessages.FindMessageInfo(Id);
    // End:0xB4
    if(Len(MSI.Id) <= 0)
    {
        return;
    }
    // End:0x160
    foreach LinkedVariables(Class'Engine.SeqVar_Object', ObjVar, "Players")
    {
        P = EvilPawn(ObjVar.GetObjectValue());
        // End:0x15F
        if(P != none)
        {
            PC = FindPC(P);
            // End:0x15F
            if(PC != none)
            {
                CachedPCs.AddItem(PC);
            }
        }        
    }    
    // End:0x291
    foreach CachedPCs(PC)
    {
        EvilGFxHudWrapper(PC.myHUD).HudMovie.SetLocalizedMessageText(MSI.Message, long, ParseTags);
        // End:0x290
        if(Len(MSI.Sound) > 0)
        {
            PC.Pawn.PlaySound(SoundCue(DynamicLoadObject(MSI.Sound, Class'Engine.SoundCue')));
        }        
    }    
    OutputLinks[0].bHasImpulse = true;
    //return;    
}

function EvilPlayerController FindPC(EvilPawn P)
{
    local EvilPlayerController PC;

    // End:0xA6
    foreach Class'Engine.WorldInfo'.static.GetWorldInfo().AllControllers(Class'EvilPlayerController', PC)
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
    ParseTags=true
    bAutoActivateOutputLinks=false
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Players",LinkVar="None",PropertyName="Players",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Show Localized Message"
}