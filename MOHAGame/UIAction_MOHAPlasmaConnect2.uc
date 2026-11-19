class UIAction_MOHAPlasmaConnect2 extends UIAction_PlasmaConnect2
    hidecategories(Object);

function Start()
{
    local Plasma P;
    local PlasmaConnectionParameters ConnParams;
    local DataStoreClient DataStoreManager;
    local UIDataStore_MOHAGameResource GameResources;

    P = Class'Plasma.Plasma'.static.GetPlasma();
    DataStoreManager = Class'Engine.UIInteraction'.static.GetDataStoreClient();
    // End:0x5D
    if(DataStoreManager != none)
    {
        GameResources = UIDataStore_MOHAGameResource(DataStoreManager.FindDataStore('MOHAGameResources'));
    }
    // End:0x138
    if((!P.InviteAccepted && GameResources != none) && GameResources.bPlayerInputSelected)
    {
        ConnParams = new Class'Plasma.PlasmaConnectionParameters';
        ConnParams.loginMode = loginMode;
        ConnParams.SetIgnoreSubAccount(true);
        ConnParams.Locale = P.GetPlasmaLocale();
        ConnParams.activeUserIndex = -1;
        ConnParams.activeUserIndex = GameResources.nControllerID;
        P.Connect(ConnParams);        
    }
    else
    {
        super.Start();
    }
    //return;    
}

defaultproperties
{
    ObjName="MOHA Connect Plasma2"
}