//+------------------------------------------------------------------+
//|                                                   Calculator.mq4 |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+ 
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "5.11"
#property strict
#property indicator_chart_window
#property indicator_buffers 24


#include <CalcLib.mqh>


datetime limittime = D'2023.01.12';
bool comment_delete = true;

input string aaaaasvacadsccsda="========残り時間設定========";//========残り時間設定========
enum MODE_remainingtime {表示する  = 0,表示しない = 1};
input MODE_remainingtime displaytime=0;//残り時間表示
input int x_time = 200;//残り時間表示位置(右から)
input int x_winrate = 240;//勝率表示位置(右から)
input int rt_fontsize = 12;//残り時間のテキストの大きさ
input color rt_color = clrWhite;//残り時間のテキストの色

input string aaaaerwacadsccsda="========インジケータ設定========";//========インジケータ設定========
input int p = 1500;//計算バー本数
input bool PreBarAlert = false;//矢印確定時アラート
input bool CurBarAlert = false;//現在足アラート
input color up_color_0 = clrRed;//High矢印色
input color down_color_0 = clrBlue;//High矢印色
input color judge_color_0 = clrYellow;//判定記号色
input int arrow_point_0 = 5;//矢印描写位置(単位:その通貨の最小単位)
input int non_judge_0 = 0;//連続サイン抑止本数
input int jt_0 = 1;//何本足で判定するか
input int sp_0 = 0;//スプレッド
input string HighExHours_0 ="";//除外時間High(日本時間：サマータイム自動判別)
input string LowExHours_0 ="";//除外時間Low (日本時間：サマータイム自動判別)
input string aaaaaaaaaaaaa="↑書き方半角「,(コンマ)」　区切り(例「2,3,6」)";//_
enum MODE4 {総合勝率=0,時間別詳細勝率　=1};
input MODE4 display_winper =1;//勝率表示モード(現在時刻)
input double exp_winper_0 = 0;//期待する勝率(％)

Logic logic[1];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   if(limittime<TimeLocal() || limittime<TimeCurrent()){
      Comment(
         "=================================\n"
         +"使用期間が過ぎています。\n"
         +"インジケータはチャートから削除されました。\n"
         +"================================="
      );
      comment_delete = false;
      return 1;
   } //日付制限
   
   
   if(displaytime==0)label("remaining_time","計算中",x_time,50,rt_color,CORNER_RIGHT_LOWER,rt_fontsize);
   
   logic[0].LogicInit("A_Logic",HighExHours_0,LowExHours_0);
   logic[0].detail_winrate = display_winper;
   logic[0].SetBuffer(0);
   logic[0].up_color = up_color_0;   
   logic[0].down_color= down_color_0;
   logic[0].judge_color = judge_color_0;
   logic[0].arrow_dis = arrow_point_0;
   logic[0].non_judge = non_judge_0;
   logic[0].jt = jt_0;
   logic[0].sp = sp_0; 
   logic[0].exp_winper = exp_winper_0;
   logic[0].LogicLabel_WinRate(x_winrate,40);   
   EventSetTimer(1);
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---

   if(Bars<0)return 0;
   if(Bars-100<p){
      Comment("計算するろうそく足の本数が多すぎます。最大バー数:",Bars-100);
      return 0;
   }
   Comment("認証完了　最大バー数:",Bars);
   
   int limit = Bars-IndicatorCounted();
   limit = MathMin(limit,p);

   static bool initialized = false;//最初の一回関数制限
   if(limit>2 && initialized){
      Print("再計算　"+IntegerToString(limit)+"   "+TimeToStr(TimeLocal())); 
      limit = p;
      for(int l=0;l<ArraySize(logic);l++){logic[l].Reset();}
   }
   //--------------------------------------------------------------
   
   for(int i=limit-1; i>=0; i--){ 
      int ram=0;
      int rom=0;
         if(on_rsi==0){ram +=rsicon(i);rom++;}
         if(on_rsi2==0){ram +=rsi2con(i);}
         if(on_cci==0){ram +=ccicon(i);rom++;}
         if(on_cci2==0){ram +=cci2con(i);}
         if(on_sto==0){ram +=stocon(i);rom++;}
         if(on_macd==0){ram +=macdcon(i);rom++;}
         if(on_macd2==0){ram +=macd2con(i);rom++;}
         if(on_sto2==0){ram +=sto2con(i);rom++;}
         if(on_ma==0){ram +=macon(i);rom++;}
         if(on_ma2==0){ram +=ma2con(i);rom++;}
         if(on_ma3==0){ram +=ma3con(i);rom++;}
         if(on_ma4==0){ram +=ma4con(i);rom++;}
         if(on_bb==0){ram +=bbcon(i);rom++;}
         if(on_bb2==0){ram +=bb2con(i);rom++;}
         if(on_ac==0){ram +=accon(i);rom++;}
         if(on_ad==0){ram +=adcon(i);rom++;}
         if(on_adx==0){ram +=adxcon(i);}
         if(on_adx2==0){ram +=adx2con(i);}
         if(on_adx3==0){ram +=adx3con(i);}
         if(on_ao==0){ram +=aocon(i);rom++;}
         if(on_atr==0){ram +=atrcon(i);rom++;}
         if(on_bears==0){ram +=bearscon(i);rom++;}
         if(on_bulls==0){ram +=bullscon(i);rom++;}
         if(on_demark==0){ram +=demarkcon(i);rom++;}
         if(on_mfi==0){ram +=mficon(i);rom++;}
         if(on_env==0){ram +=envcon(i);rom++;}
         if(on_fi==0){ram +=ficon(i);rom++;}
         if(on_ichimoku==0){ram +=ichimokucon(i);}
         if(on_ichimoku2==0){ram +=ichimoku2con(i);rom++;}
         if(on_mom==0){ram +=momcon(i);rom++;}
         if(on_mom2==0){ram +=mom2con(i);}
         if(on_osma==0){ram +=osmacon(i);rom++;}
         if(on_obv==0){ram +=obvcon(i);rom++;}
         if(on_obv==0){ram +=obvcon(i);rom++;}
         if(on_sar==0){ram +=sarcon(i);rom++;}
         if(on_sar2==0){ram +=sar2con(i);rom++;}
         if(on_rvi==0){ram +=rvicon(i);rom++;}
         if(on_rd==0){ram +=rdcon(i);rom++;}
         if(on_rvi2==0){ram +=rvi2con(i);rom++;}
         if(on_std==0){ram +=stdcon(i);}
         if(on_wpr==0){ram +=wprcon(i);rom++;}
         if(on_wpr2==0){ram +=wpr2con(i);rom++;}
         if(on_rci==0){ram +=rcicon(i);rom++;}
         if(on_rci2==0){ram +=rcicon(i);rom++;}
         if(on_cad0==0){ram +=cad0con(i);}
         if(on_cad==0){ram +=cadcon(i);rom++;}
         if(on_cad2==0){ram +=cad2con(i);rom++;}
         if(on_cad3==0){ram +=cad3con(i);rom++;}
         if(on_cad4==0){ram +=cad4con(i);rom++;} 
         if(on_bbrsi==0){ram +=bbrsi(i);rom++;}   
         if(on_hill==0){ram +=hill(i);rom++;}
      logic[0].SetArrow(i,ram,rom);
   }//インジケーターlimitループの終了
   if(IndicatorCounted()>0){
      for(int k=p;k<limit+p;k++){
         for(int l=0;l<ArraySize(logic);l++){logic[l].DelArrow(k);}
      }   
   }
   //最初一回の関数
   if(!initialized){
      for(int l=0;l<ArraySize(logic);l++){logic[l].WriteLabel();}
      initialized = true;
   }

   //新しいろうそく足関数
   static datetime tmp_time = Time[0];
   if(tmp_time!=Time[0]){
      //前足アラート
      if(PreBarAlert){
         for(int l=0;l<ArraySize(logic);l++){logic[l].AlertArrowPreBar();}
      }
      tmp_time=Time[0];
   } 
   //現在足アラート
   if(CurBarAlert){
      for(int l=0;l<ArraySize(logic);l++){logic[l].AlertArrowCurBar();}  
   } 
//--- return value of prev_calculated for next call
   return(rates_total);
  }

