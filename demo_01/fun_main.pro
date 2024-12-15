function fun_main,name
  ;print,"the num of params in function is",N_Params(）
  IF name eq '' then begin
    print,"hello",name
  ENDIF ELSE begin
    print,"hello world!"
  ENDELSE
  return,0
end