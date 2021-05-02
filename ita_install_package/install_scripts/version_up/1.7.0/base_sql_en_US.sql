ALTER TABLE A_ACCOUNT_LIST ADD COLUMN LAST_LOGIN_TIME DATETIME(6) AFTER PW_LAST_UPDATE_TIME;
ALTER TABLE A_ACCOUNT_LIST_JNL ADD COLUMN LAST_LOGIN_TIME DATETIME(6) AFTER PW_LAST_UPDATE_TIME;

ALTER TABLE C_STM_LIST ADD COLUMN SSH_KEY_FILE_PASSPHRASE INT AFTER CONN_SSH_KEY_FILE;
ALTER TABLE C_STM_LIST_JNL ADD COLUMN SSH_KEY_FILE_PASSPHRASE INT AFTER CONN_SSH_KEY_FILE;

ALTER TABLE B_LOGIN_AUTH_TYPE MODIFY COLUMN LOGIN_AUTH_TYPE_NAME VARCHAR(64);
ALTER TABLE B_LOGIN_AUTH_TYPE_JNL MODIFY COLUMN LOGIN_AUTH_TYPE_NAME VARCHAR(64);

ALTER TABLE B_DP_STATUS ADD COLUMN SPECIFIED_TIMESTAMP DATETIME(6) AFTER ABOLISHED_TYPE;
ALTER TABLE B_DP_STATUS_JNL ADD COLUMN SPECIFIED_TIMESTAMP DATETIME(6) AFTER ABOLISHED_TYPE;


-- ----メニュー作成タイプマスタ
CREATE TABLE F_MENU_CREATE_TYPE
(
MENU_CREATE_TYPE_ID                 INT                             , -- 識別シーケンス項番
MENU_CREATE_TYPE_NAME               VARCHAR (64)                    , -- メニュー作成タイプ名
ACCESS_AUTH                         TEXT                            ,
NOTE                                VARCHAR  (4000)                 , -- 備考
DISUSE_FLAG                         VARCHAR  (1)                    , -- 廃止フラグ
LAST_UPDATE_TIMESTAMP               DATETIME(6)                     , -- 最終更新日時
LAST_UPDATE_USER                    INT                             , -- 最終更新ユーザ
PRIMARY KEY (MENU_CREATE_TYPE_ID)
)ENGINE = InnoDB, CHARSET = utf8, COLLATE = utf8_bin, ROW_FORMAT=COMPRESSED ,KEY_BLOCK_SIZE=8;

CREATE TABLE F_MENU_CREATE_TYPE_JNL
(
JOURNAL_SEQ_NO                      INT                             , -- 履歴用シーケンス
JOURNAL_REG_DATETIME                DATETIME(6)                     , -- 履歴用変更日時
JOURNAL_ACTION_CLASS                VARCHAR  (8)                    , -- 履歴用変更種別

MENU_CREATE_TYPE_ID                 INT                             , -- 識別シーケンス項番
MENU_CREATE_TYPE_NAME               VARCHAR (64)                    , -- メニュー作成タイプ名
ACCESS_AUTH                         TEXT                            ,
NOTE                                VARCHAR  (4000)                 , -- 備考
DISUSE_FLAG                         VARCHAR  (1)                    , -- 廃止フラグ
LAST_UPDATE_TIMESTAMP               DATETIME(6)                     , -- 最終更新日時
LAST_UPDATE_USER                    INT                             , -- 最終更新ユーザ
PRIMARY KEY(JOURNAL_SEQ_NO)
)ENGINE = InnoDB, CHARSET = utf8, COLLATE = utf8_bin, ROW_FORMAT=COMPRESSED ,KEY_BLOCK_SIZE=8;
-- メニュー作成タイプマスタ----


CREATE OR REPLACE VIEW D_ACCOUNT_LIST AS 
SELECT TAB_A.USER_ID              ,
       TAB_A.USERNAME             ,
       TAB_A.PASSWORD             ,
       TAB_A.USERNAME_JP          ,
       TAB_A.MAIL_ADDRESS         ,
       TAB_A.PW_LAST_UPDATE_TIME  ,
       TAB_A.LAST_LOGIN_TIME      ,
       TAB_B.LOCK_ID              ,
       TAB_B.MISS_INPUT_COUNTER   ,
       TAB_B.LOCKED_TIMESTAMP     ,
       CONCAT(TAB_A.USER_ID,':',TAB_A.USERNAME) USER_PULLDOWN,
       TAB_C.USER_JUDGE_ID        ,
       TAB_C.AD_USER_SID          ,
       TAB_A.AUTH_TYPE            ,
       TAB_A.PROVIDER_ID          ,
       TAB_A.PROVIDER_USER_ID     ,
       TAB_A.ACCESS_AUTH          ,
       TAB_C.ACCESS_AUTH AS ACCESS_AUTH_01,
       TAB_A.NOTE                 ,
       TAB_A.DISUSE_FLAG          ,
       TAB_A.LAST_UPDATE_TIMESTAMP,
       TAB_A.LAST_UPDATE_USER
FROM   A_ACCOUNT_LIST TAB_A
LEFT JOIN A_ACCOUNT_LOCK TAB_B ON (TAB_A.USER_ID = TAB_B.USER_ID)
LEFT JOIN A_AD_USER_JUDGEMENT TAB_C ON (TAB_A.USER_ID = TAB_C.ITA_USER_ID)
WHERE  TAB_A.USER_ID > 0;

