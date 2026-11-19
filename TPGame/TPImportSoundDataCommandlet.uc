class TPImportSoundDataCommandlet extends Commandlet
	native;


//
// The languages that are in the spreadsheet
//
// BIG NOTE!!!!!!!!!!!!!!!!!!!!!
//
// If you update this enum, you must also update MAX_LANGUAGES below.
// It looks like I cannot use an enum value to set the size of the array.
//
// BIG NOTE!!!!!!!!!!!!!!!!!!!!!
//
enum Languages
{
	Language_English,
	Language_German,
	Language_French,
	Language_Italian,
	Language_Spanish,
	Language_Num
};

//
// BIG NOTE!!!!!!!!!!!!!!!!!!!!!
// We need this define because we cannot use Language_Num to set the size of the array.
//


//
// Holds all of the strings from a current language.
//
// BIG NOTE!!!!!!!!!!!!!!!!!!!!!
//
// NumStringsPerLanguage must contain the number of strings in the LanguageStringGroup structure.
//
// BIG NOTE!!!!!!!!!!!!!!!!!!!!!
//
struct native LanguageStringGroup
{
	var	String		m_assetSourcePath;
	var	String		m_package;
	var	String		m_group;
	var	String		m_name;
	var	String		m_subtitleData;
	var	String		m_faceFXData;
};

var				int				NumStringsPerLanguage;
var transient	array<Package>	packagesToSave;

//
// All of the strings for all of the languages for the current row will have their strings in this variable.
//
var LanguageStringGroup		m_currRowLanguageInfo[5];


// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

