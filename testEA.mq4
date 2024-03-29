//+------------------------------------------------------------------+
//|                                                       testEA.mq4 |
//|                        Copyright 2023, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#include "./Include/mq4.mqh"
#include "./Include/SpreadSheets.mqh"
#include "./Include/ChartUtil.mqh"
#include "./env/env.mqh"


//ユーザーが設定可能な項目
//EAのエントリーに関する変数
input string settingA="========EAのエントリーに関する設定========";//========EAのエントリーに関する設定========
input int MAGIC = 571994;//マジックナンバー
input int order_trial_num = 5;//注文試行回数
input int Slippage= 3;//スリップページ
input double Lots = 0.01;//ロット数
input int sl_pips = 20;//損切幅(pips)
input double RR = 2.5;//Risk:Reward
input double spread_limit = 7;//エントリー時のスプレッド制限(pips)

//Fixed value
//コメント
bool comment_delete = true;
//認証に関して
int auth = -1;//認証中 -1, 認証失敗 1, 認証成功 0
//　1ロット
double one_lot = 0;
// pips
double _Pips = 0;
Scheduler *sc;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
   //DLLの有効化
   if(!IsDllsAllowed()){
      Comment(
         "=================================\n"
         +"DLLの使用が許可されていません。\n"
         +"このEAを使用するときはチャートに適応する前に「全般」タブ\n"
         +"よりDLLを使用するにチェックを入れてください。\n"
         +"EAはチャートから削除されました。\n"
         +"================================="
      );
      comment_delete = false;
      return(INIT_FAILED);
   }
   
   //Lotに関する情報の取得
   one_lot = SymbolInfoDouble(_Symbol,SYMBOL_TRADE_CONTRACT_SIZE);
   Print("1ロット : ",one_lot);
   if(one_lot==0){
      return(INIT_FAILED);
   }
   
   //pipsに関する情報の取得
   if(_Digits == 2 || _Digits == 3){
      _Pips = 0.01;
   } else if(_Digits == 4 || _Digits == 5){
      _Pips = 0.0001;
   } else {
      PrintFormat("Pipsの情報が取得できませんでした。　_Symbol: %s ,　_Digits: %d",_Symbol,_Digits);
      return(INIT_FAILED);
   }
   

   EventSetTimer(1);
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason){
   if(reason == REASON_CHARTCHANGE){

   } else {
      if(comment_delete)Comment("");
      EventKillTimer();
      delete sc;
   }

}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick(){
   if(auth == -1){
      Comment(
         "=================================\n"
         +"EAの認証確認中です。\n"
         +"================================="
      );
      return;
   } else if(auth == 0){
      Comment(
         "=================================\n"
         +"EAの認証失敗しました。\n"
         +"================================="
      );  
      return;
   }
   //全バー数が100以下の場合OnTick　は動かさない
   if(Bars(_Symbol,_Period)<100){
      Comment(
         "=================================\n"
         +"全バー数が100以下です。\n"
         +"================================="
      );  
      return;
   }
   Comment("==EAの認証成功==\n"+sc.ToString());
   
   if(sc.Check(TimeLocal())){
      Comment("現在は制限時間内です。\n"+sc.ToString());
   }
   
   
   int EAOrder = 0;
   if( OrdersTotal() > 0){
      for( int order=0; order<OrdersTotal(); order++ ){
         if( OrderSelect(order, SELECT_BY_POS) && OrderMagicNumber() == MAGIC && OrderSymbol() == _Symbol ){               
            EAOrder++;
         }
      }
   }
   
   if(EAOrder==0){
      if(spread_limit * _Pips > MarketInfo(_Symbol,MODE_SPREAD) * _Point){
         //SL, TP計算 EURUSD: (cur - pre)*Lots*one_lot=USDLOSS
         double spread_sl = sl_pips * _Pips;
         double spread_tp = spread_sl * RR;
         
         int dir = allcon(0);
         if(dir==1){
            if(OdrSell(Lots, Slippage, MAGIC, spread_sl, spread_tp, order_trial_num)){
               Print("売り注文成功");
            } else {
               Print("売り注文失敗");
            }         
         } else if(dir==-1){
            if(OdrBuy(Lots, Slippage, MAGIC, spread_sl, spread_tp, order_trial_num)){
               Print("買い注文成功");
            } else {
               Print("買い注文失敗");
            }
         }         
      }
   }
}

//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer(){
   static int count = 0;
   static int delay = ChartNumber()*3;
   if(auth == -1){
      if(delay < count){
         auth = auth_user("289388",sheet_id,sheet_name,api_key);
         sc = getCalendar(sheet_id,sheet_name_calendar,api_key);
         Comment(sc.ToString());
      }
      count++;
   }
}
//+------------------------------------------------------------------+
int allcon(int i){
   int ram=0;
   int rom=0;
   
   if(on_rsi==0){ram +=rsicon(i);rom++;}
   
   if(ram==rom){
      return 1;
   } else if(ram==-rom){
      return -1;
   } else {
      return 0;
   }
}


input string aaaadascadsccsda="========条件設定========";//========条件設定========
enum ENABLE{ ON=0, OFF=1 };

enum COND{
   HIGHLOW=0,//設定値より上、より下
   CROSS=1,//設定値とのクロス（下→上）
   CROSSPLUS=2,//設定値とのクロス（下→上）＋前足条件
   REVCROSS=3//設定値とのクロス（上→下）
};

enum MODE2{サイン正転=1,サイン反転=-1};

enum MA_TYPE{
   SMA　=0,//SMA
   EMA　=1,//EMA
   SMMA　=2,//SMMA
   LWMA　=3//LWMA
};

enum MODEtime{
   TIME0　=0,//現在チャート
   TIME1　=1,//1分
   TIME5　=5,//5分
   TIME15　=15, //15分
   TIME30　=30, //30分
   TIME1h　=60, //1時間
   TIME4h　=240, //4時間
   TIME1d　=1440 //1日
};

input string aaaaaaaaaaaaaaaaaa="-------------------------------------";//RSIの設定------------------------------------------------- 
input ENABLE on_rsi=0;//RSI on off
input int rsi_period=14;//RSI期間
input int rsi_high=70;//RSI:この値より上でLowサイン
input int rsi_low=30;//RSI:この値より下でHighサイン
input MODE2 Vrsi=1;//条件反転
input COND rsiPlus=0;//詳細条件
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