CREATE OR REPLACE VIEW D_ACCOUNT_LIST_JNL AS 
SELECT TAB_A.JOURNAL_SEQ_NO       ,
       TAB_A.JOURNAL_REG_DATETIME ,
       TAB_A.JOURNAL_ACTION_CLASS ,
       TAB_A.USER_ID              ,
       TAB_A.USERNAME             ,
       TAB_A.PASSWORD             ,
       TAB_A.USERNAME_JP          ,
       TAB_A.MAIL_ADDRESS         ,
       TAB_A.PW_LAST_UPDATE_TIME  ,
       TAB_A.LAST_LOGIN_TIME      ,
       TAB_B.LOCK_ID              ,
       TAB_B.MISS_INPUT_COUNTER   ,
       TAB_B.LOCKED_TIMESTAMP     ,
       CONCAT(TAB_A.USER_ID,':',TAB_A.USERNAME) USER_PULLDOWN,
       TAB_C.USER_JUDGE_ID        ,
       TAB_C.AD_USER_SID          ,
       TAB_A.AUTH_TYPE            ,
       TAB_A.PROVIDER_ID          ,
       TAB_A.PROVIDER_USER_ID     ,
       TAB_A.ACCESS_AUTH          ,
       TAB_C.ACCESS_AUTH AS ACCESS_AUTH_01,
       TAB_A.NOTE                 ,
       TAB_A.DISUSE_FLAG          ,
       TAB_A.LAST_UPDATE_TIMESTAMP,
       TAB_A.LAST_UPDATE_USER
FROM   A_ACCOUNT_LIST_JNL TAB_A
LEFT JOIN A_ACCOUNT_LOCK TAB_B ON (TAB_A.USER_ID = TAB_B.USER_ID)
LEFT JOIN A_AD_USER_JUDGEMENT TAB_C ON (TAB_A.USER_ID = TAB_C.ITA_USER_ID)
WHERE  TAB_A.USER_ID > 0;


CREATE OR REPLACE VIEW E_STM_LIST 
AS 

SELECT TAB_A.SYSTEM_ID                        SYSTEM_ID                     ,
       TAB_A.HARDAWRE_TYPE_ID                 HARDAWRE_TYPE_ID              ,
       TAB_A.HOSTNAME                         HOSTNAME                      ,
       CONCAT(TAB_A.SYSTEM_ID,':',TAB_A.HOSTNAME) HOST_PULLDOWN,
       TAB_A.IP_ADDRESS                       IP_ADDRESS                    ,
       TAB_A.PROTOCOL_ID                      PROTOCOL_ID                   ,
       TAB_A.LOGIN_USER                       LOGIN_USER                    ,
       TAB_A.LOGIN_PW_HOLD_FLAG               LOGIN_PW_HOLD_FLAG            ,
       TAB_A.LOGIN_PW                         LOGIN_PW                      ,
       TAB_A.ETH_WOL_MAC_ADDRESS              ETH_WOL_MAC_ADDRESS           ,
       TAB_A.ETH_WOL_NET_DEVICE               ETH_WOL_NET_DEVICE            ,
       TAB_A.LOGIN_AUTH_TYPE                  LOGIN_AUTH_TYPE               ,
       TAB_A.WINRM_PORT                       WINRM_PORT                    ,
       TAB_A.OS_TYPE_ID                       OS_TYPE_ID                    ,
       TAB_A.HOSTNAME                         SYSTEM_NAME                   ,
       TAB_A.COBBLER_PROFILE_ID               COBBLER_PROFILE_ID            ,
       TAB_A.INTERFACE_TYPE                   INTERFACE_TYPE                ,
       TAB_A.MAC_ADDRESS                      MAC_ADDRESS                   ,
       TAB_A.NETMASK                          NETMASK                       ,
       TAB_A.GATEWAY                          GATEWAY                       ,
       TAB_A.STATIC                           STATIC                        ,

       TAB_A.CONN_SSH_KEY_FILE                CONN_SSH_KEY_FILE             ,
       TAB_A.SSH_KEY_FILE_PASSPHRASE          SSH_KEY_FILE_PASSPHRASE       ,

       TAB_A.DISP_SEQ                         DISP_SEQ                      ,
       TAB_A.ACCESS_AUTH                      ACCESS_AUTH                   ,
       TAB_A.NOTE                             NOTE                          ,
       TAB_A.DISUSE_FLAG                      DISUSE_FLAG                   ,
       TAB_A.LAST_UPDATE_TIMESTAMP            LAST_UPDATE_TIMESTAMP         ,
       TAB_A.LAST_UPDATE_USER                 LAST_UPDATE_USER

FROM C_STM_LIST TAB_A;

CREATE OR REPLACE VIEW E_STM_LIST_JNL 
AS 

SELECT TAB_A.JOURNAL_SEQ_NO                   JOURNAL_SEQ_NO                ,
       TAB_A.JOURNAL_REG_DATETIME             JOURNAL_REG_DATETIME          ,
       TAB_A.JOURNAL_ACTION_CLASS             JOURNAL_ACTION_CLASS          ,

       TAB_A.SYSTEM_ID                        SYSTEM_ID                     ,
       TAB_A.HARDAWRE_TYPE_ID                 HARDAWRE_TYPE_ID              ,
       TAB_A.HOSTNAME                         HOSTNAME                      ,
       CONCAT(TAB_A.SYSTEM_ID,':',TAB_A.HOSTNAME) HOST_PULLDOWN,
       TAB_A.IP_ADDRESS                       IP_ADDRESS                    ,
       TAB_A.PROTOCOL_ID                      PROTOCOL_ID                   ,
       TAB_A.LOGIN_USER                       LOGIN_USER                    ,
       TAB_A.LOGIN_PW_HOLD_FLAG               LOGIN_PW_HOLD_FLAG            ,
       TAB_A.LOGIN_PW                         LOGIN_PW                      ,
       TAB_A.ETH_WOL_MAC_ADDRESS              ETH_WOL_MAC_ADDRESS           ,
       TAB_A.ETH_WOL_NET_DEVICE               ETH_WOL_NET_DEVICE            ,
       TAB_A.LOGIN_AUTH_TYPE                  LOGIN_AUTH_TYPE               ,
       TAB_A.WINRM_PORT                       WINRM_PORT                    ,
       TAB_A.OS_TYPE_ID                       OS_TYPE_ID                    ,
       TAB_A.HOSTNAME                         SYSTEM_NAME                   ,
       TAB_A.COBBLER_PROFILE_ID               COBBLER_PROFILE_ID            ,
       TAB_A.INTERFACE_TYPE                   INTERFACE_TYPE                ,
       TAB_A.MAC_ADDRESS                      MAC_ADDRESS                   ,
       TAB_A.NETMASK                          NETMASK                       ,
       TAB_A.GATEWAY                          GATEWAY                       ,
       TAB_A.STATIC                           STATIC                        ,

       TAB_A.CONN_SSH_KEY_FILE                CONN_SSH_KEY_FILE             ,
       TAB_A.SSH_KEY_FILE_PASSPHRASE          SSH_KEY_FILE_PASSPHRASE       ,

       TAB_A.DISP_SEQ                         DISP_SEQ                      ,
       TAB_A.ACCESS_AUTH                      ACCESS_AUTH                   ,
       TAB_A.NOTE                             NOTE                          ,
       TAB_A.DISUSE_FLAG                      DISUSE_FLAG                   ,
       TAB_A.LAST_UPDATE_TIMESTAMP            LAST_UPDATE_TIMESTAMP         ,
       TAB_A.LAST_UPDATE_USER                 LAST_UPDATE_USER

