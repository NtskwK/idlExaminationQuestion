pro format
  ;format = '([n][*FC][+][-][width])'
  ;执行三次，左对齐，十进制数，(空格补齐）占6位
  print,format = '(3i6)',[0,2,10]
  ;     0     2    10
  ;执行三次，右对齐，十进制数，(0补齐）占3位
  print,format = '(3i03)',[-1,2,1]
  ;-01002001
  ;左对齐，字符串格式化输出，占4位(空格补齐，有多余的则去除）
  print,format = '(2a-4)',['ab','abcdef']
  ;ab  abcd
  ;十进制数，(空格补齐）占3位，太长的显示为`***`
  print,format = '(i3)',[-1,222,1111]
  ;-1
  ;222
  ;***
  ;width=0则按原样输出
  print,format = '(i0)',[-1,222,1111]
  ;-1
  ;222
  ;1111

  ;data = print_ascii_data()
  ;plot,data[1,*]

  ;reads自动切割读取字符串
  str = '1 2 3 4 5'
  a = 0
  b = 0
  s = ''
  reads,str,a,b,s
  print,s
  ; 3 4 5
end