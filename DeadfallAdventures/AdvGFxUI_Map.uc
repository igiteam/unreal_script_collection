class AdvGFxUI_Map extends AdvGfxMoviePlayer
    config(UI);

struct TTreasureGfx
{
    var GFxObject TreasureMC;
    var GFxObject TreasureIconMC;

    structdefaultproperties
    {
        TreasureMC=none
        TreasureIconMC=none
    }
};

var GFxObject RootMC;
var GFxObject MapBgMC;
var array<TTreasureGfx> TreasuresGfx;

static function SwfMovie StaticGetMovieInfoForCurrentLevel()
{
    local AdvMapInfo MapInfo;

    MapInfo = AdvMapInfo(Class'Engine.WorldInfo'.static.GetWorldInfo().GetMapInfo());
    // End:0x9C
    if((MapInfo != none) && MapInfo.TreasureMapMovie != none)
    {
        return MapInfo.TreasureMapMovie;
    }
    return none;
    //return ReturnValue;    
}

function bool Start(optional bool StartPaused = false)
{
    super(GFxMoviePlayer).Start();
    Advance(0.0000000);
    // End:0x30
    if(MovieInfo == none)
    {
        return false;
    }
    RootMC = GetVariableObject("_root");
    MapBgMC = RootMC.GetObject("Map");
    return true;
    //return ReturnValue;    
}

function SetupTreasureMapForLevel(AdvTypes.ELevelID LevelID)
{
    local int I, TreasureMappingIndex;
    local TTreasureGfx CurrTreasureGfx;
    local AdvEngine Eng;

    // End:0x11
    if(MovieInfo == none)
    {
        return;
    }
    Eng = AdvEngine(Class'AdvEngine'.static.GetEngine());
    I = 0;
    J0x4E:

    // End:0xEC [Loop If]
    if(I < Eng.TreasureMapping.Length)
    {
        // End:0xDE
        if(int(LevelID) == int(Eng.TreasureMapping[I].LevelID))
        {
            TreasureMappingIndex = I;
            // [Explicit Break]
            goto J0xEC;
        }
        I++;
        // [Loop Continue]
        goto J0x4E;
    }
    J0xEC:

    TreasuresGfx.Remove(0, TreasuresGfx.Length);    
    I = 0;
    J0x10D:

    // End:0x36C [Loop If]
    if(I < Eng.TreasureMapping[TreasureMappingIndex].TreasureID.Length)
    {
        CurrTreasureGfx.TreasureMC = RootMC.GetObject(Eng.TreasureMapping[TreasureMappingIndex].TreasureID[I]);
        // End:0x1FE
        if(CurrTreasureGfx.TreasureMC == none)
        {            
        }
        else
        {
            CurrTreasureGfx.TreasureIconMC = CurrTreasureGfx.TreasureMC.GetObject("treasure");
        }
        TreasuresGfx.AddItem(CurrTreasureGfx);        
        SetTreasureType(I, Class'AdvTreasureTrigger_Base'.static.GetTreasureTypeFromID(Eng.TreasureMapping[TreasureMappingIndex].TreasureID[I]));
        SetTreasureActive(I, !Eng.IsTreasureCollected(Eng.TreasureMapping[TreasureMappingIndex].TreasureID[I]));
        I++;
        // [Loop Continue]
        goto J0x10D;
    }
    //return;    
}

function SetTreasureType(int Index, AdvTypes.ETreasureType Type)
{
    // End:0x137
    if(Index < TreasuresGfx.Length)
    {
        // End:0x46
        if(TreasuresGfx[Index].TreasureMC == none)
        {
            return;
        }
        switch(Type)
        {
            // End:0xA2
            case 0:
                TreasuresGfx[Index].TreasureMC.GotoAndStop("LIF");
                // End:0x137
                break;
            // End:0xEB
            case 1:
                TreasuresGfx[Index].TreasureMC.GotoAndStop("LIG");
                // End:0x137
                break;
            // End:0x134
            case 2:
                TreasuresGfx[Index].TreasureMC.GotoAndStop("WAR");
                // End:0x137
                break;
            // End:0xFFFF
            default:
                break;
        }
    }
    else
    {
        //return;        
    }
}

function SetTreasureActive(int Index, bool bActive)
{
    // End:0x9E
    if(Index < TreasuresGfx.Length)
    {
        // End:0x46
        if(TreasuresGfx[Index].TreasureIconMC == none)
        {
            return;
        }
        TreasuresGfx[Index].TreasureIconMC.GotoAndStop(((bActive) ? "active" : "not"));
    }
    //return;    
}

defaultproperties
{
    bAllowInput=false
    bAllowFocus=false
}