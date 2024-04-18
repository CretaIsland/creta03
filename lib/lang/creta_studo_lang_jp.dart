import 'package:flutter/material.dart';

import 'creta_studio_lang.dart';

class CretaStudioLangJP extends AbsCretaStudioLang {
  CretaStudioLangJP() {
    pageSizeMapPresentation = {
      'カスタマイズ': '',
      'カスタム': '',
      '標準 4 : 3': '960x720',
      'ワイドスクリーン 16:9': '960x540',
      'ワイドスクリーン16:10': '960x600',
      'プレゼンテーション': '1920x1080',
      '詳細ページ': '860x1100',
      'カードニュース': '1080x1080',
      'YouTubeサムネイル': '1280x720',
      'YouTubeチャンネルアート': '2560x1440',
      'SNS': '1200x1200',
      '16:9 PC': '2560x1440',
      '9:19 iPhone': '1080x2280',
      '3:4 iPad': '2048x2732',
      '10:16 Galaxy Tab': '1600x2560',
      '9:16 Android': '1440x2560',
      'letter': '2550x3300',
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
      "カスタム",
      "4:3スクリーン",
      "16:10画面",
      "16:9画面",
      "16:9スクリーン",
      "21:9スクリーン",
      "32:9スクリーン",
    ];

    pageSizeListBarricade = [
      "カスタム",
      "3枚",
      "3枚",
      "1枚",
      "1枚",
      "2章",
      "2章",
      "4章",
      "5章",
    ];

    copyWrightList = [
      "None",
      "自由に使用可能",
      "非商業的な目的でのみ使用可能",
      "非商業的な目的でのみ使用可能",
      "ソースを公開した場合のみ使用可能",
      "許可なく使用不可",
      "許可なく使用不可",
      "許可なく使用不可",
      "End",
    ];

    // bookTypeList = [..
    // "None",
    // "プレゼンテーション用",
    // "デジタルサイネージ用",
    // "デジタルバリケード用"
    // "電子黒板用",
    // "その他",
    // "End",
    // ];

    bookInfoTabBar = {
      'クレタブック情報': 'book_info',
      'クレタブック設定': 'book_settings',
      '編集者権限': 'authority',
      '発行履歴': 'history',
    };

    frameTabBar = {
      'フレーム設定': 'frameTab',
      'コンテンツ設定': 'contentsTab',
      'リンク設定': 'linkTab',
    };

    textMenuTabBar = {
      'テキスト追加': 'add_text',
      'ワードパッド': 'word_pad',
      '特殊文字': 'special_char',
    };

    imageMenuTabBar = {
      '画像': 'image',
      'インポート': 'upload_image',
      'AI生成': 'AI_generated_image',
      'GIPHYのGIF': 'GIPHY_image',
    };

    storageTypes = {
      '全体': 'all',
      '画像': 'image',
      'ビデオ': 'video',
      // 'CretaTest': 'test',
    };

    widgetTypes = {
      '全体': 'all',
      'ミュージック': 'music',
      '天気': 'weather',
      '日付': 'date',
      '時計': 'clock',
      'ステッカー': 'sticker',
      'タイムライン': 'timeline',
      'effect': 'effect',
      'カメラ': 'camera',
      'グーグルマップ': 'map',
      'ニュース': 'news',
      '為替計算': 'currency exchange',
      '今日の英語': 'daily quote',
    };

    newsCategories = {
      '一般': 'general',
      'ビジネス': 'business',
      'エンターテイメント': 'entertainment',
      '健康': 'health',
      'science': 'science',
      'スポーツ': 'sports',
      '技術': 'technology',
    };

    menuStick = [
      "テンプレート",
      "ページ",
      "フレーム",
      "アーカイブ",
      "画像",
      "動画",
      "テキスト",
      "図形",
      "ウィジェット",
      "ビデオ会議",
      "コメント",
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
      //"全体",
      "16:9横型",
      "16:9縦型",
      "4:3横型",
      "4:3縦型",
      "16:10横型",
      "16:10縦型",
      "カスタム",
    ];

    colorTypes = [
      //"全体",
      "単色",
      "グラデーション",
    ];

    imageStyleList = [
      "写真",
      "イラスト",
      "デジタルアート",
      "ポップアート",
      "水彩画",
      "油絵",
      "版画",
      "ドローイング",
      "東洋画",
      "素描",
      "クレパス",
      "スケッチ",
    ];

    tipMessage = [
      "下記の例のように,生成したいフレーズを詳しく入力します。",
      "好きなアーティストのスタイルを入力して画像を生成することができます。",
    ];

    detailTipMessage1 = [
      "青い背景,デジタルアートで水槽にいるかわいい熱帯魚の3Dレンダリング",
      "星雲の爆発で描かれたバスケットボール選手のダンクを油絵で表現",
      "タイムズスクエアでスケートボードをするテディベアの写真",
      "宇宙船の中のとがった猫をオイルパステルで描いた作品",
    ];

    detailTipMessage2 = [
      "クレタ島の風景をモネ風のドローイングで描いた絵",
      "ヨハネス・ベルメールの 真珠の耳飾りの少女 作品をカワウソで表現",
      "ヘッドフォンでDJをしているミケランジェロのダビデ像の写真",
      "アンディ・ウォーホルスタイルのサングラスをかけたフレンチブルドッグの絵",
    ];

    dailyQuote = "今日の\n名言";
    dailyWord = "今日の\n単語";

    myCretaBook = "私のブック";
    sharedCretaBook = "共有のブック";
    teamCretaBook = "チームのブック";
    trashCan = "ゴミ箱";

    myCretaBookDesc = " あなたのクレタブックです";
    sharedCretaBookDesc = "共有されたクレタブックです";
    teamCretaBookDesc = "チームブック";
    teamCretaBookDesc = "チームのクレタブックです";
    teamCretaBookDesc = "チームのクレタブックです";

    latelyUsedFrame = "最近使用したフレーム";

    autoScale = "自動調整";

    publish = "発行する";
    channelList = "チャンネルリスト";
    tooltipNoti = '通知があります';
    tooltipNoNoti = '通知がありません';
    tooltipVolume = '作業中にサウンドをオフまたはオンにします';
    tooltipEdit = '画面編集モードに移動';
    tooltipText = 'テキスト編集';
    tooltipFrame = 'フレームを作成する';
    tooltipNoneEdit = '画面表示モードに移動';
    tooltipPause = '作業中に動画を一時停止または再生します';
    tooltipUndo = '元に戻す';
    tooltipRedo = '復元';
    // tooltipDownload = 'ダウンロード';
    tooltipInvite = '招待する';
    tooltipPlay = 'プレビュー';
    tooltipScale = '常に画面サイズに合わせます';
    tooltipDelete = '削除する';
    tooltipApply = '使用する';
    tooltipMenu = 'メニュー';
    tooltipLink = 'リンクする';

    gotoCommunity = 'コミュニティに移動';

    newBook = '新しいクレタブック';
    newPage = '新しいページを追加';
    newTemplate = '現在のページをテンプレートとして保存';
    newFrame = '新しいフレームを追加';
    treePage = 'もっと見る';
    newText = '基本テキスト';

    templateCreating = 'テンプレートを作成中です...';
    templateCreated = '新しいテンプレートが保存されました';
    templateUpdated = 'テンプレートが更新されました';
    inputTemplateName = 'テンプレートの名前を入力してください';
    templateName = 'テンプレート名';

    textEditorToolbar = 'テキストエディタを開きます';
    paragraphTemplate = '段落';
    tableTemplate = '表';
    listText = '';
    defaultText = 'サンプルテキストです';

    wide = "全ページを表示";
    usual = "オリジナルを表示";
    close = "閉じる";
    collapsed = "折りたたむ";
    open = "開く";
    hidden = "鋲";

    copy = "コピーする";
    paste = "貼り付け";
    crop = "切り取り";
    copyStyle = "書式コピー";
    pasteStyle = "書式の貼り付け";
    showUnshow = "表示/非表示";
    show = "表示";
    unshow = "非表示";

    description = "説明";
    hashTab = "ハッシュタグ";
    infomation = "情報";
    pageSize = "ページサイズ";
    frameSize = "フレームの基本プロパティ";
    linkProp = "リンクの基本プロパティ";
    clickEvent = "クリックイベント";
    bookBgColor = "全体の背景色";
    pageBgColor = "ページの背景色";
    frameBgColor = "フレームの背景色";
    onLine = "オンライン";
    offLine = "オフライン";
    bookHistory = "発行履歴";

    updateDate = "最終更新日";
    createDate = "作成日";
    creator = "作成者";
    copyRight = "著作権";
    bookType = "クレタブック用途";
    width = "幅";
    height = "高さ";
    color = "色";
    linkColor = "アイコン色";
    linkIconSize = "アイコンサイズ";
    opacity = "透明度";
    angle = "角度";
    radius = "角";
    all = "全体";

    basicColor = "基本色";
    accentColor = "強調色";
    customColor = 'カスタム';
    bwColor = '白黒';
    bgColorCodeInput = 'カラーコードで入力';

    glass = 'ガラス質';
    outlineWidth = '太さ';
    option = 'オプション';
    filter = 'フィルター';
    nofilter = 'フィルタを適用しない';
    excludeTag = '除外するキーワードタグ';
    includeTag = '含めるキーワードタグ';
    newfilter = '新しいフィルターを作成する';
    filterName = 'フィルター名';
    filterDelete = 'フィルターを削除する';
    filterHasNoName = 'フィルターに名前がありません,名前を入力してください';
    autoPlay = '自動ページめくり';
    allowReply = 'いいね/コメントを許可する';
    widthHeight = '(横x縦)';
    gradation = 'グラデーション';

    gradationTooltip = 'ツートンカラーを選択します';
    colorTooltip = '基本色を選択します';
    textureTooltip = 'テクスチャを選択します';
    angleTooltip = '45度回転します';
    cornerTooltip = 'それぞれのコーナーの値を異なる値に設定します';
    fullscreenTooltip = 'ページにいっぱいにします';

    transitionPage = "ページ遷移効果";
    // transitionFrame = "アニメーション";
    effect = "背景効果";
    contentFlipEffect = "コンテンツフリップエフェクト";

    iconOption = "アイコン選択";
    googleMapSavedList = "保存済みリスト";

    whenOpenPage = "表示するとき";
    whenClosePage = "消える時";

    // 消える時,
    nextContentTypes = [
      "なし",
      "普通のカルーセル",
      "傾斜したカルーセル",
    ];

    lastestFrame = "最近使ったフレーム";
    poligonFrame = "図形フレーム";
    animationFrame = "アニメーションフレーム";

    lastestFrameError = "最近使用したフレームがありません";
    poligonFrameError = "準備された図形フレームがありません。";
    animationFrameError = "準備されたアニメーションフレームがありません。";

    queryHintText = 'プレースホルダー';

    recentUsedImage = '最近使用した画像';
    recommendedImage = 'おすすめ画像';
    myImage = '私の画像';

    myUploadedImage = 'マイファイルのインポート';
    recentUploadedImage = '最近取り込んだ画像';

    aiImageGeneration = '生成する画像';
    aiGeneratedImage = '生成された画像';
    imageStyle = 'イメージスタイル';
    genAIImage = '画像を生成する';
    genImageAgain = '再度生成する';
    genFromBeginning = '最初から始める';

    genAIimageTooltip = 'ヒント';
    tipSearchExample = 'クレタ線+描画+モナンスタイル';

    music = '音楽プレーヤー';
    timer = '時計';
    sticker = 'ステッカー';
    effects = '効果';
    viewMore = 'もっと見る';

    genAIerrorMsg = 'サーバーが混雑しており,現在利用できません。\nしばらくしてから再試行してください。\nご迷惑をおかけして申し訳ありません';

    fixedRatio = "アスペクト比を固定します";
    editFilter = "フィルターを編集します";

    secondColor = "混合色";

    texture = "テクスチャ";

    textureTypeList = [
      "ソリッド",
      "ガラス",
      "大理石",
      "木",
      "キャンバス",
      "紙",
      "韓紙",
      "革",
      "石",
      "草",
      "砂",
      "水滴",
    ];

    posX = 'X座標';
    posY = 'Y座標';

    autoFitContents = 'コンテンツサイズに自動フィット';
    overlayFrame = 'すべてのページで固定';
    noOverlayFrame = 'すべてのページで固定解除';
    overlayExclude = 'このページのみ固定解除';
    noOverlayExclude = 'このページのみ固定解除解除';
    backgroundMusic = 'バックグラウンドミュージックで固定';
    foregroundMusic = 'バックグラウンドミュージックで固定解除';

    ani = 'アニメーション';
    flip = '左右反転';
    speed = '速度';
    transitionSpeed = '進行時間（秒）';
    delay = '遅延';
    border = '境界線';
    shadow = '影';
    borderWidth = '太さ';
    glowingBorder = 'グロー効果';
    offset = '方向距離';
    direction = '方向角度';
    spread = 'サイズ';
    blur = 'ぼかし';
    style = 'スタイル';
    borderPosition = 'アウトラインの位置';
    borderCap = '線幅';
    // shadowIn = '種類';
    nothing = 'なし';
    noBorder = '境界線なし';
    fitting = 'フィッティング';
    custom = 'カスタム';
    playersize = 'サイズ';

    // borderPositionList = { '境界内': 'outSide'
    // '境界の外側': 'outSide',
    // '境界の内側': 'inSide',
    // '境界の中央': 'center',
    // };

    borderCapList = {
      // 'round': 'round'
      '丸い': 'round',
      '斜め': 'bevel',
      '先のとがった': 'miter',
    };

    fitList = {
      'フィット': 'cover',
      '埋める': 'fill',
      '自由に': 'free',
    };

    playerSize = {
      '大': 'Big',
      '中': 'Medium',
      '小': 'Small',
      '極小': 'Tiny',
    };

    newsSize = {
      '大': 'Big',
      '中': 'Medium',
      '小': 'Small',
    };

    shape = "形状";

    eventSend = "送信イベント";
    eventReceived = "受信イベント";
    showWhenEventReceived = "イベントを受信した時のみ表示";
    durationType = "閉じる条件";
    durationSpecifiedTime = "次の時間後に閉じる";
    repeatOrOnce = "無限繰り返し";
    repeatCount = "繰り返し回数";
    reverseMove = "逆に移動する";

    durationTypeList = {
      '閉じない': 'forever',
      'コンテンツが終わる時': 'untilContentsEnd',
      '指定された時間が経過したら': 'specified',
      'specified': 'specified',
    };

    copyFrameTooltip = 'フレームをコピー';
    deleteFrameTooltip = 'フレームを削除';
    frontFrameTooltip = '前方に引っ張る';
    backFrameTooltip = '後ろに送る';
    rotateFrameTooltip = '15度ずつ回転します';
    linkFrameTooltip = '他のフレームコンテンツにリンクします';
    mainFrameTooltip = 'メインフレームとして指定します';

    flipConTooltip = 'コンテンツを反転します';
    rotateConTooltip = 'コンテンツを回転させます';
    cropConTooltip = 'コンテンツを切り取る';
    fullscreenConTooltip = 'コンテンツをフレームサイズに合わせる';
    deleteConTooltip = 'コンテンツを削除';
    editConTooltip = 'コンテンツの編集';

    imageInfo = '画像情報';
    fileName = 'ファイル名';
    contentyType = 'コンテンツタイプ';
    fileSize = 'ファイルサイズ';
    imageFilter = '画像フィルター';
    imageControl = '画像調整';
    linkControl = 'リンク編集';
    linkControlOn = 'リンク移動モード';
    linkControlOff = 'リンク移動モード解除';
    linkClass = 'リンク内容';
    musicMutedControl = 'ミュート';
    musicPlayerSize = 'ミュージックサミズ機能';

    imageFilterTypeList = [
      "明るい",
      "あたたかい",
      "明るい",
      "暗い",
      "クール",
      "ヴィンテージ",
      "ロマンチック",
      "落ち着いた",
      "やわらかい",
      "清楚",
      "エレガント",
      "セピア",
    ];

    timelineShowcase = [
      "最もシンプルなタイル",
      "子どもを中心としたタイル",
      "インジケータを手動で揃える",
      "最初か最後か？",
      "最初か最後か？",
      "タイムラインを作り始めよう！",
      "インジケーターを好きなようにカスタマイズする",
      "インジケーターをカスタマイズする",
      "インジケータにアイコンを付ける",
      "または,独自のカスタムインジケーターを用意する",
      "または,独自のカスタムインジケーターを用意する",
      "タイルの線をカスタマイズする",
      "タイルの線をカスタマイズする",
      "TimelineDividerでタイルをつなげよう",
    ];

    toFrameMenu = 'フレームメニューに切り替える';
    toContentsMenu = 'コンテンツメニューに切り替える';

    playList = 'プレイリスト';
    showPlayList = 'プレイリストを表示';

    //shadowInList = { // '外部シャドウ': '内部シャドウ'
    // '外部シャドウ': 'outSide',
    // '内部シャドウ': 'inSide',
    //};

    hugeText = 'とても大きなテキスト';
    bigText = '大きなテキスト';
    middleText = '中型テキスト';
    smallText = '小さなテキスト';
    userDefineText = 'ユーザー定義';

    textSizeMap = {
      hugeText: 64,
      bigText: 48,
      middleText: 36,
      smallText: 24,
      userDefineText: 40,
    };

    noAutoSize = '自動サイズ調整を無効にする';
    tts = '音声で放送する';
    translate = '翻訳する';

    noUnshowPage = '表示できるページがありません。 表示を解除してください';
    inSideRotate = 'ボックス内で回転する';

    publishSettings = '発行設定';
    publishSteps = [
      '情報の修正',
      '公開範囲',
      'チャンネル選択',
      '発行完了',
    ];

    publishTo = '公開する人';
    publishingChannelList = '発行するチャンネルリスト';

    wrongEmail = '正しいメールフォーマットではなく,該当するチーム名がありません。 メールアドレスまたはチーム名を入力してください';
    noExitEmail = '登録されたユーザーではありません。 自動招待機能はまだ実装されていません';

    publishComplete = '発行が完了しました';
    publishFailed = '発行に失敗しました';
    update = '修正';
    newely = '新規';

    showGrid = 'グリッド表示';
    showRuler = '定規を表示';
    linkIntro = 'リンクするページやフレームを選択してください';

    filterAlreadyExist = '同じ名前のフィルターが既に存在します';
    editFilterDialog = 'フィルターの編集';

    invitedPeople = '招待された人々';
    invitedTeam = '招待されたチーム';

    tickerSide = '横に流れる文字列';
    tickerUpDown = '上下に流れる文字列';
    rotateText = 'テキストを回転させる';
    waveText = 'Wave Text';
    fidget = 'Fidget Text';
    shimmer = 'Shimmer Text';
    typewriter = 'Typewriter Text';
    wavy = '波状テキスト';
    neon = 'ネオンテキスト';
    fade = 'フェードテキスト';
    bounce = 'バウンステキスト';
    transition = [
      'ランダム遷移',
      '徐々に遷移',
      '滑るように遷移',
      '小さくなったり大きくなったりする遷移',
      '回転遷移'
          "内側から外側への遷移",
    ];

    weather = '天気ウィジェット';
    clockandWatch = '時計とストップウォッチ';
    camera = 'カメラ';
    map = 'マップ';
    date = '日付';
    timeline = 'タイムライン';
    news = 'ニュース';
    currencyXchange = '為替レート計算';
    dailyEnglish = '今日の英語';

    onlineWeather = '天気オンライン接続';
    offLineWeather = "手動で天気を選択";

    cityName = "現在地";
    temperature = "温度";
    humidity = "湿度";
    wind = "風向・風速";
    pressure = "気圧";
    uv = "紫外線指数";
    visibility = "可視距離";
    microDust = "微細粉塵";
    superMicroDust = "超微粒子";
    realSize = "元のサイズで";
    maxSize = "最大サイズで";

    useThisThumbnail = "このコンテンツをサムネイルとして使う";

    putInDepot = "デポに入れる";
    putInDepotContents = "現在のコンテンツだけをデポに入れる";
    putInDepotFrame = "現在のフレームのすべてのコンテンツをデポに入れる";

    putInMyDepot = "私のデポに入れる";
    putInTeamDepot = "チームのデポに入れる";

    letterSpacing = "文字間隔";
    lineHeight = "行間";
    fontName = "フォント";
    fontSize = "フォントサイズ";
    iconSize = "アイコンサイズ";
    musicAudioControl = "音の調整";
    musicVol = "音量";

    depotComplete = "ライブラリへの移動が完了しました";

    downloadConfirm = '''この操作には時間がかかる場合があります。本当にダウンロードしますか？''';
    noBtDnTextDeloper = "jsonファイルのみ取得";
    noBtDnText = "いいえ";
    yesBtDnText = "はい";
    export = "クレタブックをエクスポート(Export)";
    inviteEmailFailed = "招待メール送信に失敗しました";
    inviteEmailSucceed = "招待メールが送信されました";
    zipRequestFailed = "ファイルのダウンロード要求が失敗しました";
    zipCompleteFailed = "ファイルの圧縮要求が失敗しました";
    zipStarting = "リクエストされたファイルの圧縮作業を進めています";
    fileDownloading = "リクエストされたファイルのダウンロードが開始されました";
    cretaInviteYou = "あなたがクレタに招待されました";
    pressLinkToJoinCreta1 = "さんがあなたをクレタに招待しました。下のリンクを押してクレタに参加してください。";
    isSendEmail = "まだ登録されていないメールです。招待メールを送りますか？";
    // carouselWarning = 'カルーセルディスプレイを適用するには,少なくとも3つの画像が必要です';
    mainFrameExTooltip = 'メインフレームです。このフレームのコンテンツが終了すると,自動的に次のページに移動します';
    deleteLink = 'リンクを削除します';

    textOverflow1 = 'テキストの長さ制限にかかりました';
    textOverflow2 = '文字数以内で入力してください';
    hashTagHint = '追加するハッシュタグを入力してEnterキーを押してください';

    notImpl = 'まだ実装されていません';
    isOverlayFrame = 'このフレームはページ全体に固定されたフレームです。削除すると,すべてのページでこのフレームが消えます';
    deleteConfirm = '本当に削除しますか？';
    deleteConfirm = "本当に削除しますか？";

    gobackToStudio = 'スタジオに戻る';

    myTemplate = '私のテンプレート';
    sharedTemplate = '共有テンプレート';
    saveAsSharedTemplate = '共有テンプレートとして保存';

    startDate = '開始日';
    startTime = '開始時間';
    endDate = '終了日';
    endTime = '終了時間';
    timeBasePage = '時間指定';
    useTimeBasePage = '時間指定を使う';
  }
}
