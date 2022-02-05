sub gameover
    dim ff as frame = frame(((w/2)-(len("Press any key to exit...")/2))-1,(h/2)-1,len("Press any key to exit...")+2,3,1,15,4)
    ff.redraw()
    center(h/2,"Game Over",15,4)
    center((h/2)+1,"Press any key to exit...",15,4)
    sleep
end sub


sub savescore(sc as long)
    dim scs(20) as long
    getscores("snake",scs())
    replacescore(sc,scs())
    savescores("snake",scs())
end sub

sub main
    
    

cls
dim as long x=w/2,y=h/2, points(10000,2),length=1,dx,dy,moved=0
dim as string key,way="r"
setsize(0)

dim mainframe as frame = frame(1,1,w-1,h-1,2,10,0)
dim topf as frame = frame(1,1,w-1,2,2,10,0)
topf.nl=0
mainframe.nl=0
mainframe.redraw()
topf.blc=topf.tlc
topf.brc=topf.tlc
topf.redraw()
dim pausef as frame = frame((w/2)-11,(h/2)-1,22,2,1,10,0)
center(2, "Press P to pause, press esc to exit",10,0)
dx=rand(2,w-1)
dy=rand(2,h-1)
do
    locate points(0,1),points(0,0)
    print " ";
    key=getk()
    if key="esc" then 
        return
    elseif (key ="w" or key="up")and way<>"s" then 
        way="w"
    elseif (key ="s" or key="down")and way<>"w" then 
        way="s"
    elseif (key ="a" or key="left")and way<>"d" then 
        way="a"
    elseif (key ="d" or key="right")and way<>"a" then 
        way="d"
    elseif key ="p" then 
        pausef.redraw()
        center((h/2),"Press p to unpause",10,0)
        while getk()<>"p"
        wend
        pausef.hide()
    end if
    locate points(length-1,1),points(length-1,0)
    print " ";
    dim i as long = 0
    for i=0 to length
        points(i,0)=points(i+1,0)
        points(i,1)=points(i+1,1)
    next
    points(length,0)=x
    points(length,1) = y
    if way="w" then
        if y=4 then
            gameover()
            savescore(length)
            return
        end if
        y-=1
        moved=1
    elseif way="a" then
        if x=2 then
            gameover()
            savescore(length)
            return
        end if
        x-=1
        moved=1
    elseif way="d" then
        if x=w-1 then
            gameover()
            savescore(length)
            return
        end if
        x+=1
        moved=1
    elseif way="s" then
        if y=h-1 then
            gameover()
            savescore(length)
            return
        end if
        y+=1
        moved=1
    end if
    color 10,0
    for i=0 to length
        if (y=points(i,1)) and (x=points(i,0)) and moved then
            gameover()
            savescore(length)
            return
        end if
        locate points(i,1)
        locate ,points(i,0)
        print chr(178);'points(i,0);"..";points(i,1);"..";'
    next
    locate y,x
    print chr(219);
    if (dx=x)and(dy=y)then
        dx=rand(2,w-1)
        dy=rand(4,h-1)
        length+=4
        dim as long i= 0,ii=0
        for i =0 to 4
            points(length-(i-1),0)=x
            points(length-(i-1),1) =y
        next
        continue do
    end if
    locate dy,dx
    color 4,0
    print chr(254);
    color 10,0
    sleep 75
loop while 1




end sub