//+------------------------------------------------------------------++------------------------------------------------------------------+
//| Timer function                                                   || Timer function                                                   |
//+------------------------------------------------------------------++------------------------------------------------------------------+
void OnTimer(){
   if(Bars<100)return;
   
   datetime TL= TimeLocal();
   
   //20秒関数
   static bool calced = false;
   if(calced == false && TimeSeconds(TL)>20){
      for(int l=0;l<ArraySize(logic);l++){
         logic[l].EarlyEntryReset();
         logic[l].WriteLabel();
      }
      calced = true;
   }
   if(TimeSeconds(TL)<20)calced = false;
   
   long remaining_time = Period()*60-(long)TL%(Period()*60);
   if(displaytime==0){
      if(remaining_time<0)remaining_time=0;
      ObjectSetString(NULL,"remaining_time",OBJPROP_TEXT,"残り時間　"+IntegerToString(remaining_time)+"　秒");      
   }  
   /*
   if(entry_mode==1){
      if(remaining_time<=61-entry_timing){
         for(int l=0;l<ArraySize(logic);l++){logic[l].SendTradeSingalEarlier();}
      }
   }
   */
}
//+------------------------------------------------------------------++------------------------------------------------------------------+
//| Custom indicator deinitialization function                       || Custom indicator deinitialization function                       |
//+------------------------------------------------------------------++------------------------------------------------------------------+
void OnDeinit(const int reason){
   for(int l=0;l<ArraySize(logic);l++){logic[l].LogicDeinit();} 
   if(displaytime == 0)ObjectDelete(NULL,"remaining_time");
   EventKillTimer();
	if(comment_delete)Comment("");
}

//----------------------------------------------------------------------------------------------------------------------------

input string aaaadascadsccsda="========条件設定========";//========条件設定========
enum MODE1{条件追加する=0,条件追加しない=1};
enum MODE2{サイン正転=1,サイン反転=-1};
enum MODE6{SMA　=0,EMA　=1,SMMA　=2,LWMA　=3};
enum MODE13{設定値より上、より下=0,設定値とのクロス（下→上）=1,設定値とのクロス（下→上）＋前足条件=2,設定値とのクロス（上→下）=3};
input string aaaaaaaaaaaaaaaaaa="-------------------------------------";//RSIの設定------------------------------------------------- 
input MODE1 on_rsi=0;//RSI on off
input int rsi_period=14;//RSI期間
input int rsi_high=70;//RSI:この値より上でLowサイン
input int rsi_low=30;//RSI:この値より下でHighサイン
input MODE2 Vrsi=1;//条件反転
input MODE13 rsiPlus=0;//詳細条件
input int rsi_high_pre=70;//RSI:前足条件
input int rsi_low_pre=30;//RSI:前足条件

int rsicon (int i){ 
   double rsi = iRSI(NULL,0,rsi_period,0,i);
   double rsi_pre = iRSI(NULL,0,rsi_period,0,i+1); 
     
   if(rsiPlus==0){
      if (rsi>rsi_high)return Vrsi;//Low　エントリー
      else if (rsi<rsi_low)return -Vrsi;//Highエントリー
      else return 0;   
   } 
   else if(rsiPlus==1){
      if (rsi>rsi_high && rsi_pre<rsi_high)return Vrsi;//Low　エントリー
      else if (rsi<rsi_low && rsi_pre>rsi_low)return -Vrsi;//Highエントリー
      else return 0;     
   }
   else if(rsiPlus==2){
      if (rsi>rsi_high && rsi_pre<rsi_high_pre)return Vrsi;//Low　エントリー
      else if (rsi<rsi_low && rsi_pre>rsi_low_pre)return -Vrsi;//Highエントリー
      else return 0;     
   }
   else{
      if (rsi<rsi_high && rsi_pre>rsi_high)return Vrsi;//Low　エントリー
      else if (rsi>rsi_low && rsi_pre<rsi_low)return -Vrsi;//Highエントリー
      else return 0;     
   }
}

input string aaaaaaaaefaaaaaa="-------------------------------------";//RSI指定値以内の設定------------------------------------------------- 
input MODE1 on_rsi2=1;//RSI on off
input int rsi_period2=14;//RSI期間
input int rsi_high2=70;//RSI:上限値
input int rsi_low2=30;//RSI:下限値

int rsi2con (int i){ 
   double rsi = iRSI(NULL,0,rsi_period2,0,i); 
   if (rsi_high2>rsi && rsi>rsi_low2)return 0;
   else return 100;     
}

input string fffffffffffxfff="-------------------------------------";//ボリンジャーバンド逆張りの設定--------------------------------------------------------------
input MODE1 on_bb=1;//ボリンジャーバンド逆張りon off
input int bb_period=20;//ボリンジャーバンド期間
input double bb_devi=2.5;//ボリンジャーバンド偏差
input MODE2 Vbb=1;//条件反転

int bbcon(int i){
   double band_u = iBands(NULL,0, bb_period, bb_devi, 0, PRICE_CLOSE, MODE_UPPER, i);
   double band_l = iBands(NULL,0, bb_period, bb_devi, 0, PRICE_CLOSE, MODE_LOWER, i);
   if (band_u<=Close[i])return Vbb;
   else if (band_l>=Close[i])return -Vbb;
   else return 0;
}

input string fffffffffff="-------------------------------------";//ボリンジャーバンド逆張り2の設定--------------------------------------------------------------
input MODE1 on_bb2=1;//ボリンジャーバンド逆張り2on off
input int bb_period2=20;//ボリンジャーバンド期間
input double bb_devi2=2.5;//ボリンジャーバンド偏差
input MODE2 Vbb2=1;//条件反転

int bb2con(int i){
   double band_u = iBands(NULL,0, bb_period2, bb_devi2, 0, PRICE_CLOSE, MODE_UPPER, i);
   double band_l = iBands(NULL,0, bb_period2, bb_devi2, 0, PRICE_CLOSE, MODE_LOWER, i);
   if (band_u<=Close[i])return Vbb2;
   else if (band_l>=Close[i])return -Vbb2;
   else return 0;
}

input string ffffffffffffffffff="-------------------------------------";//ストキャスメイン線の設定--------------------------------------------------------------
input MODE1 on_sto2=1;//ストキャスメイン線のみ　on off
input int k2_period=5;//%K値
input int d2_period=3;//%D値
input int sd2_period=3;//%SD値
input double sto2_m_high = 80;//ストキャスメイン線:この値より上でLowサイン
input double sto2_m_low = 20;//ストキャスメイン線:この値より下でHighサイン
input MODE2 Vsto2=1;//条件反転
input MODE13 stoPlus=0;//詳細条件
input double sto2_m_high_pre = 80;//ストキャスメイン線:前足条件(上)
input double sto2_m_low_pre = 20;//ストキャスメイン線:前足条件(下)

int sto2con(int i){
   double sto_m =iStochastic(NULL,0,k2_period,d2_period,sd2_period,MODE_SMA,0,MODE_MAIN,i);
   double sto_m_pre =iStochastic(NULL,0,k2_period,d2_period,sd2_period,MODE_SMA,0,MODE_MAIN,i+1);
   
   if(stoPlus==0){
      if (sto_m > sto2_m_high)return Vsto2;
      else if (sto_m < sto2_m_low)return -Vsto2;
      else return 0;
   } 
   else if(stoPlus==1){
      if (sto_m > sto2_m_high && sto_m_pre < sto2_m_high)return Vsto2;
      else if (sto_m < sto2_m_low && sto_m_pre > sto2_m_low)return -Vsto2;
      else return 0;   
   }   
   else if(stoPlus==2){
      if (sto_m > sto2_m_high && sto_m_pre < sto2_m_high_pre)return Vsto2;
      else if (sto_m < sto2_m_low && sto_m_pre > sto2_m_low_pre)return -Vsto2;
      else return 0;   
   }   
   else{
      if (sto_m < sto2_m_high && sto_m_pre > sto2_m_high)return Vsto2;
      else if (sto_m > sto2_m_low && sto_m_pre < sto2_m_low)return -Vsto2;
      else return 0;   
   }   
}

