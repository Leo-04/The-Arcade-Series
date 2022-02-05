sub gameover
    dim ff as frame = frame(((w/2)-(len("Press any key to exit...")/2))-1,(h/2)-1,len("Press any key to exit...")+2,3,1,15,4)
    ff.redraw()
    center(h/2,"Game Over",15,4)
    center((h/2)+1,"Press any key to exit...",15,4)
    sleep
end sub



sub savescore(sc as long)
    dim scs(20) as long
    getscores("defender",scs())
    replacescore(sc,scs())
    savescores("defender",scs())
end sub

type cord
    as long vis=0,fg=15,bg=0
    as double sp=1,x,y,t=0
    as string char=chr(254),way=""
end type


dim as cord cor(1000)

function getnext() as long
    dim as long i
    for i = 0 to 1000
        if cor(i).vis=0 then
            return i
        end if
    next
    return 999
end function


function drawcors(x as long,y as long,dx as long,dy as long) as long
    
    dim as long i, xx,sc,hit=0,num=0
    for i = 0 to 1000
        xx=(w/2)+(int(cor(i).x)-x)
        if (cor(i).char=chr(234) or cor(i).char="@" or cor(i).char=chr(228)) and cor(i).vis then
            num+=1
        end if
        if ((xx=dx) or (xx=dx-1) or (xx=dx+1)) and ((int(cor(i).y)=dy) or (int(cor(i).y)=dy-1) or ((int(cor(i).y)=dy+1))) and (cor(i).char=chr(234) or cor(i).char="@" or cor(i).char=chr(228)) and cor(i).vis then
            cor(i).vis=0
            if cor(i).char=chr(234) then 
                sc+=1
            elseif cor(i).char="@" then
                sc+=5
            elseif cor(i).char=chr(228) then 
                sc+=10
            end if
        elseif ((xx=(w/2)) or (xx=(w/2)-1) or (xx=(w/2)+1)) and ((int(cor(i).y)=y) or (int(cor(i).y)=y-1) or ((int(cor(i).y)=y+1))) and (cor(i).char=chr(234) or cor(i).char="@" or cor(i).char=chr(228)) and cor(i).vis=1 then
            hit=-1
            cor(i).vis=0
        elseif (xx<w) and (xx>0) and cor(i).vis then
            if (cor(i).char=chr(234)) then
                if rand(0,10) >6 then
                    if rand(0,2)=0 then
                        cor(i).way=iif(rand(0,3)=0,"y","x")
                    else
                        cor(i).way=""
                    end if
                end if
                if cor(i).way="x" then
                    if xx<(w/2) then
                        cor(i).x+=cor(i).sp
                    else
                        cor(i).x-=cor(i).sp
                    end if
                elseif cor(i).way="y" then
                    if cor(i).y<y then
                        cor(i).y+=cor(i).sp
                    else
                        cor(i).y-=cor(i).sp
                    end if
                end if
            elseif (cor(i).char="@") then
                if rand(0,10) >6 then
                    cor(i).way=iif(rand(0,2)=0,"y","x")
                end if
                if cor(i).way="x" then
                    if xx<(w/2) then
                        cor(i).x+=cor(i).sp
                    else
                        cor(i).x-=cor(i).sp
                    end if
                elseif cor(i).way="y" then
                    if cor(i).y<y then
                        cor(i).y+=cor(i).sp
                    else
                        cor(i).y-=cor(i).sp
                    end if
                end if
            elseif (cor(i).char=chr(228)) then
                cor(i).way=iif(rand(0,2)=0,"x","y")
                if cor(i).way="x" then
                    if xx<(w/2) then
                        cor(i).x+=cor(i).sp
                    else
                        cor(i).x-=cor(i).sp
                    end if
                elseif cor(i).way="y" then
                    if cor(i).y<y then
                        cor(i).y+=cor(i).sp
                    else
                        cor(i).y-=cor(i).sp
                    end if
                end if
            end if
            xx=(w/2)+(cor(i).x-x)
            locate cor(i).y,xx
            color cor(i).fg,cor(i).bg
            print cor(i).char;
        elseif (cor(i).char=chr(234) or cor(i).char="@") then
                if rand(0,10) >6 then
                    if rand(0,2)=0 then
                        cor(i).way=iif(rand(0,2)=0,"x","y")
                    else
                        cor(i).way=""
                    end if
                end if
                if cor(i).way="x" then
                    if rand(0,2)=0 then
                        cor(i).x+=cor(i).sp*4
                        if cor(i).x>299 then
                            cor(i).x=299
                        end if
                    else
                        cor(i).x-=cor(i).sp*4
                        if cor(i).x<0 then
                            cor(i).x=0
                        end if
                    end if
                elseif cor(i).way="y" then
                    if rand(0,2)=0 then
                        cor(i).y-=cor(i).sp/4
                        if cor(i).y>h then
                            cor(i).y=5
                        end if
                    else
                        cor(i).y+=cor(i).sp/4
                        if cor(i).y<5 then
                            cor(i).y=h
                        end if
                    end if
                end if
        
        elseif (cor(i).char=chr(228)) then
            cor(i).way=iif(rand(0,2)=0,"x","y")
            if cor(i).way="x" then
                if xx<(w/2) then
                    cor(i).x+=cor(i).sp*rand(1,4)
                else
                    cor(i).x-=cor(i).sp*rand(1,4)
                end if
            elseif cor(i).way="y" then
                if cor(i).y<y then
                    cor(i).y-=cor(i).sp/rand(1,4)
                    if cor(i).y<5 then
                        cor(i).y=h
                    end if
                else
                    cor(i).y+=cor(i).sp/rand(1,4)
                    if cor(i).y>h then
                        cor(i).y=5
                    end if
                end if
            end if
        end if
        if (cor(i).char=chr(234) or cor(i).char="@" or cor(i).char=chr(228) or cor(i).char=chr(3) or cor(i).char=chr(6)) and cor(i).vis then
            dim yy as long
            if cor(i).y>((w/3)*2) then
                yy=3
            elseif cor(i).y>((w/3)) then
                yy=2
            elseif cor(i).y<((w/3)) then
                yy=1
            end if
            locate yy,len("score: 10000")+6+(cor(i).x/5)
            '((w-(len("score: 10000")+5)-2)*(cor(i).x/300))
            if cor(i).char=chr(3) or cor(i).char=chr(6) then
                color 12, 0
            else
                color 4,0
            end if
            print chr(254);
        end if
    next
    if num=0 and hit=0 then hit=-2
    return iif(hit=0,sc,hit)