FROM C_STM_LIST_JNL TAB_A;


-- -------------------------------------------------------
-- --ER図
-- -------------------------------------------------------
CREATE TABLE B_ER_DATA
(
ROW_ID                            INT                              , -- 識別シーケンス
MENU_TABLE_LINK_ID                INT                              , -- メニュー*テーブルのリンクID
COLUMN_ID                         TEXT                             , -- カラムID名
COLUMN_TYPE                       INT                              , -- カラムタイプ
PARENT_COLUMN_ID                  TEXT                             , -- 親カラムID
PHYSICAL_NAME                     TEXT                             , -- 物理名
LOGICAL_NAME                      TEXT                             , -- 論理名
RELATION_TABLE_NAME               TEXT                             , -- 関連テーブル名
RELATION_COLUMN_ID                TEXT                             , -- 関連カラムID
DISP_SEQ                          INT                              , -- 表示順
NOTE                              VARCHAR (4000)                   , -- 備考
ACCESS_AUTH                       TEXT                             ,
DISUSE_FLAG                       VARCHAR (1)                      , -- 廃止フラグ
LAST_UPDATE_USER                  INT                              , -- 最終更新ユーザ
LAST_UPDATE_TIMESTAMP             DATETIME(6)                      , -- 最終更新日時
PRIMARY KEY(ROW_ID)
)ENGINE = InnoDB, CHARSET = utf8, COLLATE = utf8_bin, ROW_FORMAT=COMPRESSED ,KEY_BLOCK_SIZE=8;

CREATE TABLE B_ER_MENU_TABLE_LINK_LIST
(
ROW_ID                            INT                              , -- 識別シーケンス
MENU_ID                           INT                              , -- メニューID
TABLE_NAME                        TEXT                             , -- テーブル名
VIEW_TABLE_NAME                   TEXT                             , -- テーブルビュー名
NOTE                              VARCHAR (4000)                   , -- 備考
DISUSE_FLAG                       VARCHAR (1)                      , -- 廃止フラグ
ACCESS_AUTH                       TEXT                             ,
LAST_UPDATE_USER                  INT                              , -- 最終更新ユーザ
LAST_UPDATE_TIMESTAMP             DATETIME(6)                      , -- 最終更新日時
PRIMARY KEY(ROW_ID)
)ENGINE = InnoDB, CHARSET = utf8, COLLATE = utf8_bin, ROW_FORMAT=COMPRESSED ,KEY_BLOCK_SIZE=8;

CREATE TABLE B_ER_COLUMN_TYPE
(
COLUMN_TYPE_ID                    INT                              , -- 識別シーケンス
COLUMN_TYPE_NAME                  VARCHAR (64)                     , -- テーブル名
NOTE                              VARCHAR (4000)                   , -- 備考
DISUSE_FLAG                       VARCHAR (1)                      , -- 廃止フラグ
ACCESS_AUTH                       TEXT                             ,
LAST_UPDATE_USER                  INT                              , -- 最終更新ユーザ
LAST_UPDATE_TIMESTAMP             DATETIME(6)                      , -- 最終更新日時
PRIMARY KEY(COLUMN_TYPE_ID)
)ENGINE = InnoDB, CHARSET = utf8, COLLATE = utf8_bin, ROW_FORMAT=COMPRESSED ,KEY_BLOCK_SIZE=8;

CREATE OR REPLACE VIEW D_ER_MENU_TABLE_LINK_LIST AS 
SELECT TAB_A.ROW_ID,
       TAB_C.MENU_GROUP_ID,
       TAB_C.MENU_GROUP_ID      MENU_GROUP_ID_CLONE,
       TAB_C.MENU_GROUP_NAME,
       TAB_A.MENU_ID,
       TAB_A.MENU_ID            MENU_ID_CLONE,
       TAB_A.MENU_ID            MENU_ID_CLONE_02,
       TAB_B.MENU_NAME,
       CONCAT(TAB_C.MENU_GROUP_ID,':',TAB_C.MENU_GROUP_NAME,':',TAB_A.MENU_ID,':',TAB_B.MENU_NAME) MENU_PULLDOWN,
       TAB_A.TABLE_NAME,
       TAB_A.VIEW_TABLE_NAME,
       TAB_A.NOTE,
       TAB_A.ACCESS_AUTH,
       TAB_A.DISUSE_FLAG,
       TAB_A.LAST_UPDATE_TIMESTAMP,
       TAB_A.LAST_UPDATE_USER,
       TAB_B.ACCESS_AUTH AS ACCESS_AUTH_01,
       TAB_C.ACCESS_AUTH AS ACCESS_AUTH_02