input string cccccccccccccccccc="-------------------------------------";//ストキャスクロスの設定----------------------------------------------
input MODE1 on_sto=1;//ストキャスクロスon off
input int k_period=5;//%K値
input int d_period=3;//%D値(1より大きい値)
input int sd_period=3;//%SD値
input double sto_m_high = 80;//デッドクロスする時のMAIN線の値(設定値以上)
input double sto_s_high = 80;//デッドクロスする時のSIGNAL線の値(設定値以上)
input double sto_m_low = 20;//ゴールデンクロスする時のMAIN線の値(設定値以下)
input double sto_s_low = 20;//ゴールデンクロスする時のSIGNAL線の値(設定値以下)

int stocon(int i){
   double sto_m =iStochastic(NULL,0,k_period,d_period,sd_period,MODE_SMA,0,MODE_MAIN,i);
   double sto_s =iStochastic(NULL,0,k_period,d_period,sd_period,MODE_SMA,0,MODE_SIGNAL,i);
   double sto_m_pre =iStochastic(NULL,0,k_period,d_period,sd_period,MODE_SMA,0,MODE_MAIN,i+1);
   double sto_s_pre =iStochastic(NULL,0,k_period,d_period,sd_period,MODE_SMA,0,MODE_SIGNAL,i+1);

   if (sto_m_pre > sto_s_pre && sto_m < sto_s && sto_m>sto_m_high && sto_s >sto_s_high)return 1;
   else if (sto_m_pre < sto_s_pre && sto_m > sto_s && sto_m<sto_m_low && sto_s <sto_s_low)return -1;
   else return 0;
}

input string bbbbbbbbbbbbbbbbbb="-------------------------------------";//CCIの設定-------------------------------------------------
input MODE1 on_cci=1;//CCI on off
input int cci_period=14;//CCI期間
input int cci_high=100;//CCI:この値より上でLowサイン
input int cci_low=-100;//CCI:この値より下でHighサイン
input MODE2 Vcci=1;//条件反転
input MODE13 cciPlus=0;//詳細条件
input int cci_high_pre=100;//CCI:前足条件（上）
input int cci_low_pre=-100;//CCI:前足条件（下）

int ccicon(int i){
   double cci = iCCI(NULL,0,cci_period,0,i);
   double cci_pre = iCCI(NULL,0,cci_period,0,i+1);
   
   if(cciPlus==0){
      if (cci > cci_high )return Vcci;
      else if (cci < cci_low)return -Vcci;
      else return 0; 
   } 
   else if(cciPlus==1){
      if (cci > cci_high && cci_pre < cci_high)return Vcci;
      else if (cci < cci_low && cci_pre > cci_low)return -Vcci;
      else return 0;    
   }
   else if(cciPlus==2){
      if (cci > cci_high && cci_pre < cci_high_pre)return Vcci;
      else if (cci < cci_low && cci_pre > cci_low_pre)return -Vcci;
      else return 0;    
   }
   else{
      if (cci < cci_high && cci_pre > cci_high)return Vcci;
      else if (cci > cci_low && cci_pre < cci_low)return -Vcci;
      else return 0;    
   }
}

input string aaaaa43aaefaaaaaa="-------------------------------------";//CCI指定値以内の設定------------------------------------------------- 
input MODE1 on_cci2=1;//CCI on off
input int cci_period2=14;//CCI期間
input int cci_high2=100;//CCI:上限値
input int cci_low2=-100;//CCI:下限値

int cci2con (int i){ 
   double cci = iCCI(NULL,0,cci_period2,0,i); 
   if (cci_high2>cci && cci>cci_low2)return 0;
   else return 100;     
}

input string fffatewfcdddxfff="-------------------------------------";//RDcomboの設定--------------------------------------------------------------
input MODE1 on_rd=1;//RDcombo on off
input MODE2 Vrd=1;//条件反転

int rdcon(int i){
   int rd = iRD(i);
   if (rd == 1)return Vrd;
   else if (rd == -1)return -Vrd;
   else return 0;
}

input string fffffffcftffxfff="-------------------------------------";//ADXメイン線指定値以内の設定--------------------------------------------------------------
input MODE1 on_adx=1;//ADXメイン指定値以内 on off
input int adx_period = 14;//ADXの期間
input double adx_high = 30;//ADXメイン線 上限
input double adx_low = 15;//ADXメイン線 下限

int adxcon(int i){
   double adx = iADX(NULL,0,adx_period,PRICE_CLOSE,MODE_MAIN,i);
   if (adx_high>adx && adx > adx_low)return 0;
   else return 100;
}

input string fffffffcffhisxfff="-------------------------------------";//ADX Di+指定値以内の設定--------------------------------------------------------------
input MODE1 on_adx2=1;//ADX Di+指定値以内 on off
input int adx_period2 = 14;//ADXの期間
input double adx_high2 = 30;//ADX Di+ 上限
input double adx_low2 = 15;//ADX Di+ 下限

int adx2con(int i){
   double adx = iADX(NULL,0,adx_period2,PRICE_CLOSE,MODE_PLUSDI,i);
   if (adx_high2> adx && adx > adx_low2)return 0;
   else return 100;
}

input string fffffffcfsdkjvfhisxfff="-------------------------------------";//ADX Di-指定値以内の設定--------------------------------------------------------------
input MODE1 on_adx3=1;//ADX Di- 指定値以内 on off
input int adx_period3 = 14;//ADXの期間
input double adx_high3 = 30;//ADX Di- 上限
input double adx_low3 = 15;//ADX Di- 下限

int adx3con(int i){
   double adx = iADX(NULL,0,adx_period3,PRICE_CLOSE,MODE_MINUSDI,i);
   if (adx_high3> adx && adx > adx_low3)return 0;
   else return 100;
}

input string fffffcfffffxfff="-------------------------------------";//ウィリアムズ%Rの設定--------------------------------------------------------------
input MODE1 on_wpr=1;//ウィリアムズ%R on off
input int wpr_period = 14;//ウィリアムズ%Rで使用する平均線の期間
input double wpr_high=-10;//ウィリアムズ%R:この値より上でLowサイン
input double wpr_low=-90;//ウィリアムズ%R:この値より下でHighサイン
input MODE2 Vwpr=1;//条件反転
input MODE13 wprPlus=0;//詳細条件
input double wpr_high_pre=-10;//ウィリアムズ%R:前足条件（上）
input double wpr_low_pre=-90;//ウィリアムズ%R:前足条件（下）

int wprcon(int i){
   double wpr = iWPR(NULL,0,wpr_period,i);
   double wpr_pre = iWPR(NULL,0,wpr_period,i+1);
   

   if(wprPlus==0){
      if (wpr>wpr_high)return Vwpr;
      else if (wpr<wpr_low)return -Vwpr;
      else return 0;   
   } 
   else if(wprPlus==1){
      if (wpr>wpr_high && wpr_pre<wpr_high)return Vwpr;
      else if (wpr<wpr_low && wpr_pre>wpr_low )return -Vwpr;
      else return 0;     
   }
   else if(wprPlus==2){
      if (wpr>wpr_high && wpr_pre<wpr_high_pre)return Vwpr;
      else if (wpr<wpr_low && wpr_pre>wpr_low_pre )return -Vwpr;
      else return 0;     
   }
   else{
      if (wpr<wpr_high && wpr_pre>wpr_high)return Vwpr;
      else if (wpr>wpr_low && wpr_pre<wpr_low )return -Vwpr;
      else return 0;     
   }
}

input string fffffc2fxfff="-------------------------------------";//ウィリアムズ%R2の設定--------------------------------------------------------------
input MODE1 on_wpr2=1;//ウィリアムズ%R2 on off
input int wpr_period2 = 14;//ウィリアムズ%Rで使用する平均線の期間
input double wpr_high2=-10;//ウィリアムズ%R:この値より上でLowサイン
input double wpr_low2=-90;//ウィリアムズ%R:この値より下でHighサイン
input MODE2 Vwpr2=1;//条件反転
input MODE13 wprPlus2=0;//詳細条件
input double wpr_high_pre2=-10;//ウィリアムズ%R:前足条件（上）
input double wpr_low_pre2=-90;//ウィリアムズ%R:前足条件（下）

