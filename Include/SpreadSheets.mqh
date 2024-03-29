//+------------------------------------------------------------------+
//|                                                 SpreadSheets.mqh |
//|                        Copyright 2023, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict
#include "./JAson.mqh"
#include "./http.mqh"
#include "./Scheduler.mqh"
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
Scheduler* getCalendar(string id, string sheet, string api){
   string json = getSheetData(id, sheet, api);
   Scheduler *scheduler = new Scheduler(); 
   if(json=="")return scheduler;
      
   CJAVal js;
   js.Deserialize(json);
   int size = js["values"].Size();
   for(int i=0;i<size; i++){
      string start_time = js["values"][i][0].ToStr();
      string stop_time = js["values"][i][1].ToStr();
      
      StringReplace(start_time,"/",".");
      StringReplace(stop_time,"/",".");
      Print(start_time, " - " ,stop_time);
      scheduler.Add(StrToTime(start_time), StrToTime(stop_time), js["values"][i][3].ToStr());
   }
   return scheduler;
}

bool auth_user(string username, string id, string sheet, string api){
   string json = getSheetData(id, sheet, api);
   if(json=="")return false;
   
   CJAVal js;
   js.Deserialize(json);
   int size = js["values"].Size();
   for(int i=0;i<size; i++){
      if(js["values"][i][0].ToStr() == username && js["values"][i][1].ToStr() == "TRUE"){
         return true;
      }
   }
   return false;
}

string getSheetData(string id, string sheet, string api){
   string url = "https://sheets.googleapis.com/v4/spreadsheets/"+id+"/values/"+sheet+"?key="+api;
   return getRequest(url);
}