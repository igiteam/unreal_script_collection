class UIScene_PDAMsgList extends UIScene_BasePDA;

struct CategoryInfo
{
    /** INCLUDES MACROS STRUCT DECLARATIONS */
    var() array<Surface> ImageList;
    /** INCLUDES MACROS STRUCT DECLARATIONS */
    var() string ImageName;
    /** INCLUDES MACROS STRUCT DECLARATIONS */
    var() string LabelName;
    /** INCLUDES MACROS STRUCT DECLARATIONS */
    var() array<string> CategoryNameList;
    var transient UIImage ImageObj;
    var transient UILabel LabelObj;

    structdefaultproperties
    {
        ImageList=none
        ImageName=""
        LabelName=""
        CategoryNameList=none
        ImageObj=none
        LabelObj=none
    }
};

var transient UIList PDAMessageList;
var(Menu) CategoryInfo CatInfo;

event InitScene()
{
    local int Idx;

    super.InitScene();
    PDAMessageList = UIList(FindChild('lstPDAMessages', true));
    CatInfo.ImageObj = UIImage(FindChild(name(CatInfo.ImageName), true));
    CatInfo.LabelObj = UILabel(FindChild(name(CatInfo.LabelName), true));
    // End:0x1A1
    if((myPC != none) && myPC.PDAManager != none)
    {
        Idx = int(myPC.PDAManager.SortBy);
        // End:0x131
        if((Idx != 0) && Idx < CatInfo.ImageList.Length)
        {
            // End:0x131
            if(CatInfo.ImageObj != none)
            {
                CatInfo.ImageObj.SetValue(CatInfo.ImageList[Idx]);
            }
        }
        // End:0x1A1
        if((Idx != 0) && Idx < CatInfo.CategoryNameList.Length)
        {
            // End:0x1A1
            if(CatInfo.LabelObj != none)
            {
                CatInfo.LabelObj.SetDataStoreBinding(CatInfo.CategoryNameList[Idx]);
            }
        }
    }
    //return;    
}

event SceneActivated(bool bInitialActivation)
{
    super.SceneActivated(bInitialActivation);
    // End:0x28
    if(PDAMessageList != none)
    {
        PDAMessageList.RefreshSubscriberValue();
    }
    //return;    
}

function bool CustomInputKey(const out InputEventParameters EventParms)
{
    UpDateUsingGamePadForPC(EventParms);
    return false;
    //return ReturnValue;    
}