int wpr2con(int i){
   double wpr = iWPR(NULL,0,wpr_period2,i);
   double wpr_pre = iWPR(NULL,0,wpr_period2,i+1);
   

   if(wprPlus2==0){
      if (wpr>wpr_high2)return Vwpr2;
      else if (wpr<wpr_low2)return -Vwpr2;
      else return 0;   
   } 
   else if(wprPlus2==1){
      if (wpr>wpr_high2 && wpr_pre<wpr_high2)return Vwpr2;
      else if (wpr<wpr_low2 && wpr_pre>wpr_low2 )return -Vwpr2;
      else return 0;     
   }
   else if(wprPlus2==2){
      if (wpr>wpr_high2 && wpr_pre<wpr_high_pre2)return Vwpr2;
      else if (wpr<wpr_low2 && wpr_pre>wpr_low_pre2 )return -Vwpr2;
      else return 0;     
   }
   else{
      if (wpr<wpr_high2 && wpr_pre>wpr_high2)return Vwpr2;
      else if (wpr>wpr_low2 && wpr_pre<wpr_low2 )return -Vwpr2;
      else return 0;     
   }
}

input string cccccccvccccccccccc="-------------------------------------";//MACDクロスの設定----------------------------------------------
input MODE1 on_macd=1;//MACDクロスon off
input int macd_fast_ema = 12;//MACD:Fast EMA 期間
input int macd_slow_ema = 26;//MACD:Slow EMA 期間
input int macd_signal_period = 9;//MACD:Signal 期間
input double macd_m_high = 0.003;//デッドクロスする時のMAIN線の値(設定値以上)
input double macd_s_high = 0.003;//デッドクロスする時のSIGNAL線の値(設定値以上)
input double macd_m_low = -0.003;//ゴールデンクロスする時のMAIN線の値(設定値以下)
input double macd_s_low = -0.003;//ゴールデンクロスする時のSIGNAL線の値(設定値以下)

int macdcon(int i){
   double macd_m = iMACD(NULL,0,macd_fast_ema,macd_slow_ema,macd_signal_period,PRICE_CLOSE,MODE_MAIN,i);
   double macd_s = iMACD(NULL,0,macd_fast_ema,macd_slow_ema,macd_signal_period,PRICE_CLOSE,MODE_SIGNAL,i);
   double macd_m_pre = iMACD(NULL,0,macd_fast_ema,macd_slow_ema,macd_signal_period,PRICE_CLOSE,MODE_MAIN,i+1);
   double macd_s_pre = iMACD(NULL,0,macd_fast_ema,macd_slow_ema,macd_signal_period,PRICE_CLOSE,MODE_SIGNAL,i+1);
   if (macd_m_pre > macd_s_pre && macd_m < macd_s && macd_m>macd_m_high && macd_s>macd_s_high)return 1;
   else if (macd_m_pre < macd_s_pre && macd_m > macd_s && macd_m<macd_m_low && macd_s<macd_s_low)return -1;
   else return 0;
}

input string cccccccvrcccccc="-------------------------------------";//MACDヒストグラムの設定----------------------------------------------
input MODE1 on_macd2=1;//MACDヒストグラム条件on off
input int macd_fast_ema2 = 12;//MACD:Fast EMA 期間
input int macd_slow_ema2 = 26;//MACD:Slow EMA 期間
input int macd_signal_period2 = 9;//MACD:Signal 期間
enum MODE_macd2{ヒストグラム順張り=0,０値クロス=1};
input MODE_macd2 macd2_plus= 1;//詳細条件
input MODE2 Vmacd2=1;//条件反転
int macd2con(int i){
   double macd_m = iMACD(NULL,0,macd_fast_ema2,macd_slow_ema2,macd_signal_period2,PRICE_CLOSE,MODE_MAIN,i); 
   double macd_m_pre = iMACD(NULL,0,macd_fast_ema2,macd_slow_ema2,macd_signal_period2,PRICE_CLOSE,MODE_MAIN,i+1);      
   if(macd2_plus==0){
      if (macd_m<0)return Vmacd2;
      else if (macd_m>0)return -Vmacd2;
      else return 0;        
   }
   else{
      if (macd_m_pre>0 && macd_m<0 )return Vmacd2;
      else if (macd_m_pre<0 && macd_m>0 )return -Vmacd2;
      else return 0;       
   }
}

input string ffffffffffffffffffx="-------------------------------------";//移動平均線クロスの設定--------------------------------------------------------------
input MODE1 on_ma=1;//移動平均線クロスon off
input int ma_f_period=10;//短期移動平均線の期間
input int ma_s_period=25;//長期移動平均線の期間
input MODE6 _ma_mode=0;//移動平均線種類

int macon(int i){
   int ma_mode = _ma_mode;
   double ma_f=iMA(NULL,0,ma_f_period,0,ma_mode,PRICE_CLOSE,i);
   double ma_s=iMA(NULL,0,ma_s_period,0,ma_mode,PRICE_CLOSE,i);
   double ma_f_pre=iMA(NULL,0,ma_f_period,0,ma_mode,PRICE_CLOSE,i+1);
   double ma_s_pre=iMA(NULL,0,ma_s_period,0,ma_mode,PRICE_CLOSE,i+1);
   if (ma_f_pre>ma_s_pre && ma_f<ma_s)return 1;
   else if (ma_f_pre<ma_s_pre && ma_f>ma_s)return -1;
   else return 0;
}



input string fffffffffffxfffffffx="-------------------------------------";//移動平均線順張りの設定--------------------------------------------------------------
input MODE1 on_ma2=1;//移動平均線順張りon off
input int ma2_period=10;//移動平均線期間
input MODE6 _ma2_mode=0;//移動平均線種類

int ma2con(int i){
   int ma2_mode = _ma2_mode;
   double ma=iMA(NULL,0,ma2_period,0,ma2_mode,PRICE_CLOSE,i); 
   double ma_pre=iMA(NULL,0,ma2_period,0,ma2_mode,PRICE_CLOSE,i+1);
    
   if (ma_pre>ma)return 1;
   else if (ma_pre<ma)return -1;
   else return 0;
}

input string fffffffffefxfffffffx="-------------------------------------";//パーフェクトオーダーの設定--------------------------------------------------------------
input MODE1 on_ma3=1;//パーフェクトオーダーon off
input int ma3_period_s=10;//短期移動平均線期間
input int ma3_period_m=25;//中期移動平均線期間
input int ma3_period_l=50;//長期移動平均線期間
input MODE6 _ma3_mode=0;//移動平均線種類

int ma3con(int i){
   int ma3_mode = _ma3_mode;
   double ma_s=iMA(NULL,0,ma3_period_s,0,ma3_mode,PRICE_CLOSE,i); 
   double ma_s_pre=iMA(NULL,0,ma3_period_s,0,ma3_mode,PRICE_CLOSE,i+1);
   double ma_m=iMA(NULL,0,ma3_period_m,0,ma3_mode,PRICE_CLOSE,i); 
   double ma_m_pre=iMA(NULL,0,ma3_period_m,0,ma3_mode,PRICE_CLOSE,i+1);
   double ma_l=iMA(NULL,0,ma3_period_l,0,ma3_mode,PRICE_CLOSE,i); 
   double ma_l_pre=iMA(NULL,0,ma3_period_l,0,ma3_mode,PRICE_CLOSE,i+1);
   
   if (ma_s<ma_m && ma_m<ma_l && ma_s<ma_s_pre && ma_m<ma_m_pre && ma_l<ma_l_pre)return 1;
   else if (ma_s>ma_m && ma_m>ma_l && ma_s>ma_s_pre && ma_m>ma_m_pre && ma_l>ma_l_pre)return -1;
   else return 0;
}

input string ffffffffsxcfffffx="-------------------------------------";//移動平均線ろうそく足クロスの設定--------------------------------------------------------------
input MODE1 on_ma4=1;//移動平均線ろうそく足クロスon off
input int ma4_period=10;//短期移動平均線の期間
input MODE6 _ma4_mode=0;//移動平均線種類
input MODE2 Vma4=1;//条件反転

int ma4con(int i){
   int ma_mode = _ma4_mode;
   double ma=iMA(NULL,0,ma4_period,0,ma_mode,PRICE_CLOSE,i);
   
   if (ma>Open[i] && ma<Close[i])return Vma4;
   else if (ma<Open[i] && ma>Close[i])return -Vma4;
   else return 0;
}


input string ffffffffffxfff="-------------------------------------";//Accelerator/Deceleratorの設定--------------------------------------------------------------
input MODE1 on_ac=1;//AC on off
input double ac_high=0.03;//AC:この値より上でLowサイン
input double ac_low=-0.03;//AC:この値より下でHighサイン
input MODE2 Vac=1;//条件反転

