sub gameover
    dim ff as frame = frame(((w/2)-(len("Press any key to exit...")/2))-1,(h/2)-1,len("Press any key to exit...")+2,3,1,15,4)
    ff.redraw()
    center(h/2,"Game Over",15,4)
    center((h/2)+1,"Press any key to exit...",15,4)
    sleep
end sub


sub savescore(sc as long)
    dim scs(20) as long
    getscores("spaceinvaders",scs())
    replacescore(sc,scs())
    savescores("spaceinvaders",scs())
end sub

type eny
    as double x,y
    as long vis=0
    as long way=0
end type



function hit(xx as long, yy as long,ens() as eny) as long
    dim i as long
    screenlock
    for i=2 to w*5
        if (int(ens(i).x)=xx) and (int(ens(i).y)=yy)and (ens(i).vis=1) then
            color 4,0
            locate yy,xx
            print chr(15);
            sleep 50
            locate yy,xx
            print " ";
            color 9,0
            ens(i).vis=0
        end if
    next
    screenunlock
    if yy<3 then
        return 1
    end if
    return 0
end function


function shootthread(ens() as eny,myx as long,myy as long) as long
    
    
    if (hit(myx,myy,ens())=0) then
        color 9,0
        locate myy,myx
        print chr(179);
    else 
        locate myy,myx
        print " ";
        return 0
    end if
    return 1
end function

function movechr(ens() as eny, speed as double = 0.2) as long
    dim i as long , num as long=0
    screenlock
    
    for i = 2 to w*5
        if ens(i).vis=1 then
            num+=1
            locate ens(i).y,int(ens(i).x)
            print " ";
            if ens(i).way=0 then
                if  int(ens(i).x) = (w-5) then
                    ens(i).y+=1
                    ens(i).way = 1
                else
                    ens(i).x+=speed
                end if
            else
                if int(ens(i).x) = 2 then
                    ens(i).y+=1
                    ens(i).way = 0
                else
                    ens(i).x-=speed
                end if
            end if
            if ens(i).y=(h-4) then
                screenunlock
                gameover()
                return -1
            end if
            locate ens(i).y,int(ens(i).x)
            color 10,0
            print chr(234);
        end if
    next
    screenunlock
    return num
        
                
end function


sub main

dim as long x=w/2, sc=0, shotbul=0,bulx=0,buly=0,num=0,lastnum=0,numberofensat=(w)-(w/4), enhasshot=0,enxp,enyp
dim as double increase=0.001, sp=0.1+increase
dim ens(w*5) as eny

cls
dim i as long 
for i = 2 to numberofensat
    ens(i).x=i+3
    ens(i).y=2
    ens(i).way=0
    ens(i).vis=0
next
x=w/2
sc=0
dim as string key
setsize(0)

dim mainframe as frame = frame(1,1,w-1,h-1,1,2,0)
dim topf as frame = frame(1,h-2,w-1,2,1,2,0)
topf.nl=0
mainframe.nl=0
mainframe.redraw()
topf.tlc=chr(204)
topf.trc=chr(185)
topf.redraw()
dim pausef as frame = frame((w/2)-11,(h/2)-1,22,2,1,2,0)
center(h-1, "Press P to pause, press esc to exit",2,0)
do
    locate h-3,x-1
    print "   ";
    key=getk()
    if key="esc" then 
        return
    elseif (key ="a" or key="left")and x>3 then 
        x-=1
    elseif (key ="d" or key="right")and x<w-2 then 
        x+=1
    elseif key="/" then 
        sp+=increase
        center(h-1, "Press P to pause, press esc to exit, Invaders left:"+str(num)+", score:"+str(sc)+", lv:"+str(int((sp-0.1)*1000)),2,0)
    elseif key ="up" or key=" " then 
        'threadcall 
        locate buly,bulx
        print " ";
        bulx=x
        buly=h-3
        shotbul=1
        
    elseif key ="p" then 
        pausef.redraw()
        center((h/2),"Press p to unpause",10,0)
        while getk()<>"p"
        wend
        pausef.hide()
    end if
    locate h-3,x-1
    color 15,0
    print chr(220); chr(219); chr(220);
    if shotbul=1 then
        locate buly,bulx
        print " ";
        buly-=1
        if shootthread (ens(),bulx,buly)=0 then
            shotbul=0
        end if
    end if
    num = movechr(ens(),sp)
    if num = -1 then
        savescore(sc)
        return
    end if
    if num=0 then
        dim i as long 
        locate 2,5
        numberofensat+=1
        dim as long way = 0,ygo=2,xgo=2
        for i = 2 to numberofensat
            if (xgo >w-3)and (way=0) then 
                way =1
                ygo+=1
            end if
            if (xgo =2)and (way=1) then 
                way =0
                ygo+=1
            end if
            xgo+=iif(way=0,1,-1)
            ens(i).x=xgo
            ens(i).y=ygo
            ens(i).way=way
            ens(i).vis=1
            color 10,0
            print chr(234);
            sleep 100
        next
        sc+=90
        color 15,0
        sp+=increase
        if int((sp-0.1)*1000)=900 then
            increase=0
        end if
        lastnum=num
    end if
    if num<>lastnum then
        sc+=lastnum-num
        lastnum=num
        center(h-1, "Press P to pause, press esc to exit, Invaders left:"+str(num)+", score:"+str(sc)+", lv:"+str(int((sp-0.1)*1000)),2,0)
    end if
    if (enhasshot=0) and(rand(0,50)=0) then
        enhasshot=1
        enyp=1
        enxp=x
    end if
    if enhasshot=1 then
        if enyp>h-5 then
            if (enxp = x) or(enxp=x-1) or (enxp=x+1) then
                gameover()
                savescore(sc)
                return
            end if
            enhasshot=0
            locate enyp,enxp
            print " ";
            sleep 25
            continue do
        end if
        if enyp<>1 then
            locate enyp,enxp
            print " ";
        end if
        enyp+=1
        locate enyp,enxp
        color 4,0
        print chr(179);
    end if
    sleep 25
loop while 1




end sub
