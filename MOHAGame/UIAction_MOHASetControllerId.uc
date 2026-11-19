class UIAction_MOHASetControllerId extends UIAction
    hidecategories(Object);

var int NewControllerId;
var bool bAlreadyUsed;

event Activated()
{
    local Plasma P;
    local LocalPlayer PlayerOwner;
    local DataStoreClient DataStoreManager;
    local UIDataStore_MOHAGameResource GameResources;
    local array<LocalizedStringSetting> Contexts;
    local array<SettingsProperty> Properties;

    DataStoreManager = Class'Engine.UIInteraction'.static.GetDataStoreClient();
    // End:0x44
    if(DataStoreManager != none)
    {
        GameResources = UIDataStore_MOHAGameResource(DataStoreManager.FindDataStore('MOHAGameResources'));
    }
    // End:0x79
    if((GameResources != none) && GameResources.bPlayerInputSelected)
    {
        OutputLinks[0].bHasImpulse = false;
        return;
    }
    P = Class'Plasma.Plasma'.static.GetPlasma();
    // End:0xB8
    if(P.InviteAccepted)
    {
        GamepadID = P.InviteUserIndex;
    }
    // End:0x1A6
    if((GamepadID >= 0) && GamepadID < 4)
    {
        PlayerOwner = GetOwner().GetPlayerOwner();
        // End:0x1A6
        if(PlayerOwner != none)
        {
            PlayerOwner.SetControllerId(GamepadID);
            PlayerIndex = Class'Engine.UIInteraction'.static.GetPlayerIndex(PlayerOwner.ControllerId);
            P.SwitchActiveUserIndex(GamepadID);
            Class'Plasma.Plasma'.static.GetPlasma().SetRichPresence(byte(GamepadID), 1, Contexts, Properties);
            NewControllerId = GamepadID;
            GameResources.nControllerID = NewControllerId;
            GameResources.bPlayerInputSelected = true;
        }
    }
    //return;    
}

defaultproperties
{
    NewControllerId=-1
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Int',LinkedVariables=none,LinkDesc="New ControllerId",LinkVar="None",PropertyName="NewControllerId",bWriteable=true,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Int',LinkedVariables=none,LinkDesc="Player Index",LinkVar="None",PropertyName="None",bWriteable=true,bHidden=true,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[2]=(ExpectedType=Class'Engine.SeqVar_Int',LinkedVariables=none,LinkDesc="Gamepad Id",LinkVar="None",PropertyName="GamepadID",bWriteable=true,bHidden=true,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    ObjName="MOHA Set Player Controller"
}