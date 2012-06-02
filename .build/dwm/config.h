/* See LICENSE file for copyright and license details. */

/* appearance */
static const char font[]            = "-*-verdana-medium-r-*-*-11-*-*-*-*-*-*-cp1252";
static const char normbordercolor[] = "#444444";
static const char normbgcolor[]     = "#222222";
static const char normfgcolor[]     = "#bbbbbb";
static const char selbordercolor[]  = "#005577";
static const char selbgcolor[]      = "#005577";
static const char selfgcolor[]      = "#eeeeee";
static const unsigned int borderpx  = 1;        /* border pixel of windows */ static const unsigned int snap      = 32;       /* snap pixel */
static const Bool showbar           = True;     /* False means no bar */
static const Bool topbar            = True;     /* False means bottom bar */

/* tagging */
static const char *tags[] = { "term", "web", "relax", "read"};

static const Rule rules[] = { /* class      instance    title       tags mask     isfloating   monitor */
	{ "Gimp",     NULL,       NULL,       0,            True,        -1 },
	{ "Firefox",  NULL,       NULL,       1 << 8,       False,       -1 },
	{ NULL,       "chrome",       NULL,       1 << 1,       False,       -1 },
};

/* layout(s) */
static const float mfact      = 0.55; /* factor of master area size [0.05..0.95] */
static const int nmaster      = 1;    /* number of clients in master area */
static const Bool resizehints = False; /* True means respect size hints in tiled resizals */

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[T]",      tile },    /* first entry is default */
	{ "[F]",      NULL },    /* no layout function means floating behavior */
	{ "[M]",      monocle },
};

/* key definitions */
// check xmodmap to make sure that Mod1Mask is alt or control
// if I map mac key, Mod1mask is control and ControlMask is alt
#define MODKEY Mod1Mask
#define TAGKEYS(KEY,TAG) \
{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static const char *dmenucmd[]       = { "dmenu_run", "-fn", font, "-nb", normbgcolor, "-nf", normfgcolor, "-sb", selbgcolor, "-sf", selfgcolor, NULL };
static const char *termcmd[]        = { "urxvtc", NULL };
static const char *padcmd[]         = { "urxvtc", "-title", "scratchpad", "-geometry", "54x10+504+12", NULL };
static const char *soundMute[]      = { "amixer", "set", "Master", "toggle", NULL };
static const char *soundUp[]        = { "amixer", "set", "Master", "2+", NULL };
static const char *soundDown[]      = { "amixer", "set", "Master", "2-", NULL };
static const char *soundNext[]      = { "ncmpcpp", "next", NULL };
static const char *soundPrev[]      = { "ncmpcpp", "next", NULL };

static Key keys[] = {
    /* modifier                     key        function        argument */
  { Mod4Mask,                     XK_space,      spawn,      {.v = dmenucmd } },
  { Mod4Mask,                     XK_Return, spawn,          {.v = termcmd } },
  { Mod4Mask,                     XK_p,      spawn,          {.v = padcmd } },
  { Mod4Mask,                     XK_b,      spawn,          SHCMD("exec google-chrome") },
  {      0,                       XK_Print,  spawn,          SHCMD("exec scrot -q 100 -t 25 '%Y-%m-%d-%H-%M-%S.jpg' -e 'mv $f $m /ntfs-data/inbox/tmp/screenshots'") },
  //map media functions for 7818u
  {      0,                       0x1008ff12,spawn,          {.v = soundMute } },
  {      0,                       0x1008ff11,spawn,          {.v = soundDown } },
  {      0,                       0x1008ff13,spawn,          {.v = soundUp } },
  {      0,                       0x1008ff16,spawn,          {.v = soundPrev } },
  {      0,                       0x1008ff17,spawn,          {.v = soundNext } },

  { MODKEY,                       XK_b,      togglebar,      {0} },
  { Mod1Mask,                     XK_j,      focusstack,     {.i = +1 } },
  { Mod1Mask,                     XK_k,      focusstack,     {.i = -1 } },
  { Mod1Mask,                     XK_h,      setmfact,       {.f = -0.05} },
  { Mod1Mask,                     XK_l,      setmfact,       {.f = +0.05} },
  { MODKEY,                       XK_Return, zoom,           {0} },
  { MODKEY,                       XK_Tab,    view,           {0} },
  { Mod1Mask,                     XK_q,      killclient,     {0} },
  { MODKEY,                       XK_space,  setlayout,      {0} },
  { MODKEY|ShiftMask,             XK_space,  togglefloating, {0} },
  { MODKEY,                       XK_0,      view,           {.ui = ~0 } },
  { MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },
  { MODKEY,                       XK_comma,  focusmon,       {.i = -1 } },
  { MODKEY,                       XK_period, focusmon,       {.i = +1 } },
  { MODKEY|ShiftMask,             XK_comma,  tagmon,         {.i = -1 } },
  { MODKEY|ShiftMask,             XK_period, tagmon,         {.i = +1 } },
  TAGKEYS(                        XK_1,                      0)
  TAGKEYS(                        XK_2,                      1)
  TAGKEYS(                        XK_3,                      2)
  TAGKEYS(                        XK_4,                      3)
  TAGKEYS(                        XK_5,                      4)
  TAGKEYS(                        XK_6,                      5)
  TAGKEYS(                        XK_7,                      6)
  TAGKEYS(                        XK_8,                      7)
  TAGKEYS(                        XK_9,                      8)
  { MODKEY|ShiftMask,             XK_q,      quit,           {0} },
};

/* button definitions */
/* click can be ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};

