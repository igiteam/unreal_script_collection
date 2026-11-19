class TurokUI extends Object
    native;

// Export UTurokUI::execGetEngine(FFrame&, void* const)
native static function @NULL GetEngine();

// Export UTurokUI::execGetFEAudio(FFrame&, void* const)
native static function @NULL GetFEAudio();

// Export UTurokUI::execGetFEVideo(FFrame&, void* const)
native static function @NULL GetFEVideo();

// Export UTurokUI::execGetURL(FFrame&, void* const)
native static function @NULL GetURL();

// Export UTurokUI::execDoesSavedCheckpointExist(FFrame&, void* const)
native static function bool DoesSavedCheckpointExist();

// Export UTurokUI::execIsSD(FFrame&, void* const)
native static function bool IsSD();

// Export UTurokUI::execPauseAllPlayingMovies(FFrame&, void* const)
native static function PauseAllPlayingMovies();

// Export UTurokUI::execPlayAllPausedMovies(FFrame&, void* const)
native static function PlayAllPausedMovies();

// Export UTurokUI::execStopAllMovies(FFrame&, void* const)
native static function StopAllMovies();

// Export UTurokUI::execInitPauseMenu(FFrame&, void* const)
native static function InitPauseMenu();

// Export UTurokUI::execOpenPauseMenu(FFrame&, void* const)
native static function bool OpenPauseMenu();

// Export UTurokUI::execClosePauseMenu(FFrame&, void* const)
native static function ClosePauseMenu(bool isResume);

// Export UTurokUI::execShutdownPauseMenu(FFrame&, void* const)
native static function ShutdownPauseMenu();

// Export UTurokUI::execIsInGameVideoPlaying(FFrame&, void* const)
native static function bool IsInGameVideoPlaying();

// Export UTurokUI::execGetLocalizedString(FFrame&, void* const)
native static function string GetLocalizedString(int Hash);

static final function string FloatToString(float Value, optional int Precision)
{
    local int IntPart;
    local float FloatPart;
    local string IntString, FloatString;

    Precision = Max(Precision, 1);
    // End:0x33
    if(Value < float(0))
    {
        IntString = "-";
        Value *= float(-1);
    }
    IntPart = int(Value);
    FloatPart = Value - float(IntPart);
    IntString = IntString $ string(IntPart);
    FloatString = string(int(FloatPart * (float(10) ** float(Precision))));
    J0x86:

    // End:0xAA [Loop If]
    if(Len(FloatString) < Precision)
    {
        FloatString = "0" $ FloatString;
        // [Loop Continue]
        goto J0x86;
    }
    return (IntString $ ".") $ FloatString;
    //return ReturnValue;    
}

// Export UTurokUI::execGetPosition(FFrame&, void* const)
native static function GetPosition(@NULL obj, out float X, out float Y, optional byte positionEvalType);

// Export UTurokUI::execGetPosX(FFrame&, void* const)
native static function float GetPosX(@NULL obj, optional byte positionEvalType);

// Export UTurokUI::execGetPosY(FFrame&, void* const)
native static function float GetPosY(@NULL obj, optional byte positionEvalType);

// Export UTurokUI::execGetRotation(FFrame&, void* const)
native static function GetRotation(@NULL obj, out float X, out float Y, out float Z);

// Export UTurokUI::execGetRotX(FFrame&, void* const)
native static function float GetRotX(@NULL obj);

// Export UTurokUI::execGetRotY(FFrame&, void* const)
native static function float GetRotY(@NULL obj);

// Export UTurokUI::execGetRotZ(FFrame&, void* const)
native static function float GetRotZ(@NULL obj);

// Export UTurokUI::execGetPivot(FFrame&, void* const)
native static function GetPivot(@NULL obj, out float X, out float Y, out float Z);

// Export UTurokUI::execGetPivotX(FFrame&, void* const)
native static function float GetPivotX(@NULL obj);

// Export UTurokUI::execGetPivotY(FFrame&, void* const)
native static function float GetPivotY(@NULL obj);

// Export UTurokUI::execGetPivotZ(FFrame&, void* const)
native static function float GetPivotZ(@NULL obj);

// Export UTurokUI::execGetColor(FFrame&, void* const)
native static function @NULL GetColor(@NULL obj);

// Export UTurokUI::execGetSize(FFrame&, void* const)
native static function GetSize(@NULL obj, out float Width, out float Height);

// Export UTurokUI::execGetWidth(FFrame&, void* const)
native static function float GetWidth(@NULL obj);

// Export UTurokUI::execGetHeight(FFrame&, void* const)
native static function float GetHeight(@NULL obj);

// Export UTurokUI::execGetMinSafeZoneBounds(FFrame&, void* const)
native static function GetMinSafeZoneBounds(out float X, out float Y);

// Export UTurokUI::execGetMaxSafeZoneBounds(FFrame&, void* const)
native static function GetMaxSafeZoneBounds(out float X, out float Y);

// Export UTurokUI::execSetPosition(FFrame&, void* const)
native static function SetPosition(@NULL obj, float X, float Y, optional byte positionEvalType);

// Export UTurokUI::execSetPosX(FFrame&, void* const)
native static function SetPosX(@NULL obj, float X, optional byte positionEvalType);

// Export UTurokUI::execSetPosY(FFrame&, void* const)
native static function SetPosY(@NULL obj, float Y, optional byte positionEvalType);

// Export UTurokUI::execSetRotation(FFrame&, void* const)
native static function SetRotation(@NULL obj, float X, float Y, float Z);

// Export UTurokUI::execSetRotX(FFrame&, void* const)
native static function SetRotX(@NULL obj, float X);