int accon(int i){
   double ac = iAC(NULL,0,i);
   
   if (ac>ac_high)return Vac;
   else if (ac<ac_low)return -Vac;
   else return 0;
}

input string fffffffcfffxfff="-------------------------------------";//Accumulation/Distributionの設定--------------------------------------------------------------
input MODE1 on_ad=1;//AD on off
input double ad_high=-95000;//AD:この値より上でLowサイン
input double ad_low=-100000;//AD:この値より下でHighサイン
input MODE2 Vad=1;//条件反転

int adcon(int i){
   double ad =iAD(NULL,0,i);
   if (ad>ad_high)return Vad;
   else if (ad<ad_low)return -Vad;
   else return 0;
}



input string fffffffcfsfxfff="-------------------------------------";//Awesome Oscillatorの設定--------------------------------------------------------------
input MODE1 on_ao=1;//AO on off
input double ao_high=0.05;//AO:この値より上でLowサイン
input double ao_low=-0.05;//AO:この値より下でHighサイン
input MODE2 Vao=1;//条件反転

int aocon(int i){
   double ao=iAO(NULL,0,i); 
   if (ao>ao_high)return Vao;
   else if (ao<ao_low)return -Vao;
   else return 0;
}

input string ffffffddfcfsfxfff="-------------------------------------";//ATRの設定--------------------------------------------------------------
input MODE1 on_atr=1;//ATR on off
input int atr_period = 14;//ATR期間
input double atr_high=0.05;//ATR:この値より上でLowサイン
input double atr_low=0.01;//ATR:この値より下でHighサイン

int atrcon(int i){
   double atr = iATR(NULL,0,atr_period,i); 
   if(atr>atr_high)return 1;
   else if(atr<atr_low)return -1;
   else return 0;
}

input string ffffffddfcfdsfxfff="-------------------------------------";//Bears Powerの設定--------------------------------------------------------------
input MODE1 on_bears=1;//Bears Power on off
input int bears_period = 13;//Bears Power期間
input double bears_high=0.05;//Bears Power:この値より上でLowサイン
input double bears_low=-0.08;//Bears Power:この値より下でHighサイン
input MODE2 Vbears=1;//条件反転
input MODE13 bearsPlus=0;//詳細条件
input double bears_high_pre=0.05;//Bears Power:前足条件（上）
input double bears_low_pre=-0.08;//Bears Power:前足条件（下）

int bearscon(int i){
   double bear =iBearsPower(NULL,0,bears_period,PRICE_CLOSE,i);
   double bear_pre =iBearsPower(NULL,0,bears_period,PRICE_CLOSE,i+1);
   if(bearsPlus==0){
      if (bear>bears_high)return Vbears;
      else if (bear<bears_low)return -Vbears;
      else return 0;
   } 
   else if(bearsPlus==1){
      if (bear>bears_high && bear_pre<bears_high)return Vbears;
      else if (bear<bears_low && bear_pre>bears_low)return -Vbears;
      else return 0;     
   }
   else if(bearsPlus==2){
      if (bear>bears_high && bear_pre<bears_high_pre)return Vbears;
      else if (bear<bears_low && bear_pre>bears_low_pre)return -Vbears;
      else return 0;     
   }    
   else{
      if (bear<bears_high && bear_pre>bears_high)return Vbears;
      else if (bear>bears_low && bear_pre<bears_low)return -Vbears;
      else return 0;     
   } 
}

input string fffafffddfcfsfxfff="-------------------------------------";//Bulls Powerの設定--------------------------------------------------------------
input MODE1 on_bulls=1;//Bulls Power on off
input int bulls_period = 13;//Bulls Power期間
input double bulls_high=0.07;//Bulls Power:この値より上でLowサイン
input double bulls_low=-0.05;//Bulls Power:この値より下でHighサイン
input MODE2 Vbulls=1;//条件反転

int bullscon(int i){
   double bulls=iBullsPower(NULL,0,bulls_period,PRICE_CLOSE,i);
   if (bulls>bulls_high)return Vbulls;
   else if (bulls<bulls_low)return -Vbulls;
   else return 0;
}

input string fffafffddfcfsgfxfff="-------------------------------------";//DeMarkerの設定--------------------------------------------------------------
input MODE1 on_demark=1;//DeMarker  on off
input int demark_period = 14;//DeMarker期間
input double demark_high=0.7;//DeMarker:この値より上でLowサイン
input double demark_low=0.3;//DeMarker:この値より下でHighサイン
input MODE2 Vdemark=1;//条件反転
input MODE13 demarkPlus=0;//詳細条件
input double demark_high_pre=0.7;//DeMarker:前足条件（上）
input double demark_low_pre=0.3;//DeMarker:前足条件（下）

int demarkcon(int i){
   double demark = iDeMarker(NULL,0,demark_period,i);
   double demark_pre = iDeMarker(NULL,0,demark_period,i+1);
   
   if(demarkPlus==0){
      if (demark>demark_high)return Vdemark;
      else if (demark<demark_low)return -Vdemark;
      else return 0;
   } 
   else if(demarkPlus==1){
      if (demark>demark_high && demark_pre<demark_high)return Vdemark;
      else if (demark<demark_low && demark_pre>demark_low)return -Vdemark;
      else return 0;     
   }
   else if(demarkPlus==2){
      if (demark>demark_high && demark_pre<demark_high_pre)return Vdemark;
      else if (demark<demark_low && demark_pre>demark_low_pre)return -Vdemark;
      else return 0;     
   }
   else{
      if (demark<demark_high && demark_pre>demark_high)return Vdemark;
      else if (demark>demark_low && demark_pre<demark_low)return -Vdemark;
      else return 0;     
   }
}

input string fffafffddffwegfxfff="-------------------------------------";//MFIの設定--------------------------------------------------------------
input MODE1 on_mfi=1;//MFI  on off
input int mfi_period = 14;//MFI期間
input double mfi_high=80;//MFI:この値より上でLowサイン
input double mfi_low=20;//MFI:この値より下でHighサイン
input MODE2 Vmfi=1;//条件反転
input MODE13 mfiPlus=0;//詳細条件
input double mfi_high_pre=80;//MFI:前足条件（上）
input double mfi_low_pre=20;//MFI:前足条件（下）

int mficon(int i){
   double mfi = iMFI(NULL,0,mfi_period,i);
   double mfi_pre = iMFI(NULL,0,mfi_period,i+1);
   
   if(mfiPlus==0){
      if (mfi>mfi_high)return Vmfi;
      else if (mfi<mfi_low)return -Vmfi;
      else return 0;
   } 
   else if(mfiPlus==1){
      if (mfi>mfi_high && mfi_pre<mfi_high)return Vmfi;
      else if (mfi<mfi_low && mfi_pre>mfi_low)return -Vmfi;
      else return 0;     
   }
   else if(mfiPlus==2){
      if (mfi>mfi_high && mfi_pre<mfi_high_pre)return Vmfi;
      else if (mfi<mfi_low && mfi_pre>mfi_low_pre)return -Vmfi;
      else return 0;     
   }
   else{
      if (mfi<mfi_high && mfi_pre>mfi_high)return Vmfi;
      else if (mfi>mfi_low && mfi_pre<mfi_low)return -Vmfi;
      else return 0;     
   }
}


input string fffafffddcfcfsgfxfff="-------------------------------------";//エンベロープの設定--------------------------------------------------------------
input MODE1 on_env=1;//エンベロープ  on off
input int env_period = 30;//エンベロープで使用する平均線の期間
input MODE6 _env_mode=0;//平均線の種類
input double env_devi=0.05;//エンベロープの偏差
input MODE2 Venv=1;//条件反転

int envcon(int i){
   int env_mode = _env_mode;
   double env_u=iEnvelopes(NULL,0,env_period,env_mode,0,PRICE_CLOSE,env_devi,MODE_UPPER,i);
   double env_l=iEnvelopes(NULL,0,env_period,env_mode,0,PRICE_CLOSE,env_devi,MODE_LOWER,i);
   if (Close[i]>env_u)return Venv;
   else if (Close[i]<env_l)return -Venv;
   else return 0;
}

