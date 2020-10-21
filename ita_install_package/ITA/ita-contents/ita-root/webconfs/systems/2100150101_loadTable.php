<?php
//   Copyright 2019 NEC Corporation
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.
//
/* 資材管理 払出払戻コンソール：参照 */
$tmpFx = function (&$aryVariant=array(),&$arySetting=array()){
    global $g;

    if(!array_key_exists('page_dir', $g)){
        $g['page_dir'] = '2100150101';
    }

    $arrayWebSetting = array();
    $arrayWebSetting['page_info'] = $g['objMTS']->getSomeMessage("ITAMATERIAL-MNU-101401");

    $tmpAry = array(
        'TT_SYS_01_JNL_SEQ_ID'=>'JOURNAL_SEQ_NO',
        'TT_SYS_02_JNL_TIME_ID'=>'JOURNAL_REG_DATETIME',
        'TT_SYS_03_JNL_CLASS_ID'=>'JOURNAL_ACTION_CLASS',
        'TT_SYS_04_NOTE_ID'=>'NOTE',
        'TT_SYS_04_DISUSE_FLAG_ID'=>'DISUSE_FLAG',
        'TT_SYS_05_LUP_TIME_ID'=>'LAST_UPDATE_TIMESTAMP',
        'TT_SYS_06_LUP_USER_ID'=>'LAST_UPDATE_USER',
        'TT_SYS_NDB_ROW_EDIT_BY_FILE_ID'=>'ROW_EDIT_BY_FILE',
        'TT_SYS_NDB_UPDATE_ID'=>'WEB_BUTTON_UPDATE',
        'TT_SYS_NDB_LUP_TIME_ID'=>'UPD_UPDATE_TIMESTAMP'
    );

    $table = new TableControlAgent('G_FILE_MANAGEMENT_1','FILE_M_ID', $g['objMTS']->getSomeMessage("ITAMATERIAL-MNU-101301"), 'G_FILE_MANAGEMENT_JNL', $tmpAry);
    $tmpAryColumn = $table->getColumns();
    $tmpAryColumn['FILE_M_ID']->setSequenceID('F_FILE_MANAGEMENT_RIC');
    $tmpAryColumn['JOURNAL_SEQ_NO']->setSequenceID('F_FILE_MANAGEMENT_JSQ');
    unset($tmpAryColumn);

    // ----VIEWをコンテンツソースにする場合、構成する実体テーブルを更新するための設定
    $table->setDBMainTableHiddenID('F_FILE_MANAGEMENT');
    $table->setDBJournalTableHiddenID('F_FILE_MANAGEMENT_JNL');
    // 利用時は、更新対象カラムに、「$c->setHiddenMainTableColumn(true);」を付加すること
    // VIEWをコンテンツソースにする場合、構成する実体テーブルを更新するための設定----

    
    // QMファイル名プレフィックス
    $table->setDBMainTableLabel($g['objMTS']->getSomeMessage("ITAMATERIAL-MNU-101402"));
    // エクセルのシート名
    $table->getFormatter('excel')->setGeneValue('sheetNameForEditByFile', $g['objMTS']->getSomeMessage("ITAMATERIAL-MNU-101403"));

    $table->setAccessAuth(true);    // データごとのRBAC設定


    $c = new IDColumn('FILE_STATUS_ID',$g['objMTS']->getSomeMessage("ITAMATERIAL-MNU-101302"),'F_MM_STATUS_MASTER','FILE_STATUS_ID','FILE_STATUS_NAME','G_FILE_STATUS_MASTER_1',array('OrderByThirdColumn'=>'FILE_STATUS_ID'));
    $c->setDescription($g['objMTS']->getSomeMessage("ITAMATERIAL-MNU-101303"));//エクセル・ヘッダでの説明
    $c->setHiddenMainTableColumn(true);//コンテンツのソースがヴューの場合、登録/更新の対象とする際に、trueとすること。setDBColumn(true)であることも必要。
    $c->setDBColumn(true);
    $c->setRequired(true);//登録/更新時には、入力必須
    $table->addColumn($c);

    $cg = new ColumnGroup($g['objMTS']->getSomeMessage("ITAMATERIAL-MNU-101304"));

        $c = new IDColumn('FILE_ID',$g['objMTS']->getSomeMessage("ITAMATERIAL-MNU-101305"),'G_FILE_MASTER','FILE_ID','FILE_NAME_FULLPATH','G_FILE_MASTER',array('OrderByThirdColumn'=>'FILE_NAME_FULLPATH'));
        $c->setDescription($g['objMTS']->getSomeMessage("ITAMATERIAL-MNU-101306"));//エクセル・ヘッダでの説明
        $c->setHiddenMainTableColumn(true);//コンテンツのソースがヴューの場合、登録/更新の対象とする際に、trueとすること。setDBColumn(true)であることも必要。
        $c->setDBColumn(true);
        $c->setRequired(true);//登録/更新時には、入力必須
        $cg->addColumn($c);

    $table->addColumn($cg);

    $cg = new ColumnGroup($g['objMTS']->getSomeMessage("ITAMATERIAL-MNU-101307"));

        $c = new DateColumn('REQUIRE_DATE',$g['objMTS']->getSomeMessage("ITAMATERIAL-MNU-101308"));
        $c->setDescription($g['objMTS']->getSomeMessage("ITAMATERIAL-MNU-101309"));//エクセル・ヘッダでの説明
        $c->setHiddenMainTableColumn(true);//コンテンツのソースがヴューの場合、登録/更新の対象とする際に、trueとすること。setDBColumn(true)であることも必要。
        $c->setDBColumn(true);
        $c->setOutputType('update_table'  , new OutputType(new ReqTabHFmt(), new StaticTextTabBFmt($g['objMTS']->getSomeMessage("ITAMATERIAL-MNU-101310"))));
        $c->setOutputType('register_table', new OutputType(new ReqTabHFmt(), new StaticTextTabBFmt($g['objMTS']->getSomeMessage("ITAMATERIAL-MNU-101310"))));
        $c->setValidator(new DateValidator(null,null));
        $cg->addColumn($c);

        $c = new IDColumn('REQUIRE_USER_ID',$g['objMTS']->getSomeMessage("ITAMATERIAL-MNU-101311"),'A_ACCOUNT_LIST','USER_ID','USERNAME_JP','');
        $c->setDescription($g['objMTS']->getSomeMessage("ITAMATERIAL-MNU-101312"));//エクセル・ヘッダでの説明
        $c->setHiddenMainTableColumn(true);//コンテンツのソースがヴューの場合、登録/更新の対象とする際に、trueとすること。setDBColumn(true)であることも必要。
        $c->setDBColumn(true);
        $c->setOutputType('update_table'  , new OutputType(new ReqTabHFmt(), new StaticTextTabBFmt($g['objMTS']->getSomeMessage("ITAMATERIAL-MNU-101313"))));
        $c->setOutputType('register_table', new OutputType(new ReqTabHFmt(), new StaticTextTabBFmt($g['objMTS']->getSomeMessage("ITAMATERIAL-MNU-101313"))));
        $cg->addColumn($c);

    	$objVldt = new MultiTextValidator(0,4000,false);
        $c = new MultiTextColumn('REQUIRE_ABSTRUCT',$g['objMTS']->getSomeMessage("ITAMATERIAL-MNU-101314"));
        $c->setDescription($g['objMTS']->getSomeMessage("ITAMATERIAL-MNU-101315"));//エクセル・ヘッダでの説明
        $c->setHiddenMainTableColumn(true);//コンテンツのソースがヴューの場合、登録/更新の対象とする際に、trueとすること。setDBColumn(true)であることも必要。
        $c->setDBColumn(true);
        $c->getOutputType('filter_table')->setTextTagLastAttr('style = "ime-mode :active"');
        $c->getOutputType('register_table')->setTextTagLastAttr('style = "ime-mode :active"');
        $c->getOutputType('update_table')->setTextTagLastAttr('style = "ime-mode :active"');
    	$c->setValidator($objVldt);
        $cg->addColumn($c);

        $c = new DateColumn('REQUIRE_SCHEDULEDATE',$g['objMTS']->getSomeMessage("ITAMATERIAL-MNU-101316"));
        $c->setDescription($g['objMTS']->getSomeMessage("ITAMATERIAL-MNU-101317"));//エクセル・ヘッダでの説明
        $c->setHiddenMainTableColumn(true);//コンテンツのソースがヴューの場合、登録/更新の対象とする際に、trueとすること。setDBColumn(true)であることも必要。
        $c->setDBColumn(true);
    	$c->setValidator(new DateValidator(null,null));
        $cg->addColumn($c);

    $table->addColumn($cg);

    $cg = new ColumnGroup($g['objMTS']->getSomeMessage("ITAMATERIAL-MNU-101318"));

        $c = new DateColumn('ASSIGN_DATE',$g['objMTS']->getSomeMessage("ITAMATERIAL-MNU-101319"));
        $c->setDescription($g['objMTS']->getSomeMessage("ITAMATERIAL-MNU-101320"));//エクセル・ヘッダでの説明
        $c->setHiddenMainTableColumn(true);//コンテンツのソースがヴューの場合、登録/更新の対象とする際に、trueとすること。setDBColumn(true)であることも必要。
        $c->setDBColumn(true);
        $c->setOutputType('update_table'  , new OutputType(new ReqTabHFmt(), new StaticTextTabBFmt($g['objMTS']->getSomeMessage("ITAMATERIAL-MNU-101321"))));
        $c->setOutputType('register_table', new OutputType(new ReqTabHFmt(), new StaticTextTabBFmt($g['objMTS']->getSomeMessage("ITAMATERIAL-MNU-101321"))));
    	$c->setValidator(new DateValidator(null,null));
        $cg->addColumn($c);

        $c = new IDColumn('ASSIGN_USER_ID',$g['objMTS']->getSomeMessage("ITAMATERIAL-MNU-101322"),'A_ACCOUNT_LIST','USER_ID','USERNAME_JP','');
        $c->setDescription($g['objMTS']->getSomeMessage("ITAMATERIAL-MNU-101323"));//エクセル・ヘッダでの説明
        $c->setHiddenMainTableColumn(true);//コンテンツのソースがヴューの場合、登録/更新の対象とする際に、trueとすること。setDBColumn(true)であることも必要。
        $c->setDBColumn(true);
        $c->setOutputType('update_table'  , new OutputType(new ReqTabHFmt(), new StaticTextTabBFmt($g['objMTS']->getSomeMessage("ITAMATERIAL-MNU-101324"))));
        $c->setOutputType('register_table', new OutputType(new ReqTabHFmt(), new StaticTextTabBFmt($g['objMTS']->getSomeMessage("ITAMATERIAL-MNU-101324"))));
        $cg->addColumn($c);

        $c = new FileUploadColumn('ASSIGN_FILE',$g['objMTS']->getSomeMessage("ITAMATERIAL-MNU-101325"),"{$g['scheme_n_authority']}/default/menu/05_preupload.php?no={$g['page_dir']}","/uploadfiles/2100150101/ASSIGN_FILE");
        $c->setDescription($g['objMTS']->getSomeMessage("ITAMATERIAL-MNU-101326"));//エクセル・ヘッダでの説明
        $c->setMaxFileSize(4*1024*1024*1024);//単位はバイト
        $c->setHiddenMainTableColumn(true);//コンテンツのソースがヴューの場合、登録/更新の対象とする際に、trueとすること。setDBColumn(true)であることも必要。
        $c->setDBColumn(true);
        $c->setAllowSendFromFile(false);//エクセル/CSVからのアップロードを禁止する。
        $c->getOutputType('excel')->setVisible(false);
        $c->getOutputType('csv')->setVisible(false);
        $c->setFileHideMode(true);
        $cg->addColumn($c);

    	$objVldt = new SingleTextValidator(0,64,false);
        $c = new TextColumn('ASSIGN_REVISION',$g['objMTS']->getSomeMessage("ITAMATERIAL-MNU-101327"));
        $c->setDescription($g['objMTS']->getSomeMessage("ITAMATERIAL-MNU-101328"));//エクセル・ヘッダでの説明
        $c->setHiddenMainTableColumn(true);//コンテンツのソースがヴューの場合、登録/更新の対象とする際に、trueとすること。setDBColumn(true)であることも必要。
        $c->setDBColumn(true);
        $c->getOutputType('update_table')->setVisible(false);
        $c->getOutputType('register_table')->setVisible(false);
        $c->getOutputType('filter_table')->setTextTagLastAttr('style = "ime-mode :active"');
        $c->getOutputType('register_table')->setTextTagLastAttr('style = "ime-mode :active"');
        $c->getOutputType('update_table')->setTextTagLastAttr('style = "ime-mode :active"');
    	$c->setValidator($objVldt);
        $cg->addColumn($c);

    $table->addColumn($cg);

    $cg = new ColumnGroup($g['objMTS']->getSomeMessage("ITAMATERIAL-MNU-101329"));

        $c = new DateColumn('RETURN_DATE',$g['objMTS']->getSomeMessage("ITAMATERIAL-MNU-101330"));
        $c->setDescription($g['objMTS']->getSomeMessage("ITAMATERIAL-MNU-101331"));//エクセル・ヘッダでの説明
        $c->setHiddenMainTableColumn(true);//コンテンツのソースがヴューの場合、登録/更新の対象とする際に、trueとすること。setDBColumn(true)であることも必要。
        $c->setDBColumn(true);
        $c->setOutputType('update_table'  , new OutputType(new ReqTabHFmt(), new StaticTextTabBFmt($g['objMTS']->getSomeMessage("ITAMATERIAL-MNU-101332"))));
        $c->setOutputType('register_table', new OutputType(new ReqTabHFmt(), new StaticTextTabBFmt($g['objMTS']->getSomeMessage("ITAMATERIAL-MNU-101332"))));
    	$c->setValidator(new DateValidator(null,null));
        $cg->addColumn($c);

        $c = new IDColumn('RETURN_USER_ID',$g['objMTS']->getSomeMessage("ITAMATERIAL-MNU-101333"),'A_ACCOUNT_LIST','USER_ID','USERNAME_JP','');
        $c->setDescription($g['objMTS']->getSomeMessage("ITAMATERIAL-MNU-101334"));//エクセル・ヘッダでの説明
        $c->setHiddenMainTableColumn(true);//コンテンツのソースがヴューの場合、登録/更新の対象とする際に、trueとすること。setDBColumn(true)であることも必要。
        $c->setDBColumn(true);
        $c->setOutputType('update_table'  , new OutputType(new ReqTabHFmt(), new StaticTextTabBFmt($g['objMTS']->getSomeMessage("ITAMATERIAL-MNU-101335"))));
        $c->setOutputType('register_table', new OutputType(new ReqTabHFmt(), new StaticTextTabBFmt($g['objMTS']->getSomeMessage("ITAMATERIAL-MNU-101335"))));
        $cg->addColumn($c);

        $c = new FileUploadColumn('RETURN_FILE',$g['objMTS']->getSomeMessage("ITAMATERIAL-MNU-101336"),"{$g['scheme_n_authority']}/default/menu/05_preupload.php?no={$g['page_dir']}","/uploadfiles/2100150101/RETURN_FILE");
        $c->setDescription($g['objMTS']->getSomeMessage("ITAMATERIAL-MNU-101337"));//エクセル・ヘッダでの説明
        $c->setMaxFileSize(4*1024*1024*1024);//単位はバイト
        $c->setHiddenMainTableColumn(true);//コンテンツのソースがヴューの場合、登録/更新の対象とする際に、trueとすること。setDBColumn(true)であることも必要。
        $c->setDBColumn(true);
        $c->setAllowSendFromFile(false);//エクセル/CSVからのアップロードを禁止する。
        $c->getOutputType('excel')->setVisible(false);
        $c->getOutputType('csv')->setVisible(false);
        $c->setFileHideMode(true);
        $cg->addColumn($c);

        $c = new FileUploadColumn('RETURN_DIFF',$g['objMTS']->getSomeMessage("ITAMATERIAL-MNU-101338"),"{$g['scheme_n_authority']}/default/menu/05_preupload.php?no={$g['page_dir']}","/uploadfiles/2100150101/RETURN_DIFF");
        $c->setDescription($g['objMTS']->getSomeMessage("ITAMATERIAL-MNU-101339"));//エクセル・ヘッダでの説明
        $c->setMaxFileSize(4*1024*1024*1024);//単位はバイト
        $c->setHiddenMainTableColumn(true);//コンテンツのソースがヴューの場合、登録/更新の対象とする際に、trueとすること。setDBColumn(true)であることも必要。
        $c->setDBColumn(true);
        $c->setAllowSendFromFile(false);//エクセル/CSVからのアップロードを禁止する。
        $c->getOutputType('excel')->setVisible(false);
        $c->getOutputType('csv')->setVisible(false);
        $c->setFileHideMode(true);
        $cg->addColumn($c);

        $c = new FileUploadColumn('RETURN_TESTCASES',$g['objMTS']->getSomeMessage("ITAMATERIAL-MNU-101340"),"{$g['scheme_n_authority']}/default/menu/05_preupload.php?no={$g['page_dir']}","/uploadfiles/2100150101/RETURN_TESTCASES");
        $c->setDescription($g['objMTS']->getSomeMessage("ITAMATERIAL-MNU-101341"));//エクセル・ヘッダでの説明
        $c->setMaxFileSize(4*1024*1024*1024);//単位はバイト
        $c->setHiddenMainTableColumn(true);//コンテンツのソースがヴューの場合、登録/更新の対象とする際に、trueとすること。setDBColumn(true)であることも必要。
        $c->setDBColumn(true);
        $c->setAllowSendFromFile(false);//エクセル/CSVからのアップロードを禁止する。
        $c->getOutputType('excel')->setVisible(false);
        $c->getOutputType('csv')->setVisible(false);
        $c->setFileHideMode(true);
        $cg->addColumn($c);

        $c = new FileUploadColumn('RETURN_EVIDENCES',$g['objMTS']->getSomeMessage("ITAMATERIAL-MNU-101342"),"{$g['scheme_n_authority']}/default/menu/05_preupload.php?no={$g['page_dir']}","/uploadfiles/2100150101/RETURN_EVIDENCES");
        $c->setDescription($g['objMTS']->getSomeMessage("ITAMATERIAL-MNU-101343"));//エクセル・ヘッダでの説明
        $c->setMaxFileSize(4*1024*1024*1024);//単位はバイト
        $c->setHiddenMainTableColumn(true);//コンテンツのソースがヴューの場合、登録/更新の対象とする際に、trueとすること。setDBColumn(true)であることも必要。
        $c->setDBColumn(true);
        $c->setAllowSendFromFile(false);//エクセル/CSVからのアップロードを禁止する。
        $c->getOutputType('excel')->setVisible(false);
        $c->getOutputType('csv')->setVisible(false);
        $c->setFileHideMode(true);
        $cg->addColumn($c);

    $table->addColumn($cg);

    $cg = new ColumnGroup($g['objMTS']->getSomeMessage("ITAMATERIAL-MNU-101344"));

        $c = new DateColumn('CLOSE_DATE',$g['objMTS']->getSomeMessage("ITAMATERIAL-MNU-101345"));
        $c->setDescription($g['objMTS']->getSomeMessage("ITAMATERIAL-MNU-101346"));//エクセル・ヘッダでの説明
        $c->setHiddenMainTableColumn(true);//コンテンツのソースがヴューの場合、登録/更新の対象とする際に、trueとすること。setDBColumn(true)であることも必要。
        $c->setDBColumn(true);
        $c->setOutputType('update_table'  , new OutputType(new ReqTabHFmt(), new StaticTextTabBFmt($g['objMTS']->getSomeMessage("ITAMATERIAL-MNU-101347"))));
        $c->setOutputType('register_table', new OutputType(new ReqTabHFmt(), new StaticTextTabBFmt($g['objMTS']->getSomeMessage("ITAMATERIAL-MNU-101347"))));
    	$c->setValidator(new DateValidator(null,null));
        $cg->addColumn($c);

        $c = new IDColumn('CLOSE_USER_ID',$g['objMTS']->getSomeMessage("ITAMATERIAL-MNU-101348"),'A_ACCOUNT_LIST','USER_ID','USERNAME_JP','');
        $c->setDescription($g['objMTS']->getSomeMessage("ITAMATERIAL-MNU-101349"));//エクセル・ヘッダでの説明
        $c->setHiddenMainTableColumn(true);//コンテンツのソースがヴューの場合、登録/更新の対象とする際に、trueとすること。setDBColumn(true)であることも必要。
        $c->setDBColumn(true);
        $c->setOutputType('update_table'  , new OutputType(new ReqTabHFmt(), new StaticTextTabBFmt($g['objMTS']->getSomeMessage("ITAMATERIAL-MNU-101350"))));
        $c->setOutputType('register_table', new OutputType(new ReqTabHFmt(), new StaticTextTabBFmt($g['objMTS']->getSomeMessage("ITAMATERIAL-MNU-101350"))));
        $cg->addColumn($c);

    	$objVldt = new SingleTextValidator(0,64,false);
        $c = new TextColumn('CLOSE_REVISION',$g['objMTS']->getSomeMessage("ITAMATERIAL-MNU-101351"));
        $c->setDescription($g['objMTS']->getSomeMessage("ITAMATERIAL-MNU-101352"));//エクセル・ヘッダでの説明
        $c->getOutputType('filter_table')->setTextTagLastAttr('style = "ime-mode :active"');
        $c->getOutputType('register_table')->setTextTagLastAttr('style = "ime-mode :active"');
        $c->getOutputType('update_table')->setTextTagLastAttr('style = "ime-mode :active"');
    	$c->setValidator($objVldt);
        $cg->addColumn($c);

    $table->addColumn($cg);


//----head of setting [multi-set-unique]

//tail of setting [multi-set-unique]----

    $table->fixColumn();

    $table->setGeneObject('webSetting', $arrayWebSetting);
    return $table;
};
loadTableFunctionAdd($tmpFx,__FILE__);
unset($tmpFx);
?>