// Export UTurokUI::execSetRotY(FFrame&, void* const)
native static function SetRotY(@NULL obj, float Y);

// Export UTurokUI::execSetRotZ(FFrame&, void* const)
native static function SetRotZ(@NULL obj, float Z);

// Export UTurokUI::execSetPivot(FFrame&, void* const)
native static function SetPivot(@NULL obj, float X, float Y, float Z);

// Export UTurokUI::execSetPivotX(FFrame&, void* const)
native static function SetPivotX(@NULL obj, float X);

// Export UTurokUI::execSetPivotY(FFrame&, void* const)
native static function SetPivotY(@NULL obj, float Y);

// Export UTurokUI::execSetPivotZ(FFrame&, void* const)
native static function SetPivotZ(@NULL obj, float Z);

// Export UTurokUI::execSetColor(FFrame&, void* const)
native static function SetColor(@NULL obj, @NULL the_color);

// Export UTurokUI::execSetSize(FFrame&, void* const)
native static function SetSize(@NULL obj, float Width, float Height);

// Export UTurokUI::execSetWidth(FFrame&, void* const)
native static function SetWidth(@NULL obj, float Width);

// Export UTurokUI::execSetHeight(FFrame&, void* const)
native static function SetHeight(@NULL obj, float Height);

// Export UTurokUI::execGetLabelScale(FFrame&, void* const)
native static function float GetLabelScale(@NULL obj);

// Export UTurokUI::execGetLabelSize(FFrame&, void* const)
native static function GetLabelSize(@NULL obj, out float Width, out float Height, optional float Scale);

// Export UTurokUI::execGetLabelWidth(FFrame&, void* const)
native static function float GetLabelWidth(@NULL obj, optional float Scale);

// Export UTurokUI::execGetLabelHeight(FFrame&, void* const)
native static function float GetLabelHeight(@NULL obj, optional float Scale);

// Export UTurokUI::execGetStringSize(FFrame&, void* const)
native static function GetStringSize(@NULL obj, out float Width, out float Height, optional float Scale);

// Export UTurokUI::execGetStringWidth(FFrame&, void* const)
native static function float GetStringWidth(@NULL obj, optional float Scale);

// Export UTurokUI::execGetStringHeight(FFrame&, void* const)
native static function float GetStringHeight(@NULL obj, optional float Scale);

// Export UTurokUI::execSetLabelScale(FFrame&, void* const)
native static function SetLabelScale(@NULL obj, float Scale);

// Export UTurokUI::execGetTextureWidthHeightSlow(FFrame&, void* const)
native static function GetTextureWidthHeightSlow(@NULL pImage, out float Width, out float Height);

// Export UTurokUI::execGetUV(FFrame&, void* const)
native static function GetUV(@NULL img, out float Left, out float Top, out float Width, out float Height);

// Export UTurokUI::execGetTopLeftUV(FFrame&, void* const)
native static function GetTopLeftUV(@NULL img, out float Left, out float Top);

// Export UTurokUI::execGetWidthHeightUV(FFrame&, void* const)
native static function GetWidthHeightUV(@NULL img, out float Width, out float Height);

// Export UTurokUI::execGetTopUV(FFrame&, void* const)
native static function float GetTopUV(@NULL img);

// Export UTurokUI::execGetHeightUV(FFrame&, void* const)
native static function float GetHeightUV(@NULL img);

// Export UTurokUI::execGetLeftUV(FFrame&, void* const)
native static function float GetLeftUV(@NULL img);

// Export UTurokUI::execGetWidthUV(FFrame&, void* const)
native static function float GetWidthUV(@NULL img);

// Export UTurokUI::execSetUV(FFrame&, void* const)
native static function SetUV(@NULL img, float Left, float Top, float Width, float Height);

// Export UTurokUI::execSetTopLeftUV(FFrame&, void* const)
native static function SetTopLeftUV(@NULL img, float Left, float Top);

// Export UTurokUI::execSetWidthHeightUV(FFrame&, void* const)
native static function SetWidthHeightUV(@NULL img, float Width, float Height);

// Export UTurokUI::execSetTopUV(FFrame&, void* const)
native static function SetTopUV(@NULL img, float Top);

// Export UTurokUI::execSetHeightUV(FFrame&, void* const)
native static function SetHeightUV(@NULL img, float Height);

// Export UTurokUI::execSetLeftUV(FFrame&, void* const)
native static function SetLeftUV(@NULL img, float Left);

// Export UTurokUI::execSetWidthUV(FFrame&, void* const)
native static function SetWidthUV(@NULL img, float Width);

// Export UTurokUI::execInitScriptCtrl(FFrame&, void* const)
native static function InitScriptCtrl(@NULL pObject);

// Export UTurokUI::execAddScript(FFrame&, void* const)
native static function @NULL AddScript(@NULL pObject, string kScriptName, optional bool bMoveTo);

// Export UTurokUI::execGetScript(FFrame&, void* const)
native static function @NULL GetScript(@NULL pObject, string kScriptName);

// Export UTurokUI::execPlayScript(FFrame&, void* const)
native static function PlayScript(@NULL obj, string script_name);

// Export UTurokUI::execIsScriptSet(FFrame&, void* const)
native static function bool IsScriptSet(@NULL obj, string script_name);

// Export UTurokUI::execAddHighlightLoop(FFrame&, void* const)
native static function @NULL AddHighlightLoop(@NULL obj, optional bool bIsSlider);

// Export UTurokUI::execCreateWidgetInScene(FFrame&, void* const)
native static function @NULL CreateWidgetInScene(class<Class> WidgetClass, name WidgetTag, @NULL ParentScene, @NULL Owner);