input string ffffffddfcifsfxfff="-------------------------------------";//Force Indexの設定--------------------------------------------------------------
input MODE1 on_fi=1;//Force Index on off
input int fi_period = 14;//Force Indexで使用する平均線の期間
input MODE6 _fi_mode=0;//平均線の種類
input double fi_high=3;//Force Index:この値より上でLowサイン
input double fi_low=-3;//Force Index:この値より下でHighサイン
input MODE2 Vfi=1;//条件反転
input MODE13 fiPlus=0;//詳細条件
input double fi_high_pre=3;//Force Index:前足条件（上）
input double fi_low_pre=-3;//Force Index:前足条件（下）

int ficon(int i){
   int fi_mode = _fi_mode;
   double fi=iForce(NULL,0,fi_period,fi_mode,PRICE_CLOSE,i);
   double fi_pre=iForce(NULL,0,fi_period,fi_mode,PRICE_CLOSE,i+1);
   
   if(fiPlus==0){
      if (fi>fi_high)return Vfi;
      else if (fi<fi_low)return -Vfi;
      else return 0;  
   } 
   else if(fiPlus==1){
      if (fi>fi_high && fi_pre<fi_high)return Vfi;
      else if (fi<fi_low && fi_pre>fi_low)return -Vfi;
      else return 0;    
   }   
   else if(fiPlus==2){
      if (fi>fi_high && fi_pre<fi_high_pre)return Vfi;
      else if (fi<fi_low && fi_pre>fi_low_pre)return -Vfi;
      else return 0;    
   } 
   else{
      if (fi<fi_high && fi_pre>fi_high)return Vfi;
      else if (fi>fi_low && fi_pre<fi_low)return -Vfi;
      else return 0;    
   }   
}

input string fffffddfcifsfxfff="-------------------------------------";//一目均衡表　雲でのサインなしの設定--------------------------------------------------------------
input MODE1 on_ichimoku=1;//一目均衡表　雲でのサインなし on off
input int tenkan = 9;//転換線
input int kijun =26;//基準線
input int senkoub =53;//先行スパンB

int ichimokucon(int i){
   double senkou_a =  iIchimoku(NULL,0,tenkan,kijun,senkoub,MODE_SENKOUSPANA,i);
   double senkou_b =  iIchimoku(NULL,0,tenkan,kijun,senkoub,MODE_SENKOUSPANB,i);
   if (
      (senkou_b > senkou_a && senkou_b>Close[i] && Close[i]>senkou_a)||
      (senkou_b < senkou_a && senkou_b<Close[i] && Close[i]<senkou_a)||
      (senkou_b > senkou_a && senkou_b>Open[i] && Open[i]>senkou_a)||
      (senkou_b < senkou_a && senkou_b<Open[i] && Open[i]<senkou_a)
   )return 100;
   else return 0;
}

input string fffffddsasfxfff="-------------------------------------";//一目均衡表　基準線転換線クロスの設定--------------------------------------------------------------
input MODE1 on_ichimoku2=1;//一目均衡表　基準線転換線クロス on off
input int tenkan2 = 9;//転換線
input int kijun2 =26;//基準線
input int senkoub2 =53;//先行スパンB
input MODE2 Vichimoku2=1;//条件反転

int ichimoku2con(int i){
   double kijun_l =  iIchimoku(NULL,0,tenkan,kijun,senkoub,MODE_KIJUNSEN,i);
   double tenkan_l =  iIchimoku(NULL,0,tenkan,kijun,senkoub,MODE_TENKANSEN,i);
   double kijun_l_pre =  iIchimoku(NULL,0,tenkan,kijun,senkoub,MODE_KIJUNSEN,i+1);
   double tenkan_l_pre =  iIchimoku(NULL,0,tenkan,kijun,senkoub,MODE_TENKANSEN,i+1);
   if (kijun_l>tenkan_l && kijun_l_pre<tenkan_l_pre)return Vichimoku2;
   else if (kijun_l<tenkan_l && kijun_l_pre>tenkan_l_pre)return -Vichimoku2;
   else return 0;    
}

input string fffafffddffxfff="-------------------------------------";//Momentumの設定--------------------------------------------------------------
input MODE1 on_mom=1;//Momentum on off
input int mom_period = 14;//Momentum期間
input double mom_high=100.07;//Momentum:この値より上でLowサイン
input double mom_low=99.93;//Momentum:この値より下でHighサイン
input MODE2 Vmom=1;//条件反転
input MODE13 momPlus=0;//詳細条件
input double mom_high_pre =100.07;//Momentum:前足条件（上）
input double mom_low_pre =99.93;//Momentum:前足条件（下）

int momcon(int i){
   double mom = iMomentum(NULL,0,mom_period,PRICE_CLOSE,i);
   double mom_pre = iMomentum(NULL,0,mom_period,PRICE_CLOSE,i+1);
   if(momPlus==0){
      if (mom>mom_high)return Vmom;
      else if (mom<mom_low)return -Vmom;
      else return 0;   
   } 
   else if(momPlus==1){
      if (mom>mom_high && mom_pre<mom_high)return Vmom;
      else if (mom<mom_low && mom_pre>mom_low)return -Vmom;
      else return 0;     
   }
   else if(momPlus==2){
      if (mom>mom_high && mom_pre<mom_high_pre)return Vmom;
      else if (mom<mom_low && mom_pre>mom_low_pre)return -Vmom;
      else return 0;     
   }
   else{
      if (mom<mom_high && mom_pre>mom_high)return Vmom;
      else if (mom>mom_low && mom_pre<mom_low)return -Vmom;
      else return 0;     
   }
}

input string aaaai87aaefaaaaaa="-------------------------------------";//Momentum指定値以内の設定------------------------------------------------- 
input MODE1 on_mom2=1;//Momentumm指定値以内 on off
input int mom_period2=14;//Momentum期間
input double mom_high2=100.07;//Momentum:上限値
input double mom_low2=99.93;//Momentum:下限値

int mom2con (int i){ 
   double mom = iMomentum(NULL,0,mom_period2,PRICE_CLOSE,i);
   if (mom_high2>mom && mom>mom_low2)return 0;
   else return 100;     
}

input string fffafffddffxfcff="-------------------------------------";//OsMAの設定--------------------------------------------------------------
input MODE1 on_osma=1;//OsMA on off
input int fast_ema = 12;//OsMA Fast EMA 期間
input int slow_ema = 26;//OsMA Slow EMA 期間
input int signal_period = 9;//OsMA Signal 期間
input double osma_high=0.012;//OsMA:この値より上でLowサイン
input double osma_low=-0.012;//OsMA:この値より下でHighサイン
input MODE2 Vosma=1;//条件反転

int osmacon(int i){
   double osma =iOsMA(NULL,0,fast_ema,slow_ema,signal_period,PRICE_CLOSE,i);
   if (osma>osma_high)return Vosma;
   else if (osma<osma_low)return -Vosma;
   else return 0;
}

input string fffafffcdddffxfff="-------------------------------------";//On Balance Volumeの設定--------------------------------------------------------------
input MODE1 on_obv=1;//On Balancee Volume on off
input int obv_period = 14;//OVB期間
input int obv_high=357600;//OVB:この値より上でLowサイン
input int obv_low=349300;//OVB:この値より下でHighサイン

int obvcon(int i){
   double obv = iOBV(NULL,0,PRICE_CLOSE,i);
   if(obv>obv_high)return 1;
   else if(obv<obv_low)return -1;
   else return 0;
}

input string fffafffcdddxfff="-------------------------------------";//パラボリックSAR順張りの設定--------------------------------------------------------------
input MODE1 on_sar=1;//パラボリックSAR順張り on off
input MODE2 Vsar=1;//条件反転

int sarcon(int i){
   double sar = iSAR(NULL,0,0.02,0.2,i);
   if (sar>High[i])return Vsar;
   else if (sar<Low[i])return -Vsar;
   else return 0;
}

input string fffafffjisfcdddxfff="-------------------------------------";//パラボリックSAR変化時の設定--------------------------------------------------------------
input MODE1 on_sar2=1;//パラボリックSAR変化時 on off
input MODE2 Vsar2=1;//条件反転
input double step = 0.02;//パラボリックSARステップ
input double level = 0.2;//パラボリックSAR上限

int sar2con(int i){
   double sar = iSAR(NULL,0,step,level,i);
   double sar_pre = iSAR(NULL,0,step,level,i+1);
   if (sar>High[i] && sar_pre<Low[i+1])return Vsar2;
   else if (sar<Low[i] && sar_pre>High[i+1])return -Vsar2;
   else return 0;
}

