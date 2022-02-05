sub gameover
    dim ff as frame = frame(((w/2)-(len("Press any key to exit...")/2))-1,(h/2)-1,len("Press any key to exit...")+2,3,1,15,4)
    ff.redraw()
    center(h/2,"Game Over",15,4)
    center((h/2)+1,"Press any key to exit...",15,4)
    sleep
end sub



sub savescore(sc as long)
    dim scs(20) as long
    getscores("flappybird",scs())
    replacescore(sc,scs())
    savescores("flappybird",scs())
end sub





function colistion(x as long, y as long,dx as long, dy as long,SIZEOFPIPE as long) as long
    'bird box: x->x+8, y->y+5
    'topp box: dx->dx+7, dy-SIZEOFPIPE->0
    'botp box: dx->dx+7, dy+SIZEOFPIPE->h
    'if x+10<dx or x>dx+7 then
    '    return 0
    'end if
    for bx as long=x to x+8
        for by as long=y to y+7
            if bx<=dx+7 and bx>= dx then
                if by<=dy-SIZEOFPIPE or by>dy+SIZEOFPIPE then
                    return 1
                end if
            end if
        next
    next
    return 0
end function


sub main
    
    cls
    setsize(0)
    
    dim as long x=15,sc=0,SIZEOFPIPE=8
    dim as double inc=1,y=(h/2)-2,dx=w-7,dy=int(h/2)
    dim as string k
    
    
    dim mainframe as frame = frame(1,1,w-1,h-1,2,14,0)
    dim topf as frame = frame(1,1,w-1,2,2,14,0)
    topf.blc=topf.tlc
    topf.brc=topf.tlc
    dim pausef as frame = frame((w/2)-11,(h/2)-1,22,2,1,14,0)
    mainframe.redraw()
    topf.redraw()
    center(2, "Press any key to start",14,0)
    sleep
    getk()
    do
        k=getk()
        if k="esc" then
            return
        elseif k =" " then 
            if y-6>3 then
                y-=6
            else
                y=4
            end if
        elseif k ="p" then 
            pausef.redraw()
            center((h/2),"Press p to unpause",6,0)
            while getk()<>"p"
            wend
            pausef.hide()
        end if
        
        screenlock
        cls
        mainframe.redraw()
        topf.redraw()
        center(2, "Press P to pause, press esc to exit, press space to jump, score:"+str(sc),14,0)
        
        'color 10,4
        dim yy as long =4
        if dy<>0 then
            color 2,0
            while yy<>int(dy-SIZEOFPIPE)
                locate yy,dx+1
                print STRING(5,chr(219));
                yy+=1
            wend
            locate yy,dx
            print STRING(7,chr(219));
            locate yy+1,dx
            print STRING(7,chr(219));
            
            yy=h
            while yy<>int(dy+SIZEOFPIPE)
                locate yy,dx+1
                print STRING(5,chr(219));
                yy-=1
            wend
            locate yy,dx
            print STRING(7,chr(219));
            locate yy-1,dx
            print STRING(7,chr(219));
        end if
        y+=inc
        if int (y+5)=h then
            screenunlock
            gameover()
            savescore(sc)
            return
        end if
        yy = y
        color 14,0
        locate yy,x
        print " ";" ";" ";" ";" ";chr(219);chr(219);chr(219);
        locate y+1,x
        print " ";chr(219);chr(219);chr(219);chr(219);" ";" ";" ";chr(219);
        locate y+2,x
        print chr(219);" ";" ";" ";chr(219);" ";chr(219);" ";chr(219);
        locate y+3,x
        print " ";chr(219);" ";" ";chr(219);" ";" ";" ";chr(219);chr(219);
        locate y+4,x
        print " ";" ";chr(219);chr(219);" ";" ";" ";chr(219);chr(219);
        locate y+5,x
        print " ";" ";" ";" ";chr(219);chr(219);chr(219);
        'print chr(220);chr(219);chr(223);chr(220);
        'color 11,1
        'locate y+1,x
        'print chr(223);chr(219);chr(219);chr(219);chr(223);
        if colistion(x,y,dx,dy,SIZEOFPIPE)=1 then
            screenunlock
            gameover()
            savescore(sc)
            return
        end if
        dx-=inc
        if dx<1 then
            dx=w-7
            dy=rand(13,h-13)
            sc+=1
        end if
        screenunlock
        
        sleep 50
    loop while 1
end sub