Config { font = "xft:Monospace-10"
       , bgColor = "#282c34"
       , fgColor = "#ffffff"
       , position = Top
       , commands = [ Run Cpu ["-L","3","-H","50","--high","red"] 10
                    , Run Memory ["-t","Mem: <usedratio>%"] 10
                    , Run Date "%a %b %_d %Y %H:%M:%S" "date" 10
                    , Run StdinReader
                    ]
       , sepChar = "%"
       , alignSep = "}{"
       , template = "%StdinReader% }{ %cpu% | %memory% | %date%"
       }

