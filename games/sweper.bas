sub gameover
    dim ff as frame = frame(((w/2)-(len("Press any key to exit...")/2))-1,(h/2)-1,len("Press any key to exit...")+2,3,1,15,4)
    ff.redraw()
    center(h/2,"Game Over",15,4)
    center((h/2)+1,"Press any key to exit...",15,4)
    sleep
end sub



sub savescore(sc as long)
    dim scs(20) as long
    getscores("sweper",scs())
    replacescore(sc,scs())
    savescores("sweper",scs())
end sub

type cord
    as long isbomb=0,fg=15,bg=0,shotat=0
    as string char=" "
end type


dim as cord cor(79,28)

function isgood(x as long,y as long) as long
    if y<0 then
        return 0
    elseif x<0 then
        return 0
    elseif x>=w then
        return 0
    elseif y>h-3 then
        return 0
    end if
    return 1
end function


function rclick(x as long,y as long) as long
    dim as long n=0
    /'locate 1,1
    print "x:";x;"Y:";y;"...";
    sleep'/
    cor(x,y).shotat=1
    if isgood(x+1,y)=1 then
        if cor(x+1,y).isbomb<>0 then 
            n+=1
        end if
    end if
    
    if isgood(x+1,y-1)=1 then
        if cor(x+1,y-1).isbomb<>0 then 
            n+=1
        end if
    end if
    
    if isgood(x+1,y+1)=1 then
        if cor(x+1,y+1).isbomb<>0 then 
            n+=1
        end if
    end if
    
    if isgood(x-1,y)=1 then
        if cor(x-1,y).isbomb<>0 then 
            n+=1
        end if
    end if
    
    if isgood(x-1,y-1)=1 then
        if cor(x-1,y-1).isbomb<>0 then 
            n+=1
        end if
    end if
    
    if isgood(x-1,y+1)=1 then
        if cor(x-1,y+1).isbomb<>0 then 
            n+=1
        end if
    end if
    
    if isgood(x,y-1)=1 then
        if cor(x,y-1).isbomb<>0 then 
            n+=1
        end if
    end if
    
    if isgood(x,y+1)=1 then
        if cor(x,y+1).isbomb<>0 then 
            n+=1
        end if
    end if
    
    cor(x,y).char=iif (n=0," ",str(n))
    dim as long sc=1
    if n=0 then
        cor(x,y).bg=8
        if isgood(x+1,y)=1 then
            
            if cor(x+1,y).isbomb<>0 then 
                n+=1
            elseif cor(x+1,y).shotat=0 then 
                rclick(x+1,y)
            end if
        end if
        
        if isgood(x+1,y-1)=1 then
            if cor(x+1,y-1).isbomb<>0 then 
                n+=1
            elseif cor(x+1,y-1).shotat=0 then 
                sc+=rclick(x+1,y-1)
            end if
        end if
        
        if isgood(x+1,y+1)=1 then
            if cor(x+1,y+1).isbomb<>0 then 
                n+=1
            elseif cor(x+1,y+1).shotat=0 then 
                sc+=rclick(x+1,y+1)
            end if
        end if
        
        if isgood(x-1,y)=1 then
            if cor(x-1,y).isbomb<>0 then 
                n+=1
            elseif cor(x-1,y).shotat=0 then 
                sc+=rclick(x-1,y)
            end if
        end if
        
        if isgood(x-1,y-1)=1 then
            if cor(x-1,y-1).isbomb<>0 then 
                n+=1
            elseif cor(x-1,y-1).shotat=0 then 
                sc+=rclick(x-1,y-1)
            end if
        end if
        
        if isgood(x-1,y+1)=1 then
            if cor(x-1,y+1).isbomb<>0 then 
                n+=1
            elseif cor(x-1,y+1).shotat=0 then 
                sc+=rclick(x-1,y+1)
            end if
        end if
        
        if isgood(x,y-1)=1 then
            if cor(x,y-1).isbomb<>0 then 
                n+=1
            elseif cor(x,y-1).shotat=0 then 
                sc+=rclick(x,y-1)
            end if
        end if
        
        if isgood(x,y+1)=1 then
            if cor(x,y+1).isbomb<>0 then 
                n+=1
            elseif cor(x,y+1).shotat=0 then 
                sc+=rclick(x,y+1)
            end if
        end if
    elseif n=1 then
        cor(x,y).bg=6
    elseif n=2 then
        cor(x,y).bg=12
    elseif n=3 then
        cor(x,y).bg=4
    elseif n=4 then
        cor(x,y).bg=3
    elseif n=5 then
        cor(x,y).bg=9
    elseif n=6 then
        cor(x,y).bg=5
    elseif n=7 then
        cor(x,y).bg=2
    elseif n=8 then
        cor(x,y).bg=15
    end if
    return sc
