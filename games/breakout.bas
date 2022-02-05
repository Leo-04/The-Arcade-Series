sub gameover
    dim ff as frame = frame(((w/2)-(len("Press any key to exit...")/2))-1,(h/2)-1,len("Press any key to exit...")+2,3,1,15,4)
    ff.redraw()
    center(h/2,"Game Over",15,4)
    center((h/2)+1,"Press any key to exit...",15,4)
    sleep
end sub



sub savescore(sc as long)
    dim scs(20) as long
    getscores("breakout",scs())
    replacescore(sc,scs())
    savescores("breakout",scs())
end sub

type box
    as long x,y,w=6, fg=8, bg =0,vis=0
end type

dim as box boxes(130)
' 10 rows of 13 boxes width of 6

sub drawbox(b as box)
    locate b.y,b.x
    color b.fg,b.bg
    print chr(222);STRING(b.w-2,chr(219));chr(221)
    
end sub
function drawboxes() as long
    dim as long changed=0
    for i as long = 0 to 130
        if boxes(i).vis=1 then
            changed=1
            drawbox(boxes(i))
        end if
    next
    return changed
end function
sub newboxes()
    dim as long i=0,inc=0
    for xx as long=0 to 13
        inc=0
        for yy as long=0 to 9
            if i=130 then 
                return
            end if
            boxes(i).vis=1
            boxes(i).fg=yy+1
            boxes(i).x=(xx*6)+2
            boxes(i).y=8+inc
            inc+=2
            i+=1
        next
    next
    
end sub

function is_hit (x as long, y as long, bx as long, by as long, bw as long) as long
	if (x>=bx and x<=bw+bx) and (by=y) then
		return 1
	end if
	return 0
end function
function ball_hit (x as long, y as long) as long
	dim as long score=0
	for i as long=0 to 130
		if is_hit (x, y, boxes(i).x, boxes(i).y, boxes(i).w)=1 and boxes(i).vis=1 then
            boxes(i).vis=0
			score +=1
		end if
	next
	return score
end function


sub main
    cls
    setsize(0)
    dim mainframe as frame = frame(1,1,w-1,h-1,3,15,0)
    dim topf as frame = frame(1,1,w-1,2,2,15,0)
    mainframe.redraw()
    topf.redraw()
    dim pausef as frame = frame((w/2)-11,(h/2)-1,22,2,1,15,0)
    
    dim as long wi=10,x=(w/2)-(wi/2), sc=0, lives=3
    dim as double xinc=-0.5, yinc=-0.5,bx=int(w/2),by=h-3
    dim as string k,ball=chr(254)
    
    newboxes()
    
    do
        k = getk()
        if k="esc" then
            return
        elseif (k ="a" or k="left")and x<>2 then 
            x-=1
        elseif (k ="d" or k="right")and x<>w-wi then 
            x+=1
        /'elseif k ="u" then
            xinc=0
            yinc=0
        elseif k ="i" then
            by-=1
        elseif k ="k" then
            by+=1
        elseif k ="j" then
            bx-=1
        elseif k ="l" then
            bx+=1'/
        elseif k ="p" then 
            pausef.redraw()
            center((h/2),"Press p to unpause",15,0)
            while getk()<>"p"
            wend
            pausef.hide()
        end if
        screenlock
        mainframe.redraw()
        topf.redraw()
        
        
        by+=yinc
        bx+=xinc
        if int(by)=h then
            xinc=-0.5
            yinc=-0.5
            bx=int(x+(wi/2))
            by=h-3
            lives-=1
            if lives=0 then
                screenunlock
                gameover()
                savescore(sc)
                return
            end if
        end if
        if int(by)=h-2 and int(bx)>=x and int(bx)<=x+wi then
            if bx<=x+1 then
                xinc=-0.7
            elseif bx>=(x+wi)-1 then
                xinc=0.7
            elseif bx>x+(wi/2) then
                xinc=0.5
            else
                xinc=-0.5
            end if
            yinc=-yinc
            by+=yinc
        end if
        if int(bx)=w-2 then
            xinc=-xinc
        elseif int(bx)=2 then
            xinc=-xinc
        elseif int(by)=4 then
            yinc=-yinc
        end if
        dim as long sci=ball_hit(bx,by)
        if sci<>0 then
            sc+=sci
            yinc=-yinc
        end if
        center(2, "Press P to pause, press esc to exit, score:"+str(sc)+", lives:"+str(lives),15,0)
        locate int(by),int(bx)
        color 7,0
        print ball;
        
        locate h-2,x
        color 15,0
        print chr(17)+STRING(wi-2,chr(240))+chr(16);
        if drawboxes()=0 then
            newboxes()
            sc+=130
            lives+=1
            xinc=-0.5
            yinc=-0.5
            bx=int(w/2)
            by=h-3
            x=(w/2)-(wi/2)
        end if
        screenunlock
        sleep 50
    loop while 1
    
    
end sub
