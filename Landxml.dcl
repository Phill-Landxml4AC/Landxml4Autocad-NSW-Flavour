// Landxml
//
// By Phillip Nixon
//

dcl_settings : default_dcl_settings { audit_level = 0; }

 XDE: dialog {
    spacer ;
     label = "Xdata Editor";

:column{



:edit_box {
   label = "Xdata:";
   alignment = left;
   edit_width = 100;
   edit_limit = 2000;
   value = "xdatai";
   key = "xdata";
   
}//editbox

}
        ok_cancel;

 }

landxml: dialog {
    spacer ;
    label = "Landxml";

     :boxed_column { 
    
  : list_box {
    label = "Select Type:";
    key = "selections";
    height = 20;
    width = 50;
    
    allow_accept = true;
  }

  
    
   ok_cancel;
 
}
 }
    

   
 