end function



function click(x as long,y as long) as long
        if cor(x,y).shotat=1 then
            return 0
        elseif cor(x,y).isbomb=0 then
            return rclick(x,y)
        else 
            return -1
        end if
end function




sub newmap(numb as long=300)
    dim as long x,y,bms=numb
    for x=0 to 79
        for y =0 to 28
            cor(x,y).char=" "
            cor(x,y).isbomb=0
            cor(x,y).fg=15
            cor(x,y).bg=0
            cor(x,y).shotat=0
        next
    next
    while bms<>0
        x = rand(0,79)
        y = rand(0,28)
        if cor(x,y).isbomb=0 then
            bms-=1
            cor(x,y).isbomb=1
            cor(x,y).char=" "
        end if
    wend
end sub

function redrawmap as long
    dim as long x,y,n=0
    for x=0 to 79
        for y =0 to 28
            if cor(x,y).shotat = 1 then
                locate y+4,x+1
                color cor(x,y).fg,cor(x,y).bg
                print cor(x,y).char;
            else 
                n+=1
            end if
            if (cor(x,y).isbomb = 0) and (cor(x,y).char = chr(213)) then
                n+=1
            end if
        next
    next
    color 9,0
    return n
end function


sub main
    cls
    newmap()
    setsize(1)
    dim topf as frame = frame(1,1,w-1,2,1,10,0)
    
    
    
    dim as long x=-1,y=-1,b,xx,yy,numb=300,sc=0,lv=1,num
    dim as string k,flag = chr(213)
    dim as double timetake=0
    
    
    
    do
        k=getk()
        if k="esc" then
            exit do
        elseif k="f" then
            
            for x=0 to 79
                for y =0 to 28
                    
                    cor(x,y-3).char=flag
                    cor(x,y-3).bg = 0
                    cor(x,y-3).fg = 11
                    cor(x,y-3).shotat=1
                next
            next
        end if
        screenlock
        cls
        getmouse xx, yy, , b
        x=getmousex()
        y=getmousey()+3
        topf.redraw()
        if redrawmap()=0 then
            lv+=1
            newmap(299+lv)
        end if
        if y>2 and x>-1 and y<h and x<w then
            color 0,15
            locate y+1,x+1
            print cor(x,y-3).char;
            color 9,0
        end if
        center(2,"Score: "+str(sc)+", Lv: "+str(lv)+", time: "+str(int(timetake)),9,0)
        if b=1 then
            if y>2 and x>-1 and y<h and x<w then
                num=click(x,y-3)
                if num=-1 then
                    screenunlock
                    gameover()
                    savescore(sc)
                    return
                else
                    sc+=num
                end if
            end if
        elseif b=2 then
            if cor(x,y-3).shotat=0 then
                cor(x,y-3).char=flag
                cor(x,y-3).bg = 0
                cor(x,y-3).fg = 11
                cor(x,y-3).shotat=1
                screenunlock
                do 
                    getmouse xx, yy, , b
                loop while b=2
                screenlock
            elseif cor(x,y-3).char=flag then
                cor(x,y-3).char=" "
                cor(x,y-3).bg = 0
                cor(x,y-3).fg = 9
                cor(x,y-3).shotat=0
                screenunlock
                do 
                    getmouse xx, yy, , b
                loop while b=2
                screenlock
            end if
        end if
        screenunlock
        
        sleep 50
        timetake+=0.05
    loop while 1
    
    
end sub