input string fffatfffcdddxfff="-------------------------------------";//RVIクロスの設定--------------------------------------------------------------
input MODE1 on_rvi=1;//RVIクロス on off
input int rvi_period = 10;//RVIの期間　
input double rvi_m_high = 0.4;//デッドクロスする時のMAIN線の値(設定値以上)
input double rvi_s_high = 0.4;//デッドクロスする時のSIGNAL線の値(設定値以上)
input double rvi_m_low = -0.4;//ゴールデンクロスする時のMAIN線の値(設定値以下)
input double rvi_s_low = -0.4;//ゴールデンクロスする時のSIGNAL線の値(設定値以下)

int rvicon(int i){
   double rvi_m = iRVI(NULL,0,rvi_period,MODE_MAIN,i);
   double rvi_s = iRVI(NULL,0,rvi_period,MODE_SIGNAL,i);
   double rvi_m_pre = iRVI(NULL,0,rvi_period,MODE_MAIN,i+1);
   double rvi_s_pre = iRVI(NULL,0,rvi_period,MODE_SIGNAL,i+1);
   if (rvi_m_pre > rvi_s_pre && rvi_m < rvi_s && rvi_m>rvi_m_high && rvi_s>rvi_s_high)return 1;
   else if (rvi_m_pre < rvi_s_pre && rvi_m > rvi_s && rvi_m<rvi_m_low && rvi_s<rvi_s_low)return -1;
   else return 0;
}



input string fffatfeffcdddxfff="-------------------------------------";//RVIメイン線の設定--------------------------------------------------------------
input MODE1 on_rvi2=1;//RVIメイン線 on off
input int rvi2_period = 10;//RVIの期間　
input double rvi2_high=0.4;//RVIメイン線:この値より上でLowサイン
input double rvi2_low=0.4;//RVIメイン線:この値より下でHighサイン
input MODE2 Vrvi2=1;//条件反転

int rvi2con(int i){
   double rvi = iRVI(NULL,0,rvi2_period,MODE_MAIN,i);
   if (rvi>rvi2_high)return Vrvi2;
   else if (rvi<rvi2_low)return -Vrvi2;
   else return 0;
}

input string fffatfefdxfff="-------------------------------------";//Standard　Deviationの設定--------------------------------------------------------------
input MODE1 on_std=1;//StdDev低いときサインなし on off
input int std_period = 20;//StdDevで使用する平均線の期間
input MODE6 _std_mode =0;//平均線の種類
input double std_low = 0.01;//この値以下でサインなし

int stdcon(int i){
   int std_mode = _std_mode;
   double std = iStdDev(NULL,0,std_period,0,std_mode,PRICE_CLOSE,i);
   if (std<std_low)return 100;
   else return 0;
}



input string ffffsdff="-------------------------------------";//RCIの設定--------------------------------------------------------------
input MODE1 on_rci=1;//RCI on off
input int rci_period=14;//RCI期間
input double rci_high_level = 0.6;//上偏差
input double rci_low_level = -0.6;//下偏差
input MODE13 rciPlus=0;//詳細条件
input double rci_high_level_pre = 0.6;//前足条件上偏差
input double rci_low_level_pre = -0.6;//前足条件下偏差

int rcicon(int i){
   double rci = iRCI(Symbol(),Period(),rci_period,i);
   double rci_pre = iRCI(Symbol(),Period(),rci_period,i+1);
   if(rciPlus==0){
      if (rci > rci_high_level )return 1;
      else if (rci < rci_low_level  )return -1;
      else return 0;   
   }
   else if(rciPlus==1){
      if (rci > rci_high_level && rci_pre < rci_high_level  )return 1;
      else if (rci < rci_low_level && rci_pre > rci_low_level )return -1;
      else return 0;  
   }
   else if(rciPlus==2){
      if (rci > rci_high_level && rci_pre < rci_high_level_pre  )return 1;
      else if (rci < rci_low_level && rci_pre > rci_low_level_pre )return -1;
      else return 0;  
   }
   else {
      if (rci < rci_high_level && rci_pre > rci_high_level  )return 1;
      else if (rci > rci_low_level && rci_pre < rci_low_level )return -1;
      else return 0;  
   }
}

input string bbbbbbbbbbbbbb="-------------------------------------";//RCIクロスの設定-------------------------------------------------
input MODE1 on_rci2=1;//RCIクロス on off
input int rci_long_period=52;//RCI中期期間
input int rci_short_period=26;//RCI短期期間
input double rci_high_level2 = 0.6;//上偏差
input double rci_low_level2 = -0.6;//下偏差

int rci2con(int i){
   double rci_l = iRCI(Symbol(),Period(),rci_long_period,i);
   double rci_s = iRCI(Symbol(),Period(),rci_short_period,i);
   double rci_l_pre = iRCI(Symbol(),Period(),rci_long_period,i+1);
   double rci_s_pre = iRCI(Symbol(),Period(),rci_short_period,i+1);
   if (rci_l_pre < rci_s_pre && rci_l > rci_s && rci_l>rci_high_level2)return 1;
   else if (rci_l_pre > rci_s_pre && rci_l < rci_s && rci_l<rci_low_level2)return -1;
   else return 0;
}

input string bbbbbbbdxzcsbbbb="-------------------------------------";//ろうそく足幅の設定-------------------------------------------------
input MODE1 on_cad0=1;//ろうそく足幅条件 on off
input int point_candleL0 = 0;//ろうそく足の大きさ以上(最小変動単位)
input int point_candleH0 = 1000;//ろうそく足の大きさ以下(最小変動単位)

int cad0con(int i){
   double length = MathAbs(Close[i]-Open[i]);
   if(length>Point()*point_candleL0 && length<Point()*point_candleH)return 0;
   else return 100;
}


input string bbbbbbbdcsbbbb="-------------------------------------";//ろうそく足条件1の設定-------------------------------------------------
input MODE1 on_cad=1;//ろうそく足条件 on off
input int calc_candle = 3;//陰線陽線の連続数
input int point_candleL = 0;//ろうそく足の大きさ以上(最小変動単位)
input int point_candleH = 1000;//ろうそく足の大きさ以下(最小変動単位)
input MODE2 Vcad=1;//条件反転

int cadcon(int i){
   int hcad=0;
   int lcad=0;
   for(int j=0;j<calc_candle;j++){
      if(Close[i+j]-Open[i+j]>Point()*point_candleL && Close[i+j]-Open[i+j]<Point()*point_candleH)hcad++;
      else if(Open[i+j]-Close[i+j]>Point()*point_candleL && Open[i+j]-Close[i+j]<Point()*point_candleH )lcad++;
   }
   if (hcad==calc_candle)return Vcad;
   else if (lcad==calc_candle)return -Vcad;
   else return 0;
}

input string bbbbbxzbbdcvsd="-------------------------------------";//ろうそく足条件2の設定-------------------------------------------------
input MODE1 on_cad2=1;//ろうそく足条件2 on off
input int calc_candle2 = 3;//ろうそく足幅連続増大の連続数
input MODE2 Vcad2=1;//条件反転

int cad2con(int i){
   int hcad2=0;
   int lcad2=0;
   for(int j=0;j<calc_candle2;j++){
      if(Close[i+j]-Open[i+j]>0 && Close[i+j+1]-Open[i+j+1]>0){
         if(MathAbs(Close[i+j]-Open[i+j]) >  MathAbs(Close[i+j+1]-Open[i+j+1]) )lcad2++;
         else break;
      }
      else if(Close[i+j]-Open[i+j]<0 && Close[i+j+1]-Open[i+j+1]<0){
         if(MathAbs(Close[i+j]-Open[i+j]) >  MathAbs(Close[i+j+1]-Open[i+j+1]) )hcad2++;
         else break;      
      }
      else break;
   }
   if (hcad2==calc_candle2)return Vcad2;
   else if (lcad2==calc_candle2)return -Vcad2;
   else return 0;
}

input string bbbbbxzcvsd="-------------------------------------";//ヒゲとローソク足の割合の設定-------------------------------------------------
input MODE1 on_cad3=1;//ヒゲとローソク足の割合 on off
input double ratio_shadow = 1.1;//ヒゲがろうそく足の実体の何倍以上か

