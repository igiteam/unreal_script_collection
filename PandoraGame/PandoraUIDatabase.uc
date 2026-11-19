class PandoraUIDatabase extends Object
    native
    perobjectconfig
    editinlinenew;

struct native SPText
{
    /** INCLUDES MACROS struct DECLARATIONS */
    var() name textTag;
    /** INCLUDES MACROS struct DECLARATIONS */
    var() const localized string Text;

    structdefaultproperties
    {
        textTag="None"
        Text=""
    }
};

/** VARIABLE DECLARATIONSvar(Text) const bool changeToValidate;  Just change this to run the validation routine. */
var(Text) array<SPText> textStore;
