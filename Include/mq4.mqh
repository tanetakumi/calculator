//+------------------------------------------------------------------+
//|                                                         test.mqh |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict
#include <stdlib.mqh>
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2010
//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);
// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import
//+------------------------------------------------------------------+
//| EX5 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex5"
//   string ErrorDescription(int error_code);
// #import
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//| Order function                                                   |
//+------------------------------------------------------------------+

bool OdrBuy(double lots, int slipppage, int magic, double sp_sl, double sp_tp, int trial_num){
   //買い
   bool result = false;
   int ticket = -1;
   double stoploss = 0, takeprofit = 0;
   
   for(int count = 0; count < trial_num ; count ++ ) {
      if(sp_sl != 0)stoploss = Ask - sp_sl;
      if(sp_tp != 0)takeprofit = Ask + sp_tp;
      ticket = OrderSend(Symbol(), OP_BUY, lots, Ask, slipppage, NormalizeDouble(stoploss,_Digits), NormalizeDouble(takeprofit,_Digits), NULL, magic, 0, clrRed);
      if ( ticket == -1 ){ //ERROR
         int errorcode = GetLastError();      // エラーコード取得
         printf("エラーコード:%d , 詳細:%s , TP:%f , SL:%f ", errorcode , ErrorDescription(errorcode),stoploss,takeprofit);
         Sleep(1000);                                           // 1000msec待ち
         RefreshRates();                                        // レート更新
      } else {    // 注文約定
         Print("新規注文約定。 チケットNo=",ticket);
         result = true;
         break;
      }
   }
   return result;
}

bool OdrSell(double lots, int slipppage, int magic, double sp_sl, double sp_tp, int trial_num){
   //売り
   bool result = false;
   int ticket = -1;
   double stoploss = 0, takeprofit = 0;
   
   for(int count = 0; count < trial_num ; count ++ ) {
      if(sp_sl != 0)stoploss = Bid + sp_sl;
      if(sp_tp != 0)takeprofit = Bid - sp_tp;
      ticket = OrderSend(Symbol(), OP_SELL, lots, Bid, slipppage, NormalizeDouble(stoploss,_Digits), NormalizeDouble(takeprofit,_Digits), NULL, magic, 0, clrBlue);
      if ( ticket == -1 ){ //ERROR
         int errorcode = GetLastError();      // エラーコード取得
         printf("エラーコード:%d , 詳細:%s , TP:%f , SL:%f ", errorcode , ErrorDescription(errorcode),stoploss,takeprofit);
         Sleep(1000);
         RefreshRates();
      } else {   // 注文約定
         Print("新規注文約定。 チケットNo=",ticket);
         result = true;
         break;
      }
   }
   return result;
}

bool OdrModify(int ticket, double sp_sl, double sp_tp, int trial_num){
   //修正
   bool result = false;
   double stoploss = 0, takeprofit = 0;
   
   if(OrderSelect(ticket, SELECT_BY_TICKET)){
      for(int count = 0; count < trial_num ; count ++ ) {
         if(OrderType()==OP_BUY){
            if(sp_sl != 0)stoploss = Ask - sp_sl;
            if(sp_tp != 0)takeprofit = Ask + sp_tp;            
         } else if(OrderType()==OP_SELL){
            if(sp_sl != 0)stoploss = Bid + sp_sl;
            if(sp_tp != 0)takeprofit = Bid - sp_tp;             
         }
         if (OrderModify(OrderTicket(), OrderOpenPrice(), NormalizeDouble(stoploss,_Digits), NormalizeDouble(takeprofit,_Digits), OrderExpiration(), clrPink)){
            Print("新規修正完了。 チケットNo=",ticket);
            result = true;
            break;         
         } else {   // error
            int errorcode = GetLastError();      // エラーコード取得
            printf("エラーコード:%d , 詳細:%s , TP:%f , SL:%f ", errorcode , ErrorDescription(errorcode),stoploss,takeprofit);
            Sleep(1000);
            RefreshRates();
         }
      }
   } else {
      Print("注文が選択できませんでした。 チケットNo=",ticket);
      result = false;
   }
   return result;
}

int getObjectsCount(){
   return ObjectsTotal();
}

double ReObjectGetValueByTime(long chart_id, const string object_name, datetime time, int line_id = 0){
   if(ObjectGetInteger(chart_id, object_name, OBJPROP_TYPE)==OBJ_CHANNEL && line_id==1){
      double price2 = ObjectGetDouble(chart_id,object_name,OBJPROP_PRICE,2);
      double price3 = ObjectGetValueByTime(chart_id,object_name,ObjectGetInteger(chart_id,object_name,OBJPROP_TIME,2));
      return ObjectGetValueByTime(chart_id,object_name,time)+(price2-price3);
   } else {
      return ObjectGetValueByTime(chart_id,object_name,time,line_id);
   }
}

bool symbolExists(string symbol_name){
   return SymbolSelect(symbol_name,true);
}