int cad3con(int i){
   
   double upper_rb = MathMax(Close[i],Open[i]);
   double lower_rb = MathMin(Close[i],Open[i]);
   double rb = upper_rb-lower_rb;
   double upper_shadow = High[i]-upper_rb;
   double lower_shadow = lower_rb-Low[i];
   if(upper_shadow >= lower_shadow){
      if(rb*ratio_shadow<upper_shadow)return 1;
      else return 0;
   }
   if(lower_shadow >= upper_shadow){
      if(rb*ratio_shadow<lower_shadow)return -1;
      else return 0;
   }   
   else return 0;
}

input string bbbbeerzcvsd="-------------------------------------";//RSIにボリバンタッチの設定-------------------------------------------------
input MODE1 on_bbrsi=1;//RSIにボリバンタッチ on off
input int bbrsi_rsi_period = 14;//RSI期間
input int bbrsi_bb_period = 20;//ボリバン期間
input double bbrsi_bb_devi = 2.0;//ボリバン偏差
int bbrsi(int i){
   double buf[1];
   int size = MathMax(bbrsi_rsi_period,bbrsi_bb_period);
   ArrayResize(buf,size);
   for(int j=0;j<size;j++){
      buf[j] = iRSI(NULL,0,bbrsi_rsi_period,0,i+j);
   }
   ArraySetAsSeries(buf,true);
   double bbonRSI_high = iBandsOnArray(buf,0,bbrsi_bb_period,2.0,0,MODE_UPPER,0);
   double bbonRSI_low = iBandsOnArray(buf,0,bbrsi_bb_period,2.0,0,MODE_LOWER,0);
   if(buf[0]>bbonRSI_high)return 1;
   else if(buf[0]<bbonRSI_low)return -1;
   else return 0;
}

input string bbdwvsd="-------------------------------------";//Hillインジケーターの設定-------------------------------------------------
input MODE1 on_hill=1;//Hillインジケーター on off

input int    RsiLength  = 14;//RSI期間
input int    RsiPrice   = PRICE_CLOSE;//RSI適応価格
input int    HalfLength = 12;//計算期間
input int    DevPeriod  = 100;//StdDevの期間
input double Deviations = 1.8;//StdDevの偏差

int hill(int i){
   //if(i>Bars-DevPeriod-5)return 0;
   //定義
   double buf[1];
   //サイズの拡大
   int size = MathMax(RsiLength,DevPeriod);
   ArrayResize(buf,size);
   
   for(int l=0;l<size;l++){
      buf[l] = iRSI(NULL,0,RsiLength,RsiPrice,i+l);
   }
   
   ArraySetAsSeries(buf,true);
   double dev  = iStdDevOnArray(buf,0,DevPeriod,0,MODE_SMA,0);
   double sum  = 0;
   double sumw = 0;

   for(int j=0;j<=HalfLength; j++){
      int reverse = HalfLength-j+1;//0の時13 1-12
      sum  += reverse*buf[j];
      sumw += reverse;
   }
   
   double base = sum/sumw;
   double up = base+dev*Deviations;
   double down = base-dev*Deviations;
   
   if(buf[0]>up)return 1;
   else if(buf[0]<down)return -1;
   else return 0;
   
}
input string bbdwvsdasd="-------------------------------------";//陰線陽線の連続数の設定-------------------------------------------------
input MODE1 on_cad4=1;//ヒゲとローソク足の割合 on off
input int calc_candle3 = 1;//陰線陽線の連続数
input int point_candleL3 = 0;//ろうそく足の大きさ以上(最小変動単位)
input int point_candleH3 = 1000;//ろうそく足の大きさ以下(最小変動単位)

int cad4con(int i){
   int hcad=0;
   int lcad=0;
   for(int j=0;j<calc_candle3;j++){
      if(Close[i+j]-Open[i+j]>Point()*point_candleL3 && Close[i+j]-Open[i+j]<Point()*point_candleH3)hcad++;
      else if(Open[i+j]-Close[i+j]>Point()*point_candleL3 && Open[i+j]-Close[i+j]<Point()*point_candleH3 )lcad++;
   }
   if (hcad==calc_candle3)return 1;
   else if (lcad==calc_candle3)return -1;
   else return 0;
}


//+------------------------------------------------------------------+ RCI計算関数
double iRCI(const string symbol, int timeframe, int period, int index){   
    int rank;
    double d = 0;
    double close_arr[];
    ArrayResize(close_arr, period); 

    for (int i = 0; i < period; i++) {
        close_arr[i] = iClose(symbol, timeframe, index + i);
    }

    ArraySort(close_arr, WHOLE_ARRAY, 0, MODE_DESCEND);

    for (int j = 0; j < period; j++) {
        rank = ArrayBsearch(close_arr,iClose(symbol, timeframe, index + j),WHOLE_ARRAY,0,MODE_DESCEND);
        d += MathPow(j - rank, 2);
    }
    return((1 - 6 * d / (period * (period * period - 1))) * 100);
}


int iRD(int i){
   double ma5= iMA(NULL, 0, 5, 0, MODE_LWMA, PRICE_CLOSE, i);
   double ma20= iMA(NULL, 0, 20, 0, MODE_LWMA, PRICE_CLOSE, i);
   
   double cci= iCCI(NULL, 0, 5, PRICE_CLOSE, i);
   double rvimain= iRVI(NULL, 0, 1, MODE_MAIN, i);
   double rvisignal= iRVI(NULL, 0, 1, MODE_SIGNAL, i);
   
   double adxmain= iADX(NULL, 0, 14, PRICE_CLOSE, MODE_MAIN, i);
   double adxplus= iADX(NULL, 0, 14, PRICE_CLOSE, MODE_PLUSDI, i);
   double adxminus= iADX(NULL, 0, 14, PRICE_CLOSE, MODE_MINUSDI, i);
   double adxmain_pre= iADX(NULL, 0, 14, PRICE_CLOSE, MODE_MAIN, i+1);
   double adxplus_pre= iADX(NULL, 0, 14, PRICE_CLOSE, MODE_PLUSDI, i+1);
   double adxminus_pre= iADX(NULL, 0, 14, PRICE_CLOSE, MODE_MINUSDI, i+1);
   
   double fore = iForecast(15,i);
   double foreT3 = iForecastT3(i);

   if (ma5>ma20 && cci>0 && rvimain>0 && rvisignal>0 && rvimain-rvisignal>0){
      if(adxmain>adxmain_pre && adxplus>adxplus_pre && adxmain>20 && adxplus>20 && fore>0 && foreT3>0 && fore>foreT3)return 1;
      else return 0;
   }
   else if (ma5<ma20 && cci<0 && rvimain<0 && rvisignal<0 && rvimain-rvisignal<0){
      if(adxmain>adxmain_pre && adxminus>adxminus_pre && adxmain>20 && adxminus>20 && fore<0 && foreT3<0 && fore<foreT3)return -1;
      else return 0;
   }
   else return 0;
}

double iForecast(int period,int shift){
   double tmp,tmp2,sum=0;
   for (int i = period; i>0; i--) {
      tmp = period+1;
      tmp = tmp/3;
      tmp2 = i;
      tmp = tmp2 - tmp;
      sum = sum + tmp*Close[shift+period-i]; 
   }
   double WT = sum*6/(period*(period+1)); 
   double forecastosc= (Close[shift]-WT)/WT*100; 
   
   return forecastosc;
}

double iForecastT3(int shift){
   double c1 = -0.343;
   double c2 = 2.499;
   double c3 = -6.069;
   double c4 = 4.913;
   double n = 2;
   double w1 = 0.6666666666;
   double w2 = 0.3333333333;
   
   double e1=0,e2=0,e3=0,e4=0,e5=0,e6=0,t3_fosc=0;
   
   for (int i = 30+shift; i>=shift; i--){
      double forecastosc = iForecast(15,i);
      e1 = w1*forecastosc + w2*e1; 
      e2 = w1*e1 + w2*e2; 
      e3 = w1*e2 + w2*e3; 
      e4 = w1*e3 + w2*e4; 
      e5 = w1*e4 + w2*e5; 
      e6 = w1*e5 + w2*e6; 
      t3_fosc = c1*e6 + c2*e5 + c3*e4 + c4*e3;
   }
   return t3_fosc;
}