end function


sub startlv(n as long,s as long,k as long)
    dim i as long
    
        /'if ri<6 then
            cor(n).char=chr(234)
            fsp=1.5
            ssp=1
        elseif ri>5 and ri<9 then
            cor(n).char="@"
            fsp=1.2
            ssp=1
        else 
            cor(n).char=chr(228)
            fsp=1.2
            ssp=0.75
        end if'/
    for i=0 to n
        n=getnext()
        cor(n).x=rand(w+1,(300-(w+2)))
        cor(n).y=rand(5,h)
        cor(n).fg=10
        cor(n).sp=1
        cor(n).vis=1
        cor(n).char=chr(234)
    next
    for i=0 to s
        n=getnext()
        cor(n).x=rand(w+1,(300-(w+2)))
        cor(n).y=rand(5,h)
        cor(n).fg=10
        cor(n).sp=1
        cor(n).vis=1
        cor(n).char="@"
    next
    for i=0 to k
        n=getnext()
        cor(n).x=rand(w+1,(300-(w+2)))
        cor(n).y=rand(5,h)
        cor(n).fg=10
        cor(n).sp=0.75
        cor(n).vis=1
        cor(n).char=chr(228)
    next
        
end sub
/'
            elseif (cor(i).char="@") then
                
            elseif (cor(i).char=chr(228)) then
                
            end if'/
sub upgrade(lv as long)
    dim i as long
    if lv=1 then
        for i=0 to 1000
            if (cor(i).char=chr(234)) then
                cor(i).fg=4
                cor(i).sp=1.5
            end if
        next
    elseif lv=2 then
        for i=0 to 1000
            if (cor(i).char=chr(234)) then
                cor(i).fg=10
                cor(i).sp=1
                cor(i).char="@"
            end if
        next
    elseif lv=3 then
        for i=0 to 1000
            if (cor(i).char="@") then
                cor(i).fg=4
                cor(i).sp=1.2
            end if
        next
    elseif lv=4 then
        for i=0 to 1000
            if (cor(i).char="@") then
                cor(i).fg=10
                cor(i).sp=0.75
                cor(i).char=chr(228)
            end if
        next
    elseif lv=5 then
        for i=0 to 1000
            if (cor(i).char=chr(228)) then
                cor(i).fg=4
                cor(i).sp=1
            end if
        next
    end if
end sub


sub main
cls
setsize(0)
'basic = 234
'through walls =@
'fly after you = 228

'236 = bull
'248 = enbul

dim as long i
for i = 0 to 1000
    cor(i).vis=0
    cor(i).char=""
    cor(i).x=0
    cor(i).y=0
    cor(i).bg=0
        
next
dim n as long,ii as long, ri as long, fsp as double,ssp as double
/'for i=5 to h
    n=getnext()
    cor(n).x=0
    cor(n).y=i
    cor(n).fg=9
    cor(n).char=chr(176)
    cor(n).vis=1
    n=getnext()
    cor(n).x=300
    cor(n).y=i
    cor(n).fg=10
    cor(n).char=chr(176)
    cor(n).vis=1
next'/
startlv(80,15,5)
'end if


dim as string key,way="l",dw=""
dim as long x=20,y=h/2,sc=0,lv=1,t=0,health=len("score: 10000")-4,dx=0,dy=0,num,itx=-1,ity=-1,itis=-1,bombs=5,invis=0,invistime=0,itn,xx
dim as double spinc=0.1,inc=0,lvinc=1,maxinc=150'00

