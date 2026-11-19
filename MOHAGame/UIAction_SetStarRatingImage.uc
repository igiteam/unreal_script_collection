class UIAction_SetStarRatingImage extends UIAction
    hidecategories(Object);

enum eLevel
{
    LEVEL_NONE,                     // 0
    LEVEL_HUSKY,                    // 1
    LEVEL_AVALANCHE,                // 2
    LEVEL_NEPTUNE,                  // 3
    LEVEL_MARKET,                   // 4
    LEVEL_VARFAC,                   // 5
    LEVEL_VARFLK,                   // 6
    LEVEL_MAX                       // 7
};

enum eDifficulty
{
    Easy,                           // 0
    Medium,                         // 1
    Hard,                           // 2
    ANY,                            // 3
    eDifficulty_MAX                 // 4
};

var array<string> StarImageMarkups;
var array<name> ExpectedImageTags;
var() UIAction_SetStarRatingImage.eLevel Level;
var() UIAction_SetStarRatingImage.eDifficulty nDifficulty;
var int nRating;

function Activated()
{
    local MOHAPlayerController PlayerController;
    local MOHAPlayerReplicationInfo PRI;
    local array<Object> objVars;
    local int idx;
    local name imageName;
    local UIImage Target;
    local int NIndex;

    // End:0x37
    foreach GetWorldInfo().DynamicActors(Class'MOHAPlayerController', PlayerController)
    {
        // End:0x36
        if(NetConnection(PlayerController.Player) == none)
        {
            // End:0x37
            break;
        }        
    }    
    PRI = MOHAPlayerReplicationInfo(PlayerController.PlayerReplicationInfo);
    // End:0x5E
    if(PRI == none)
    {
        return;
    }
    // End:0x70
    if(int(Level) == int(0))
    {
        return;
    }
    // End:0x130
    if(int(nDifficulty) == int(3))
    {
        NIndex = 0;
        J0x87:

        // End:0x11A [Loop If]
        if(NIndex < 3)
        {
            // End:0x110
            if(nRating <= PRI.SPStatsGlobal.MissionRatingStats[int(Level)].iRating[NIndex])
            {
                nRating = PRI.SPStatsGlobal.MissionRatingStats[int(Level)].iRating[NIndex];
                nDifficulty = byte(NIndex);
            }
            NIndex++;
            // [Loop Continue]
            goto J0x87;
        }
        // End:0x12D
        if(nRating == 0)
        {
            nDifficulty = 0;
        }        
    }
    else
    {
        nRating = PRI.SPStatsGlobal.MissionRatingStats[int(Level)].iRating[int(nDifficulty)];
    }
    GetObjectVars(objVars, "Star Image");
    idx = 0;
    J0x186:

    // End:0x331 [Loop If]
    if(idx < objVars.Length)
    {
        Target = UIImage(objVars[idx]);
        // End:0x327
        if(Target != none)
        {
            imageName = Target.WidgetTag;
            NIndex = 0;
            J0x1D2:

            // End:0x327 [Loop If]
            if(NIndex < ExpectedImageTags.Length)
            {
                // End:0x309
                if(InStr(string(imageName), string(ExpectedImageTags[NIndex])) != -1)
                {
                    switch(nDifficulty)
                    {
                        // End:0x25D
                        case 0:
                            // End:0x23F
                            if((NIndex + 1) > nRating)
                            {
                                Target.SetDataStoreBinding(StarImageMarkups[3]);                                
                            }
                            else
                            {
                                Target.SetDataStoreBinding(StarImageMarkups[0]);
                            }
                            // End:0x309
                            break;
                        // End:0x2B1
                        case 1:
                            // End:0x293
                            if((NIndex + 1) > nRating)
                            {
                                Target.SetDataStoreBinding(StarImageMarkups[4]);                                
                            }
                            else
                            {
                                Target.SetDataStoreBinding(StarImageMarkups[1]);
                            }
                            // End:0x309
                            break;
                        // End:0x306
                        case 2:
                            // End:0x2E7
                            if((NIndex + 1) > nRating)
                            {
                                Target.SetDataStoreBinding(StarImageMarkups[5]);                                
                            }
                            else
                            {
                                Target.SetDataStoreBinding(StarImageMarkups[2]);
                            }
                            // End:0x309
                            break;
                        // End:0xFFFF
                        default:
                            break;
                    }
                }
                else
                {
                    Target.RefreshSubscriberValue();
                    NIndex++;
                    // [Loop Continue]
                    goto J0x1D2;
                }/* !MISMATCHING REMOVE, tried Loop got Type:Else Position:0x309! */
            }/* !MISMATCHING REMOVE, tried If got Type:Loop Position:0x1D2! */
            idx++;
            // [Loop Continue]
            goto J0x186;
        }/* !MISMATCHING REMOVE, tried Loop got Type:If Position:0x1AC! */
        //return;        
    }/* !MISMATCHING REMOVE, tried Else got Type:Loop Position:0x186! */
}

defaultproperties
{
    StarImageMarkups[0]="<Images:UI_TX_Medals.UI_TX_StatStar_bronze>"
    StarImageMarkups[1]="<Images:UI_TX_Medals.UI_TX_StatStar_silver>"
    StarImageMarkups[2]="<Images:UI_TX_Medals.UI_TX_StatStar>"
    StarImageMarkups[3]="<Images:UI_TX_Medals.UI_TX_StatStar_bronze_inactive>"
    StarImageMarkups[4]="<Images:UI_TX_Medals.UI_TX_StatStar_silver_inactive>"
    StarImageMarkups[5]="<Images:UI_TX_Medals.UI_TX_StatStar_inactive>"
    ExpectedImageTags[0]="RatingStar1"
    ExpectedImageTags[1]="RatingStar2"
    ExpectedImageTags[2]="RatingStar3"
    ExpectedImageTags[3]="RatingStar4"
    ExpectedImageTags[4]="RatingStar5"
    nDifficulty=3
    nRating=-1
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Star Image",LinkVar="None",PropertyName="None",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Int',LinkedVariables=none,LinkDesc="Star Rating",LinkVar="None",PropertyName="nRating",bWriteable=true,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[2]=(ExpectedType=Class'Engine.SeqVar_Int',LinkedVariables=none,LinkDesc="Difficulty",LinkVar="None",PropertyName="nDifficulty",bWriteable=true,bHidden=false,MinVars=1,MaxVars=1,DrawX=0,CachedProperty=none)
    ObjName="Set Star Rating"
}