FROM B_ER_MENU_TABLE_LINK_LIST TAB_A
LEFT JOIN A_MENU_LIST TAB_B ON (TAB_A.MENU_ID = TAB_B.MENU_ID)
LEFT JOIN A_MENU_GROUP_LIST TAB_C ON (TAB_B.MENU_GROUP_ID = TAB_C.MENU_GROUP_ID);

CREATE OR REPLACE VIEW D_ER_DATA AS 
SELECT TAB_A.ROW_ID,
       TAB_A.MENU_TABLE_LINK_ID,
       TAB_B.MENU_GROUP_ID,
       TAB_B.MENU_GROUP_ID      MENU_GROUP_ID_CLONE,
       TAB_B.MENU_ID,
       TAB_B.MENU_ID            MENU_ID_CLONE,
       TAB_A.COLUMN_ID,
       TAB_A.COLUMN_TYPE,
       TAB_A.PARENT_COLUMN_ID,
       TAB_A.PHYSICAL_NAME,
       TAB_A.LOGICAL_NAME,
       TAB_A.RELATION_TABLE_NAME,
       TAB_A.RELATION_COLUMN_ID,
       TAB_A.DISP_SEQ,
       TAB_A.NOTE,
       TAB_A.ACCESS_AUTH,
       TAB_A.DISUSE_FLAG,
       TAB_A.LAST_UPDATE_TIMESTAMP,
       TAB_A.LAST_UPDATE_USER,
       TAB_B.ACCESS_AUTH AS ACCESS_AUTH_01
FROM B_ER_DATA TAB_A
LEFT JOIN D_ER_MENU_TABLE_LINK_LIST TAB_B ON (TAB_A.MENU_TABLE_LINK_ID = TAB_B.ROW_ID);


CREATE UNIQUE INDEX IND_C_SYMPHONY_INSTANCE_MNG_01      ON C_SYMPHONY_INSTANCE_MNG      ( DISUSE_FLAG,SYMPHONY_INSTANCE_NO                  );
CREATE        INDEX IND_C_CONDUCTOR_IF_INFO_01          ON C_CONDUCTOR_IF_INFO          ( DISUSE_FLAG                                       );
CREATE UNIQUE INDEX IND_C_NODE_CLASS_MNG_01             ON C_NODE_CLASS_MNG             ( NODE_CLASS_NO,DISUSE_FLAG                         );
CREATE        INDEX IND_C_NODE_TERMINALS_CLASS_MNG_01   ON C_NODE_TERMINALS_CLASS_MNG   ( NODE_CLASS_NO,DISUSE_FLAG,TERMINAL_TYPE_ID        );
CREATE        INDEX IND_C_CONDUCTOR_INSTANCE_MNG_01     ON C_CONDUCTOR_INSTANCE_MNG     ( DISUSE_FLAG,STATUS_ID,TIME_BOOK                   );
CREATE UNIQUE INDEX IND_C_CONDUCTOR_INSTANCE_MNG_02     ON C_CONDUCTOR_INSTANCE_MNG     ( DISUSE_FLAG,CONDUCTOR_INSTANCE_NO                 );
CREATE        INDEX IND_C_NODE_INSTANCE_MNG_01          ON C_NODE_INSTANCE_MNG          ( CONDUCTOR_INSTANCE_NO,I_NODE_TYPE_ID,DISUSE_FLAG  );
CREATE        INDEX IND_C_NODE_INSTANCE_MNG_02          ON C_NODE_INSTANCE_MNG          ( I_NODE_CLASS_NO,DISUSE_FLAG,CONDUCTOR_INSTANCE_NO );


DELETE FROM A_SEQUENCE WHERE NAME IN ('B_DP_SYM_OPE_STATUS_RIC', 'B_DP_SYM_OPE_STATUS_JSQ');

INSERT INTO A_SEQUENCE (NAME,VALUE,MENU_ID,DISP_SEQ,NOTE,LAST_UPDATE_TIMESTAMP) VALUES('B_ER_DATA_RIC',1,'2100000326',2100000328,NULL,STR_TO_DATE('2015/04/01 10:00:00.000000','%Y/%m/%d %H:%i:%s.%f'));

INSERT INTO A_SEQUENCE (NAME,VALUE,MENU_ID,DISP_SEQ,NOTE,LAST_UPDATE_TIMESTAMP) VALUES('B_ER_MENU_TABLE_LINK_LIST_RIC',1,'2100000326',2100000327,NULL,STR_TO_DATE('2015/04/01 10:00:00.000000','%Y/%m/%d %H:%i:%s.%f'));


UPDATE A_MENU_LIST SET NOTE='' WHERE MENU_ID IN (2100000303,2100000305,2100000306,2100000307,2100000308,2100000309,2100000310,2100000211,2100000212,2100000311,2100000314);
UPDATE A_MENU_LIST_JNL SET NOTE='' WHERE MENU_ID IN (2100000303,2100000305,2100000306,2100000307,2100000308,2100000309,2100000310,2100000211,2100000212,2100000311,2100000314);

UPDATE A_MENU_LIST SET NOTE='Cannot discard' WHERE MENU_ID IN (2100000214,2100000215,2100000311,2100000221,2100000222,2100000299,2100000231,2100000232,2100000232,2100000216);
UPDATE A_MENU_LIST_JNL SET NOTE='Cannot discard' WHERE MENU_ID IN (2100000214,2100000215,2100000311,2100000221,2100000222,2100000299,2100000231,2100000232,2100000232,2100000216);

UPDATE A_MENU_LIST SET MENU_NAME='Role・Menu link list' WHERE MENU_ID IN (2100000209);
UPDATE A_MENU_LIST_JNL SET MENU_NAME='Role・Menu link list' WHERE MENU_ID IN (2100000209);

