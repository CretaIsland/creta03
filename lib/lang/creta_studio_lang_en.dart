import 'package:flutter/material.dart';

import 'creta_studio_lang.dart';

class CretaStudioLangEN extends AbsCretaStudioLang {
  CretaStudioLangEN() {
    pageSizeMapPresentation = {
      'Custom': '',
      'Standard 4:3': '960x720',
      'Widescreen 16:9': '960x540',
      'Widescreen 16:10': '960x600',
      'Presentation': '1920x1080',
      'Details': '860x1100',
      'Card News': '1080x1080',
      'YouTube thumbnail': '1280x720',
      'YouTube channel art': '2560x1440',
      'social media': '1200x1200',
      '16:9 PC': '2560x1440',
      '9:19 iPhone': '1080x2280',
      '3:4 iPad': '2048x2732',
      '10:16 Galaxy Tab': '1600x2560',
      '9:16 Android': '1440x2560',
      'Letter': '2550x3300',
      'a4': '2480x3508',
      'a3': '3508x4961',
      'a5': '1748x2480',
      'a6': '105x148',
      'b3': '4169x5906',
      'b4': '2953x4169',
      'b5': '2079x2953',
      'c4': '2705x3827',
      'c5': '1913x2705',
      'c6': '1346x1913',
    };

    pageSizeListSignage = [
      "Customize",
      "4:3 Screen",
      "16:10 Screen",
      "16:9 screen",
      "21:9 screen",
      "32:9 screen",
    ];

    pageSizeListBarricade = [
      "Customize",
      "Chapter 3",
      "Chapter 1",
      "Chapter 2",
      "Chapter 4",
      "Chapter 5",
    ];

    copyWrightList = [
      "None",
      "Free to use",
      "May be used for non-commercial purposes only",
      "May be used only if source is disclosed",
      "Do not use without permission",
      "End",
    ];

    // bookTypeList = [
    // "None",
    // "For presentations",
    // "For digital signage",
    // "For digital barricades"
    // "For blackboard",
    // "Other",
    // "End",
    // ];

    bookInfoTabBar = {
      'Cretabook info': 'book_info',
      'Crete Book Settings': 'book_settings',
      'Editor Authority': 'authority',
      'Publication History': 'history',
    };

    frameTabBar = {
      'Frame settings': 'frameTab',
      'Content Settings': 'contentsTab',
      'Link Setting': 'linkTab',
    };

    textMenuTabBar = {
      'Add Text': 'add_text',
      'Word Pad': 'word_pad',
      'Special Characters': 'special_char',
    };

    imageMenuTabBar = {
      'image': 'image',
      'Import': 'upload_image',
      'AI generated': 'AI_generated_image',
      'GIF from GIPHY': 'GIPHY_image',
    };

    storageTypes = {
      'All': 'all',
      'Image': 'image',
      'Video': 'video',
      // 'CretaTest': 'test',
    };

    widgetTypes = {
      'All': 'all',
      'Music': 'music',
      'Weather': 'weather',
      'Date': 'date',
      'Clock': 'clock',
      'Sticker': 'sticker',
      'timeline': 'timeline',
      'effect': 'effect',
      'camera': 'camera',
      'Google Maps': 'map',
      'news': 'news',
      'currency exchange': 'currency exchange',
      'daily quote': 'daily quote',
    };

    newsCategories = {
      'General': 'general',
      'Business': 'business',
      'Entertainment': 'entertainment',
      'Health': 'health',
      'Science': 'science',
      'Sports': 'sports',
      'technology': 'technology',
    };

    menuStick = [
      "template",
      "page",
      "Frames",
      "Archive",
      "Images",
      "video",
      "Text",
      "Shapes",
      "Widgets",
      "video conference",
      "comments",
    ];

    firstCurrency = [
      "USD",
      "GBP",
      "JPY",
      "EUR",
      "CNY",
      "VND",
    ];

    secondCurrency = [
      "KRW",
      "KRW",
      "KRW",
      "KRW",
      "KRW",
      "KRW",
    ];

    menuIconList = [
      Icons.library_books_outlined, //Icons.dynamic_feed_outlined, //MaterialIcons.dynamic_feed,
      Icons.insert_drive_file_outlined, //MaterialIcons.insert_drive_file,
      Icons.space_dashboard_outlined,
      Icons.inventory_2_outlined,
      Icons.image_outlined,
      Icons.slideshow_outlined,
      Icons.title_outlined,
      Icons.pentagon_outlined,
      Icons.interests_outlined,
      Icons.photo_camera_outlined,
      Icons.chat_outlined,
    ];

    frameKind = [
      //"Full",
      "16:9 Landscape",
      "16:9 portrait",
      "4:3 aspect",
      "4:3 portrait",
      "16:10 aspect",
      "16:10 portrait",
      "custom",
    ];

    colorTypes = [
      //"Full",
      "Solid",
      "Gradient",
    ];

    imageStyleList = [
      "Photo",
      "Illustration",
      "Digital Art",
      "Pop Art",
      "watercolor",
      "oil painting",
      "Printmaking",
      "Drawing",
      "Oriental painting",
      "Oil painting",
      "Crepe",
      "sketch",
    ];

    tipMessage = [
      "Enter the details of the phrase you want to generate, as shown in the examples below",
      "You can generate an image by entering the style of your favorite artist."
    ];

    detailTipMessage1 = [
      "3D rendering of a cute tropical fish in a fish tank with a blue background, digital art",
      "Oil painting of a basketball player's dunk depicted as an explosion of a nebula",
      "Photo of a teddy bear skateboarding in Times Square."
          "an oil pastel drawing of a spiky cat inside a spaceship",
    ];

    detailTipMessage2 = [
      "A Monet-style drawing of a landscape on the island of Crete",
      "Representation of Johannes Vermeer's Girl with a Pearl Earring as a sea otter",
      "A picture of Michelangelo's sculpture of David with headphones DJing",
      "A painting of a French bulldog wearing Andy Warhol-style sunglasses",
    ];

    dailyQuote = "Quote\nof the day";
    dailyWord = "Word \nof the Day";

    myCretaBook = "My Book";
    sharedCretaBook = "Shared Book";
    teamCretaBook = "Team Book";
    trashCan = "Trash Can";

    myCretaBookDesc = "This is your Creta Book";
    sharedCretaBookDesc = " This is your shared Creta book";
    teamCretaBookDesc = " This is your team's Creta book";

    latelyUsedFrame = "Recently used frame";

    autoScale = "AutoFit";

    publish = "Publish";
    channelList = "Channel list";
    tooltipNoti = "You have a notification";
    tooltipNoNoti = "There are no notifications";
    tooltipVolume = "Turn the sound off or on while you work";
    tooltipEdit = 'Go to screen edit mode';
    tooltipText = 'Edit text';
    tooltipFrame = 'Create a frame';
    tooltipNoneEdit = 'Go to screen view mode';
    tooltipPause = 'Stop or play the video while you work';
    tooltipUndo = 'Cancel';
    tooltipRedo = 'Restore';
    // tooltipDownload = 'Download';
    tooltipInvite = 'Invite';
    tooltipPlay = 'Preview';
    tooltipScale = 'Always fit to screen size';
    tooltipDelete = 'Delete';
    tooltipApply = 'Apply';
    tooltipMenu = 'Menu';
    tooltipLink = 'Link';

    gotoCommunity = 'Go to Community';

    newBook = 'New Cretan Book';
    newPage = 'Add new page';
    newTemplate = 'Save current page as template';
    newFrame = 'Add new frame';
    treePage = 'Read more';
    newText = 'Default text';

    templateCreating = 'Creating a template...';
    templateCreated = 'Your new template has been saved';
    templateUpdated = 'The template has been updated';
    inputTemplateName = 'Please enter a name for the template';
    templateName = 'Template name';

    textEditorToolbar = 'Open text editor';
    paragraphTemplate = 'Paragraph';
    tableTemplate = 'Table';
    listText = '';
    defaultText = 'This is sample text';

    wide = "View full page";
    usual = "View original";
    close = "Close";
    collapsed = "Collapse";
    open = "Open";
    hidden = "Thumbtack";

    copy = "Copy";
    paste = "Paste";
    crop = "Cut";
    copyStyle = "FormatCopy";
    pasteStyle = "Paste Formatting";
    showUnshow = "Show/Hide";
    show = "Show";
    unshow = "Invisible";

    description = "Description";
    hashTab = "Hashtags";
    infomation = "Information";
    pageSize = "Page size";
    frameSize = "Frame default properties";
    linkProp = "Link basic properties";
    clickEvent = "Click event";
    bookBgColor = "Overall background color";
    pageBgColor = "Page background color";
    frameBgColor = "Frame background color";
    onLine = "Online";
    offLine = "Offline";
    bookHistory = "Publication History";

    updateDate = "Last modified date";
    createDate = "Date created";
    creator = "Creator";
    copyRight = "Copyright";
    bookType = "For Cretan books";
    width = "Width";
    height = "Height";
    color = "color";
    linkColor = "Icon color";
    linkIconSize = "Icon size";
    opacity = "Transparency";
    angle = "Angle";
    radius = "Corner";
    all = "All";

    basicColor = "Basic color";
    accentColor = 'Accent color';
    customColor = 'Custom';
    bwColor = 'Black and White';
    bgColorCodeInput = 'Input by color code';

    glass = 'Vitreous';
    outlineWidth = 'Thickness';
    option = 'Options';
    filter = 'Filter';
    nofilter = 'No filter applied';
    excludeTag = 'Keyword tags to exclude';
    includeTag = 'Keyword tags to include';
    newfilter = 'Create new filter';
    filterName = 'Filter name';
    filterDelete = 'Delete filter';
    filterHasNoName = 'The filter has no name, please enter a name';
    autoPlay = 'Automatic page flip';
    allowReply = 'Allow likes/comments';
    widthHeight = '(widthxheight)';
    gradation = 'Gradient';

    gradationTooltip = 'Select a two-tone color';
    colorTooltip = 'Select a primary color';
    textureTooltip = 'Select a texture';
    angleTooltip = 'Rotate 45 degrees';
    cornerTooltip = 'Set each corner value differently';
    fullscreenTooltip = 'Fills the page';

    transitionPage = "Page transition effect";
    // transitionFrame = "Animation";
    effect = "Background effect";
    contentFlipEffect = "Content flip effect";

    iconOption = "Icon selection";
    googleMapSavedList = "Saved list";

    whenOpenPage = "When it appears";
    whenClosePage = "When it disappears";

    // when it disappears,
    nextContentTypes = [
      "None",
      "Normal Carousel",
      "Tilted Carousel",
    ];

    lastestFrame = "Recently used frame";
    poligonFrame = "Geometry frame";
    animationFrame = "Animation frame";

    lastestFrameError = "There are no recently used frames";
    poligonFrameError = "No geometry frame is ready";
    animationFrameError = "No animation frames are ready";

    queryHintText = 'Placeholder';

    recentUsedImage = 'Recently used image';
    recommendedImage = 'Recommended image';
    myImage = 'My image';

    myUploadedImage = 'Import my file';
    recentUploadedImage = 'Recently imported image';

    aiImageGeneration = 'Image to generate';
    aiGeneratedImage = 'Generated image';
    imageStyle = 'Image style';
    genAIImage = 'Generate image';
    genImageAgain = 'Generate again';
    genFromBeginning = 'Starting from the beginning';

    genAIimageTooltip = 'Tip';
    tipSearchExample = 'Cretan+Drawing+Monastyle';

    music = 'Music Player';
    timer = 'Clock';
    sticker = 'Sticker';
    effects = 'Effects';
    viewMore = 'More';

    genAIerrorMsg =
        'This is currently unavailable due to server congestion. \nPlease try again in a moment. \nWe apologize for the inconvenience';

    fixedRatio = "Fixes the aspect ratio";
    editFilter = "Edit the filter";

    secondColor = "Mixed color";

    texture = "Texture";

    textureTypeList = [
      "Solid",
      "Glass",
      "marble",
      "wood",
      "canvas",
      "paper",
      "Hanji",
      "leather",
      "stone",
      "grass",
      "sand",
      "waterdrop",
    ];

    posX = 'X coordinate';
    posY = 'Y coordinate';

    autoFitContents = 'Auto fit to content size';
    overlayFrame = 'Sticky on all pages';
    noOverlayFrame = 'Unfreeze on all pages';
    overlayExclude = 'Unpin on this page only';
    noOverlayExclude = 'Unpin on this page only';
    backgroundMusic = 'Pin as background music';
    foregroundMusic = 'Unpin as background music';

    ani = 'Animation';
    flip = 'Flip left and right';
    speed = 'Speed';
    transitionSpeed = 'Progression time in seconds';
    delay = 'Delay';
    border = 'Border';
    shadow = 'Shadow';
    borderWidth = 'Thickness';
    glowingBorder = 'Glow effect';
    offset = 'Directional distance';
    direction = 'Directional angle';
    spread = 'Size';
    blur = 'Blur';
    style = 'Style';
    borderPosition = 'Outline position';
    borderCap = 'Line Cap';
    // shadowIn = 'Kind';
    nothing = 'Nothing';
    noBorder = 'No border';
    fitting = 'Fitting';
    custom = 'Customize';
    playersize = 'Size';

    // borderPositionList = {
    // 'Outside the border': 'outSide',
    // 'Border inside': 'inSide',
    // 'Border center': 'center',
    // };

    borderCapList = {
      'round': 'round',
      'angled': 'bevel',
      'pointed': 'miter',
    };
    fitList = {
      'fit': 'cover',
      'fill': 'fill',
      'free': 'free',
    };

    playerSize = {
      'Big': 'Big',
      'Medium': 'Medium',
      'Small': 'Small',
      'Mini': 'Tiny',
    };

    newsSize = {
      'Big': 'Big',
      'Medium': 'Medium',
      'small': 'Small',
    };

    shape = "Shape";

    eventSend = "Outgoing event";
    eventReceived = "Received event";
    showWhenEventReceived = "Appears only when the event is received";
    durationType = "Closed condition";
    durationSpecifiedTime = "Closes after the next time";
    repeatOrOnce = "Repeat infinitely";
    repeatCount = "Number of repetitions";
    reverseMove = "Reverse move";

    durationTypeList = {
      'never close': 'forever',
      'When content ends': 'untilContentsEnd',
      'after a specified amount of time': 'specified',
    };

    copyFrameTooltip = 'Copy frame';
    deleteFrameTooltip = 'Delete frame';
    frontFrameTooltip = 'Pull forward';
    backFrameTooltip = 'Send back';
    rotateFrameTooltip = 'Rotate in 15 degree increments';
    linkFrameTooltip = 'Link to other frame content';
    mainFrameTooltip = 'Make it the main frame';

    flipConTooltip = 'Flip content';
    rotateConTooltip = 'Rotate content';
    cropConTooltip = 'Crop content';
    fullscreenConTooltip = 'Fit content to frame size';
    deleteConTooltip = 'Delete content';
    editConTooltip = 'Edit content';

    imageInfo = 'Image information';
    fileName = 'File name';
    contentyType = 'ContentyType';
    fileSize = 'File size';
    imageFilter = 'Image filter';
    imageControl = 'Adjust image';
    linkControl = 'Edit link';
    linkControlOn = 'Link move mode';
    linkControlOff = 'Toggle link movement mode';
    linkClass = 'Link content';
    musicMutedControl = 'Mute';
    musicPlayerSize = 'Music Samizu feature';

    imageFilterTypeList = [
      "Bright",
      "warm",
      "bright",
      "dark",
      "cool",
      "vintage",
      "romantic",
      "calm",
      "soft",
      "clean",
      "elegant",
      "sepia",
    ];

    timelineShowcase = [
      "The simplest tile",
      "A centered tile with children",
      "Manual aligning the indicator",
      "Is it the first or the last?",
      "Start to make a timeline!",
      "Customize the indicator as you wish.",
      "Give an Icon to the indicator.",
      "Or provide your own custom indicator.",
      "Customize the tile's line.",
      "Connect tiles with TimelineDivider.",
    ];

    toFrameMenu = 'Switch to frame menu';
    toContentsMenu = 'Switch to the contents menu';

    playList = 'Playlist';
    showPlayList = 'Show playlist';

    // shadowInList = {
    // 'Outer shadow': 'outSide',
    // 'inner shadow': 'inSide',
    // };

    hugeText = 'Very large text';
    bigText = 'big text';
    middleText = 'medium text';
    smallText = 'small text';
    userDefineText = 'User Defined';

    textSizeMap = {
      hugeText: 64,
      bigText: 48,
      middleText: 36,
      smallText: 24,
      userDefineText: 40,
    };

    noAutoSize = 'Do not use auto-sizing';
    tts = 'Broadcast by voice';
    translate = 'Translate';

    noUnshowPage = 'There are no pages to view, please unshow them';
    inSideRotate = 'Rotate inside the box';

    publishSettings = 'Publish settings';
    publishSteps = [
      'Edit information',
      'Public Coverage',
      'Select Channel',
      'Complete publication',
    ];

    publishTo = 'To whom to publish';
    publishingChannelList = 'List of channels to publish to';

    wrongEmail =
        'This is not a valid email format, there is no corresponding team name, please enter an email address or team name';
    noExitEmail = 'You are not a registered user, the auto-invite feature is not yet implemented';

    publishComplete = 'The publication is complete';
    publishFailed = 'The publication failed';
    update = 'Update';
    newely = 'New';

    showGrid = 'Grid view';
    showRuler = 'Ruler view';
    linkIntro = 'Please select a page or frame to link to';

    filterAlreadyExist = 'A filter with the same name already exists';
    editFilterDialog = 'Edit filter';

    invitedPeople = 'Invited people';
    invitedTeam = 'Invited teams';

    tickerSide = 'String running sideways';
    tickerUpDown = 'String flowing up and down';
    rotateText = 'Rotate Text';
    waveText = 'Wave Text';
    fidget = 'Fidget Text';
    shimmer = 'Shimmer Text';
    typewriter = 'Typewriter Text';
    wavy = 'Wavy Text';
    neon = 'Neon Text';
    fade = 'Fade Text';
    bounce = 'Bounce Text';
    transition = [
      'Random Transition',
      'Gradual transition',
      'Sliding transition',
      'Smaller to larger transition',
      'rotate transition',
      'transition from inside to outside',
    ];

    weather = 'Weather widget';
    clockandWatch = 'Clock and stopwatch';
    camera = 'Camera';
    map = 'Map';
    date = 'Date';
    timeline = 'Timeline';
    news = 'News';
    currencyXchange = 'Currency exchange';
    dailyEnglish = 'English for today';

    onlineWeather = 'Connect weather online';
    offLineWeather = "Select weather manually";

    cityName = "Your current location";
    temperature = "Temperature";
    humidity = "Humidity";
    wind = "Wind direction/wind speed";
    pressure = "Barometric pressure";
    uv = "Ultraviolet Index";
    visibility = "Visibility";
    microDust = "Fine dust";
    superMicroDust = "Super fine dust";
    realSize = "Original size";
    maxSize = "to maximum size";

    useThisThumbnail = "Use this content as thumbnail";

    putInDepot = "Put in Depot";
    putInDepotContents = "Put only the current content into the depot";
    putInDepotFrame = "Put all content in the current frame into the depot";

    putInMyDepot = "Put in my depot";
    putInTeamDepot = "Put in the team depot";

    letterSpacing = "Spacing";
    lineHeight = "Line height";
    fontName = "Font";
    fontSize = "Font Size";
    iconSize = "Icon size";
    musicAudioControl = "Sound control";
    musicVol = "Sound volume";

    depotComplete = "Move to depot is complete";

    downloadConfirm = '''This operation may take a long time.
Are you sure you want to download it?''';
    noBtDnTextDeloper = "Get json file only";
    noBtDnText = "No";
    yesBtDnText = "Yes";
    export = "Export Cretan Book";
    inviteEmailFailed = "Sending invitation email failed";
    inviteEmailSucceed = "The invitation email was sent successfully";
    zipRequestFailed = "File download request failed";
    zipCompleteFailed = "The request to compress the file failed";
    zipStarting = "The requested file is being compressed";
    fileDownloading = "The download of the requested file has started";
    cretaInviteYou = "You have been invited to join creta";
    pressLinkToJoinCreta1 =
        "You have been invited to join Creta. Please press the link below to join Creta. ";
    isSendEmail = "You are not yet signed up. Are you sure you want to send an invitation email?";
    // carouselWarning = "You must have at least 3 images to apply carousel display";
    mainFrameExTooltip =
        'This is the main frame. When the content in this frame ends, it will automatically advance to the next page';
    deleteLink = 'Delete link';

    textOverflow1 = 'The text length limit has been reached';
    textOverflow2 = 'Please try to stay within characters';
    hashTagHint = 'Enter the hash tag you want to add and press enter';

    notImpl = 'Not yet implemented';
    isOverlayFrame =
        'This is a frame that will stick to the entire page. Deleting it will remove this frame from all pages';
    deleteConfirm = 'Are you sure you want to delete this?';

    gobackToStudio = 'Return to Studio';

    myTemplate = 'My template';
    sharedTemplate = 'Public template';
    saveAsSharedTemplate = 'Save as shared template';

    startDate = 'Start date';
    startTime = 'Start time';
    endDate = 'End date';
    endTime = 'End time';
    timeBasePage = 'Specify time';
    useTimeBasePage = 'Use time specification';
  }
}
