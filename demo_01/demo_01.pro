pro demo_01
;  res = fun_main()
;  res = fun_var_show(1)

  a = 1
  print,"var:",a
  print,"type:","int16"
  print,"type code:",size(a,/type)
  
  a = 1B
  print,"var:",a
  print,"type:","byte"
  print,"type code:",size(a,/type)
  
  a = 1L
  print,"var:",a
  print,"type:","Long"
  print,"type code:",size(a,/type)
  help,a
  
  a = 1LL
  print,"var:",a
  print,"type:","Long64"
  print,"type code:",size(a,/type)
  help,a

  res = dialog_message(!DLM_PATH,title=!DIR,DISPLAY_NAME='hello',/QUESTION)
  print,res
  
  while res eq 'Yes' do begin
    res = dialog_message("It's only a joke.",title=!DIR,DISPLAY_NAME='joke',/QUESTION)
  endwhile

end