UPDATE A_MENU_LIST SET MENU_NAME='Role・User link list' WHERE MENU_ID IN (2100000210);
UPDATE A_MENU_LIST_JNL SET MENU_NAME='Role・User link list' WHERE MENU_ID IN (2100000210);

UPDATE A_MENU_LIST SET MENU_NAME='Export・Import menu list', NOTE='' WHERE MENU_ID IN (2100000213);
UPDATE A_MENU_LIST_JNL SET MENU_NAME='Export・Import menu list', NOTE='' WHERE MENU_ID IN (2100000213);

UPDATE A_MENU_LIST SET MENU_NAME='Operation list', NOTE='' WHERE MENU_ID IN (2100000304);
UPDATE A_MENU_LIST_JNL SET MENU_NAME='Operation list', NOTE='' WHERE MENU_ID IN (2100000304);

DELETE FROM A_MENU_LIST WHERE MENU_ID IN (2100000401,2100000402,2100000403);
DELETE FROM A_MENU_LIST_JNL WHERE MENU_ID IN (2100000401,2100000402,2100000403);

INSERT INTO A_MENU_LIST (MENU_ID,MENU_GROUP_ID,MENU_NAME,WEB_PRINT_LIMIT,WEB_PRINT_CONFIRM,XLS_PRINT_LIMIT,LOGIN_NECESSITY,SERVICE_STATUS,AUTOFILTER_FLG,INITIAL_FILTER_FLG,DISP_SEQ,NOTE,DISUSE_FLAG,LAST_UPDATE_TIMESTAMP,LAST_UPDATE_USER) VALUES(2100000326,2100000003,'ER Diagram',NULL,NULL,NULL,1,0,1,1,60,NULL,'0',STR_TO_DATE('2015/04/01 10:00:00.000000','%Y/%m/%d %H:%i:%s.%f'),1);
INSERT INTO A_MENU_LIST_JNL (JOURNAL_SEQ_NO,JOURNAL_REG_DATETIME,JOURNAL_ACTION_CLASS,MENU_ID,MENU_GROUP_ID,MENU_NAME,WEB_PRINT_LIMIT,WEB_PRINT_CONFIRM,XLS_PRINT_LIMIT,LOGIN_NECESSITY,SERVICE_STATUS,AUTOFILTER_FLG,INITIAL_FILTER_FLG,DISP_SEQ,NOTE,DISUSE_FLAG,LAST_UPDATE_TIMESTAMP,LAST_UPDATE_USER) VALUES(-300326,STR_TO_DATE('2015/04/01 10:00:00.000000','%Y/%m/%d %H:%i:%s.%f'),'INSERT',2100000326,2100000003,'ER Diagram',NULL,NULL,NULL,1,0,1,1,60,NULL,'0',STR_TO_DATE('2015/04/01 10:00:00.000000','%Y/%m/%d %H:%i:%s.%f'),1);
INSERT INTO A_MENU_LIST (MENU_ID,MENU_GROUP_ID,MENU_NAME,WEB_PRINT_LIMIT,WEB_PRINT_CONFIRM,XLS_PRINT_LIMIT,LOGIN_NECESSITY,SERVICE_STATUS,AUTOFILTER_FLG,INITIAL_FILTER_FLG,DISP_SEQ,NOTE,DISUSE_FLAG,LAST_UPDATE_TIMESTAMP,LAST_UPDATE_USER) VALUES(2100000327,2100000003,'ER Diagram Menu List',NULL,NULL,NULL,1,0,1,1,70,NULL,'0',STR_TO_DATE('2015/04/01 10:00:00.000000','%Y/%m/%d %H:%i:%s.%f'),1);
INSERT INTO A_MENU_LIST_JNL (JOURNAL_SEQ_NO,JOURNAL_REG_DATETIME,JOURNAL_ACTION_CLASS,MENU_ID,MENU_GROUP_ID,MENU_NAME,WEB_PRINT_LIMIT,WEB_PRINT_CONFIRM,XLS_PRINT_LIMIT,LOGIN_NECESSITY,SERVICE_STATUS,AUTOFILTER_FLG,INITIAL_FILTER_FLG,DISP_SEQ,NOTE,DISUSE_FLAG,LAST_UPDATE_TIMESTAMP,LAST_UPDATE_USER) VALUES(-300327,STR_TO_DATE('2015/04/01 10:00:00.000000','%Y/%m/%d %H:%i:%s.%f'),'INSERT',2100000327,2100000003,'ER Diagram Menu List',NULL,NULL,NULL,1,0,1,1,70,NULL,'0',STR_TO_DATE('2015/04/01 10:00:00.000000','%Y/%m/%d %H:%i:%s.%f'),1);
INSERT INTO A_MENU_LIST (MENU_ID,MENU_GROUP_ID,MENU_NAME,WEB_PRINT_LIMIT,WEB_PRINT_CONFIRM,XLS_PRINT_LIMIT,LOGIN_NECESSITY,SERVICE_STATUS,AUTOFILTER_FLG,INITIAL_FILTER_FLG,DISP_SEQ,NOTE,DISUSE_FLAG,LAST_UPDATE_TIMESTAMP,LAST_UPDATE_USER) VALUES(2100000328,2100000003,'ER Diagram Item List',NULL,NULL,NULL,1,0,1,1,80,NULL,'0',STR_TO_DATE('2015/04/01 10:00:00.000000','%Y/%m/%d %H:%i:%s.%f'),1);
INSERT INTO A_MENU_LIST_JNL (JOURNAL_SEQ_NO,JOURNAL_REG_DATETIME,JOURNAL_ACTION_CLASS,MENU_ID,MENU_GROUP_ID,MENU_NAME,WEB_PRINT_LIMIT,WEB_PRINT_CONFIRM,XLS_PRINT_LIMIT,LOGIN_NECESSITY,SERVICE_STATUS,AUTOFILTER_FLG,INITIAL_FILTER_FLG,DISP_SEQ,NOTE,DISUSE_FLAG,LAST_UPDATE_TIMESTAMP,LAST_UPDATE_USER) VALUES(-300328,STR_TO_DATE('2015/04/01 10:00:00.000000','%Y/%m/%d %H:%i:%s.%f'),'INSERT',2100000328,2100000003,'ER Diagram Item List',NULL,NULL,NULL,1,0,1,1,80,NULL,'0',STR_TO_DATE('2015/04/01 10:00:00.000000','%Y/%m/%d %H:%i:%s.%f'),1);