dim topf as frame = frame(1,1,w-1,3,2,9,0)
dim rarf as frame = frame(len("score: 10000")+5,1,w-(len("score: 10000")+5),2,1,9,0)

topf.t=" "
topf.r=" "
topf.l=" "
topf.tlc=" "
topf.trc=" "
topf.blc=topf.b
topf.brc=topf.b
rarf.t=" "
rarf.b=" "
dim pausef as frame = frame((w/2)-11,(h/2)-1,22,2,1,10,0)
do
    key = getk()
    if key="esc" then 
        exit do
    end if
    if (key="up" or key="w") and y<>6 then 
        y-=1
    end if
    if (key="down" or key="s") and y<>h-1 then 
        y+=1
    end if
    if (key="left" or key="a") and (x>0) then 
        x-=1
        way="l"
    end if
    if (key="right" or key="d") and (x<301) then 
        x+=1
        way="r"
    end if
    if (key="f") and (x<301) then
        if bombs>0 then
            for i=0 to 1000
                dim as long xx=(w/2)+(int(cor(i).x)-x)
                if (xx<w) and (xx>0) and cor(i).vis and (cor(i).char=chr(234) or cor(i).char="@" or cor(i).char=chr(228)) then
                    cor(i).vis=0
                    if cor(i).char=chr(234) then 
                        sc+=2
                    elseif cor(i).char="@" then
                        sc+=10
                    elseif cor(i).char=chr(228) then 
                        sc+=20
                    end if
                end if
            next
            bombs-=1
        end if
    end if
    if key=" " then 
        dw=way
        dx=w/2
        dy=y
    elseif key="i" then
        health=-1
    elseif key ="p" then 
        pausef.redraw()
        center((h/2),"Press p to unpause",10,0)
        while getk()<>"p"
        wend
        pausef.hide()
    end if
    if (x=0) then
        x=1
    elseif (x=300) then
        x=299
    end if
    screenlock
    cls
    xx=(w/2)+(int(itx)-x)
    if (((xx=dx) or (xx=dx-1) or (xx=dx+1)) and ((ity=dy) or (ity=dy-1) or ((ity=dy+1)))) or (((itx=x) or (itx=x-1) or (itx=x+1)) and ((ity=y) or (ity=y-1) or ((ity=y+1)))) then
        itx=-1
        ity=-1
        cor(itn).vis=0
        if itis=0 then
            health+=3
        elseif itis=1 then
            bombs+=1
        end if
        itis=-1
    end if
    if rand(0,1000) =0 and itis=-1 then
        itis=rand(0,2)
        '0=3 hearts (3)
        '1=bomb (6)
        itx=rand(x-(w/3),x+(w/3))
        ity=rand(4,h)
        n=getnext()
        itn=n
        cor(n).x=itx
        cor(n).y=ity
        cor(n).fg=12
        if itis = 0 then 
            cor(n).char=chr(3)
        elseif itis=1 then 
            cor(n).char = chr(6)
        end if
        cor(n).vis=1
    end if
    if inc>maxinc then
        upgrade(lvinc)
        lvinc+=1
        inc=0
    end if
    topf.redraw()
    rarf.redraw()
    num=drawcors(x,y,dx,dy)
    if num=-1 then
        health-=1
        if health=0 then 
            screenunlock
            gameover()
            savescore(sc)
            return
        end if
    elseif num=-2 then
        lv+=1
        startlv(80+lv,15+lv,5+lv)
        health+=1
        inc=0
        lvinc=1
        if (maxinc<>40) then maxinc-=0.5
    else
        sc+=num
    end if
    if dw="l" then
        dx-=2
    elseif dw="r" then
        dx+=2
    end if
    if (dx<0) or (dx>w-1) then
        dw=""
        dx=-1
        dy=-1
    end if
    if dw<>"" then
        color 11,0
        locate dy-1,dx
        print chr(236);
        locate dy+1,dx
        print chr(236);
        locate dy-1,dx-1
        print chr(236);
        locate dy+1,dx-1
        print chr(236);
    end if
    color 15,0
    if way="r" then
        locate y-1,(w/2)-1
        print chr(220);
        locate y,w/2
        print chr(232);chr(16);
        locate y+1,(w/2)-1
        print chr(223);
    else
        locate y-1,(w/2)+1
        print chr(220);
        locate y,(w/2)-1
        print chr(17);chr(232);
        locate y+1,(w/2)+1
        print chr(223);
    end if
    
    locate 2,len("score: 10000")+6+(x/5)
    color 15,0
    print chr(254);
    color 9,0
    
    locate 1,1
    print "Score: "+str(sc);
    locate 2,1
    print "Lv:"+str(lv);"   ";chr(6)+":"+str(bombs);'+" "+str(x)'+" #"+str((w-(len("score: 10000")+5))-len("score: 10000")+5);/
    locate 3,1
    print "Health:";
    color 12,0
    if health<=len("score: 10000")-4 then
        print STRING(health,chr(3));
    else 
        print STRING(len("score: 10000")-3,chr(3));"+";
    end if
    color 9,0
    screenunlock
    inc+=spinc
    sleep 50
loop while 1



end sub