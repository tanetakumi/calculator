//+------------------------------------------------------------------+
//|                                                 CalculatorEA.mq4 |
//|                        Copyright 2023, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict



#include <CalcLib.mqh>

//HDDのシリアルナンバーを取得する
#import "Kernel32.dll"
bool GetVolumeInformationW(string,string,uint,uint&[],uint,uint,string,uint);
#import


datetime limittime = D'2028.08.20';
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

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
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
   
   if(!IsDllsAllowed()){
      Comment(
         "=================================\n"
         +"DLLの使用が許可されていません。\n"
         +"このインジケータを使用するときは「ツール->オプション->エキスパートアドバイザタブ」\n"
         +"よりDLLを使用するにチェックを入れてください。\n"
         +"インジケータはチャートから削除されました。\n"
         +"================================="
      );
      comment_delete = false;
      return 1;
   }
   EventSetTimer(1);
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason){
   EventKillTimer();
   Comment("");
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick(){

}
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
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
   
   
}
//+------------------------------------------------------------------+