INSERT INTO A_ACCOUNT_LIST (USER_ID,USERNAME,PASSWORD,USERNAME_JP,MAIL_ADDRESS,AUTH_TYPE,NOTE,DISUSE_FLAG,LAST_UPDATE_TIMESTAMP,LAST_UPDATE_USER) VALUES(-100326,'a326a','5ebbc37e034d6874a2af59eb04beaa52','ER Diagram work procedure','sample@xxx.bbb.ccc',NULL,'ER Diagram work procedure','H',STR_TO_DATE('2015/04/01 10:00:00.000000','%Y/%m/%d %H:%i:%s.%f'),1);
INSERT INTO A_ACCOUNT_LIST_JNL (JOURNAL_SEQ_NO,JOURNAL_REG_DATETIME,JOURNAL_ACTION_CLASS,USER_ID,USERNAME,PASSWORD,USERNAME_JP,MAIL_ADDRESS,AUTH_TYPE,NOTE,DISUSE_FLAG,LAST_UPDATE_TIMESTAMP,LAST_UPDATE_USER) VALUES(-100326,STR_TO_DATE('2015/04/01 10:00:00.000000','%Y/%m/%d %H:%i:%s.%f'),'INSERT',-100326,'a326a','5ebbc37e034d6874a2af59eb04beaa52','ER Diagram work procedure','sample@xxx.bbb.ccc',NULL,'ER Diagram work procedure','H',STR_TO_DATE('2015/04/01 10:00:00.000000','%Y/%m/%d %H:%i:%s.%f'),1);


DELETE FROM A_ROLE_MENU_LINK_LIST WHERE LINK_ID IN (2100000401,2100000402,2100000403);
DELETE FROM A_ROLE_MENU_LINK_LIST_JNL WHERE LINK_ID IN (2100000401,2100000402,2100000403);

INSERT INTO A_ROLE_MENU_LINK_LIST (LINK_ID,ROLE_ID,MENU_ID,PRIVILEGE,NOTE,DISUSE_FLAG,LAST_UPDATE_TIMESTAMP,LAST_UPDATE_USER) VALUES(2100000326,1,2100000326,1,'System Administrator','0',STR_TO_DATE('2015/04/01 10:00:00.000000','%Y/%m/%d %H:%i:%s.%f'),1);
INSERT INTO A_ROLE_MENU_LINK_LIST_JNL (JOURNAL_SEQ_NO,JOURNAL_REG_DATETIME,JOURNAL_ACTION_CLASS,LINK_ID,ROLE_ID,MENU_ID,PRIVILEGE,NOTE,DISUSE_FLAG,LAST_UPDATE_TIMESTAMP,LAST_UPDATE_USER) VALUES(-300326,STR_TO_DATE('2015/04/01 10:00:00.000000','%Y/%m/%d %H:%i:%s.%f'),'INSERT',2100000326,1,2100000326,1,'System Administrator','0',STR_TO_DATE('2015/04/01 10:00:00.000000','%Y/%m/%d %H:%i:%s.%f'),1);
INSERT INTO A_ROLE_MENU_LINK_LIST (LINK_ID,ROLE_ID,MENU_ID,PRIVILEGE,NOTE,DISUSE_FLAG,LAST_UPDATE_TIMESTAMP,LAST_UPDATE_USER) VALUES(2100000327,1,2100000327,1,'System Administrator','1',STR_TO_DATE('2015/04/01 10:00:00.000000','%Y/%m/%d %H:%i:%s.%f'),1);
INSERT INTO A_ROLE_MENU_LINK_LIST_JNL (JOURNAL_SEQ_NO,JOURNAL_REG_DATETIME,JOURNAL_ACTION_CLASS,LINK_ID,ROLE_ID,MENU_ID,PRIVILEGE,NOTE,DISUSE_FLAG,LAST_UPDATE_TIMESTAMP,LAST_UPDATE_USER) VALUES(-300327,STR_TO_DATE('2015/04/01 10:00:00.000000','%Y/%m/%d %H:%i:%s.%f'),'INSERT',2100000327,1,2100000327,1,'System Administrator','1',STR_TO_DATE('2015/04/01 10:00:00.000000','%Y/%m/%d %H:%i:%s.%f'),1);
INSERT INTO A_ROLE_MENU_LINK_LIST (LINK_ID,ROLE_ID,MENU_ID,PRIVILEGE,NOTE,DISUSE_FLAG,LAST_UPDATE_TIMESTAMP,LAST_UPDATE_USER) VALUES(2100000328,1,2100000328,1,'System Administrator','1',STR_TO_DATE('2015/04/01 10:00:00.000000','%Y/%m/%d %H:%i:%s.%f'),1);
INSERT INTO A_ROLE_MENU_LINK_LIST_JNL (JOURNAL_SEQ_NO,JOURNAL_REG_DATETIME,JOURNAL_ACTION_CLASS,LINK_ID,ROLE_ID,MENU_ID,PRIVILEGE,NOTE,DISUSE_FLAG,LAST_UPDATE_TIMESTAMP,LAST_UPDATE_USER) VALUES(-300328,STR_TO_DATE('2015/04/01 10:00:00.000000','%Y/%m/%d %H:%i:%s.%f'),'INSERT',2100000328,1,2100000328,1,'System Administrator','1',STR_TO_DATE('2015/04/01 10:00:00.000000','%Y/%m/%d %H:%i:%s.%f'),1);


