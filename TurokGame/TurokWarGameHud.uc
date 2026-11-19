class TurokWarGameHud extends TurokTeamGameHud
    transient
    config(Game)
    hidecategories(Navigation);

function Reset()
{
    super.Reset();
    mDrawMissionInfo = false;
    //return;    
}

function DrawObjectiveText()
{
    local @NULL GRI;

    GRI = TurokWarGameReplicationInfo(WorldInfo.GRI);
    // End:0x4D
    if((GRI != none) && !GRI.bMatchIsOver)
    {
        mObjectiveText.Draw();
    }
    //return;    
}

function ShowObjectiveLocator()
{
    local int I;
    local @NULL Info, obj, GRI;

    GRI = TurokWarGameReplicationInfo(WorldInfo.GRI);
    // End:0x14E
    if((GRI != none) && !GRI.bMatchIsOver)
    {
        Info = GRI.GetMissionInfo();
        // End:0x7C
        if((Info == none) || Info.CanToggleOnWargameObjectiveIndicator())
        {
            super.ShowObjectiveLocator();
        }
        I = 0;
        J0x83:

        // End:0x14E [Loop If]
        if(I < GRI.mIndicatorsNum)
        {
            obj = TurokMPObjectiveIndicator(GRI.mIndicators[I]);
            // End:0x144
            if(((obj != none) && int(obj.GetTeamNum()) == int(PlayerOwner.GetTeamNum())) && (Info == none) || Info.CanToggleOnWargameObjectiveText())
            {
                mObjectiveText.InitObjText(obj.GetObjectiveHashID());
                // [Explicit Break]
                goto J0x14E;
            }
            ++I;
            // [Loop Continue]
            goto J0x83;
        }
    }
    J0x14E:

    //return;    
}

function ShowChangedObjective()
{
    local int I;
    local @NULL obj, GRI;

    GRI = TurokWarGameReplicationInfo(WorldInfo.GRI);
    // End:0xED
    if((GRI != none) && !GRI.bMatchIsOver)
    {
        ShowObjectiveLocator();
        I = 0;
        J0x47:

        // End:0xED [Loop If]
        if(I < GRI.mIndicatorsNum)
        {
            obj = TurokMPObjectiveIndicator(GRI.mIndicators[I]);
            // End:0xE3
            if((obj != none) && int(obj.GetTeamNum()) == int(PlayerOwner.GetTeamNum()))
            {
                mObjectiveText.InitObjText(obj.GetObjectiveHashID());
                // [Explicit Break]
                goto J0xED;
            }
            ++I;
            // [Loop Continue]
            goto J0x47;
        }
    }
    J0xED:

    //return;    
}

defaultproperties
{
    mDrawMissionInfo=false
    // Reference: TurokSoundController'Default__TurokWarGameHud.TurokSoundControllerComponent'
    begin object name=TurokSoundControllerComponent
    end object
    mSoundController=TurokSoundControllerComponent
    Components[0]=TurokSoundControllerComponent
}