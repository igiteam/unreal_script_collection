class SeqAct_OverrideEvilTriggerParams extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var(TriggerCaption) string LocModule;
var(TriggerCaption) string LocSection;
var(TriggerCaption) string LocString;
var(TriggerCaption) string LocAltSection;
var(TriggerCaption) string LocAltString;
var(TriggerCaption) bool Use3DCaption;
var(TriggerCaption) bool bVisible;
var(TriggerCaption) bool UseColorizing;
var(TriggerCaption) bool DrawBorders;
var(TriggerCaption) bool DrawAlt;
var(TriggerCaption) Vector Offset;
var(TriggerCaption) Vector OffsetAlt;

event Activated()
{
    local SeqVar_Object ObjVar;
    local EvilUsableTriggerWithText TheUsableTrigger;

    // End:0x6D
    foreach LinkedVariables(Class'Engine.SeqVar_Object', ObjVar, "Trigger")
    {
        TheUsableTrigger = EvilUsableTriggerWithText(ObjVar.GetObjectValue());
        // End:0x6C
        if(TheUsableTrigger != none)
        {
            // End:0x6D
            break;
        }        
    }    
    // End:0xBB
    if(TheUsableTrigger == none)
    {
        ScriptLog(("WARNING: Trigger variable for" @ string(self)) @ "is empty");        
    }
    else
    {
        // End:0x3C4
        if(InputLinks[0].bHasImpulse)
        {
            TheUsableTrigger.CaptionComponent.SetCaptionLoc(LocString, LocSection, LocModule);
            TheUsableTrigger.CaptionComponent.SetCaptionAltLoc(LocAltString, LocAltSection, LocModule);
            TheUsableTrigger.CaptionComponent.Use3DCaption = self.Use3DCaption;
            TheUsableTrigger.CaptionComponent.Offset = self.Offset;
            TheUsableTrigger.CaptionComponent.OffsetAlt = self.OffsetAlt;
            // End:0x2AC
            if(self.bVisible)
            {
                TheUsableTrigger.CaptionComponent.Show();                
            }
            else
            {
                TheUsableTrigger.CaptionComponent.Hide();
            }
            TheUsableTrigger.CaptionComponent.UseColorizing = self.UseColorizing;
            TheUsableTrigger.CaptionComponent.DrawBorders = self.DrawBorders;
            TheUsableTrigger.CaptionComponent.DrawAlt = self.DrawAlt;
        }
    }
    //return;    
}

defaultproperties
{
    LocModule="EvilGame"
    LocSection="Captions"
    LocAltSection="CaptionsAlt"
    Use3DCaption=true
    bVisible=true
    Offset=(X=0.0000000,Y=0.0000000,Z=45.0000000)
    OffsetAlt=(X=0.0000000,Y=0.0000000,Z=60.0000000)
    bCallHandler=false
    InputLinks[0]=(LinkDesc="Override",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Trigger",LinkVar="None",PropertyName="Targets",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=1,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Evil trigger params"
}