INSERT INTO B_CMDB_HIDE_MENU_GRP (HIDE_ID,MENU_GROUP_ID,DISP_SEQ,NOTE,DISUSE_FLAG,LAST_UPDATE_TIMESTAMP,LAST_UPDATE_USER) VALUES(27,'2100110001',27,NULL,'0',STR_TO_DATE('2015/04/01 10:00:00.000000','%Y/%m/%d %H:%i:%s.%f'),1);
INSERT INTO B_CMDB_HIDE_MENU_GRP_JNL (JOURNAL_SEQ_NO,JOURNAL_REG_DATETIME,JOURNAL_ACTION_CLASS,HIDE_ID,MENU_GROUP_ID,DISP_SEQ,NOTE,DISUSE_FLAG,LAST_UPDATE_TIMESTAMP,LAST_UPDATE_USER) VALUES(27,STR_TO_DATE('2015/04/01 10:00:00.000000','%Y/%m/%d %H:%i:%s.%f'),'INSERT',27,'2100110001',27,NULL,'0',STR_TO_DATE('2015/04/01 10:00:00.000000','%Y/%m/%d %H:%i:%s.%f'),1);


INSERT INTO A_PROC_LOADED_LIST (ROW_ID,PROC_NAME,LOADED_FLG,LAST_UPDATE_TIMESTAMP) VALUES(2100000326,'ky_create_er-workflow','0',STR_TO_DATE('2015/04/01 10:00:00.000000','%Y/%m/%d %H:%i:%s.%f'));


INSERT INTO A_PROVIDER_ATTRIBUTE_NAME_LIST (ID,NAME,NOTE,DISUSE_FLAG,LAST_UPDATE_TIMESTAMP,LAST_UPDATE_USER) VALUES('11','ignoreSslVerify',NULL,NULL,NULL,NULL);
INSERT INTO A_PROVIDER_ATTRIBUTE_NAME_LIST_JNL (JOURNAL_SEQ_NO,JOURNAL_REG_DATETIME,JOURNAL_ACTION_CLASS,ID,NAME,NOTE,DISUSE_FLAG,LAST_UPDATE_USER) VALUES(11,STR_TO_DATE('2015/04/01 10:00:00.000000','%Y/%m/%d %H:%i:%s.%f'),'INSERT','11','ignoreSslVerify',NULL,NULL,NULL);


UPDATE B_LOGIN_AUTH_TYPE SET LOGIN_AUTH_TYPE_NAME='Key authentication (no passphrase)', DISP_SEQ=2 WHERE LOGIN_AUTH_TYPE_ID=1;
UPDATE B_LOGIN_AUTH_TYPE_JNL SET LOGIN_AUTH_TYPE_NAME='Key authentication (no passphrase)', DISP_SEQ=2 WHERE LOGIN_AUTH_TYPE_ID=1;

UPDATE B_LOGIN_AUTH_TYPE SET DISP_SEQ=1 WHERE LOGIN_AUTH_TYPE_ID=2;
UPDATE B_LOGIN_AUTH_TYPE_JNL SET DISP_SEQ=1 WHERE LOGIN_AUTH_TYPE_ID=2;

INSERT INTO B_LOGIN_AUTH_TYPE (LOGIN_AUTH_TYPE_ID,LOGIN_AUTH_TYPE_NAME,DISP_SEQ,NOTE,DISUSE_FLAG,LAST_UPDATE_TIMESTAMP,LAST_UPDATE_USER) VALUES(3,'Key authentication (key exchanged)',4,NULL,'0',STR_TO_DATE('2015/04/01 10:00:00.000000','%Y/%m/%d %H:%i:%s.%f'),1);
INSERT INTO B_LOGIN_AUTH_TYPE_JNL (JOURNAL_SEQ_NO,JOURNAL_REG_DATETIME,JOURNAL_ACTION_CLASS,LOGIN_AUTH_TYPE_ID,LOGIN_AUTH_TYPE_NAME,DISP_SEQ,NOTE,DISUSE_FLAG,LAST_UPDATE_TIMESTAMP,LAST_UPDATE_USER) VALUES(3,STR_TO_DATE('2015/04/01 10:00:00.000000','%Y/%m/%d %H:%i:%s.%f'),'INSERT',3,'Key authentication (key exchanged)',4,NULL,'0',STR_TO_DATE('2015/04/01 10:00:00.000000','%Y/%m/%d %H:%i:%s.%f'),1);
INSERT INTO B_LOGIN_AUTH_TYPE (LOGIN_AUTH_TYPE_ID,LOGIN_AUTH_TYPE_NAME,DISP_SEQ,NOTE,DISUSE_FLAG,LAST_UPDATE_TIMESTAMP,LAST_UPDATE_USER) VALUES(4,'Key authentication (with passphrase)',3,NULL,'0',STR_TO_DATE('2015/04/01 10:00:00.000000','%Y/%m/%d %H:%i:%s.%f'),1);
INSERT INTO B_LOGIN_AUTH_TYPE_JNL (JOURNAL_SEQ_NO,JOURNAL_REG_DATETIME,JOURNAL_ACTION_CLASS,LOGIN_AUTH_TYPE_ID,LOGIN_AUTH_TYPE_NAME,DISP_SEQ,NOTE,DISUSE_FLAG,LAST_UPDATE_TIMESTAMP,LAST_UPDATE_USER) VALUES(4,STR_TO_DATE('2015/04/01 10:00:00.000000','%Y/%m/%d %H:%i:%s.%f'),'INSERT',4,'Key authentication (with passphrase)',3,NULL,'0',STR_TO_DATE('2015/04/01 10:00:00.000000','%Y/%m/%d %H:%i:%s.%f'),1);
INSERT INTO B_LOGIN_AUTH_TYPE (LOGIN_AUTH_TYPE_ID,LOGIN_AUTH_TYPE_NAME,DISP_SEQ,NOTE,DISUSE_FLAG,LAST_UPDATE_TIMESTAMP,LAST_UPDATE_USER) VALUES(5,'Password authentication (winrm)',5,NULL,'0',STR_TO_DATE('2015/04/01 10:00:00.000000','%Y/%m/%d %H:%i:%s.%f'),1);
INSERT INTO B_LOGIN_AUTH_TYPE_JNL (JOURNAL_SEQ_NO,JOURNAL_REG_DATETIME,JOURNAL_ACTION_CLASS,LOGIN_AUTH_TYPE_ID,LOGIN_AUTH_TYPE_NAME,DISP_SEQ,NOTE,DISUSE_FLAG,LAST_UPDATE_TIMESTAMP,LAST_UPDATE_USER) VALUES(5,STR_TO_DATE('2015/04/01 10:00:00.000000','%Y/%m/%d %H:%i:%s.%f'),'INSERT',5,'Password authentication (winrm)',5,NULL,'0',STR_TO_DATE('2015/04/01 10:00:00.000000','%Y/%m/%d %H:%i:%s.%f'),1);


