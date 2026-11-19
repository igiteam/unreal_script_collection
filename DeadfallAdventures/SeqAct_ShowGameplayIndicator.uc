class SeqAct_ShowGameplayIndicator extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var() AdvGFxHud.EIndicatorType IndicatorType;
var array< Class > IndicatorItemClasses;

event Activated()
{
    local SeqVar_Object ObjVar;
    local EvilPawn P;

    // End:0x200
    foreach LinkedVariables(Class'Engine.SeqVar_Object', ObjVar, "Players")
    {
        // End:0xA9
        if(EvilPlayerController(ObjVar.GetObjectValue()) != none)
        {
            P = EvilPawn(EvilPlayerController(ObjVar.GetObjectValue()).Pawn);            
        }
        else
        {
            P = EvilPawn(ObjVar.GetObjectValue());
        }
        // End:0x1FF
        if(P != none)
        {
            // End:0x1FF
            if(((IndicatorItemClasses[int(IndicatorType)] == none) || P.WeaponLeft == none) || !ClassIsChildOf(P.WeaponLeft.Class, IndicatorItemClasses[int(IndicatorType)]))
            {
                AdvGFxHud(AdvGFxHudWrapper(EvilPlayerController(P.Controller).myHUD).HudMovie).ShowGameplayIndicator(IndicatorType);
            }
        }        
    }    
    //return;    
}

defaultproperties
{
    IndicatorItemClasses[0]=Class'AdvInventoryItem_Compass'
    IndicatorItemClasses[1]=Class'AdvInventoryItem_Notepad'
    IndicatorItemClasses[2]=none
    IndicatorItemClasses[3]=none
    IndicatorItemClasses[4]=none
    IndicatorItemClasses[5]=none
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Players",LinkVar="None",PropertyName="Players",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Show Gameplay Indicator"
}