const int MIN_USERNAME_LENGTH = 3;
const int MIN_PASSWORD_LENGTH = 8;
const int OTP_LENGTH = 6;

const Map<String, String> USER_ROLES = {
  'STUDENT': 'STUDENT',
  'TEACHER': 'TEACHER',
  'ADMIN': 'ADMIN',
};

const Map<String, String> SEC_ITEM_TYPES = {
  'TEXT': 'TEXT',
  'VIDEO': 'VIDEO',
  'AUDIO': 'AUDIO',
  'TEST': 'TEST',
};

const Map<String, String> TEST_TYPES = {
  'QUIZ': 'QUIZ',
  'CUSTOM': 'CUSTOM',
};

const Map<String, String> TEST_STATUSES = {
  'DISPLAY': 'DISPLAY',
  'HIDE': 'HIDE',
  'DRAFT': 'DRAFT',
};

const Map<String, String> QUESTION_TYPES = {
  'SINGLE_CHOICE': 'SINGLE_CHOICE',
  'MULTI_CHOICE': 'MULTIPLE_CHOICE',
  'TRUE_FALSE': 'TRUE_FALSE',
  'MATCHING': 'MATCHING',
  'FILL_BLANK': 'FILL_BLANK',
};

const String SAVED_ORDERS_TAB_INDEX_KEY = 'selectedOrdersTabIndex';

const List<String> ORDERS_TAB_STATUSES = [
  'All',
  'PENDING_PAYMENT',
  'PAID',
  'FAILED',
  'REFUNDED',
  'EXPIRED',
];

String getOrdersTabStatusByIndex(int index) {
  return index >= 0 && index < ORDERS_TAB_STATUSES.length
      ? ORDERS_TAB_STATUSES[index]
      : ORDERS_TAB_STATUSES[0];
}

const int DEFAULT_LIST_SIZE = 10;