DELETE FROM B_DP_HIDE_MENU_LIST WHERE HIDE_ID IN(44,46,47,48);


UPDATE B_DP_MODE SET DP_MODE='Environment migration' WHERE ROW_ID=1;
UPDATE B_DP_MODE SET DP_MODE='Time specification' WHERE ROW_ID=2;


INSERT INTO B_ER_COLUMN_TYPE (COLUMN_TYPE_ID,COLUMN_TYPE_NAME,NOTE,DISUSE_FLAG,LAST_UPDATE_TIMESTAMP,LAST_UPDATE_USER) VALUES(1,'Group',NULL,'0',STR_TO_DATE('2015/04/01 10:00:00.000000','%Y/%m/%d %H:%i:%s.%f'),1);

INSERT INTO B_ER_COLUMN_TYPE (COLUMN_TYPE_ID,COLUMN_TYPE_NAME,NOTE,DISUSE_FLAG,LAST_UPDATE_TIMESTAMP,LAST_UPDATE_USER) VALUES(2,'Item',NULL,'0',STR_TO_DATE('2015/04/01 10:00:00.000000','%Y/%m/%d %H:%i:%s.%f'),1);


INSERT INTO F_MENU_CREATE_TYPE (MENU_CREATE_TYPE_ID,MENU_CREATE_TYPE_NAME,NOTE,DISUSE_FLAG,LAST_UPDATE_TIMESTAMP,LAST_UPDATE_USER) VALUES(1,'Create New',NULL,'0',STR_TO_DATE('2015/04/01 10:00:00.000000','%Y/%m/%d %H:%i:%s.%f'),1);
INSERT INTO F_MENU_CREATE_TYPE_JNL (JOURNAL_SEQ_NO,JOURNAL_REG_DATETIME,JOURNAL_ACTION_CLASS,MENU_CREATE_TYPE_ID,MENU_CREATE_TYPE_NAME,NOTE,DISUSE_FLAG,LAST_UPDATE_TIMESTAMP,LAST_UPDATE_USER) VALUES(1,STR_TO_DATE('2015/04/01 10:00:00.000000','%Y/%m/%d %H:%i:%s.%f'),'INSERT',1,'Create New',NULL,'0',STR_TO_DATE('2015/04/01 10:00:00.000000','%Y/%m/%d %H:%i:%s.%f'),1);
INSERT INTO F_MENU_CREATE_TYPE (MENU_CREATE_TYPE_ID,MENU_CREATE_TYPE_NAME,NOTE,DISUSE_FLAG,LAST_UPDATE_TIMESTAMP,LAST_UPDATE_USER) VALUES(2,'Initialize',NULL,'0',STR_TO_DATE('2015/04/01 10:00:00.000000','%Y/%m/%d %H:%i:%s.%f'),1);
INSERT INTO F_MENU_CREATE_TYPE_JNL (JOURNAL_SEQ_NO,JOURNAL_REG_DATETIME,JOURNAL_ACTION_CLASS,MENU_CREATE_TYPE_ID,MENU_CREATE_TYPE_NAME,NOTE,DISUSE_FLAG,LAST_UPDATE_TIMESTAMP,LAST_UPDATE_USER) VALUES(2,STR_TO_DATE('2015/04/01 10:00:00.000000','%Y/%m/%d %H:%i:%s.%f'),'INSERT',2,'Initialize',NULL,'0',STR_TO_DATE('2015/04/01 10:00:00.000000','%Y/%m/%d %H:%i:%s.%f'),1);
INSERT INTO F_MENU_CREATE_TYPE (MENU_CREATE_TYPE_ID,MENU_CREATE_TYPE_NAME,NOTE,DISUSE_FLAG,LAST_UPDATE_TIMESTAMP,LAST_UPDATE_USER) VALUES(3,'Edit',NULL,'0',STR_TO_DATE('2015/04/01 10:00:00.000000','%Y/%m/%d %H:%i:%s.%f'),1);
INSERT INTO F_MENU_CREATE_TYPE_JNL (JOURNAL_SEQ_NO,JOURNAL_REG_DATETIME,JOURNAL_ACTION_CLASS,MENU_CREATE_TYPE_ID,MENU_CREATE_TYPE_NAME,NOTE,DISUSE_FLAG,LAST_UPDATE_TIMESTAMP,LAST_UPDATE_USER) VALUES(3,STR_TO_DATE('2015/04/01 10:00:00.000000','%Y/%m/%d %H:%i:%s.%f'),'INSERT',3,'Edit',NULL,'0',STR_TO_DATE('2015/04/01 10:00:00.000000','%Y/%m/%d %H:%i:%s.%f'),1);

