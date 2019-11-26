/// BLE RING

const SC_ROOT = '0000fab1-0000-1000-8000-00805f9b34fb';
const CH_WRITE = '0000fab2-0000-1000-8000-00805f9b34fb';
const CH_WRITE_N = '0000fab3-0000-1000-8000-00805f9b34fb';
const CH_INDI = '0000fab4-0000-1000-8000-00805f9b34fb';
const CH_NOTI = '0000fab5-0000-1000-8000-00805f9b34fb';
const CH_READ = '0000fab6-0000-1000-8000-00805f9b34fb';

const SC_LOG_ROOT = '0000faf1-0000-1000-8000-00805f9b34fb';
const CH_LOG_CTRL = '0000faf2-0000-1000-8000-00805f9b34fb';
const CH_LOG_DATA = '0000faf3-0000-1000-8000-00805f9b34fb';

/// BLE EEG

const SC_EEG_ROOT = 'f86afee0-8b6a-11e9-b0eb-80a589e0081a';
const CH_EEG_CTRL = 'f86afee1-8b6a-11e9-b0eb-80a589e0081a';
const CH_EEG_DATA = 'f86afee2-8b6a-11e9-b0eb-80a589e0081a';
const CH_EEG_INFO = 'f86afee3-8b6a-11e9-b0eb-80a589e0081a';

const SC_EEG_LOG_ROOT = '4999fef0-8cfd-11e9-af28-80a589e0081a';
const CH_EEG_LOG_CTRL = '4999fef1-8cfd-11e9-af28-80a589e0081a';
const CH_EEG_LOG_DATA = '4999fef2-8cfd-11e9-af28-80a589e0081a';


/// cmd
const CMD_SHUTDOWN = 0xb2; // 停摆
const CMD_FAKEBIND = 0xb0;
const CMD_RESET = 0xe2;
const CMD_LIVECTRL = 0xed;
const CMD_RAWDATA = 0xf0;
const CMD_CRASHLOG = 0xf3; // app get crash log
const CMD_SETTIME = 0xe0;
const CMD_SETUSERINFO = 0xe3; //  30, 0, 170, 60, 0
const CMD_FINDME = 0xb1;
const CMD_MONITOR = 0xd0;
const CMD_SYNCDATA = 0xeb;
const CMD_NOTIBATT = 0xd2;
const CMD_NOTISTEP = 0xe9;
const CMD_HEARTBEAT = 0xd3; // APP_KEEPALIVE_CMD

const CMD_V2_MODE_SPO_MONITOR = 0xd0; // 模式: 血氧监护
const CMD_V2_MODE_ECG_BP = 0xd4; // 模式: 血压
const CMD_V2_MODE_SPORT = 0xd5; // 模式: 运动
const CMD_V2_MODE_DAILY = 0xd6; // 模式: 日常
const CMD_V2_MODE_LIVE_SPO = 0xd7; // 模式: 实时血氧仪
const CMD_V2_GET_MODE = 0xf6; // get current v2 mode
const CMD_V2_GET_BOOTUP_TIME = 0xf7; // v2 get 设备启动时间
const CMD_V2_APP_NOTIFY_DFU_CMD = 0xD8;
const CMD_V2_GET_PERIOD_SETTING = 0xF8;
const CMD_V2_PERIOD_MONITOR_SET = 0xD9;
const CMD_V2_PERIOD_MONITOR_ENSURE = 0xCE; // 确认以定时方式开始监测
const CMD_V2_PERIOD_MONITOR_INDIC = 0xCF; // 定时监测确认开启的提醒 通过indicate上报

const CMD_TEST_CPUID = 0x70;
const CMD_TEST_FLASH = 0x71;
const CMD_TEST_GSENSOR = 0x72;
const CMD_TEST_HR = 0x73;
const CMD_TEST_SCREEN = 0x74;
const CMD_TEST_CHARGER = 0x75;
const CMD_TEST_PD = 0x76;
const CMD_TEST_AD8232 = 0x77;
const CMD_TEST_BQ25120 = 0x78;
const CMD_TEST_OVER = 0xa0;
const CMD_TEST_CURRENT_IDLE = 0x79;
const CMD_TEST_COPY_IMAGE = 0x9f;
const CMD_TEST_AGEING = 0x80; // 开关老化
const CMD_TEST_LARGER_SMALL_CONSUME = 0x81;
const CMD_TEST_BLACK_OUT = 0x82; // 测试漏光，提示遮盖

const CTRL_LIVE_START = 0;
const CTRL_LIVE_STOP = 1;
const CTRL_RAWDATA_ON = 0;
const CTRL_RAWDATA_OFF = 1;
const CTRL_MONITOR_OFF = 0;
const CTRL_MONITOR_ON = 1;
const CTRL_MONITOR_PAUSE = 2;
const CTRL_SCREEN_OFF = 1;
const CTRL_SCREEN_ON = 0;
const CTRL_MONITOR_DATA = 0xef;
const CTRL_DAILY_DATA = 0xf1;
const CTRL_AFE_SPO2 = 1;
const CTRL_AFE_EHR = 2;
const CTRL_NORMAL_ON = 1;
const CTRL_NORMAL_OFF = 0;
