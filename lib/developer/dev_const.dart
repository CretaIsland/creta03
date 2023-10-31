class DevConst {
  static Map<String, List<Map<String, String>>> indexMap = {
    'creta_book': [
      {
        'bookType': 'ASC',
        'creator': 'ASC',
        'isRemoved': 'ASC',
        'likeCount': 'DESC',
        'updateTime': 'DESC'
      },
      {
        'bookType': 'ASC',
        'creator': 'ASC',
        'isRemoved': 'ASC',
        'name': 'ASC',
        'updateTime': 'DESC'
      },
      {'bookType': 'ASC', 'creator': 'ASC', 'isRemoved': 'ASC', 'updateTime': 'DESC'},
      {
        'bookType': 'ASC',
        'creator': 'ASC',
        'isRemoved': 'ASC',
        'viewCount': 'DESC',
        'updateTime': 'DESC'
      },
      {'bookType': 'ASC', 'isRemoved': 'ASC', 'updateTime': 'DESC'},
      {
        'bookType': 'ASC',
        'shares': 'array',
        'isRemoved': 'ASC',
        'likeCount': 'DESC',
        'updateTime': 'DESC'
      },
      {
        'bookType': 'ASC',
        'shares': 'array',
        'isRemoved': 'ASC',
        'name': 'ASC',
        'updateTime': 'DESC'
      },
      {'bookType': 'ASC', 'shares': 'array', 'isRemoved': 'ASC', 'updateTime': 'DESC'},
      {
        'bookType': 'ASC',
        'shares': 'array',
        'isRemoved': 'ASC',
        'viewCount': 'DESC',
        'updateTime': 'DESC'
      },
      {'creator': 'ASC', 'isRemoved': 'ASC', 'likeCount': 'DESC', 'updateTime': 'DESC'},
      {'creator': 'ASC', 'isRemoved': 'ASC', 'name': 'ASC', 'updateTime': 'DESC'},
      {'creator': 'ASC', 'isRemoved': 'ASC', 'updateTime': 'DESC'},
      {'creator': 'ASC', 'isRemoved': 'ASC', 'viewCount': 'DESC', 'updateTime': 'DESC'},
      {'isRemoved': 'ASC', 'updateTime': 'ASC'},
      {'isRemoved': 'ASC', 'updateTime': 'DESC'},
      {'shares': 'array', 'isRemoved': 'ASC', 'likeCount': 'DESC', 'updateTime': 'DESC'},
      {'shares': 'array', 'isRemoved': 'ASC', 'name': 'ASC', 'updateTime': 'DESC'},
      {'shares': 'array', 'isRemoved': 'ASC', 'updateTime': 'DESC'},
      {'shares': 'array', 'isRemoved': 'ASC', 'viewCount': 'DESC', 'updateTime': 'DESC'},
    ],
    'creta_book_published': [
      {'bookType': 'ASC', 'isRemoved': 'ASC', 'updateTime': 'DESC'},
      {'channels': 'array', 'updateTime': 'DESC'},
      {'isRemoved': 'ASC', 'mid': 'ASC', 'updateTime': 'DESC'},
      {'isRemoved': 'ASC', 'parentMid': 'ASC', 'updateTime': 'DESC'},
      {'isRemoved': 'ASC', 'sourceMid': 'ASC', 'updateTime': 'DESC'},
      {'isRemoved': 'ASC', 'updateTime': 'ASC'},
      {'isRemoved': 'ASC', 'updateTime': 'DESC'},
      {'mid': 'ASC', 'updateTime': 'DESC'},
      {
        'shares': 'array',
        'bookType': 'ASC',
        'isRemoved': 'ASC',
        'likeCount': 'DESC',
        'updateTime': 'DESC'
      },
      {
        'shares': 'array',
        'bookType': 'ASC',
        'isRemoved': 'ASC',
        'name': 'ASC',
        'updateTime': 'DESC'
      },
      {
        'shares': 'array',
        'bookType': 'ASC',
        'isRemoved': 'ASC',
        'viewCount': 'DESC',
        'updateTime': 'DESC'
      },
      {'shares': 'array', 'isRemoved': 'ASC', 'likeCount': 'DESC', 'updateTime': 'DESC'},
      {'shares': 'array', 'isRemoved': 'ASC', 'name': 'ASC', 'updateTime': 'DESC'},
      {'shares': 'array', 'isRemoved': 'ASC', 'updateTime': 'DESC'},
      {'shares': 'array', 'isRemoved': 'ASC', 'viewCount': 'DESC', 'updateTime': 'DESC'},
    ],
    'creta_channel': [
      {'isRemoved': 'ASC', 'mid': 'ASC', 'updateTime': 'DESC'},
      {'isRemoved': 'ASC', 'updateTime': 'ASC'},
      {'isRemoved': 'ASC', 'userId': 'ASC', 'updateTime': 'DESC'},
      {'mid': 'array', 'updateTime': 'DESC'},
      {'mid': 'ASC', 'updateTime': 'DESC'},
    ],
    'creta_comment': [
      {
        'bookId': 'ASC',
        'isRemoved': 'ASC',
        'parentId': 'ASC',
        'createTime': 'ASC',
        'updateTime': 'DESC'
      },
      {
        'bookId': 'ASC',
        'isRemoved': 'ASC',
        'parentId': 'ASC',
        'createTime': 'DESC',
        'updateTime': 'DESC'
      },
      {'isRemoved': 'ASC', 'updateTime': 'ASC'},
    ],
    'creta_connected_user': [
      {'isRemoved': 'ASC', 'parentMid': 'ASC', 'updateTime': 'DESC'},
      {'isRemoved': 'ASC', 'updateTime': 'ASC'},
    ],
    'creta_contents': [
      {'isRemoved': 'ASC', 'parentMid': 'ASC', 'order': 'ASC', 'updateTime': 'DESC'},
      {'isRemoved': 'ASC', 'updateTime': 'ASC'},
    ],
    'creta_contents_published': [
      {'isRemoved': 'ASC', 'parentMid': 'ASC', 'order': 'ASC', 'updateTime': 'DESC'},
      {'isRemoved': 'ASC', 'parentMid': 'ASC', 'updateTime': 'DESC'},
      {'isRemoved': 'ASC', 'updateTime': 'ASC'},
    ],
    'creta_depot': [
      {'contentsMid': 'ASC', 'isRemoved': 'ASC', 'updateTime': 'DESC'},
      {
        'contentsType': 'ASC',
        'isRemoved': 'ASC',
        'parentMid': 'ASC',
        'order': 'ASC',
        'updateTime': 'DESC'
      },
      {'contentsType': 'ASC', 'isRemoved': 'ASC', 'parentMid': 'ASC', 'updateTime': 'DESC'},
      {'isRemoved': 'ASC', 'parentMid': 'ASC', 'order': 'ASC', 'updateTime': 'DESC'},
      {'isRemoved': 'ASC', 'parentMid': 'ASC', 'updateTime': 'DESC'},
      {'isRemoved': 'ASC', 'updateTime': 'ASC'},
    ],
    'creta_enterprise': [
      {'isRemoved': 'ASC', 'name': 'ASC', 'order': 'ASC', 'updateTime': 'DESC'},
      {'isRemoved': 'ASC', 'updateTime': 'ASC'},
    ],
    'creta_favorites': [
      {'bookId': 'ASC', 'isRemoved': 'ASC', 'updateTime': 'DESC'},
      {'bookId': 'ASC', 'isRemoved': 'ASC', 'userId': 'ASC', 'updateTime': 'DESC'},
      {'isRemoved': 'ASC', 'mid': 'ASC', 'updateTime': 'DESC'},
      {'isRemoved': 'ASC', 'updateTime': 'ASC'},
      {'isRemoved': 'ASC', 'userId': 'ASC', 'lastUpdateTime': 'DESC', 'updateTime': 'DESC'},
    ],
    'creta_filter': [
      {'isRemoved': 'ASC', 'parentMid': 'ASC', 'updateTime': 'DESC'},
      {'isRemoved': 'ASC', 'updateTime': 'ASC'},
    ],
    'creta_frame': [
      {
        'frameType': 'ASC',
        'isRemoved': 'ASC',
        'parentMid': 'ASC',
        'order': 'ASC',
        'updateTime': 'DESC'
      },
      {'isRemoved': 'ASC', 'parentMid': 'ASC', 'order': 'ASC', 'updateTime': 'DESC'},
      {'isRemoved': 'ASC', 'parentMid': 'ASC', 'updateTime': 'DESC'},
      {'isRemoved': 'ASC', 'updateTime': 'ASC'},
    ],
    'creta_frame_published': [
      {'isRemoved': 'ASC', 'parentMid': 'ASC', 'order': 'ASC', 'updateTime': 'DESC'},
      {'isRemoved': 'ASC', 'parentMid': 'ASC', 'updateTime': 'DESC'},
      {'isRemoved': 'ASC', 'updateTime': 'ASC'},
    ],
    'creta_link': [
      {'isRemoved': 'ASC', 'parentMid': 'ASC', 'updateTime': 'DESC'},
    ],
    'creta_page': [
      {'isRemoved': 'ASC', 'parentMid': 'ASC', 'order': 'ASC', 'updateTime': 'DESC'},
      {'isRemoved': 'ASC', 'parentMid': 'ASC', 'updateTime': 'DESC'},
      {'isRemoved': 'ASC', 'updateTime': 'ASC'},
    ],
    'creta_page_published': [
      {'isRemoved': 'ASC', 'parentMid': 'ASC', 'order': 'ASC', 'updateTime': 'DESC'},
      {'isRemoved': 'ASC', 'parentMid': 'ASC', 'updateTime': 'DESC'},
      {'isRemoved': 'ASC', 'updateTime': 'ASC'},
    ],
    'creta_playlist': [
      {'channelId': 'ASC', 'isRemoved': 'ASC', 'lastUpdateTime': 'DESC', 'updateTime': 'DESC'},
      {'channelId': 'ASC', 'isRemoved': 'ASC', 'updateTime': 'DESC'},
      {'isRemoved': 'ASC', 'lastUpdateTime': 'DESC', 'updateTime': 'DESC'},
      {'isRemoved': 'ASC', 'mid': 'ASC', 'updateTime': 'DESC'},
      {'isRemoved': 'ASC', 'name': 'ASC', 'updateTime': 'DESC'},
      {'isRemoved': 'ASC', 'updateTime': 'ASC'},
      {'isRemoved': 'ASC', 'updateTime': 'DESC'},
      {'mid': 'ASC', 'updateTime': 'DESC'},
    ],
    'creta_subscription': [
      {
        'channelId': 'ASC',
        'isRemoved': 'ASC',
        'subscriptionChannelId': 'ASC',
        'updateTime': 'DESC'
      },
      {'channelId': 'ASC', 'isRemoved': 'ASC', 'updateTime': 'DESC'},
      {'isRemoved': 'ASC', 'updateTime': 'ASC'},
    ],
    'creta_team': [
      {'isRemoved': 'ASC', 'mid': 'ASC', 'updateTime': 'DESC'},
      {'isRemoved': 'ASC', 'name': 'ASC', 'parentMid': 'ASC', 'updateTime': 'DESC'},
      {'isRemoved': 'ASC', 'updateTime': 'ASC'},
      {'mid': 'array', 'isRemoved': 'ASC', 'updateTime': 'DESC'},
      {'teamMembers': 'array', 'isRemoved': 'ASC', 'updateTime': 'DESC'},
    ],
    'creta_user_property': [
      {'email': 'ASC', 'isRemoved': 'ASC', 'order': 'ASC', 'updateTime': 'DESC'},
      {'email': 'ASC', 'isRemoved': 'ASC', 'updateTime': 'DESC'},
      {'email': 'ASC', 'updateTime': 'DESC'},
      {'isRemoved': 'ASC', 'parentMid': 'ASC', 'order': 'ASC', 'updateTime': 'DESC'},
      {'isRemoved': 'ASC', 'parentMid': 'ASC', 'updateTime': 'DESC'},
      {'isRemoved': 'ASC', 'updateTime': 'ASC'},
    ],
    'creta_watch_history': [
      {'isRemoved': 'ASC', 'updateTime': 'ASC'},
    ]
  };
}
